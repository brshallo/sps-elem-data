library(tidyverse)
library(rvest)

# Define the URL of the webpage containing the school information
# url <- "https://www.seattleschools.org/schools/type/elementary/" # Replace with the actual URL
url <- "https://www.seattleschools.org/schools/"


# Read the HTML content of the page
html_page <- read_html(url)

# Define the CSS selectors for the school name and address
css_selector_title <- ".list-item-title a"
css_selector_address <- "address"

# Find all the school blocks on the page
school_blocks <- html_page %>% html_elements(".list-item")

# Function to loop through each school block and extract the title and address
extract_school_info <- function(school_block) {
  school_name <- school_block %>% 
    html_element(css_selector_title) %>% 
    html_text(trim = TRUE)
  
  school_address <- school_block %>% 
    html_element(css_selector_address) %>% 
    html_text(trim = TRUE)
  
  tibble(name = school_name, address = school_address)
}

clean_address <- function(address) {
  address %>%
    # Remove carriage returns
    str_replace_all("\r", "") %>%
    # Remove "About" followed by any text until the end
    str_replace("About.*$", "") %>%
    # Remove any leading or trailing whitespace
    str_trim()
}

schools_df <- map(school_blocks, extract_school_info) %>% 
  bind_rows() %>% 
  filter(str_detect(str_to_lower(name), "elementary|k-8")) %>% 
  mutate(address = clean_address(address))

write_csv(schools_df, here::here("data-output", "schools-addrs.csv"))
