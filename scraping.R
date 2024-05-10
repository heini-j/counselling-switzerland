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

#profile links start at 56

links_profiles <- links[56:3793]


#2. extract the links

#3. store the links in a vector

profile_list <- vector(mode="list", length=length(links_profiles))

length(links_profiles)

#lenght is the same as n of psychologist jubii!!

#4. loop over the links and scrape the content

?str_c

links2 <- str_c("psyfinder.html", links_profiles)

articles <- vector(mode="list", length=length(links2))

for(i in 1:length(links2)){
  cat("iteration", i, "\n")
  articles[[i]] <- read_html(links2[i]) %>%
    html_elements(css="a") %>%
    html_attr(name="href")
  Sys.sleep(8)
}

#5. store the content in a list

#6. save the list as a csv file


links2[10]

read_html("https://www.psychologie.ch/en/psyfinder-map?search=") %>%
  html_elements(css=css.selector) %>%
  html_text()

#getting the links
read_html("https://www.psychologie.ch/en/psyfinder-map?search=") %>%
  html_elements(css="a") %>%
  html_text()

#getting the attributes
links <- read_html("https://www.psychologie.ch/en/psyfinder-map?search=") %>%
  html_elements(css="a") %>%
  html_attr(name="href")


