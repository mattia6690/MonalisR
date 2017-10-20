
####' A Demo Script for the MonalisR Package
####' Presented by Mattia Rossi
####' 20. October 2017
####' EURAC Reseach


### 1. Load the Package in your R-Environment ----

# Download and load directy from Gitlab
library(devtools)
library(git2r)
library(getPass)

uname<- "mattia.rossi"

devtools::install_git("https://gitlab.inf.unibz.it/REMSEN/MonalisR", 
                      credentials = git2r::cred_user_pass(uname, getPass::getPass()))
library(MonalisR)

### 2. Take a look at the MonalisR Package functions ----


### 3. Checkout the Databases ----
##* 3.1 MONALISA ----

mnls<-getMonalisaDB()
mnls2<-getMonalisaDB_sub(subset="property")
mnls3<-getMonalisaDB_sub(subset="station")
mnls4<- getMonalisaStat()
mnls4_unique<- unique(getMonalisaStat())


s <- "2015-12-31 00:00"
e <- "2016-02-28 00:00"
starturl <- setMonalisaURL()

downloadMonalisa(datestart = s,dateend = e)

