# MonalisR
## An R-package for handling open Data in South Tyrol

### The MONALISA Database
  
The MONALISA (MONitoring key environmental parameters in the ALpine environment Involving Science, technology and Application) project's main goal is the development of multi-scale monitoring approaches for key environmental parameters and production processes using innovative monitoring technologies and non-destructive methods in the application field of agriculture. <br>
Within this project a database has been created to store and distribute the wide variety of environmental parameters collected. Mainly based on Postgres, the Database works with OGC standardized format and it is distributed based on 52noths SOS impementation.<br>
This R-package provides a possibility to access this database via R. Hereby core functionalities are implemented in this package for:

* Accessing and exploring the data stored
* Plotting the locations (or stations) of interest spatially
* Downloading and storing the desired dataset(s)<br>


### Meteorological Data

A second Database contains meteorological Data of the meteorological Service of South Tyrol. This Database is now openly accessible via the [Open Data Portal](http://daten.buergernetz.bz.it/de/info) of the Autonompus Province of South Tyrol. On this Platform multiple different Databases have been opened to the public. A central API handles the request for each single Database stored. <br>
The codes within this package aims at interacting with the central API and provides core functionalities for different data handling tasks:

* Accessing and exploring the data stored
* Plotting the locations (or stations) of interest spatially
* Downloading and storing the desired dataset(s)<br>


#### Download the Package from Gitlab

A general Way to load the package in R is provided with the following code:<br>

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
Since the Gitlab Repository for now is available only to registered group members the access to the Gitlab repository has to be granted by one of the active members (see below).

#### Contributors

* [Mattia Rossi] (https://gitlab.inf.unibz.it/Mattia.Rossi)
* [Daniel Frisinghelli] (https://gitlab.inf.unibz.it/Daniel.Frisinghelli)

#### Contact

For further information please contact: mattia.rossi@eurac.edu