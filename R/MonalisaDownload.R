#' @title Download MONALISA Data
#' @description Core script for handling the data provided in the MONALISA Database
#' collected and stored by EURAC Research. For more information please visit http://monalisasos.eurac.edu/sos/.
#' @param starturl URL, Path to the  MONLISA Database. 
#' If empty the adress of the EURAC Monalisa Database (as available on 30.01.2017) will automatically be pasted.
#' @param datestart date, Starting Date required in "Y-m-d H:M" format.
#' @param dateend date, End Date required "Y-m-d H:M" format.
#' @param foi Character, Input for the FOI. Multiple input possible. Read Notes for further information
#' @param procedure Character, Input for the Procedure. Multiple input possible. Read Notes for further information
#' @param property Character, Input for the Property. Multiple input possible. Read Notes for further information
#' @param path Character, Path for the Output of a RData File with the Respnse from the SOS Server. 
#' If blank the Output is returned as an object in the R Environment.
#' @param abbr Boolean, Do you want the Properties to be automatically abbreviated in the Output? 
#' If TRUE the Abbreviate() function is applied.
#' @param csv Boolean, Additionally Save as csv?
#' @note 
#' For the Parameters foi, procedures and property the Input can be left empty. This is standard for the function. 
#' In this case the respective items are listed and can then be selected one by one by digitizing the index number. 
#' 
#' When the three parameters are left empty ("") every element is taken into consideration
#' @examples
#' 
#' s <- "2016-01-01 00:00"
#' e <- "2016-12-31 00:00"
#' mnls_down<-downloadMonalisa(datestart = s,dateend = e)
#' 
#' downloadMonalisa(datestart = s,dateend = e,path= "Tempdir",csv=T)
#' 
#' #END
#' 
#' @import dplyr
#' @import stringr
#' @import magrittr
#' @import tibble
#' @importFrom jsonlite fromJSON
#' @importFrom purrr map_if map2
#' @importFrom utils write.csv
#' @export

downloadMonalisa <- function(starturl=NULL, datestart, dateend, foi = NULL, procedure = NULL, property = NULL,path = "", abbr=F, csv = F){

  # Handle Exceptions
  if((as.Date(dateend)-as.Date(datestart))>365) stop("The selected timespan has to be 1 Year or below")
  if(is.null(starturl)) starturl<-setMonalisaURL()
  
  x<-getMonalisaDB(url=starturl,subset="combined") %>% as.data.frame()
  
  # Dates
  datestart1 <- datestart %>% str_replace(.," ","T") %>% paste0(.,":00%2F")
  dateend1<-dateend %>%  str_replace(.," ","T") %>% paste0(.,":00")
  
  # FOIs
  if(length(foi)==1){
    if(is.null(foi)){
      y<-x$foi %>% unique %>% as.data.frame %>% print
      z<-readline(prompt = "Please digit the ID of the desired FOI:      ")
      z<- suppressWarnings(str_split(z,",") %>% unlist %>% as.numeric)
      if(is.na(z)) stop("Please insert a FOI or insert it in the Function")
      foi1<-y[z,] %>% as.character
    }
    if(foi=="") foi1<-x$foi %>% unique
  }
  
  if(!is.null(foi) & foi!=""){
    
    ie<-is.element(foi,as.character(x$foi))
    if(!all(ie)) stop("One of the input FOIs were not found in the SOS Database")
    foi1 <- foi
    
  }

  # Observable Properties
  if(length(property)==1){
    if(is.null(property)){
      y<- x$prop %>% unique %>% as.data.frame %>% print
      z<- readline(prompt = "Please digit the ID of the desired Property:      ")
      z<- suppressWarnings(str_split(z,",") %>% unlist %>% as.numeric)
      if(is.na(z)) stop("Please insert a Property or insert it in the Function")
      prop1<-y[z,] %>% as.character
    }
    if(property=="") prop1<-x$prop %>% unique
  }
  
  if(!is.null(property) & property!=""){
    
    ie<-is.element(property,as.character(x$prop))
    if(!all(ie)) stop("One of the input OBSERVABLE PROPERTIES were not found in the SOS Database")
    prop1 <- property
    
  }
  
  # Procedure
  if(length(procedure)==1){
    if(is.null(procedure)){
      y<-x$proc %>% unique %>% as.data.frame %>% print
      z<-readline(prompt = "Please digit the ID of the desired Procedure:      ")
      z<- suppressWarnings(str_split(z,",") %>% unlist %>% as.numeric)
      if(is.na(z)) stop("Please insert a Procedure or insert it in the Function")
      proc1<-y[z,] %>% as.character
    }
    if(procedure=="") proc1<-x$proc %>% unique
  } 
  
  if(!is.null(procedure) & procedure!=""){
    
    ie<-is.element(procedure,as.character(x$proc))
    if(!all(ie)) stop("One of the input PROCEDURES were not found in the SOS Database")
    proc1 <- procedure
    
  }
  
  #Filter for Inputs
  au<-x %>% 
    filter(foi %in% foi1) %>% 
    filter(proc %in% proc1) %>% 
    filter(prop %in% prop1)
  
  if(nrow(au)==0) stop("The Combination of FOI, Property and Procedure is not available")
  
  # Get the Response from the Server and Modify the List
  url1<-paste0(starturl,au$id,"/getData?timespan=",datestart1,dateend1)
  response<-lapply(url1,function(i){
    u<-jsonlite::fromJSON(i)
    u<-do.call(cbind,u)
    u[,1]<-convertDate(u[,1])
    colnames(u)<-c("TimeStamp","Value")
    return(u)})
  
 
  #Create the Filenames
  date_s <- datestart %>% str_replace(":","") %>% str_replace(" ", "T")
  date_e <- dateend %>%  str_replace(":","") %>% str_replace(" ", "T")
  ifelse(abbr==T,pp<-abbreviate(au$prop),pp<-au$prop)
  myfile <- paste0(path, "/", "SOS_", au$foi, "_",au$proc,"_",pp,"_",date_s,"&", date_e)
  
  # Save the Files
  map2(myfile,response, function(i,j){
    
    if(path != ""){
      save(j, file = paste0(i,".RData"))
      if(csv == T){
        write.csv(j, paste0(i,".csv"))
      }
    }
  })
  
  return(response)
}



# 
# # Save
# if(path != ""){
#   save(DAT, file = paste0(myfile,".RData"))
#   if(csv == T){
#     write.csv(DAT, paste0(myfile,".csv"))
#   }
# }
# return(DAT)
# # Get Timeseries
# u<-xmlfile %>% select(contains("label"))
# 
# # Readline Option
# u<-xmlfile %>% 
#   do.call(cbind,.) %>% as.list %>% 
#   do.call(cbind,.) %>% as.tibble  %>% 
#   filter(station.properties.label==foi)
# print(u)
# r<-readline(prompt = "Please digit the ID of the desired Properties for your FOI:      ")
# r<- strsplit(r,",") %>% unlist
# 
# # Error handling
# a<-suppressWarnings(as.numeric(r))
# if(any(is.na(a))) stop("Please Digit Numbers for the IDs")
# 
# # Get required TS
# ID <-u[a,] %>% select(id) %>% as.matrix()
# 
# # for loop building requests depending on the number of user inputs
# request<-list()
# DAT <- list()
# for(i in 1:length(ID)){
#   
#   url1<-paste0(starturl,ID[i],"/getData?timespan=")
#   
#   datestart1 <- datestart %>% str_replace(.," ","T") %>% paste0(.,":00%2F")
#   dateend1<-dateend %>%  str_replace(.," ","T") %>% paste0(.,":00")
#   
#   # Request & Parsing
#   request[i]<-paste0(url1,datestart1,dateend1)
#   SOS_data <- jsonlite::fromJSON(request[[i]]) %>% do.call(cbind,.)
#   SOS_data[,1] <- convertDate(SOS_data[,1])
#   
#   # Header definition
#   property_spec <- u[a[i],] %>% select(label) %>% map_if(is.factor, as.character) %>% unlist %>%
#     strsplit(.,"-") %>% unlist
#   
#   property <- property_spec[1]
#   spec <- property_spec[2] %>% str_replace(.," ", "") %>% str_split(., "[:blank:][:upper:]") %>% unlist %>% .[1]
#   colnames(SOS_data) <- c("Timestamp", paste0(property,"(",spec,")"))
#   SOS_data$FOI<-rep(foi,times=nrow(SOS_data))
#   
#   # Append data to List
#   DAT[[i]] <- SOS_data
# }
# 
# # Output Infos
# date_s <- datestart %>% str_replace(":","") %>% str_replace(" ", "T")
# date_e <- dateend %>%  str_replace(":","") %>% str_replace(" ", "T")
# myfile = paste0(path, "/", "SOS4R_", foi, "_", date_s, "&", date_e)
# 
# # Save
# if(path != ""){
#   save(DAT, file = paste0(myfile,".RData"))
#   if(csv == T){
#     write.csv(DAT, paste0(myfile,".csv"))
#   }
# }
# return(DAT)
# }
# 
# 
# 
# 
# 
# 
# 
