####' Demo Script 2
####' MonalisR v. 0.3
####' Mattia Rossi
####' 23.01.2017
####' EURAC Reseach
####' 
####' The LSTER Database


# Download and load directy from Gitlab
library(devtools)
library(git2r)
library(getPass)
library(rgdal)

uname<- "mattia.rossi"

devtools::install_git("https://gitlab.inf.unibz.it/REMSEN/MonalisR", 
                      credentials = git2r::cred_user_pass(uname, getPass::getPass()))
library(MonalisR)

# Set the MONALISA Path
mnls<-setMonalisaURL(db="http://sdcgbe06.eurac.edu:8080/sos_test/api/v1/timeseries/")
mnls

# Get the LTER Information
lter<-getMonalisaDB(url=mnls)
lter_foi<-getMonalisaDB(url=mnls,subset = "foi")
lter_props<-getMonalisaDB(url=mnls,subset = "property")
lter_proc<-getMonalisaDB(url=mnls,subset = "procedure")
lter_comb<-getMonalisaDB(url=mnls,subset = "combined")

# Plot on a Leaflet
plotMonalisaLeaflet(lter)

# Test Download from LTER Database
foi1<-"B3mef2000"
proc1<-c("EuracID00306A","EuracID00303A")
prop1<-c("HF_Soil","Illum_diff_IN")
s <- "2016-01-01 00:00"
e <- "2016-12-31 00:00"

down<-downloadMonalisa(starturl=mnls,datestart=s,dateend=e,foi=foi1,proc=proc1,prop=prop1,path=getwd())


