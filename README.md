# MonalisR
## An R-package for handling open Databases for South Tyrol

This R-Package aims to access multiple open databases providing information related to the Autonomous Province of South Tyrol. The Databases are all openly accessable via central APIs and can therefore be addressed and made accessible via R. For all the Databases core functionalities were implemented simplifying

* data access and exploration
* spatial and data plots of locations (or stations) of interest
* download and storage of the desired dataset(s)<br>

### DB01: The MONALISA Database
  
The [MONALISA project](http://monalisasos.eurac.edu/sos/index) (**MON**itoring key environmental parameters in the **AL**pine environment **I**nvolving **S**cience, technology and **A**pplication) aims at the development of multi-scale monitoring approaches for key environmental parameters and production processes using innovative monitoring technologies and non-destructive methods in the application field of agriculture. <br>
Within this project the [MONALISA Database](http://monalisasos.eurac.edu/sos/static/client/helgoland/index.html#/map) has been created to store and distribute the wide variety of environmental parameters collected. Mainly based on Postgres, the Database works with OGC standardized format and it is distributed based on 52noths SOS impementation.<br>

### DB02: Meteorological Data

A second Platform to retrieve open Data for Science applications is now openly accessible via the [Open Data Portal](http://daten.buergernetz.bz.it/de/info) of the Autonomous Province of South Tyrol. On this Platform multiple different Databases have been opened to the public. A central API handles the request for each single Database stored. For now one of these databases is addressable with this Package containing meteorological data of several fixed Stations continuously operated by the Meteorological Service of South Tyrol.<br>

<br>

#### Download the Package from Gitlab

For now this Package is in a develpment stage and therefore privatly hosted in a Gitlab repository. It is available only to registered group members and the access has to be granted by one of the active members of the group (see [Members Section](https://gitlab.inf.unibz.it/SOS/MonalisR/project_members) or below)
A general way to load the package in R is provided with the following code:<br>

```r
library(devtools)
library(git2r)
library(getPass)

uname<-     "Your Gitlab Username"
password<-  "Your Gitlab Passwort" # Manual insertion
password<-  getPass::getPass() # Password Popup


devtools::install_git("https://gitlab.inf.unibz.it/SOS/MonalisR", 
  credentials = git2r::cred_user_pass(uname, password)
)

```

#### Contributors

* [Mattia Rossi] (https://gitlab.inf.unibz.it/Mattia.Rossi)
* [Daniel Frisinghelli] (https://gitlab.inf.unibz.it/Daniel.Frisinghelli)<br>

<br>![](http://www.eurac.edu/Style%20Library/logoEURAC.jpg)<br><br>

#### Contact

For further information please contact: mattia.rossi@eurac.edu