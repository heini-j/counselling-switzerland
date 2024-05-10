library(rvest)
library(tidyverse)
library(RSelenium)
library(wdman)

#scraping the links from the stored html file


#1. read the html file

links <- read_html("psyfinder.html") %>%
  html_elements(css="a") %>%
  html_attr(name="href")

links[1:60]

links[3700:3796]

#profile links start at 56 and end at 3793

links_profiles <- links[56:3793]

profile_list <- vector(mode="list", length=length(links_profiles))

#2. extract the links

write.csv(links_profiles, "profilelinks.csv", row.names = FALSE)

length(links_profiles)

#lenght is the same as n of psychologist jubii!!


#3. store the links in a vector

read_html(links_profiles[1]) %>%
  html_elements(css=".pe-8px") %>%
  html_text()

?paste0


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




