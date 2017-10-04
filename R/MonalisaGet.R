#' Set the MONALISA URL
#' @description Set the MONALISA URL or leave as default.
#' @param url character; Input the URL to the Timeseries of the MONALISA Database.
#' If this parameter is left empty the standard URL will be set.
#' @export

setMonalisaURL<-function(url=NA){
  
  if(is.na(url)) return("http://monalisasos.eurac.edu/sos/api/v1/timeseries/")
  else return(url)
}

#' @title Overview of the Monalisa Database
#' @description This function accesses the Monalisa Database via the API in JSON format
#' and returns a list of the peatured parameters.
#' @param url URL; URL of the Monalisa SOS API. If empty a default path is used
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr select
#' @export

getMonalisaDB<-function(url=NA){
  
  if(is.na(url)) url <- setMonalisaURL()
  xmlfile <- jsonlite::fromJSON(url)
  
  return(xmlfile)
}

#' @title Overview of the Monalisa Database
#' @description This function accesses the Monalisa Database via the API in JSON format
#' and returns a list of the peatured parameters. In respect to the *getMonalisaDB* function
#' *getMonalisaDB_sub* returns a subset of the whole database information.
#' @param subset character; the name of the subset that has to be taken.
#' Digit either "station" for a list of tha available stations or "property" for
#' a list of the available properties in the database
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr select
#' @importFrom tibble as.tibble
#' @export

getMonalisaDB_sub<-function(subset="station"){
  
  xmlfile<-getMonalisaDB()
  
  if(subset=="station"){
    
    x<-xmlfile %>% 
      select(.,contains("station")) %>% do.call(cbind,.) %>%
      select(.,contains("properties")) %>% do.call(cbind,.) %>%
      select(.,contains("label")) %>%  unique(.)
    rownames(x) <- NULL
    colnames(x) <- "Stations"
    
  }
  
  if(subset=="property"){
    
    x<-xmlfile %>% select(contains("label"))
    x<-xmlfile %>% do.call(cbind,.) %>% as.list %>% do.call(cbind,.) %>% as.tibble
    names(x)[2:3] <- c("Observable properties", "Units")
    
  }
  
  return(x)
  
}

#' @title Monalisa Stations
#' @description Returns all the Stations in the MONALISA Database
#' @import magrittr
#' @import tibble
#' @importFrom dplyr select
#' @export
 
getMonalisaStat<-function(){
  
  db<-getMonalisaDB()
  coords<-db$station$geometry$coordinates %>% 
    do.call(rbind,.) %>% 
    as.tibble %>% 
    select(.,-V3)
  name<-db$station$properties$label
  stats<-cbind.data.frame(coords,name)
  colnames(stats)<-c("LONG","LAT","name")
  
  return(stats)
  
  
}
