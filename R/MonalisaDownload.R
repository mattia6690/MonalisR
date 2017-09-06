#' @title Download MONALISA Data
#' @description Core script for handling the data provided in the MONALISA Database
#' collected and stored by EURAC Research. For more information please visit http://monalisasos.eurac.edu/sos/.
#' @param starturl URL, Path to the  MONLISA Database. If empty the adress will automatically be pasted.
#' @param datestart date, Starting Date required in "Y-m-d H:M" format.
#' @param dateend date, End Date required "Y-m-d H:M" format.
#' @param fois Character, Aternative Input in case the FOIs for the download are already defined.
#' @param path Character, Path for the Output. If blank the Output is returned as an object in the R Environment.
#' @param csv Boolean, Additionally Save as csv?
#' @import dplyr
#' @import stringr
#' @import magrittr
#' @import tibble
#' @importFrom jsonlite fromJSON
#' @importFrom purrr map_if
#' @importFrom utils write.csv
#' @export

MonalisaDownload <- function(starturl, datestart, dateend, fois = "", path = "", csv = F){

  xmlfile<-getDataBase()

  if(fois==""){
    x<-select(xmlfile,contains("station")) %>%
      do.call(cbind,.) %>%
      select(.,contains("properties")) %>%
      do.call(cbind,.) %>%
      select(.,contains("label")) %>%
      unique(.)

    rownames(x) <- NULL; colnames(x) <- "Stations"
    print(x)

    y<-readline(prompt = "Please digit the ID of the desired station:      ")
    y<- strsplit(y,",") %>% unlist
    if((length(y) > 1)) stop("Please select one station at a time!")

    b<-suppressWarnings(as.numeric(y))
    if((is.na(b))) stop("Please Digit a number for the ID")
    foi<-as.matrix(x)[b]
  } else {foi <- fois}

  # Get Timeseries
  u<-xmlfile %>% select(contains("label"))
  
  # Readline Option
  u<-xmlfile %>% do.call(cbind,.) %>% as.list %>% do.call(cbind,.) %>% as.tibble  %>% filter(station.properties.label==foi)
  print(u)
  r<-readline(prompt = "Please digit the ID of the desired Properties for your FOI:      ")
  r<- strsplit(r,",") %>% unlist

  # Error handling
  a<-suppressWarnings(as.numeric(r))
  if(any(is.na(a))) stop("Please Digit Numbers for the IDs")

  # Get required TS
  ID <-u[a,] %>% select(id) %>% as.matrix()

  # for loop building requests depending on the number of user inputs
  request<-list()
  DAT <- list()
  for(i in 1:length(ID)){

    url1<-paste0(starturl,ID[i],"/getData?timespan=")

    datestart1 <- datestart %>% str_replace(.," ","T") %>% paste0(.,":00%2F")
    dateend1<-dateend %>%  str_replace(.," ","T") %>% paste0(.,":00")

    # Request & Parsing
    request[i]<-paste0(url1,datestart1,dateend1)
    SOS_data <- jsonlite::fromJSON(request[[i]]) %>% do.call(cbind,.)
    SOS_data[,1] <- convertDate(SOS_data[,1])

    # Header definition
    property_spec <- u[a[i],] %>% select(label) %>% map_if(is.factor, as.character) %>% unlist %>%
                strsplit(.,"-") %>% unlist

    property <- property_spec[1]
    spec <- property_spec[2] %>% str_replace(.," ", "") %>% str_split(., "[:blank:][:upper:]") %>% unlist %>% .[1]
    colnames(SOS_data) <- c("Timestamp", paste0(property,"(",spec,")"))
    SOS_data$FOI<-rep(foi,times=nrow(SOS_data))

    # Append data to List
    DAT[[i]] <- SOS_data
  }

  # Output Infos
  date_s <- datestart %>% str_replace(":","") %>% str_replace(" ", "T")
  date_e <- dateend %>%  str_replace(":","") %>% str_replace(" ", "T")
  myfile = paste0(path, "/", "SOS4R_", foi, "_", date_s, "&", date_e)

  # Save
  if(path != ""){
    save(DAT, file = paste0(myfile,".RData"))
    if(csv == T){
      write.csv(DAT, paste0(myfile,".csv"))
    }
  }
  return(DAT)
}






