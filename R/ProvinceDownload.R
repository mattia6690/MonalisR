#' @title Download Meteorological Data
#' @description Function for downloading the meteorological Data provided by the meteorological
#' service of South Tyrol
#' @param dburl URL; URL of the Province Database. If left empty the original API will be used
#' @param station_code string; Station of Interest ("SCODE")
#' @param sensor_code string; Abbreviation of the sensor of interest (e.g. "N" for Precipitation)
#' @param datestart string; Starting time for the download in "Ymd" Format
#' @param dateend string; End time for the download in "Ymd" Format
#' @param path string; Specify the output path. If left empty only a object is returned
#' @param csv boolean; output as csv?
#' @import magrittr
#' @import dplyr
#' @import stringr
#' @importFrom jsonlite fromJSON
#' @export

MeteoDownload <- function(dburl=NULL, station_code, sensor_code, datestart, dateend, path = "", csv = FALSE){
  
  if(is.null(dburl)) dburl<- "http://daten.buergernetz.bz.it/services/meteo/v1/timeseries"
  datestart1 <- datestart %>% convertDate(.,db="meteo")
  dateend1<-    dateend %>%  convertDate(.,db="meteo")
  dates<-c(datestart %>% as.Date,dateend %>% as.Date) %>% str_replace_all(.,"-","")
  
  # Build the Request String
  req1<-dburl %>% 
    paste0(.,"?station_code=",station_code) %>% 
    paste0(.,"&output_format=JSON") %>% 
    paste0(.,"&sensor_code=",sensor_code) %>% 
    paste0(.,"&date_from=",datestart1) %>% 
    paste0(.,"&date_to=",dateend1)
  
  DAT <- fromJSON(req1) 
  
  if(length(DAT)!=0) {
    
    DAT<- DAT %>% 
      add_column(rep(sensor_code,times=nrow(.)),.before=2) %>% 
      add_column(rep(station_code,times=nrow(.)),.before=2)
    colnames(DAT)<-c("TimeStamp","Station","Sensor","Value")
    
    if(path != ""){
      myfile=paste0(path,"/",station_code,"_",sensor_code,"_",dates[1],"_",dates[2])
      save(DAT, file = paste0(myfile,".RData"))
      if(csv == TRUE){
        write.csv(x = DAT, paste0(myfile,".csv"))
      }
    }
    return(DAT)
  }
}
