![](http://www.eurac.edu/Style%20Library/logoEURAC.jpg)<br><br>

# MonalisR
## An R-package for handling open Databases for South Tyrol

This R-Package aims at accessing multiple open databases for the environmental parameters in the Autonomous Province of South Tyrol. The databases are all openly accessible via central APIs and structurized storages. This makes them addressable and accessible via R. For all the databases core functionalities were implemented simplifying

* data access and exploration
* spatial and data plots of locations (or stations) of interest
* download and storage of the desired dataset(s)<br>

For each database the respective functions are devided according to the three tasks. Following that, th naming conventions utilize the prefixes *get*, *plot* and *download*.

Additionally the repository contains a */Demo* folder with exemplary codes showing the basic functionalities of the MonalisR package.

### 1. EURAC Databases

Two environmental databases hosted by [EURAC research](http://www.eurac.edu/) can be accessed with the MonalisR Package. Both are based on the [Sensor Observation Service (SOS)](http://www.opengeospatial.org/standards/sos) convention defined by the [Open Geospatial Consortium (OGC)](http://www.opengeospatial.org/) and contain environmental parameters from multiple sensors mounted on fixed station all across South Tyrol, Italy.

#### 1.1. MONALISA
  
The [MONALISA project](http://monalisasos.eurac.edu/sos/index) (**MON**itoring key environmental parameters in the **AL**pine environment **I**nvolving **S**cience, technology and **A**pplication) aims at the development of multi-scale monitoring approaches for key environmental parameters and production processes using innovative monitoring technologies and non-destructive methods in the application field of agriculture. 
Within this project the [MONALISA Database](http://monalisasos.eurac.edu/sos/static/client/helgoland/index.html#/map) has been created to store and distribute the wide variety of environmental parameters collected.<br>

### 2. Open Data Portal South Tyrol - Meteo Data

A second platform to retrieve open data for scientific applications is now openly accessible via the [Open Data Portal](http://daten.buergernetz.bz.it/de/info) of the Autonomous Province of South Tyrol. On this platform multiple meteorological variables have been opened to the public. A central API handles the request for each single database stored. For now the package offers the possibilty to access one of these databases is addressable with this package containing meteorological data of several fixed Stations continuously operated by the Meteorological Service of South Tyrol.<br>


### 3. Download the Package
#### 3.1 Development Repository

This package is in an active development stage and therefore [privatly hosted in a Gitlab repository](https://gitlab.inf.unibz.it/REMSEN). It is available only to registered group members and the access has to be granted by one of the active members of the group (see [Members Section](https://gitlab.inf.unibz.it/SOS/MonalisR/project_members))
A general way to load the package in R is provided with the following code:<br>

```r
library(devtools)
library(git2r)
library(getPass)

uname<-     "Your GITLAB username"

devtools::install_git("https://gitlab.inf.unibz.it/REMSEN/MonalisR", 
  credentials = git2r::cred_user_pass(uname, getPass::getPass()))

```

#### 3.2 Open Repository

The stable versions of the packages will be shared on the [Open Repository](https://gitlab.inf.unibz.it/earth_observation_public) and can be downloaded without the need to provide the credentials: <br>

```r
library(devtools)

devtools::install_git("https://gitlab.inf.unibz.it/earth_observation_public//MonalisR")

```

### 4. Contributors & Contact

* [Mattia Rossi] (https://gitlab.inf.unibz.it/Mattia.Rossi)
* [Daniel Frisinghelli] (https://gitlab.inf.unibz.it/Daniel.Frisinghelli)<br>

For further information or interest/ideas for future development please contact: mattia.rossi@eurac.edu
