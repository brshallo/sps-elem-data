# scrape enrollment data

library(tidyverse)
library(rvest)

url <- "https://en.wikipedia.org/wiki/List_of_schools_of_the_Seattle_School_District"
webpage <- read_html(url)

# This assumes that the table you want is the first one on the page.
# If it's not, you might need to use html_nodes() and select the appropriate index
# with [[n]] where n is the number of the table you want.
tables <- webpage %>%
  html_nodes("table.wikitable")

school_enrollment <- tables[1:2] %>%
  purrr::map(html_table, fill = TRUE) %>%
  map(set_names, c("school", "established", "neighborhood", "nickname", "spring_2023_enrollment")) %>% 
  map(~mutate(.x, established = str_remove_all(established, "\\[.*?\\]") %>% as.integer())) %>% 
  bind_rows() 

# data_schools$name %>% str_replace(" Elementary", "") %>% str_replace(" K-8", "")
# 
# school_enrollment$school %>% str_remove_all("\\[.*?\\]") %>% str_replace("B\\.F\\.", "Benjamin Franklin") %>%  str_replace("Int'l", "International")
