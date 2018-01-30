#' @title Plot the MONALISA Stations
#' @description Function to spatially plot the MONALISA Stations and the respective FOI
#' to a Leaflet plot for better visualization.
#' @param db optional DB table; If empty the standard db file fill be generated
#' @examples 
#' 
#' plotMonalisaLeaflet() # Calls the Already Preconfuigured MONALISA Leaflet
#' 
#' # END
#' 
#' @import leaflet
#' @import magrittr
#' @import tibble
#' @export

plotMonalisaLeaflet<- function(db=NULL){
  
  if(is.null(db)) db<-setMonalisaURL(db=db)
  
  coords<-getMonalisaDB(db,subset = "geom") %>% as.tibble()
  
  m<-leaflet() %>% addTiles() %>% addMarkers(
    lng=coords$LAT %>% as.numeric,
    lat=coords$LON %>% as.numeric,
    popup=paste("Station: ",coords$FOI)
  )
  
  return(m)
  
}

#' @title Plot MONALISA Request inn GGPlot
#' @description Plot the MONALISA Requests either as Line or Boxplot. Both outputs
#' are displayed as GGPlots
#' @param x tbl, Table with the Value that should be implemented in the
#' @examples
#' 
#' plotMonalisaGG(mnls_down[[1]],stat="boxplot")
#' 
#' # END
#' 
#' @import magrittr
#' @import ggplot2
#' @export

plotMonalisaGG<-function(x,stat="line"){
  
  x1<-x %>% names
  colnames(x)<-c("Timestamp","values","FOI")
  x$Timestamp<-as.Date(x$Timestamp)
  
  
  if(stat=="line"){
    g1<-ggplot(data=x,aes(Timestamp,values))+
    geom_line()+
    ggtitle(paste0("Variablility of ",x1[2]),unique(x$FOI))+
    ylab(x1[2])
  }
  
  if(stat=="boxplot"){
    x2<-x %>% group_by(Timestamp)
    g1<-ggplot(x,aes(Timestamp,values,group=Timestamp))+ 
    geom_boxplot()+
    ggtitle(paste0("Variablility of ",x1[2]),unique(x$FOI))+
    ylab(x1[2])
  }
  
  return(g1)
  
}
