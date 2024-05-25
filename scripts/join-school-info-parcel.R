library(tidyverse)

# This data was downloaded from here:
# https://geo.wa.gov/datasets/wa-geoservices::current-parcels/explore?location=47.661018%2C-122.293356%2C16.17
# but it's a large file so I didn't include it in git
data_parcels <- read_csv(here::here("data", "Current_Parcels_8903521118267267315.csv"))
data_schools <- read_csv(here::here("data", "schools-df.csv"))

parcel_info <- data_parcels %>% 
  filter(COUNTY_NM == "King", SITUS_CITY_NM == "SEATTLE")

convert_address <- function(address){
  str_replace_all(address, "[[:punct:]]", "") %>% 
    str_replace("\\n.*$", "") %>% 
    str_to_upper()
}

# These schools have the wrong address on the website (or at least different from what's on google, so they need to be rewritten)
data_schools %>% 
  mutate(SITUS_ZIP_NR = str_sub(address, -5),
         SITUS_ADDRESS = convert_address(address)) %>% 
  left_join(parcel_info) %>% 
  filter(is.na(PARCEL_ID_NR)) %>%
  glimpse()

data_parcels %>% 
  filter(PARCEL_ID_NR == "033-9550202395")
