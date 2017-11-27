#' @title Retreive meteorological Stations
#' @description Retreive the meteorological stations within the borders of the autonomous province of South Tyrol, Italy
#' this script dives the possibility to download the information of these stations as
#' a table containing all relevant information as well as a spatial in form of an "sp" object.
#' @param url URL; URL of the Province Database. If left empty the original API will be used.
#' @param format string; digit "table" if the output should be a tibble or "spatial" for a spatial
#' output as sp-object
#' @examples
#' 
#' s <- "2017-05-01 00:00"
#' e <- "2017-06-01 00:00"
#' a<-downloadMeteo(station_code = "27100MS",
#'                  sensor_code = "LT",
#'                  datestart = s,
#'                  dateend = e)
#' 
#' downloadMeteo(station_code = "27100MS",
#'               sensor_code = "LT",
#'               datestart = s,
#'               dateend = e, path= path,csv=T)
#'              
#' @import magrittr
#' @import tibble
#' @importFrom jsonlite fromJSON
#' @importFrom geojsonio geojson_read
#' @export

getMeteoStat<- function(url=NA,format="table"){
  
  if(is.na(url)) url<-"http://daten.buergernetz.bz.it/services/meteo/v1/stations"
  if(format == "table"){
    
    js1<-fromJSON(url)
    js1<-js1$features$properties %>% as.tibble
    return(js1)
    
  } else if (format =="spatial") {
    
    js1<-geojson_read(paste0(url,".geojson"),method = "web",what = "sp")
    return(js1)
    
  } 
}

#' @title List all the properties for one or multiple stations
#' @description Returns a list af all the sensors and datasets available at one station.
#' @param url URL; URL of the Province Database. If left empty the original API will be used.
#' @param SCODE string; Station Code of one or multiple Stations. If this field is left
#' empty all the possible combinations of SCODE and Sensors will be returned
#' @param onlySensor logical; Sould only the available Sensors be returned?
#' If false all the combination of SCODE and Sensor are returned as tibble
#' @import tibble
#' @import httr
#' @importFrom jsonlite fromJSON
#' @export

getMeteoSensor<-function(url=NULL,SCODE=NULL,onlySensor=F){
  
  if(is.null(url)) url<-"http://daten.buergernetz.bz.it/services/meteo/v1/sensors"
  
  u<-GET(url) %>% content
  ui<-cbind(sapply(u, "[[", 1),sapply(u, "[[", 2)) %>% as.tibble
  colnames(ui)<-c("SCODE","Sensor")
  
  if(!is.null(SCODE)) ui<-is.element(ui$SCODE,SCODE) %>% which(.==T) %>% ui[.,]
  if(onlySensor==T)   ui<-ui$Sensor %>% unique
  
  return(ui)
  
}

#' @title Buffer intersect with meteorological Stations
#' @description This function add the possibility to create a Buffer around a Spatial point
#' and spatially examine it together with the meteorological stations of the province
#' South Tyrol. The return can either be the nearest station or a list of the distances
#' from he point to all station within the buffered area.
#' @param point SpatialPointDataFrame; Indicates the position of the Points
#' which are examined together with the meteorological stations
#' @param bufferW numeric; width of the Buffer in meters
#' @param getBufferShp Boolean; return only the buffer(s)?
#' @param dist Boolean; shall the distances from the Points to the stations be added to
#' the output?
#' @import magrittr
#' @importFrom rgeos gBuffer gDistance 
#' @importFrom sp coordinates spTransform
#' @importFrom raster projection
#' @export

buffmeteo<-function(point,bufferW=5000,getBufferShp=F,dist=F){
  
  sp  <- getMeteoStat(format="spatial")
  shp <- spTransform(point,CRS=CRS(projection(sp))) # Transform
  
  buff1<-rgeos::gBuffer(shp,byid = T,width=bufferW) # Compute
  ov<-sp::over(sp,buff1,returnList = T)
  names(ov)<-sp$SCODE
  dc<-do.call(rbind,ov)
  
  nms1<-rownames(dc) %>% str_split("\\.") %>% do.call(rbind,.) %>% .[,1] # rename
  df<-cbind.data.frame(nms1,dc[,1])
  colnames(df)<-c("Province","Shape")
  
  if(dist==T){
    
    df$dist<-NA
    
    for(i in 1:nrow(df)){
      
      rr<- as.matrix(df[i,])
      shp1<-shp[which(shp@data$Name==rr[,2]),]
      sp1 <-sp[which(sp@data$SCODE==rr[,1]),]
      df$dist[i]<-gDistance(shp1,sp1)
      
    }
  }
  if(getBufferShp==T){return(buff1)}
  return(df)
}
