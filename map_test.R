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

?tmap_mode

tmap_mode("plot")

#renaming the zipcode column to "PLZ" to match with the names in the shapefile

data$PLZ <- data$zipcode

#creating a map that shows the number of psychologists in each zipcode

psyc_count <- data %>% group_by(PLZ) %>% summarise(count = n())

#merging the zipcode_count dataframe with the mapdata dataframe

mapdata <- merge(mapdata, psyc_count, by.x = "PLZ", by.y = "PLZ", all.x = TRUE)

#creating a map that shows the number of psychologists in each zipcode

tm_shape(mapdata) +
  tm_polygons(col = "count", 
              border.col = "grey",
              lwd = 0.1,
              palette = "BuPu", 
              n = 3,
              style = "log10_pretty",
              colorNA = "white") +
  tm_layout(main.title = "N of psychologist in each zipcode",
            scale = 0.8,
            bg.color = "grey85",
            legend.outside = TRUE,
            legend.position = c("right", "bottom"))

#next looking at the number of psychologist relative to the population in each zipcode
#reading an excel file to R

bevol_data <- readxl::read_excel("bevolkerung.xlsx")

#selecting columns of interest


print(bevol_data[[1]])

#column 1 includes the zipcodes

print(bevol_data[[2]])

#column 2 includes the population

#renaming column 1 in bevol_data as "PLZ" to match with the names in the shapefile

bevol_data$PLZ <- bevol_data[[1]]

#renaming column 2 in bevol_data as "population"

bevol_data$population <- bevol_data[[2]]

#separating the 2 new columns from the rest of the data

bevol_data <- bevol_data[, c("PLZ", "population")]

#first 3 rows include unnecessary information so removing them

bevol_data <- bevol_data[-c(1:3),]

#creating a new variable that divides population by number of psychologists in each zipcode


#creating a dataframe of bevol_data where the zipcodes are in the valid_zipcode list

bevol_data <- bevol_data %>% filter(PLZ %in% valid_zipcode)

#filtering the same zipcodes in the mapdata dataframe

psyc_count <- psyc_count %>% filter(PLZ %in% valid_zipcode)

mapdata$psyc_relative <-  mapdata$count / bevol_data$population

#Error in bevol_data$population/mapdata$count : non-numeric argument to binary operator

#converting the columns to numeric

bevol_data$population <- as.numeric(bevol_data$population)



?tm_layout

?tm_shape

?tm_polygons

tmaptools::palette_explorer()

#creating a map that shows the variation in the "availability" variable in each zipcode

availability_count <- data %>% group_by(PLZ, availability) %>% summarise(count = n())

#merging the availability_count dataframe with the mapdata dataframe

mapdata <- merge(mapdata, availability_count, by.x = "PLZ", by.y = "PLZ", all.x = TRUE)



#reading an excel file to R

bevol_data <- readxl::read_excel("bevolkerung.xlsx")

View(bevol_data[2])






