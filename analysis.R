library(tidyverse)

data <- read.csv("psychologist_combined.csv")

#find out all the unique values in the column zipcode

zipcode_list <- unique(data$zipcode)

#sorting the list

zipcode_list <- sort(zipcode_list)

zipcode_list

#data includes zipcodes that are not valid, so we need to filter out the invalid zipcodes

valid_zipcode <- zipcode_list[grepl("^\\d{4}$", zipcode_list)]

print(valid_zipcode)

#removing the profiles with invadid zipcodes from the data

psychologist_df <- data %>% filter(zipcode %in% valid_zipcode)

#this leaves us 3723 profiles for further analysis

#find out which zipcode has the most psychologists

zipcode_count <- psychologist_df %>% group_by(zipcode) %>% summarise(count = n()) %>% arrange(desc(count))

zipcode_count

#1003 has 141 psychologists, 3011 has 124 psychologists, 8006 has 99 psychologists

#create a new variable that groups zipcodes by the first digit of the zipcode

zipcode_count$first_digit <- substr(zipcode_count$zipcode, 1, 1)

#find out which first digit has the most psychologists

zipcode_count <- zipcode_count %>% group_by(first_digit) %>% summarise(count = sum(count)) %>% arrange(desc(count))

zipcode_count
#zipcodes starting with 1 has most psychologist (1208), then 8/ Zurich (946), 3/ Bern (418), 6/ Luzern (395)

#FInding out how many psychologist have "Covered by basic insurance" in their billing information

psychologist_df$billing <- as.factor(psychologist_df$billing)

psychologist_df %>% group_by(billing) %>% summarise(count = n()/3723)

#15 % don't have "covered by basic insurance" in their profile -> 85 % are!

#counting the availability of the 3723 psychologist on the list

psychologist_df %>% group_by(availability) %>% summarise(count = n()/3723)

#15,8 % are available in less than 2 weeks, 22,3 % in 2-4 weeks, 32,7 % at least four weeks, 29,2 % don't have any availability
#for 60 % of the psychologist one has to wait at least 4 weeks

#ggplot2#Turning the result in a table

billing_table <- psychologist_df %>% group_by(billing) %>% summarise(count = n()) %>% knitr::kable()

billing_table

install.packages("maps")
library(maps)




#creating a dataframe with the number of psychologists in each zipcode

zipcode_count <- data %>% group_by(PLZ) %>% summarise(count = n())

zipcode_count <- 

#merging the zipcode_count dataframe with the mapdata dataframe

mapdata$PLZ <- as.character(mapdata$PLZ)


#creating a dataframe with the number of psychologists in each zipcode

zipcode_count <- data %>% group_by(PLZ) %>% summarise(count = n())

