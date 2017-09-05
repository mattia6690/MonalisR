source("DependingFunctions.R")
source("global.R")
source("server.R")
source("ui.R")

wd1<-getwd()
setwd("Shiny/Shiny/")

shinyApp(ui = ui, server=server)

setwd(wd1)