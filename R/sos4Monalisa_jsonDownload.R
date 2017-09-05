
#' @title Download MONALISA Data
#' @description Downloads the Data from EURACs MONLISA Database
#' @param starturl MONALISA URL path, character
#' @param datestart Starting Date required, character (Y-m-d H:M)
#' @param dateend End Date required, character (Y-m-d H:M)
#' @param fois Aternative Input in case the FOIs for the download are already defined
#' @param path Path for the Output. If blank the Output is returne din the R Environment
#' @param csv Additional Save as csv?, Boolean
#' @importFrom jsonlite fromJSON
#' @import tidyverse
#' @import dplyr
#' @import stringr
#' @import purrr
#' @importFrom magrittr "%>%"
#' @export


MonalisaDownload <- function(starturl, datestart, dateend, fois = "", path = "", csv = FALSE){

  source("R/DependingFunctions.R")
  # parse url to JSON
  xmlfile <- jsonlite::fromJSON(starturl)

  #######################################################################################################
  # Interactive selection of FOI ########################################################################

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

  ########################################################################################################
  ########################################################################################################

  # select timeseries of the selected station
  u<-xmlfile %>% select(contains("label"))

  # process selection for print
  u<-xmlfile %>% do.call(cbind,.) %>% as.list %>% do.call(cbind,.) %>% as.tibble  %>% filter(station.properties.label==foi)

  # print list of selectable timeseries for the station "foi"
  print(u)

  # User input specifying observable properties of the feature of interest "station"
  r<-readline(prompt = "Please digit the ID of the desired Properties for your FOI:      ")
  r<- strsplit(r,",") %>% unlist

  # Error catching if user input is not a number
  a<-suppressWarnings(as.numeric(r))
  if(any(is.na(a))) stop("Please Digit Numbers for the IDs")

  # get timeseries id for url request
  ID <-u[a,] %>% select(id) %>% as.matrix()

  # for loop building requests depending on the number of user inputs
  request<-list()
  DAT <- list()
  for(i in 1:length(ID)){

    url1<-paste0(starturl,ID[i],"/getData?timespan=")

    datestart1 <- datestart %>% str_replace(.," ","T") %>% paste0(.,":00%2F")
    dateend1<-dateend %>%  str_replace(.," ","T") %>% paste0(.,":00")

    # build request
    request[i]<-paste0(url1,datestart1,dateend1)

    # parse data
    SOS_data_json <- jsonlite::fromJSON(request[[i]])

    SOS_data <- SOS_data_json %>% do.call(cbind,.)

    SOS_data[,1] <- .convert_sos_date(SOS_data[,1])

    # redefine header
    property_spec <- u[a[i],] %>% select(label) %>% map_if(is.factor, as.character) %>% unlist %>%
                strsplit(.,"-") %>% unlist

    property <- property_spec[1]

    spec <- property_spec[2] %>% str_replace(.," ", "") %>% str_split(., "[:blank:][:upper:]") %>% unlist %>% .[1]

    # write header
    colnames(SOS_data) <- c("Timestamp", paste0(property,"(",spec,")"))

    SOS_data$FOI<-rep(foi,times=nrow(SOS_data))

    # append data to list DAT
    DAT[[i]] <- SOS_data
  }

  date_s <- datestart %>% str_replace(":","") %>% str_replace(" ", "T")
  date_e <- dateend %>%  str_replace(":","") %>% str_replace(" ", "T")

  myfile = paste0(path, "/", "SOS4R_", foi, "_", date_s, "&", date_e)

  # return or save list DAT containing timeseries of all selected observable properties
  if(path != ""){
    save(DAT, file = paste0(myfile,".RData"))
    if(csv == TRUE){
      write.csv(DAT, paste0(myfile,".csv"))
    }
  }
  return(DAT)
}


.convert_sos_date <- function(date){
  date = date/1000
  as.POSIXct(date, origin = "1970-01-01")
}





