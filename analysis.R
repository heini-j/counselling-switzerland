library(tidyverse)

data <- read.csv("psychologist_combined.csv")

#find out all the unique values in the column zipcode

zipcode_list <- unique(data$zipcode)

#sorting the list

zipcode_list <- sort(zipcode_list)

zipcode_list

#data includes zipcodes that are not valid, so we need to filter out the invalid zipcodes

valid_zipcode <- zipcode_list[grepl("^\\d{4}$", zipcode_list)]

#removing the profiles with invadi zipcodes from the data

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
#zipcodes starting with 1 has most psychologist (1208), then Zurich (946), Bern (418), Luzern (395)

#FInding out how many psychologist have "Covered by basic insurance" in their billing information

psychologist_df$billing <- as.factor(psychologist_df$billing)

psychologist_df %>% group_by(billing) %>% summarise(count = n())

#Turning the result in a table

billing_table <- psychologist_df %>% group_by(billing) %>% summarise(count = n()) %>% knitr::kable()

billing_table

install.packages("maps")
library(maps)

