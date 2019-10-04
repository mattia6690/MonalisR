#' @title Plot the Province Stations
#' @description Function for spatially Plotting the desired Province Stations on a leaflet
#' template. Besides the plotting of the desired meteorological stations other information
#' can be added such as additional points, a buffer around certain points
#' @param stations Point sf; Meteorological Data Points of the province of South Tyrol,
#' If this is left empty all the Stations will be plotted
#' @param addPoints Point sf; Additional Points on the Leaflet Map. If left empty no Points will be added
#' @param Buffer numeric; The width of a buffer (in m) will be added to the leaflet.
#' If none is provided the map won't draw a polygon
#' @importFrom leaflet leaflet awesomeIcons addTiles addAwesomeMarkers addPolygons
#' @importFrom magrittr "%>%"
#' @importFrom sf st_transform st_buffer st_crs
#' @export

# Get a map with the Spatial Location of the Stations
plotMeteoLeaflet<- function(stations=NULL,addPoints=NULL,Buffer=NA){
  
  ref<- getMeteoInfo(format="spatial")
  if(is.null(stations)) stations<-ref

  c1<-awesomeIcons(icon = 'ios-close',iconColor = 'black',library = 'ion',markerColor = "blue")
  c2<-awesomeIcons(icon = 'ios-close',iconColor = 'black',library = 'ion',markerColor = "red")
  
  m<-leaflet() %>% 
    addTiles() %>% 
    addAwesomeMarkers(
      data=stations,
      icon=c1,
      popup=paste("Code:",stations$SCODE,"<br>",
                "Name GER:",stations$NAME_D,"<br>",
                "Name ITA:",stations$NAME_I,"<br>",
                "Altitude:",stations$ALT)
      )
  
  if(!is.null(addPoints)) {
    
    addPoints<-st_transform(addPoints,st_crs(ref))
    m<-m %>% addAwesomeMarkers(data=addPoints,icon=c2)
    
    if(!is.na(Buffer)) {
      
      if(!is.numeric(Buffer)) error("Buffer needs to be a numeric value")

      pnt.t  <- st_transform(addPoints, 32632)
      pnt.tb <- st_buffer(pnt.t,Buffer)
      buff1  <- st_transform(pnt.tb,st_crs(ref))
      
      m<-m %>% addPolygons(data=buff1,fillColor = c2$markerColor, weight=0)
    }
  }
  
  return(m)
  
}
