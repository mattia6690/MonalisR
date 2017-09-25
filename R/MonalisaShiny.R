#' @title MONALISA Shiny App
#' @description This Shiny App accesses the MONSALISA Database via a central API.
#' With this App it is possible to access, visualize and download the desired data
#' directly from the server. The facilitated few-click access is designed for the
#' exploration of all stored and maintained datasets.
#' @import shiny
#' @import leaflet
#' @import magrittr
#' @import tibble
#' @import dplyr
#' @include ShinyUi.R
#' @include ShinyServer.R
#' @export

MonaShiny<-shinyApp(ui = ui, server=server)
