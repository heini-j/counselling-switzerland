library(sf)
library(leaflet)
library(tmap)
library(dplyr)
library(shinyjs)

#reading the shp file for a map of switzerland with zipcode areas to R

mapdata <- sf::st_read("zipcodemap.shp")

#checking that the data was read correctly

print(mapdata)

#plotting the map


tmap_mode("plot")

#renaming the zipcode column to "PLZ" to match with the names in the shapefile

psychologist_df$PLZ <- psychologist_df$zipcode

#creating a map that shows the number of psychologists in each zipcode

psyc_count <- psychologist_df %>% group_by(PLZ) %>% summarise(count = n())

#merging the zipcode_count dataframe with the mapdata dataframe

mapdata <- merge(mapdata, psyc_count, by.x = "PLZ", by.y = "PLZ", all.x = TRUE)

mapdata <- merge(mapdata, psyc_log, by.x = "PLZ", by.y = "PLZ", all.x = TRUE)

mapdata$log2_count <- log2(mapdata$count)

#creating a map that shows the number of psychologists in each zipcode

tm_shape(mapdata) +
  tm_polygons(col = "log2_count", 
              border.col = "grey",
              lwd = 0.1,
              palette = "BuPu", 
              n = 6,
              style = "pretty",
              colorNA = "white") +
  tm_layout(main.title = "Log2 of number of psychologist in each zipcode",
            main.title.size = 0.8,
            bg.color = "grey85",
            legend.outside = TRUE,
            legend.position = c("right", "bottom"))

#next looking at the number of psychologist relative to the population in each zipcode
#reading an excel file to R

popdata <- read.csv("populationPLZ.csv")

#selecting columns of interest

View(popdata)

#ccreating a map that shows the population in each zipcode to visually compare with the number of psychologists

mapdata <- merge(mapdata, popdata, by.x = "PLZ", by.y = "PLZ", all.x = TRUE)

tm_shape(mapdata) +
  tm_polygons(col = "N", 
              border.col = "grey",
              lwd = 0.1,
              palette = "BuPu", 
              n = 6,
              style = "pretty",
              colorNA = "white") +
  tm_layout(main.title = "Population in each zipcode",
            main.title.size = 0.8,
            bg.color = "grey85",
            legend.outside = TRUE,
            legend.position = c("right", "bottom"))

#creating a map that shows the relative number of psychologist per population in each zipcode

mapdata$pop_psyc <- mapdata$N/mapdata$count

tm_shape(mapdata) +
  tm_polygons(col = "pop_psyc", 
              border.col = "grey",
              lwd = 0.1,
              palette = "BuPu", 
              n = 6,
              style = "pretty",
              colorNA = "white") +
  tm_layout(main.title = "Population / psychologist in each postcode",
            main.title.size = 0.8,
            bg.color = "grey85",
            legend.outside = TRUE,
            legend.position = c("right", "bottom"))


?as.numeric
?tm_layout

?tm_shape

?tm_polygons

tmaptools::palette_explorer()

#checking which values the availablity variable in psychologist_df takes

unique(psychologist_df$availability)









