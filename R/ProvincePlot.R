#' @title Plot the Province Stations
#' @description Function for spatially Plotting the desired Province Stations on a leaflet
#' template. Besides the plotting of the desired meteorological stations other information
#' can be added such as additional points, a buffer around certain points
#' @param stations Points; Meteorological Data Points of the province of South Tyrol,
#' If this is left empty all the Stations will be plotted
#' @param addPoints Points; Additional Points on the Leaflet Map. If left empty no Points will be added
#' @param addBuff Boolean; add a Buffer to the additional points
#' @param widthBuff numeric; The width of a buffer in case it is added
#' @import leaflet
#' @import magrittr
#' @importFrom rgeos gBuffer gDistance 
#' @importFrom sp coordinates spTransform
#' @export

# Get a map with the Spatial Location of the Stations
plotMeteoLeaflet<- function(stations=NULL,addPoints=NULL,addBuff=F,widthBuff=10000){
  
  if(is.null(stations)) stations<-getMeteoStat(format="spatial")
  c1<-awesomeIcons(icon = 'ios-close',iconColor = 'black',library = 'ion',markerColor = "blue")
  c2<-awesomeIcons(icon = 'ios-close',iconColor = 'black',library = 'ion',markerColor = "red")
  
  m<-leaflet() %>% addTiles() %>% addAwesomeMarkers(
    lng=stations$LONG %>% as.character %>% as.numeric,
    lat=stations$LAT %>% as.character %>% as.numeric,
    icon=c1,
    popup=paste("Code:",stations$SCODE,"<br>",
                "Name GER:",stations$NAME_D,"<br>",
                "Name ITA:",stations$NAME_I,"<br>",
                "Altitude:",stations$ALT)
  )
  if(!is.null(addPoints)) {
    coords<-coordinates(addPoints)
    m<-m %>% addAwesomeMarkers(coords[,1], coords[,2],icon=c2)
  }
  if(addBuff==T) {
    ref <- getMeteoStat(as="spatial")
    shp <- spTransform(addPoints,CRS=CRS(projection(ref))) # Transform
    
    buff1<-gBuffer(shp,byid = T,width=widthBuff)
    buff1<-spTransform(buff1,CRS=CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
    
    m<-m %>% addPolygons(data=buff1,fillColor = "red",weight=0)
  }
  
  return(m)
  
}
