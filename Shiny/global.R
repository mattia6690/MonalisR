# Source the functions in 'DependingFucntions.R'
source("DependingFunctions.R")

# Monalisa-Sos timeseries API url
starturl = "http://monalisasos.eurac.edu/sos/api/v1/timeseries/"

# parse url to JSON
xmlfile <- jsonlite::fromJSON(starturl)

# select feature of interest (station)
x<-select(xmlfile,contains("station")) %>% do.call(cbind,.) %>% select(.,contains("properties")) %>%
  do.call(cbind,.) %>% select(.,contains("label")) %>%  unique(.)

# select timeseries of the selected station
u<-xmlfile %>% select(contains("label"))

# process selection for print
u<-xmlfile %>% do.call(cbind,.) %>% as.list %>% do.call(cbind,.) %>% as.tibble()

names(u)[2:3] <- c("Observable properties", "Units")

rownames(x) <- NULL; colnames(x) <- "Stations"

# Available output format selection
format = list("csv", "RData", "txt")
