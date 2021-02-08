

library("XML2")
library("tibble")
library("magrittr")
library("dplyr")
library("jsonlite")
library("tidyr")


url<-"http://monalisasos.eurac.edu/sos/api/v1/offerings/"
fromJSON(url)

get1    <-getMonalisaDB(subset="combined") %>% as_tibble()
get.geom<-getMonalisaDB(subset="geom") %>% as_tibble()
get.all <-getMonalisaDB() %>% as_tibble()

foi1  <-"domef1500"
proc1 <-""
prop1 <-"Normalized Difference Vegetation Index - average"
s <- "2016-12-01 00:00"
e <- "2016-12-05 00:00"
down<-downloadMonalisa(datestart=s,dateend=e,foi=foi1,procedure=proc1,property=prop1)

myfois<-c("domef1500","domef2000","domes1500","domes2000","dopas2000",
  "nemef1500","nemef2000","nemes1500","nemes2000","nepas2000",
  "vimef2000", "vimes1500","vimef1500","vimes2000","vipas2000")

myfois<-c("domef1500","domef2000",
          "nemef1500","nemef2000",
          "vimef2000", "vimes1500")


coords<-get.geom %>% 
  mutate(coords=paste(LAT,LON)) %>% 
  dplyr::filter(is.element(FOI,myfois)) %>% 
  arrange(FOI)
coords2<-paste(coords$coords,collapse=", ")

myfois<-get1$foi %>% unique


get2<-get1 %>% arrange(foi) %>% 
  dplyr::filter(is.element(foi,myfois)) %>% 
  mutate(sensor=strsplit(proc,"_")[[1]][1])


proc<-get2$proc %>% unique()

getO<-getMonalisaDB(subset="property") %>% as_tibble()

