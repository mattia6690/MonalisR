
# MonalisR <a href="https://mattia6690.github.io/MonalisR"><img align="right" src="man/figures/logo.png"/></a>
## An R-package for handling open Databases for South Tyrol

This R-Package aims at accessing multiple open databases for the environmental parameters in the Autonomous Province of South Tyrol. The databases are all openly accessible via central APIs and structurized storages. This makes them addressable and accessible via R. For all the databases core functionalities were implemented simplifying

* data access and exploration
* spatial and data plots of locations (or stations) of interest
* download and storage of the desired dataset(s)<br>

For each database the respective functions are devided according to the three tasks. Following that, th naming conventions utilize the prefixes *get*, *plot* and *download*.

Additionally the repository contains a */Demo* folder with exemplary codes showing the basic functionalities of the MonalisR package.

### Databases

This package offers the possibility to access databases exposing JSON Files with [Sensor Observation Service (SOS)](http://www.opengeospatial.org/standards/sos) convention defined by the [Open Geospatial Consortium (OGC)](http://www.opengeospatial.org/) or by [CKAN APIs](https://ckan.org/portfolio/api/). We implemented the access to two different Databases as exposed by [EURAC Research](www.eurac.edu) and the [OpenData Portal South Tytol](http://daten.buergernetz.bz.it/).
Both Databases offer rich environamental and meteorological Databases across the province of South Tyrol.

#### MONALISA
  
The [MONALISA project](http://monalisasos.eurac.edu/sos/index) (**MON**itoring key environmental parameters in the **AL**pine environment **I**nvolving **S**cience, technology and **A**pplication) aims at the development of multi-scale monitoring approaches for key environmental parameters and production processes using innovative monitoring technologies and non-destructive methods in the application field of agriculture. 
Within this project the [MONALISA Database](http://monalisasos.eurac.edu/sos/static/client/helgoland/index.html#/map) has been created to store and distribute the wide variety of environmental parameters collected.<br>

#### Open Data Portal South Tyrol - Meteo Data

A second platform to retrieve open data for scientific applications is now openly accessible via the [Open Data Portal](http://daten.buergernetz.bz.it/de/info) of the Autonomous Province of South Tyrol. On this platform multiple meteorological variables have been opened to the public. A central API handles the request for each single database stored. For now the package offers the possibilty to access one of these databases is addressable with this package containing meteorological data of several fixed Stations continuously operated by the Meteorological Service of South Tyrol.<br>


### Download the Package

The stable versions of the packages will be shared on the [Github](https://github.com/mattia6690/MonalisR) and can be downloaded without the need to provide the credentials: <br>

```r
library(devtools)

devtools::install_github("https://github.com/mattia6690/MonalisR")

```

### Contributors & Contact

[Mattia Rossi](https://github.com/mattia6690)  <br>
[Daniel Frisinghelli](https://gitlab.inf.unibz.it/Daniel.Frisinghelli)  <br>

![](http://www.eurac.edu/Style%20Library/logoEURAC.jpg)