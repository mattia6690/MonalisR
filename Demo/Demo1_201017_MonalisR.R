
####' A Demo Script for the MonalisR Package
####' Presented by Mattia Rossi
####' 20. October 2017
####' EURAC Reseach


### 1. Load the Package----

# Download and load directy from Gitlab
library(devtools)
library(git2r)
library(getPass)

uname<- "mattia.rossi"

devtools::install_git("https://gitlab.inf.unibz.it/REMSEN/MonalisR", 
                      credentials = git2r::cred_user_pass(uname, getPass::getPass()))
library(MonalisR)

### 2. MonalisR Package ----

### 3. Databases ----
##* 3.1 MONALISA ----

mnls<-getMonalisaDB()
mnls2<-getMonalisaDB_sub(subset="property")
mnls3<-getMonalisaDB_sub(subset="station")
mnls4<- getMonalisaStat()
mnls4_unique<- unique(getMonalisaStat())

s <- "2015-12-31 00:00"
e <- "2016-02-28 00:00"

mnls_down<-downloadMonalisa(datestart = s,dateend = e)

path<-"C:/Users/MRossi/Documents/07_Codes/"
downloadMonalisa(datestart = s,dateend = e,path= path,csv=T)

plotMonalisaLeaflet()

plotMonalisaGG(mnls_down[[1]],stat="boxplot")

##* 3.2 Meteo ----

met1<-getMeteoStat()
met2<-getMeteoStat(format = "spatial")
met3<-getMeteoSensor()
met3<-getMeteoSensor(SCODE="27100MS")

s <- "2017-05-01 00:00"
e <- "2017-06-01 00:00"

a<-downloadMeteo(station_code = "27100MS",
                 sensor_code = "LT",
                 datestart = s,
                 dateend = e)

downloadMeteo(station_code = "27100MS",
              sensor_code = "LT",
              datestart = s,
              dateend = e, path= path,csv=T)

plotMeteoLeaflet()

##* 3.2 Combine them ----
# The buffmeteo function is able to combine the Points from the MeteoData with other data

library("rgdal")
shp<- readOGR("C:/Users/MRossi/Documents/07_Codes/03_TestData","TestPoint")

buffmeteo(point=shp,bufferW=10000)


