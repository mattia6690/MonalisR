ui <- fluidPage(
   
  
  # include CSS template
  includeCSS(system.file("extdata","ShinyTheme.css",package="MonalisR")),
  
  # sidebar containing user inputs
  sidebarLayout(
    sidebarPanel(
      
      wellPanel(
        
        # Input selection of the station
        selectInput(inputId = "stations", 
                    h1("Select station"),
                    choices = getMonalisaDB_sub(subset="station")),
        
        # Input selection of the observed properties of the selected station
        uiOutput("ids"),
        
        # date range of the selected timeseries
        hr(), h2("Available time period"),
        verbatimTextOutput(outputId = "av"),
        
        # date range selection
        uiOutput("Date"),
        
        # plot create/refresh button
        tags$div(actionButton(inputId = "plot", label = "Search", icon("refresh")),
                 style = "float:right")
      ),
      
      # some background color optimization
      tags$div(tags$style(HTML('.input-sm {background-color: white}'))),
      
      # Add footer with license and EURAC logo
      tags$footer(
        tags$img(src="http://www.eurac.edu/Style%20Library/logoEURAC.jpg", width = "150", height = "40", align = "top",
                 style="display:inline; margin-left: 0%; margin-right: 1%;"),
        
        "This work is licensed under a",
        tags$a(href="https://creativecommons.org/licenses/by/4.0/", "Creative Commons Attribution
               4.0 International License", target = "_blank", style = "display:inline"),
        tags$img(src="https://licensebuttons.net/l/by/4.0/80x15.png"),
        style = "position:fixed;bottom:0;width:100%;height:50px;")
      
      ),
    
    
    # main panel containing outputs
    mainPanel(
      tabsetPanel(
        
        tabPanel("Map",
                 leafletOutput(outputId = "map", width="100%", height = 750)),
        
        # panel showing the plots
        tabPanel("Plot",
                 plotOutput(outputId = "plot")),
        
        # panel showing the gaps
        tabPanel("Missing data", verbatimTextOutput(outputId = "gaps")),
        
        # panel showing the statistics
        tabPanel("Statistics", verbatimTextOutput(outputId = "requests")),
        
        # panel handling the download
        tabPanel("Download",
                 
                 selectInput(inputId = "format", 
                             h2("Select format"), 
                             choices = list("csv", "RData", "txt")),
                 downloadButton(outputId = "download", label = "Download"))
        
      )
      
    )
    
  )
  
)
