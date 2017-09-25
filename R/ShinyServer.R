shinyServer(server <- function(input,output){
  
  # reactive variable: returns 'prop_list', a list of observed properties of the selected station
  re_1 <- reactive({
    
    u<-getMonalisaDB_sub(subset="property")
    prop_list <- u %>% filter(station.properties.label==input$stations) %>% as.data.frame
    return(prop_list)  
    
  })
  
  
  # reactive user interface: sets the default date range to 1 week, starting from the first date available of
  # the selected property of the station 
  output$Date <- renderUI({
    
    dates <- re_av()
    
    str_dat_st <- dates$first
    str_dat_end <- dates$first + 7 
    
    dateRangeInput("date",h2("Date Range"),
                   start = str_dat_st, end = str_dat_end, format = "yyyy-mm-dd")
    
    
  })
  
  
  # reactive variable: returns the list of observed properties used in the user input selection
  re_properties <- reactive({
    
    print_prop <- as.character(re_1()[,2]) %>% str_split(., ",") %>% unlist 
    print_eff <- print_prop[seq(1,length(print_prop),by=2)]
    
    return(print_eff)
  })
  
  
  # reactive user interface: uses the list of observed properties as selection to the user input
  output$ids <- renderUI({
    selectInput("prop", h2("Select observed property"), choices = re_properties())
  })
  
  
  # reactive variable: returns the selected observed property 
  re_2 <- reactive({
    tmp_prop <- re_properties()
    idy<- which(tmp_prop == input$prop)
    
    p <- re_1() %>% select("Observable properties") %>% .[idy,] %>% as.matrix()
    return(p)
  })
  
  
  # reactive variable: returns the ID of the selected observed property: Used in the url to get the data
  re_id <- reactive({
    
    tmp_id <- re_properties()
    idx <- which(tmp_id == input$prop)
    
    ID <- re_1() %>% select(id) %>% .[idx,] %>% as.matrix
    return(ID)
  })
  
  
  # reactive variable: returns a data frame which shows the first and the last date of the selected timeseries
  re_av <- reactive({
    
    url_av<-paste0(paste(setMonalisaURL()),re_id())
    tmp <- jsonlite::fromJSON(url_av)
    
    first <- tmp$firstValue$timestamp %>% convertDate(.,db="Monalisa") %>% as.Date
    last <- tmp$lastValue$timestamp %>% convertDate(.,db="Monalisa") %>% as.Date
    availability <- data.frame("first" = first, "last" = last)
    
    return(availability)
    
  })
  
  
  # reactive variable: builds the request and retrieves the data from the database: returns 'DAT' a table containing
  # the selected timeseries
  re_data <- reactive({
    
    url1<-paste0(setMonalisaURL(),re_id(),"/getData?timespan=")
    
    shiny::validate(
      need(input$date[1] < input$date[2], "WARNING: Start date is greater than end date!"),
      need(input$date[2] - input$date[1] <= 366, "ERROR: Time range can not be greater than one year!")
    )
    
    datestart <- input$date[1] %>% paste0(.,"T00:00:00%2F")
    dateend  <- input$date[2] %>% paste0(.,"T00:00:00")
    
    # build request
    request<-paste0(url1,datestart,dateend)
    
    SOS_data <- jsonlite::fromJSON(request) %>% do.call(cbind,.)
    
    # Error Handling if no timeseries is selected
    shiny::validate(
      need(is_empty(SOS_data) == FALSE, "No data available for the selected time period!")
    )
    
    # convert Julian date to "yyyy-mm-dd HH:MM" format 
    SOS_data[,1] <- convertDate(SOS_data[,1],db="Monalisa")
    
    # redefine header
    tmp_prop_d <- re_properties()
    idz<- which(tmp_prop_d == input$prop)
    
    property_spec <- re_1() %>% select("Observable properties") %>% .[idz,] %>% map_if(is.factor, as.character) %>%
      unlist %>% strsplit(.,"-") %>% unlist
    
    property <- property_spec[1]
    spec <- property_spec[2] %>% str_replace(.," ", "") %>% str_split(., "[:blank:][:upper:]") %>% unlist %>% .[1]
    
    # write header
    colnames(SOS_data) <- c("Timestamp", paste0(property,"(",spec,")"))
    
    SOS_data$FOI<-rep(input$stations,times=nrow(SOS_data))
    
    # create output
    DAT <- SOS_data
    
    return(DAT)
    
  })
  
  
  # reactive variable: plot the selected timeseries
  shiny_plot <- reactive({
    Data <- re_data()
    g1<-plotMonalisaGG(Data,stat="line")
    g2<-plotMonalisaGG(Data,stat="boxplot")
    
    plots <- grid.arrange(g1,g2,nrow=2)
    return(plots)
    
  })
  
  
  # reactive variable: calculate some basic statistics: returns 'stats_data'
  stats <- reactive({
    data_mean <- re_data()[,2] %>% mean(.)
    data_max <- re_data()[,2] %>% max(.)
    data_min <- re_data()[,2] %>% min(.)
    data_std <- re_data()[,2] %>% sd(.)
    
    stats_data <- data.frame("Minimum" = data_min, "Maximum" = data_max, "Mean" = data_mean,
                             "Stdev" = data_std)
    
    return(stats_data)
    
  })
  
  
  # reactive variable: checks for gaps in the timeseries
  gaps <- reactive({
    date_gaps <- CheckGaps(re_data())
  })
  
  
  # prints the calculated statistics to the UI
  output$requests <- renderPrint({
    print(stats())
    
  })
  
  
  # prints the gaps to the UI
  output$gaps <- renderPrint({
    if(length(gaps()[,1]) == 0){
      print("No gaps in the dataset!")
    } else {
      print(gaps(), max = 30)
    }
    
    
  })
  
  
  # prints the first and the last date of a timeseries to the UI
  output$av <- renderPrint({
    print(re_av())
    
  })
  
  mapMonalisa<-reactive({
    
    plotMonalisaLeaflet()
    
  })
  
  output$map<-renderLeaflet({
    
    mapMonalisa()
    
  })
  
  # Prevents the plot to automatically refresh: plot refreshes when button 'Search' is clicked
  observeEvent(input$plot,{
    
    output$plot <- renderPlot({
      
      isolate(shiny_plot())
      
      
    },height = 550)})
  
  
  # Download Handler: Creates filename and needs specified input format, shown in UI
  output$download <-downloadHandler(
    
    filename = function(){
      paste0(input$stations, "_",input$prop, "_", input$date[1], "T", input$date[2], ".", input$format)
    },
    
    content = function(file){
      DATA = re_data()
      
      if(input$format == "RData"){
        save(DATA, file = file)
      } else if(input$format == "csv"){
        write.csv(DATA, file)
      } else if(input$format == "txt"){
        DATA_DF = as.data.frame(do.call(rbind,DATA))
        write.table(DATA_DF, file)
      }
      
    }
  )
  
})
