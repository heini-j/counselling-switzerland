library(rvest)
library(tidyverse)
library(httr)

#scraping the links from the stored html file

#1. read the html file

links <- read_html("psyfinder.html") %>%
  html_elements(css="a") %>%
  html_attr(name="href")

#checking where the profile links start and end

links[1:60]

links[3700:3796]

#profile links start at 56 and end at 3793

links_profiles <- links[56:3793]

profile_list <- vector(mode="list", length=length(links_profiles))

#2. extract the links

write.csv(links_profiles, "profilelinks.csv", row.names = FALSE)

#checking that the lenght is the same as the number of psychologist on the website

length(links_profiles)

#It was!


# reading the first profile on the list to form a basis for a loop

page <- httr::GET(links_profiles[1],
                        httr::add_headers(
                          From = "heini.jaervioe@stud.unilu.ch",
                          `User-Agent` = R.Version()$version.string))

bin <- content(page, as = "raw")

writeBin(object = bin, con ="testpage.html")

#reading the needed information from the first profile in the html file

titles <- read_html(here::here("testpage.html")) %>%
  html_elements(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "align-items-start", " " ))] | //*[contains(concat( " ", @class, " " ), concat( " ", "border-color-pumpkin-500", " " ))] | //*[contains(concat( " ", @class, " " ), concat( " ", "body-4", " " ))]//div') %>%
  html_text2( ) %>%
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

for(i in 1:length(links_profiles)){
  cat("iteration", i, "\n")
  links_profiles[[i]] <- read_html(links_profiles[u]) %>%
    html_elements(css=".pe-8px") %>%
    html_text()
  Sys.sleep(8)
}






#5. store the content in a list

#6. save the list as a csv file




