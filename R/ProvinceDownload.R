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
#' @importFrom dplyr mutate select rename
#' @importFrom stringr str_replace_all
#' @importFrom magrittr "%>%" 
#' @importFrom jsonlite fromJSON
#' @importFrom lubridate as_datetime
#' @importFrom sp coordinates CRS spTransform
#' @importFrom stats setNames
#' @export

downloadMeteo <- function(dburl=NULL, station_code, sensor_code, datestart, dateend, path = "", csv = FALSE){
  
  if(is.null(dburl)) dburl<- "http://daten.buergernetz.bz.it/services/meteo/v1/timeseries"
  datestart1 <- convertDate(datestart,db="Meteo")
  dateend1<-    convertDate(dateend,db="Meteo")
  dates1<- c(as.Date(datestart),as.Date(dateend))
  dates <- str_replace_all(dates1,"-","")
  
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
      add_column(rep(station_code,times=nrow(.)),.before=2) %>% 
      setNames(c("TimeStamp","Station","Sensor","Value")) %>% 
      mutate(TimeStamp=as_datetime(TimeStamp)) %>% 
      arrange(TimeStamp)
    
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

#' @title Download Meteorological Data (v2)
#' @description Function for accessing the Meteorological Data. This function will replace the
#' Original Function in the next version. No save to CSV is possible anymore. On the other side
#' it will be possible to speed up the actual processing times and to make multiple requests at once
#' @param dburl URL; URL of the Province Database. If left empty the original API will be used
#' @param station_code string; Station of Interest ("SCODE")
#' @param sensor_code string; Abbreviation of the sensor of interest (e.g. "N" for Precipitation)
#' @param datestart string; Starting time for the download in "Ymd" Format
#' @param dateend string; End time for the download in "Ymd" Format
#' @importFrom dplyr mutate select rename
#' @importFrom magrittr "%>%" extract
#' @importFrom lubridate as_datetime
#' @importFrom stats setNames
#' @importFrom tidyr unnest
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @importFrom purrr pmap_chr map_df
#' @importFrom tidyselect everything
#' @export

downloadMeteo2<-function(dburl=NULL, station_code, sensor_code, datestart, dateend){
  
  if(is.null(dburl)) dburl<- "http://daten.buergernetz.bz.it/services/meteo/v1/timeseries"
  datestart1 <- convertDate(datestart, db="Meteo")
  dateend1   <- convertDate(dateend, db="Meteo")
  
  dat<-expand.grid(station_code,sensor_code) %>% 
    as_tibble() %>% 
    setNames(c("SCODE","Type")) %>% 
    mutate(Start=format(as.Date(datestart),format="%Y%m%d")) %>% 
    mutate(End=format(as.Date(dateend),format="%Y%m%d")) %>% 
    mutate(URL=pmap_chr(.,function(SCODE,TYPE,Start,End){
      
      dburl %>% 
        paste0(.,"?station_code=",SCODE) %>% 
        paste0(.,"&output_format=JSON") %>% 
        paste0(.,"&sensor_code=",Type) %>% 
        paste0(.,"&date_from=",Start) %>% 
        paste0(.,"&date_to=",End)
      
    })) %>% 
    mutate(Data= lapply(URL, function(x){
      tryCatch({as_tibble(fromJSON(x))},error=function(e){NA})
      }))
  
  fmt<- unnest(dat)
  if(nrow(fmt)>0){
    
    fmt2<- fmt %>% 
      mutate(Date=as_datetime(DATE)) %>% 
      rename(Value=VALUE) %>% 
      select(-c(URL,DATE)) %>% 
      select(Date, everything()) %>% 
      arrange(Type,Date)
    
    return(fmt2)
  } else {stop("None of the URLS is valid. Please modify the Input parameters")}
}


