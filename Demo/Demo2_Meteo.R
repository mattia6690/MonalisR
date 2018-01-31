####' Demo Script 1
####' MonalisR v. 0.2
####' Mattia Rossi
####' 30. October 2017
####' EURAC Reseach
####' 
####' The Open Database South Tyrol - Meteorological Data


# Download and load directy from Gitlab
library(devtools)
library(git2r)
library(getPass)
library(rgdal)

uname<- "mattia.rossi"

devtools::install_git("https://gitlab.inf.unibz.it/REMSEN/MonalisR", 
                      credentials = git2r::cred_user_pass(uname, getPass::getPass()))
library(MonalisR)

### 2. Package Help----
help(package="MonalisR")
??Demo1_201017_MonalisR


##* 4.1 Explore the Database ----
met1<-getMeteoStat()
met2<-getMeteoStat(format = "spatial")
met3<-getMeteoSensor()
met3<-getMeteoSensor(SCODE="27100MS")

##* 4.2 Download ----
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

##* 4.3 Plot ----
plotMeteoLeaflet()

##* 4.4 Combine with other Data
# Select the Stations in a radius of 10km from one Point Shapefile

shp<- readOGR("C:/Users/MRossi/Documents/07_Codes/03_TestData","TestPoint")
buffmeteo(point=shp,bufferW=10000) 