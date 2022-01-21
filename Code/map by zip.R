setwd("E:/CTO Office/event data analysis")
library(tidyverse)
library(dplyr)
library(tidyr)
library(ggplot2)
library(sf)
library(readxl)
#install.packages('usa')
library(usa)
#install.packages('chicagomap')
#install.packages('tidycensus')
#install.packages('gapminder')
library(tidycensus)
library(gapminder)

#zipcode to geography info with usa package
zcs <- usa::zipcodes
head(zcs)

#original dataset
zip <- read_excel('new_zip.xlsx')

#zipcode to geography info with usa package
try1 <- merge(x=zip, y=zcs, by='zip', all.x=TRUE)

try1$zip <- as.character(try1$zip)

# try1 <- try1 %>% filter(city == "Chicago")

#plot
#ggplot(df, aes(x = long, y = lat, fill = count, geometry = geometry))

#ggplot(try1)+
  #geom_sf(aes(fill = count, geometry = geometry))+
  #theme_minimal(base_size = 10)


# draw map with tidycensus
#census_api_key("c8505fbda9df327850422eaf26dc685297b80c63", install = TRUE)
CENSUS_KEY <- Sys.getenv("CENSUS_API_KEY")
Sys.getenv("CENSUS_API_KEY")

#课件上的参考语句
#acs_data <- get_acs(
  #geography = "state",
  #variables = c("B01001_001","B19013_001"),
#year = 2018
#) %>%
#arrange(NAME)


mydata <- get_acs(
  geography = 'zcta',
  variables = 'B19013_001',
  geometry = TRUE)

map <- mydata %>% separate(NAME, into = c("zcta", "zip")) %>% select(zip, geometry)

df <- try1 %>% left_join(map, by = "zip")

ggplot(data = df, aes(fill = frequency, geometry = geometry)) + geom_sf()+
  scale_fill_distiller(name='Attendance Frequency', trans='reverse')


