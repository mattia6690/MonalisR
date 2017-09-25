#' @title Overview of the Monalisa Database
#' @description This function accesses the Monalisa Database via the API in JSON format
#' and returns a list of the peatured parameters.
#' @param url URL; URL of the Monalisa SOS API. If empty a default path is used
#' @importFrom jsonlite fromJSON
#' @export

getMonalisaDB<-function(url=""){
  
  if(url=="") url <- "http://monalisasos.eurac.edu/sos/api/v1/timeseries/"
  xmlfile <- jsonlite::fromJSON(url)
  return(xmlfile)
}
