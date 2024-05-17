library(rvest)
library(tidyverse)
library(httr)

#scraping the links from the stored html file

#reading links from the html file of the website scrolled to the end

links <- read_html("psyfinder.html") %>%
  html_elements(css = "a") %>%
  html_attr(name = "href")

#checking where the psychologists' profile links start and end

links[1:60]

links[3700:3796]

#profile links start at 56 and end at 3793

links_profiles <- links[56:3793]

#checking that the lenght is the same as the number of psychologist on the website

length(links_profiles)

#It was!

#saving the links to a csv file

write.csv(links_profiles, "profilelinks.csv", row.names = FALSE)

# reading the first profile on the list to form a basis for a loop

test <- read_html(links_profiles[1]) %>%
  html_elements(xpath = '//h3[.="Address"]/parent::div') %>%
  html_text2() %>%
  str_replace("Address\n", "") %>%
  str_replace_all("\n", " ")

test[[1]][1]

# Extract the zipcode of 4 digits from the address string
zipcode <- str_extract(test, "\\d{4}")

#turning links_profiles into a character vector
psychologist_combined2 <- data.frame(Title = character(), stringsAsFactors = FALSE)

#looping through all the profiles to extract the needed information

i <- 0
for (profile_link in links_profiles2) {
  i <- i + 1
  pages <- GET(
    profile_link,
    add_headers(From = "heini.jaervioe@stud.unilu.ch", 'User-Agent' = R.Version()$version.string)
  )
  if (status_code(pages) == 200) {
    # Check if the request was successful
    print("Success!")
  } else {
    print("Error!")
    print(status_code(pages))
  }
  Sys.sleep(5)
  
  
  bin <- content(pages, as = "parsed")
  
  availability <- bin %>%
    html_elements(xpath = '//div[.="Availability"]/parent::div') %>%
    html_text2() %>%
    strsplit("\n")
  
  group <- bin %>%
    html_elements(xpath = '//div[.="Target groups"]/parent::div') %>%
    html_text2() %>%
    strsplit("\n")
  
  bill <- bin %>%
    html_elements(xpath = '//div[.="Billing"]/parent::div') %>%
    html_text2() %>%
    strsplit("\n")
  
  lang <- bin %>%
    html_elements(xpath = '//div[.="Languages"]/parent::div') %>%
    html_text2() %>%
    strsplit("\n")
  
  addr <- bin %>%
    html_elements(xpath = '//h3[.="Address"]/parent::div') %>%
    html_text2() %>%
    str_replace("Address\n", "") %>%
    str_replace_all("\n", " ")
  
  zipcode <- str_extract(addr, "\\d{4}")

#saving the data to a dictionary object with the correct labels
  
  data <- list(
    address = addr[[1]][1],
    availability = availability[[1]][2],
    groups = group[[1]][2],
    languages = lang[[1]][2],
    billing = bill[[1]][2],
    zipcode = zipcode
  )
  
#turning the dictionary object into a dataframe
  
  psychologist_df <- data.frame(data)
  
  psychologist_combined2 <- rbind.data.frame(psychologist_combined2, psychologist_df)
}

#Saving the dataframe as a csv file

write.csv(psychologist_combined2, "psychologist2.csv", row.names = FALSE)
