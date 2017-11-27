# MonalisR
## An R-package for handling open Databases for South Tyrol

This R-Package aims at accessing multiple open databases for the environmental parameters in the Autonomous Province of South Tyrol. The Databases are all openly accessible via central APIs and structurized storages. This makes them addressable and accessible via R. For all the Databases core functionalities were implemented simplifying

* data access and exploration
* spatial and data plots of locations (or stations) of interest
* download and storage of the desired dataset(s)<br>

For earch database the respective functions are devided according to the three tasks. Following that, th naming conventions utilize the prefixes *get*, *plot* and *download*

### DB01: The MONALISA Database
  
The [MONALISA project](http://monalisasos.eurac.edu/sos/index) (**MON**itoring key environmental parameters in the **AL**pine environment **I**nvolving **S**cience, technology and **A**pplication)
aims at the development of multi-scale monitoring approaches for key environmental parameters and production processes using innovative monitoring technologies and non-destructive methods in the application field of agriculture. <br>
Within this project the [MONALISA Database](http://monalisasos.eurac.edu/sos/static/client/helgoland/index.html#/map) has been created to store and distribute the wide variety of environmental parameters collected. Mainly based on Postgres, the Database works with OGC standardized format and it is distributed based on 52noths SOS impementation.<br>

### DB02: Meteorological Data

A second Platform to retrieve open Data for Science applications is now openly accessible via the [Open Data Portal](http://daten.buergernetz.bz.it/de/info) of the Autonomous Province of South Tyrol. On this Platform multiple meteorological variables have been opened to the public. A central API handles the request for each single Database stored. For now the package offers the possibilty to access one of these databases is addressable with this Package containing meteorological data of several fixed Stations continuously operated by the Meteorological Service of South Tyrol.<br>


#### Download the Package from Gitlab (development repository)

This Package is in an active development stage and therefore [privatly hosted in a Gitlab repository](https://gitlab.inf.unibz.it/REMSEN). It is available only to registered group members and the access has to be granted by one of the active members of the group (see [Members Section](https://gitlab.inf.unibz.it/SOS/MonalisR/project_members) or below)
A general way to load the package in R is provided with the following code:<br>

```r
library(devtools)
library(git2r)
library(getPass)

uname<-     "Your GITLAB username"

devtools::install_git("https://gitlab.inf.unibz.it/REMSEN/MonalisR", 
  credentials = git2r::cred_user_pass(uname, getPass::getPass()))

```

#### Download the Package from Gitlab (Open Repository)

The stable versions of the Packages will be shared on the [Open Repository](https://gitlab.inf.unibz.it/earth_observation_public) and can be downloaded without the need to provide the credentials: <br>

```r
library(devtools)

devtools::install_git("https://gitlab.inf.unibz.it/earth_observation_public//MonalisR")

```

#### Contributors

* [Mattia Rossi] (https://gitlab.inf.unibz.it/Mattia.Rossi)
* [Daniel Frisinghelli] (https://gitlab.inf.unibz.it/Daniel.Frisinghelli)<br>

<br>![](http://www.eurac.edu/Style%20Library/logoEURAC.jpg)<br><br>

#### Contact

For further information or interest/ideas for future development please contact: mattia.rossi@eurac.edu