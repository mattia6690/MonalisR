#' @title Convert SOS Dates
#' @description Convert a Date object formatted in SOS Julian Date Format to a "Ymd" format POSIXct
#' @param date date; SOS Date Object
#' @export

convertDate <- function(date){
  date = date/1000
  as.POSIXct(date, origin = "1970-01-01")
}

#' @title Overview of the Monalisa Database
#' @description Get a table with the overview on the MONALISA Database
#' @param url URL; URL of the monalisasos. If empty a default path is used
#' @details This function accesses the Monalisa Database via the API in JSON format
#' and returns a list of the peatured parameters
#' @export

getDataBase<-function(url=""){
  
  if(url=="") url <- "http://monalisasos.eurac.edu/sos/api/v1/timeseries/"
  xmlfile <- jsonlite::fromJSON(url)
  return(xmlfile)
}
