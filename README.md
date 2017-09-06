
# MonalisR
### An R-package for accessing, visualizing, downloading data provided in the MONALISA Database
   
  
The MONALISA (MONitoring key environmental parameters in the ALpine environment Involving Science, technology and Application) project's main goal is the development of multi-scale monitoring approaches for key environmental parameters and production processes using innovative monitoring technologies and non-destructive methods in the application field of agriculture.
Within this project a database has been created to store and distribute the wide variety of environmental parameters collected. Mainly based on Postgres the Database works with OGC standardized format and is distributed based on 52noths SOS impementation.
This Package provides a possibility to access this database via R. Hereby core functionalities are implemented in this package for:
* Accessing and exploring the data stored
* Plotting the locations (or stations) of interest spatially
* Downloading and storing the desired dataset(s)

In future other possibilities of accessing the database will be established e.g. through server utilizing rocker containers and Shiny.
