library(tidyverse)

# downloaded from here: https://gis-kingcounty.opendata.arcgis.com/search?tags=property_OpenData
# Specifically: https://gis-kingcounty.opendata.arcgis.com/documents/4a5915991c4e4bc6b701117859da3f20/about
parcel_address_data <- foreign::read.dbf("C:/Users/bshallow/Downloads/parcel_address/parcel_address/parcel_address.dbf")
king_co_parcel <- parcel_address_data %>% 
  as_tibble() %>% 
  mutate(across(where(is.factor), as.character))
  # filter(as.character(CTYNAME) == "SEATTLE") %>% 
  # glimpse()

king_co_parcel %>% glimpse()
  count(is.na(MAJOR))

# still have 11 record mismatches
data_schools %>% 
  mutate(ZIP5 = str_sub(address, -5),
         ADDR_FULL = convert_address(address)) %>% 
  left_join(king_co_parcel) %>% 
  filter(is.na(MAJOR)) %>%
  glimpse()
  


## From King County Assessor office: https://info.kingcounty.gov/assessor/datadownload/default.aspx 
ki_co_assessor <- read_csv(here::here("data", "EXTR_CommBldg.csv"))
ki_co_assessor %>% 
  filter(Minor == "0400", Major == "036900") %>% 
  glimpse()

school_info %>% 
  left_join(
    ki_co_assessor %>% 
      mutate(ORIG_PARCEL_ID = paste0(Major, Minor))
  )

ki_co_assessor %>% 
  mutate(ORIG_PARCEL_ID = paste0(Major, Minor)) %>% 
  semi_join(school_info) %>% 
  group_by(ORIG_PARCEL_ID) %>% 
  filter(n() > 1) %>% 
  arrange(ORIG_PARCEL_ID) %>% 
  View()


# Have the square footage joined on now... just need to add the enrollment numbers
ki_co_assessor %>% 
  mutate(ORIG_PARCEL_ID = paste0(Major, Minor)) %>% 
  semi_join(school_info) %>% 
  arrange(ORIG_PARCEL_ID) %>% 
  group_by(ORIG_PARCEL_ID) %>% 
  summarise(across(c(YrBuilt, EffYr), 
                   list(wt = ~round(sum(.x * BldgNetSqFt) / sum(BldgNetSqFt), 0),
                        main = ~mean(
                          ifelse(BldgNetSqFt == max(BldgNetSqFt), .x, NA), na.rm = TRUE)
                        )
                   ),
            across(c(BldgGrossSqFt, BldgNetSqFt), sum)) %>% 
  right_join(school_info) %>% glimpse()
