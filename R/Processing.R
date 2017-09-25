#' @title Convert SOS Dates
#' @description Convert a Date object formatted in SOS Julian Date Format to a "Ymd" format POSIXct
#' @param date date; SOS Date Object
#' @param db character; Digit "Monalisa" for the MONALISA Database and "Meteo" for the meteorological Stations
#' @import magrittr
#' @import stringr
#' @export

convertDate <- function(date,db="Monalisa"){
  
  if(db=="Monalisa") {
    date<-date/1000
    date<-as.POSIXct(date, origin = "1970-01-01") 
    return(date)
  }
  if(db=="Meteo"){
    
    date<-date %>% str_replace_all(.,"-","") %>% 
      str_replace(.,":","") %>% 
      str_replace(.," ","") 
    return(date)
    
  } 
}

#' @title Check MONALISA NA gaps
#' @description Analysis Function for the Server response of a MONALISA Request.
#' This function simply returns the NA gaps as a table
#' @param x a MONALISA Server Response
#' @import magrittr
#' @import stringr
#' @export

CheckGaps <- function(x){
  
  gaps_date <- which(diff(x$Timestamp) > 10) %>% x$Timestamp[.]
  gaps_date <- gaps_date + min(diff(x$Timestamp))*60
  gaps_date <- data.frame("Missing values" = gaps_date)
  
  return(gaps_date)
}