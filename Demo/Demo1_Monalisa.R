####' Demo Script 1
####' MonalisR v. 0.2
####' Mattia Rossi
####' 31. 01. 2017
####' EURAC Reseach
####' 
####' THE MONALISA Database

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


# Set the Path to the SOS JSON
SOS<-setMonalisaURL() # The Default Path for this Function is already the MONALISA Database
SOS

# Inspect the Database
mnls_all<-getMonalisaDB(url=SOS,subset = "all") # Get the complete response from the server
mnls_foi<-getMonalisaDB(url=SOS,subset = "foi") # Get the list of FOIs
mnls_geom<-getMonalisaDB(url=SOS,subset = "geom") # Get the Location of each FOI
mnls_props<-getMonalisaDB(url=SOS,subset = "property") # Get the list of properties
mnls_proc<-getMonalisaDB(url=SOS,subset = "procedure") # Get the list of procedures
mnls_comb<-getMonalisaDB(url=SOS,subset = "combined") # Get the list of all possible FOI/Property/Procedure combinations on the server

# Plot on a Leaflet
plotMonalisaLeaflet(SOS)

# Download
foi1<-"domef1500"
proc1<-""
prop1<-c("Normalized Difference Vegetation Index - Index2")
s <- "2016-01-01 00:00"
e <- "2016-12-31 00:00"
path<-getwd()

down<-downloadMonalisa(starturl=SOS,datestart=s,dateend=e,foi=foi1,proc=proc1,prop=prop1,path=path)

##* 3.3 Plot ----
plotMonalisaLeaflet()
plotMonalisaGG(mnls_down[[1]],stat="boxplot")



