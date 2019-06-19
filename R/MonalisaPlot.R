#' @title Plot the MONALISA Stations
#' @description Function to spatially plot the MONALISA Stations and the respective FOI
#' to a Leaflet plot for better visualization.
#' @param db optional DB table; If empty the standard db file fill be generated
#' @import leaflet
#' @importFrom magrittr "%>%"
#' @importFrom tibble as_tibble
#' @export

plotMonalisaLeaflet<- function(db=NULL){
  
  if(is.null(db)) db<-setMonalisaURL()
  
  coords<-getMonalisaDB(db,subset = "geom") %>% as_tibble()
  
  m<-leaflet() %>% addTiles() %>% addMarkers(
    lng=coords$LAT %>% as.numeric,
    lat=coords$LON %>% as.numeric,
    popup=paste("Station: ",coords$FOI)
  )
  
  return(m)
  
}