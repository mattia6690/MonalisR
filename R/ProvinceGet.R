#' @title Return Meteo South Tyrol Metainformation
#' @description This function returns all the metainformation of the meteorological Data from
#' the OpenData Portal South Tyrol, It is a combination of both former functions `getMeteoStat` and `getMeteoSensor`. 
#' It unifies both information returning the complete range of information present in the Open Data Portal South Tyrol.
#' @param format string; digit "table" if the output should be a Dataframe or "spatial" for a spatial
#' output as sf-object
#' @importFrom jsonlite fromJSON
#' @importFrom sf st_as_sf
#' @export

getMeteoInfo<-function(format="table"){
  
  stat      <-fromJSON("http://daten.buergernetz.bz.it/services/meteo/v1/stations")
  stat.prop <-stat$features$properties
  sens.prop <-fromJSON("http://daten.buergernetz.bz.it/services/meteo/v1/sensors")
  
  ret<- merge(stat.prop,sens.prop,by="SCODE")
  
  if(format == "table")   ret<-ret
  if(format == "spatial") ret<-st_as_sf(ret,coords=c("LONG","LAT"),crs=4326,na.fail = F)
  
  return(ret)
}

#' @title Buffer intersect with meteorological Stations
#' @description This function add the possibility to create a buffer around a spatial point
#' and spatially examine it together with the meteorological stations of the province
#' South Tyrol. The return can either be the nearest station or a list of the distances
#' from he point to all station within the buffered area.
#' @param point SpatialPointDataFrame; Indicates the position of the points
#' which are examined together with the meteorological stations
#' @param bufferW numeric; width of the buffer in meters
#' @param getSHP Boolean; return only the buffer(s)?
#' @param dist Boolean; shall the distances from the points to the stations be added to
#' the output?
#' @importFrom magrittr "%>%" 
#' @importFrom rgeos gBuffer gDistance 
#' @importFrom sp coordinates CRS spTransform over
#' @importFrom rgeos gBuffer
#' @importFrom raster projection
#' @export

buffmeteo<-function(point,bufferW=5000,getSHP=F,dist=F){
  
  sp  <- getMeteoInfo(format="spatial")
  shp <- spTransform(point,CRS=CRS(projection(sp))) # Transform
  
  buff1<-gBuffer(shp,byid = T,width=bufferW) # Compute
  ov<-over(sp,buff1,returnList = T)
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
  if(getSHP==T){return(buff1)}
  return(df)
}




