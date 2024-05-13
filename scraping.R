library(rvest)
library(tidyverse)
library(httr)

#scraping the links from the stored html file

#1. read the html file

links <- read_html("psyfinder.html") %>%
  html_elements(css = "a") %>%
  html_attr(name = "href")

#checking where the profile links start and end

links[1:60]

links[3700:3796]

#profile links start at 56 and end at 3793

links_profiles <- links[56:3793]

profile_list <- vector(mode = "list", length = length(links_profiles))

#2. extract the links

write.csv(links_profiles, "profilelinks.csv", row.names = FALSE)

#checking that the lenght is the same as the number of psychologist on the website

length(links_profiles)

#It was!


# reading the first profile on the list to form a basis for a loop

page <- httr::GET(
  links_profiles[3],
  httr::add_headers(From = "heini.jaervioe@stud.unilu.ch", `User-Agent` = R.Version()$version.string)
)

bin <- content(page, as = "parsed")

writeBin(object = bin, con = "testpage.html")

#reading the needed information from the first profile in the html file


titles <- read_html(here::here("testpage.html")) %>%
  html_elements(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "align-items-start", " " ))] | //*[contains(concat( " ", @class, " " ), concat( " ", "border-color-pumpkin-500", " " ))] | //*[contains(concat( " ", @class, " " ), concat( " ", "body-4", " " ))]//div') %>%
  html_text2() %>%
  strsplit("\n")

#checking where the needed information is located in the list
titles

#creating a dictionary with the elements we need for the analysis

data <- list(
  address = titles[[11]][3],
  availability = titles[[4]][2],
  groups = titles[[8]][2],
  languages = titles[[9]][2],
  billing = titles[[10]][2]
)

#turning the dictionary into a dataframe

psychologist_df <- as.data.frame(data)

#saving the data frame as a csv file

write.csv(psychologist_df, "psychologist.csv", row.names = FALSE)

#4. loop over the links and scrape the content

links_profiles[1:5]


test <- read_html(links_profiles[1]) %>%
  html_elements(xpath = '//h3[.="Address"]/parent::div') %>%
  html_text2() %>%
  str_replace("Address\n", "") %>%
  str_replace_all("\n", " ")

# Extract the zipcode of 4 digits from the address string
zipcode <- str_extract(test, "\\d{4}")

zipcode

test[[1]][1]

print(links_profiles)

#turning links_profiles into a vector to be able to loop over it

#finding out what kind of variable links_profiles is

class(links_profiles)

links_profiles[3]

#turning links_profiles into a character vector
psychologist_combined <- data.frame(Title = character(), stringsAsFactors = FALSE)

i <- 0
for (profile_link in links_profiles) {
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
  if (i == 10)
    break
  Sys.sleep(8)
  
  
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

  
  data <- list(
    address = addr[[1]][1],
    availability = availability[[1]][2],
    groups = group[[1]][2],
    languages = lang[[1]][2],
    billing = bill[[1]][2],
    zipcode = zipcode
  )
  
  
  psychologist_df <- data.frame(data)
  
  psychologist_combined <- rbind.data.frame(psychologist_combined, psychologist_df)
}

?content

class(bin)

#Found out that the structure is different on each page; sos

write.csv(psychologist_combined, "psychologist.csv", row.names = FALSE)

read_html(bin) %>%
  html_elements(xpath = '//div[.="Availability"]/parent::div') %>%
  html_text2() %>%
  strsplit("\n")

class(bin)
profiles <- bin %>%
  html_text2() %>%
  strsplit("\n")

profiles

bin
