#' Set the MONALISA URL
#' @description Set the MONALISA URL or leave as default.
#' @param url character; Input the URL to the Timeseries of the MONALISA Database.
#' If this parameter is left empty the standard URL will be set.
#' @export

setMonalisaURL<-function(db=NA){
  
  if(is.na(db)) return("http://monalisasos.eurac.edu/sos/api/v1/timeseries/")
  else return(url)
}

#' @title Overview of the Monalisa Database
#' @description This function accesses the Monalisa Database via the API in JSON format
#' and returns a list of the peatured parameters.
#' @param url URL; URL of the Monalisa SOS API. If empty a default path is used
#' @param subset character; The subset of interest. If left empty the whole Data frame will be returned. 
#' Possible Subsets are "foi","procedure","property"
#' @examples 
#' 
#' # Get the Information hosted in the MONALISA Database
#' mnls<-getMonalisaDB()
#' mnls2<-getMonalisaDB(subset="property")
#' mnls3<-getMonalisaDB(subset="station")
#' 
#' # END
#' 
#' @import magrittr
#' @importFrom jsonlite fromJSON
#' @importFrom stringr str_split
#' @importFrom dplyr select
#' @export

getMonalisaDB<-function(url=NA,subset=""){
  
  if(is.na(url)){
    url <- setMonalisaURL()
    xmlfile <- jsonlite::fromJSON(url)
  }else{xmlfile <- jsonlite::fromJSON(url)}
  
  if(subset=="") return(xmlfile)
  
  split<-str_split(xmlfile$label,",")
  
  if(subset=="foi"){
    lsp1<- split %>% 
      sapply(.,"[[",2) %>% 
      unique
    return(lsp1)
  }
  
  if(subset=="procedure"){
    lsp1<-split %>% 
      sapply(.,"[[",1)
      str_split(.," ")
    lsp2<-lsp1 %>% 
      grepl(pattern = "_",unlist(.)) %>% 
      which %>% 
      unlist(lsp1)[.] %>% 
      unique
    return(lsp2)
  }
  
  if(subset=="property"){
    lsp1<-split %>% 
      sapply(.,"[[",1) %>% 
      gregexpr(pattern =' ',.)
    lsp2<-lsp1 %>% 
      lapply(., function(x){x[length(x)]}) %>% 
      unlist %>% 
      substring(lsp1,1,.) %>%
      unique
    
    return(lsp2)
  }
}
