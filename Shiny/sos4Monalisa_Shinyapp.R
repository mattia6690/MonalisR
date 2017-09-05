setwd(paste0(getwd(),"/Shiny/Shiny/"))
source("DependingFunctions.R")
source("global.R")
source("server.R")
source("ui.R")

shiny<-shinyApp(ui = ui, server=server)


setwd("~/07_Codes/MonalisR")