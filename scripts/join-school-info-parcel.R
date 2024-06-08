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
  select(name, SITUS_ADDRESS)

parcel_info %>% 
  filter(PARCEL_ID_NR == "033-3416600240") %>% glimpse()

missing_school_addresses <- list("Lawton Elementary" = "4017 26TH AVE W",
  "Leschi Elementary" = "3233 E SPRUCE ST",
  "McDonald International Elementary" = "120 NE 54TH ST",
  "Rainier View Elementary" = "11236 BEACON AVE S",
  "Sand Point Elementary" = "6200 60TH AVE NE",
  "South Shore PK-8" = "8601 RAINIER AVE S",
  "Stevens Elementary" = "1800 E GALER ST",
  "Thornton Creek Elementary" = "7725 43RD AVE NE",
  "TOPS K-8" = "2515 BOYLSTON AVE E",
  "Viewlands Elementary" = "10505 3RD AVE NW",
  "Whittier Elementary" = "7501 13TH AVE NW"
  ) %>% 
  enframe() %>% 
  mutate(SITUS_ADDRESS = map_chr(value, `[`)) %>% 
  select(-value)


school_info <- bind_rows(
  data_schools %>% 
    mutate(SITUS_ZIP_NR = str_sub(address, -5),
           SITUS_ADDRESS = convert_address(address)) %>% 
    anti_join(parcel_info) %>% 
    select(-SITUS_ADDRESS) %>% 
    left_join(missing_school_addresses),
  
  data_schools %>% 
    mutate(SITUS_ZIP_NR = str_sub(address, -5),
           SITUS_ADDRESS = convert_address(address)) %>% 
    semi_join(parcel_info)
) %>% 
  arrange(name) %>% 
  left_join(parcel_info)
