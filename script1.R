library(rvest)
library(tidyverse)
library(RSelenium)
library(wdman)

sys.sleep(5)

for (i in 1:10) {
  cat(i)}

#scraping the links

read_html("https://www.psychologie.ch/en/psyfinder-map?search=")

css.selector <- "span"

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

links

#opening a Selenium server/browser to scrape the links through the infinite scrolling

rd <- rsDriver(browser = "firefox",
               chromever = NULL)

driver <- rd$client

driver$setWindowSize(360, 640)

#closing the driver

driver$close()

driver$navigate('https://www.psychologie.ch/en/psyfinder-map')

html <- driver$getPageSource()[[1]]
print(html)

pageEl  <- driver$findElements(using = "css", value = "a")

button_element <- driver$findElement(using = "class name", "d-md-none")
button_element$clickElement()

#scraping each page 

links <- links[10:160]
links2 <- str_c("https://yle.fi", links)

links2[85]


#1. creating an empty container to place the results
articles <- vector(mode="list", length=length(links2))

#2. build the body for the loop

read_html(links2[85]) %>%
  html_elements(css=".yle__article__paragraph") %>%
  html_text()

#3. loop over the iterator i with random time intervals

length(links2)

for(i in 1:length(links2)){
  cat("iteration", i, "\n")
  articles[[i]] <- read_html(links2[i]) %>%
    html_elements(css=".yle__article__paragraph") %>%
    html_text()
  Sys.sleep(runif(n=1, min=0.2,max=0.4))
}

#conditional programming with if ..  else (if) statements