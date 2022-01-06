
# Selenium start



library(rvest)
library(dplyr)

page_r <- read_html("https://www.sportsnet.org.tw/score_detail_utf8.php?Id=250") %>% 
  html_nodes("a") %>%
  html_attr("href")
  html_text()

#intro to R selenium tutorial: https://joshuamccrain.com/tutorials/web_scraping_R_selenium.html
library("RSelenium")

  #this opens a light version of firefox 
rD <- rsDriver(browser="firefox", port=4546L, verbose=F)

#this saves the version of firefox that we just opened
remDr <- rD[["client"]]


#this opens the tourism bureau website that we want

remDr$navigate("https://stat.taiwan.net.tw/inboundSearch")


zip <- "11010"
remDr$findElement(using = "id", value = "checkboxform0")$sendKeysToElement(list(zip))

?RSelenium

# other sources: https://www.r-bloggers.com/2021/04/using-rselenium-to-scrape-a-paginated-html-table/ 

