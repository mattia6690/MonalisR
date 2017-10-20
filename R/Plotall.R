
plotM<- function(addPoints=NULL,addBuff=F,widthBuff=10000){
  
  stationP<-getMeteoStat(format="spatial")
  stationM<-getMonalisaStat()
  c1 <-awesomeIcons(icon = 'ios-close',iconColor = 'black',library = 'ion',markerColor = "blue")
  c1b<-awesomeIcons(icon = 'ios-close',iconColor = 'black',library = 'ion',markerColor = "darkblue")
  c2 <-awesomeIcons(icon = 'ios-close',iconColor = 'black',library = 'ion',markerColor = "red")
  
  popupsM<-paste("Type: MONALISA Station","<br>",
                 "FOI:",stationM$name)
  popupsP<-paste("Type: Meteo Station","<br>",
                 "Code:",stationP$SCODE,"<br>",
                 "Name GER:",stationP$NAME_D,"<br>",
                 "Name ITA:",stationP$NAME_I,"<br>",
                 "Altitude:",stationP$ALT)
  
  m<-leaflet() %>% addTiles() %>% 
    addAwesomeMarkers(icon=c1,popup=popupsP,
                      lng=stationP$LONG %>% as.character %>% as.numeric,
                      lat=stationP$LAT %>% as.character %>% as.numeric) %>% 
    addAwesomeMarkers(icon=c1b,popup=popupsM,
                      lng=stationM$LONG %>% as.character %>% as.numeric,
                      lat=stationM$LAT %>% as.character %>% as.numeric)
  
  
  if(!is.null(addPoints)) {
    coords<-coordinates(addPoints)
    m<-m %>% addAwesomeMarkers(coords[,1], coords[,2],icon=c2)
  }
  if(addBuff==T) {
    
    shp <- spTransform(addPoints,CRS=CRS(projection(stations))) # Transform
    
    buff1<-gBuffer(shp,byid = T,width=widthBuff)
    buff1<-spTransform(buff1,CRS=CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
    
    m<-m %>% addPolygons(data=buff1,fillColor = "red",weight=0)
  }
  
  return(m)
  
}