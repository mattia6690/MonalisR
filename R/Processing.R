#' @title Convert SOS Dates
#' @description Convert a Date object formatted in SOS Julian Date Format to a "Ymd" format POSIXct
#' @param date date; SOS Date Object
#' @param db character; Digit "Monalisa" for the MONALISA Database and "Meteo" for the meteorological Stations
#' @import magrittr
#' @import stringr
#' @export

convertDate <- function(date,db="Monalisa"){
  
  if(db=="Monalisa") as.POSIXct(date = date/1000, origin = "1970-01-01") %>% return(.)
  if(db=="Meteo") date %>% str_replace_all(.,"-","") %>% str_replace(.,":","") %>% str_replace(.," ","") %>% return(.)
}



