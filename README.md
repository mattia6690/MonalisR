
# MonalisR <a href="https://mattia6690.github.io/MonalisR"><img align="right" src="man/figures/logo.png" width="25%"></a>
[![Build Status](https://travis-ci.org/mattia6690/MonalisR.svg?branch=master)](https://travis-ci.org/mattia6690/MonalisR) 
[![CRAN](http://www.r-pkg.org/badges/version/MonalisR)](https://cran.r-project.org/package=MonalisR)
[![Lifecycle:stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
## Handling open Databases in South Tyrol

This R-Package is designed to interact with open environmental databases in the Autonomous Province of South Tyrol in Italy. Our mission is to use exposed APIs in order to etrieve a multitude of environmental variables. This approach guarantees a steady and reproducible access to a wide variety of data potentially interesting for diverse scientific research.For each database core functionalities were implemented aiming at simplifying:

* data access and exploration
* download and storage of the desired data set(s)
* spatial plotting of the data <br>

For each database the respective functions are divided according to these three tasks. Following that, the naming conventions utilize the prefixes *get*, *plot* and *download*.


### Databases

This package offers the possibility to access databases exposing JSON Files with [Sensor Observation Service (SOS)](http://www.opengeospatial.org/standards/sos) convention defined by the [Open Geospatial Consortium (OGC)](http://www.opengeospatial.org/) or by [CKAN APIs](https://ckan.org/portfolio/api/). We implemented the access to two different Databases as exposed by [EURAC Research](www.eurac.edu) and the [OpenData Portal South Tytol](http://daten.buergernetz.bz.it/).
Both Databases offer rich environmental and meteorological Databases across the province of South Tyrol.

#### MONALISA
  
The [MONALISA project](http://monalisasos.eurac.edu/sos/index) (**MON**itoring key environmental parameters in the **AL**pine environment **I**nvolving **S**cience, technology and **A**pplication) aims at the development of multi-scale monitoring approaches for key environmental parameters and production processes using innovative monitoring technologies and non-destructive methods in the application field of agriculture. 
Within this project the [MONALISA Database](http://monalisasos.eurac.edu/sos/static/client/helgoland/index.html#/map) has been created to store and distribute the wide variety of environmental parameters collected.<br>

#### Open Data Portal South Tyrol - Meteo Data

A second platform to retrieve open data for scientific applications is now openly accessible via the [Open Data Portal](http://daten.buergernetz.bz.it/de/info) of the Autonomous Province of South Tyrol. On this platform multiple meteorological variables have been opened to the public. A central API handles the request for each single database stored. For now the package offers the possibility to access one of these databases is addressable with this package containing meteorological data of several fixed Stations continuously operated by the Meteorological Service of South Tyrol.<br>


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