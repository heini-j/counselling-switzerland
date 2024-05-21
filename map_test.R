install.packages("sf")
install.packages("leaflet")
install.packages("tmap")

library(sf)
library(leaflet)
library(tmap)
library(dplyr)

#reading the shp file to R

?st_drivers
mapdata <- sf::st_read("daten.shp")

print(mapdata)
#plotting the map

tmap_mode("view")

tm_shape(mapdata) +
  tm_polygons(col = "white", border.col = "black") +
  tm_layout(legend.position = c("left", "bottom"))


#creating a map that shows the number of psychologists in each zipcode

zipcode_count <- data %>% group_by(PLZ) %>% summarise(count = n())

#merging the zipcode_count dataframe with the mapdata dataframe

mapdata <- merge(mapdata, zipcode_count, by.x = "PLZ", by.y = "PLZ", all.x = TRUE)

#plotting the map

tm_shape(mapdata) +
  tm_polygons(col = "count", border.col = "grey") +
  tm_layout(legend.position = c("left", "bottom"))

?tm_polygons






