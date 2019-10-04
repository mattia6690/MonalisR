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
  
  stat      <-jsonlite::fromJSON("http://daten.buergernetz.bz.it/services/meteo/v1/stations")
  stat.prop <-stat$features$properties
  sens.prop <-jsonlite::fromJSON("http://daten.buergernetz.bz.it/services/meteo/v1/sensors")
  
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
#' @param Buffer numeric; width of the buffer in meters
#' @param projectedepsg numeric: EPSG code of the projected Coordinate System. 
#' In order to compute the distance properly we need to provide a projected coordinate system.
#' Default is 32632 for UTM 32N
#' @importFrom sf st_transform st_buffer st_intersects
#' @export

buffmeteo<-function(point,Buffer=5000,projectedepsg= 32632){
  
  sp  <- getMeteoInfo(format="spatial")
  shp.t  <- st_transform(shp, projectedepsg)
  shp.tb <- st_buffer(shp.t,Buffer)
  buff1  <- st_transform(shp.tb,st_crs(sp))
  
  intersect <- suppressMessages(st_intersects(buff1,sp))
  sp.buff   <- sp[unlist(intersect),]
  
  return(sp.buff)
}




