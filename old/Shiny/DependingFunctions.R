###############################################
### Program for the automatic SOS Download ####
### By Mattia Rossi, EURAC ####################
###############################################

# Function to check if library 'mypgk' is available
loadandinstall <- function(mypkg) {if (!is.element(mypkg, installed.packages()[,1]))
{install.packages(mypkg, repos = "http://cran.r-project.org/")}; library(mypkg, character.only=TRUE)  }

# Initialization of the Packages
loadandinstall("jsonlite")
loadandinstall("dplyr")
loadandinstall("tidyverse")
loadandinstall("stringr")
loadandinstall("tibble")
loadandinstall("lubridate")
loadandinstall("reshape")
loadandinstall("gridExtra")
loadandinstall("shiny")

# Adjust the time format in the MONALISA Package
.mnls_time       <- function(time){

  u<-str_replace(time,"T"," ")
  u<-str_replace(u,"Z","")
  u<-str_replace(u,".000","")
  return(u)

}

# Convert the Dates from the SOS from Julian to Normal
convert_sos_date <- function(date){
  date = date/1000
  as.POSIXct(date, origin = "1970-01-01")
}

# Check for gaps
check_gaps <- function(x){
  check_data <- x
  
  gaps_date <- which(diff(check_data$Timestamp) > 10) %>% check_data$Timestamp[.]
  gaps_date <- gaps_date + min(diff(check_data$Timestamp))*60
  
  gaps_date <- data.frame("Missing values" = gaps_date)
  
  return(gaps_date)
}


# Create a Lineplot GGPlot for a Download
SOS_get_lineplot<-function(x){
  
  x1<-x %>% names
  colnames(x)<-c("Timestamp","values","FOI")
  nms<-x %>% names
  
  g1<-ggplot(data=x,aes(Timestamp,values))+
    geom_line()+
    ggtitle(paste0("Variablility of ",x1[2]),unique(x$FOI))+
    ylab(x1[2])#+
    #geom_smooth(stat="smooth",linetype="dashed")
  
  return(g1)
  
}

# Create a Boxplot GGPlot for a Download
SOS_get_boxplot<-function(x){
  
  x1<-x %>% names
  colnames(x)<-c("Timestamp","values","FOI")
  x$Timestamp<-as.Date(x$Timestamp)
  x2<-x %>% group_by(Timestamp)
  
  g2<-ggplot(x,aes(Timestamp,values,group=Timestamp))+ 
    geom_boxplot()+
    ggtitle(paste0("Variablility of ",x1[2]),unique(x$FOI))+
    ylab(x1[2])
  
  return(g2)
  
}

# Combine the Plots
arrange_SOS_plots<-function(g1,g2) grid.arrange(g1,g2,nrow=2)


