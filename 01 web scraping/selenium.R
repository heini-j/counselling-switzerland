library(rvest)
library(tidyverse)
library(RSelenium)
library(wdman)

#opening a Selenium server/browser to scrape the links through the infinite scrolling

rd <- rsDriver(browser = "firefox",
               chromever = NULL)

driver <- rd$client

#setting the window size as phone adapted website is easier to manage

driver$setWindowSize(360, 640)


#navigating to the website with the selenium driver
driver$navigate('https://www.psychologie.ch/en/psyfinder-map')

html <- driver$getPageSource()[[1]]
print(html)

pageEl  <- driver$findElements(using = "css", value = "a")

#clicking open the button to show all the results
button_element <- driver$findElement(using = "class name", "d-md-none")
button_element$clickElement()

#scrolling to the bottom of the page to load all the results
scroll_element <- driver$findElement(using = "class name", "overflow-scroll")
scroll_element$sendKeysToElement(list(key = "end"))

#creating a loop that does the infine scroll

for(i in 1:50){
  scroll_element$sendKeysToElement(list(key = "end"))
  Sys.sleep(8)
}

# Get the HTML source and save to a file
html <- driver$getPageSource()[[1]]
writeLines(html, "psyfinder.html")

#closing the driver

driver$close()
