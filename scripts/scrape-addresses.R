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

# Initialize an empty list to store the extracted information
schools_data <- list()

# Loop through each school block and extract the title and address
for (i in seq_along(school_blocks)) {
  school_name <- school_blocks[i] %>% 
    html_element(css_selector_title) %>% 
    html_text(trim = TRUE)
  
  school_address <- school_blocks[i] %>% 
    html_element(css_selector_address) %>% 
    html_text(trim = TRUE) %>% 
    str_replace_all("\n|<br>", ", ") # Replace newlines and <br> with commas for address formatting
  
  # Append the extracted information to the list
  schools_data[[i]] <- list(name = school_name, address = school_address)
}

# Convert the list to a data frame
schools_df <- bind_rows(schools_data)

# Print the result
print(schools_df)
schools_df %>% 
  filter(str_detect(str_to_lower(name), "elementary|k-8"))
# 