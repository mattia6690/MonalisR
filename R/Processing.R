#' @title Convert SOS Dates
#' @description Convert a Date object formatted in SOS Julian Date Format to a "Ymd" format POSIXct
#' @param date date; SOS Date Object
#' @param db character; Digit "Monalisa" for the MONALISA Database and "Meteo" for the meteorological Stations
#' @export

convertDate <- function(date,db="Monalisa"){
  
  if(db=="Monalisa") as.POSIXct(date = date/1000, origin = "1970-01-01") %>% return(.)
  if(db=="Meteo") date %>% str_replace_all(.,"-","") %>% str_replace(.,":","") %>% str_replace(.," ","") %>% return(.)
}

#' @title Overview of the Monalisa Database
#' @description This function accesses the Monalisa Database via the API in JSON format
#' and returns a list of the peatured parameters.
#' @param url URL; URL of the Monalisa SOS API. If empty a default path is used
#' @export

getMonalisaDB<-function(url=""){
  
  if(url=="") url <- "http://monalisasos.eurac.edu/sos/api/v1/timeseries/"
  xmlfile <- jsonlite::fromJSON(url)
  return(xmlfile)
}


