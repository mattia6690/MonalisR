#' Set the MONALISA URL
#' @description Set the MONALISA URL or leave as default for EURACs MONALISA Database
#' @param db character; Input the URL to the Timeseries of the MONALISA Database.
#' If this parameter is left empty the standard URL will be set.
#' @export

setMonalisaURL<-function(db=NA){
  
  if(is.na(db)) return("http://monalisasos.eurac.edu/sos/api/v1/timeseries/")
  else return(db)
}

#' @title Overview of the Monalisa Database
#' @description This function accesses the Monalisa Database via the API in JSON format
#' and returns a list of the featured parameters.
#' @param url URL; URL of the Monalisa SOS API. If left empty a default url for the MONALISA database is used.
#' The url Paramater is needed until the timeseries path (e.g. ".../sos/api/v1/timeseries/")
#' @param subset character; The subset of interest. If left empty the whole Data frame will be returned. 
#' Possible Subsets are "all","id","foi","procedure","property", "combined" and "geom"
#' @examples 
#' 
#' # Get the Information hosted in the MONALISA Database
#' getMonalisaDB()
#' getMonalisaDB(subset="property")
#' getMonalisaDB(subset="station")
#' 
#' # END
#' 
#' @import magrittr
#' @importFrom jsonlite fromJSON
#' @importFrom stringr str_split
#' @importFrom dplyr select
#' @export

getMonalisaDB<-function(url=NA,subset="all"){
  
  # Subset NA handling
  possibleSubsets<-c("all","foi","procedure","property","combined","geom")
  ie<-is.element(subset,possibleSubsets)
  if(!isTRUE(ie)) break("The Subset is not available in the function")
  
  # Construct URL
  if(is.na(url)){
    url <- setMonalisaURL()
    xmlfile <- jsonlite::fromJSON(url)
  }else{xmlfile <- jsonlite::fromJSON(url)}
  
  # Normal return when "all" subset
  if(subset=="all") return(xmlfile)
  
  #Unique Server ID
  id<-xmlfile$id
  if(subset=="id") return(id)
  
  # FOI
  split_1<- foi<- str_split(xmlfile$label,", ") %>% sapply(.,"[[",2)
  if(subset=="foi") return(unique(split_1))
  
  # Procedure and ObservableProperties
  split_2<- str_split(xmlfile$label,",") %>% sapply(.,"[[",1)
  split_3<- str_split(split_2," ")
  
  proc<-sapply(split_3,function(i) tail(i,n=1L)) 
  prop<-lapply(split_3,function(i) paste(head(i,n=-1L),collapse=" ")) %>% unlist
  
  if(subset=="procedure") return(unique(proc))
  if(subset=="property")  return(unique(prop))
  if(subset=="combined")  return(cbind(id,foi,proc,prop))
  
  #Geometry
  geom<-xmlfile$station$geometry$coordinates
  geomt<-sapply(geom,function(i) head(i,n=-1L)) %>% t
  geom2<-cbind(split_1,geomt) %>% unique
  colnames(geom2)<-c("FOI","LAT","LON")
  if(subset=="geom") return(geom2)
  
}
