#install.packages('tidyverse')
#install.packages('sf')
#install.packages('tmap')
library(ggplot2)
library(tmap)
library(tmaptools)
library(leaflet)
library(dplyr)
library(sf)
library(tidyverse)

setwd("F:/00-career development/mayor office intern/work/event data analysis")

options(scipen = 999)

mydata <-  readxl::read_xlsx("new_zip.xlsx")
mymap <-  st_read('geo_chicago.shp', 
                stringsAsFactors=FALSE)
#这里出现过错误，注意shp file的directory里一定要有shx文件。
#而且stringsAsFactors别拼错了，漏了一个s.

str(mymap)

map_and_data <- merge(mymap, mydata)

tm_shape(map_and_data) +
  tm_polygons('frequency', id = 'zip', palette = 'Greens')
tmap_mode('view')
testmap <- tmap_last()
tmap_save(testmap, 'test_map.html')

ggplot(map_and_data) +
  geom_sf(aes(fill=frequency)) +
  scale_fill_gradient(low='#56B1F7', high='#132B43')

          