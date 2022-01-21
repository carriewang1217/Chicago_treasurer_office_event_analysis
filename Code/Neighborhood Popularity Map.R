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

# original dataset
zip <- read_excel('new_zip.xlsx')

# zipcode to geography info with usa package
zip_geo <- merge(x=zip, y=zcs, by='zip', all.x=TRUE)

zip_geo$zip <- as.character(zip_geo$zip)

# zip_geo <- zip_geo %>% filter(city == "Chicago")


# draw map with tidycensus
#census_api_key("your census API key", install = TRUE)
CENSUS_KEY <- Sys.getenv("CENSUS_API_KEY")
Sys.getenv("CENSUS_API_KEY")

mydata <- get_acs(
  geography = 'zcta',
  variables = 'B19013_001',
  geometry = TRUE)

# separate zcta and zip code
map <- mydata %>% separate(NAME, into = c("zcta", "zip")) %>% select(zip, geometry)

df <- zip_geo %>% left_join(map, by = "zip")

# Plot
ggplot(data = df, aes(fill = frequency, geometry = geometry)) + geom_sf()+
  scale_fill_distiller(name='Attendance Frequency', trans='reverse')


