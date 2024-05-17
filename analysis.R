library(tidyverse)


df1 <- read.csv("psychologist.csv")
df2 <- read.csv("psychologist2.csv")
View(df2)

# Combine the two dataframes

psychologist_df <- rbind(df1, df2)

#save the new dataframe as a csv file

write.csv(psychologist_df, "psychologist_combined.csv")

#find out all the unique values in the column zipcode

zipcode_list <- unique(psychologist_df$zipcode)

#sort l

zipcode_list <- sort(zipcode_list)

class(zipcode_list)

#find out which zipcode has the most psychologists

zipcode_count <- psychologist_df %>% group_by(zipcode) %>% summarise(count = n()) %>% arrange(desc(count))

#create a new variable that groups zipcodes by the first digit of the zipcode

zipcode_count$first_digit <- substr(zipcode_count$zipcode, 1, 1)

#find out which first digit has the most psychologists

zipcode_count <- zipcode_count %>% group_by(first_digit) %>% summarise(count = sum(count)) %>% arrange(desc(count))

zipcode_count
#Vaud eniten, sitten Zurich, sitten Bern, sitten Luzern


#find out which profile has NA for the zipcode

na_zipcode <- psychologist_df %>% filter(is.na(zipcode))



zipcode_count[1,]
zipcode_count[2,]
