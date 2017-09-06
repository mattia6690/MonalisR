#' @title Monalisa Shiny
#' @description Open Shiny for Access, Visualization and Download of Data collected in the MONALISA Database (EURAC Reseach)
#' @export

MonaShiny<-function() {
  
  setwd("~/07_Codes/MonalisR/Shiny")
  source("DependingFunctions.R")
  source("global.R")
  source("server.R")
  source("ui.R")
  shiny<-shinyApp(ui = ui, server=server)
  setwd("~/07_Codes/MonalisR")
  
  return(shiny)
} 


