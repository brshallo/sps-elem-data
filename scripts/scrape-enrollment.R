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
  bind_rows() %>% 
  mutate(name = 
           str_remove_all(school, "\\[.*?\\]") %>% 
           str_replace("B\\.F\\.", "Benjamin Franklin") %>%  
           str_replace("Int'l", "International") %>% 
           str_remove_all("[[:punct:]]") %>% 
           str_to_lower()
         )


school_co_info %>% 
  left_join(school_enrollment)

# remove punctuation in both and make all lower case
# PK-8 should be removed
# change name from "Coe" to "Franz Coe"

# # No info on cascade parent partnership
# school_enrollment %>% 
#   anti_join(school_co_info)


