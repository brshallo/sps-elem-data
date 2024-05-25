# downloaded from here: https://gis-kingcounty.opendata.arcgis.com/search?tags=property_OpenData
# Specifically: https://gis-kingcounty.opendata.arcgis.com/documents/4a5915991c4e4bc6b701117859da3f20/about
parcel_address_data <- foreign::read.dbf("C:/Users/bshallow/Downloads/parcel_address/parcel_address/parcel_address.dbf")
king_co_parcel <- parcel_address_data %>% 
  as_tibble() %>% 
  mutate(across(where(is.factor), as.character))
  # filter(as.character(CTYNAME) == "SEATTLE") %>% 
  # glimpse()

king_co_parcel %>% 
  count(is.na(MAJOR))

# still have 11 record mismatches
data_schools %>% 
  mutate(ZIP5 = str_sub(address, -5),
         ADDR_FULL = convert_address(address)) %>% 
  left_join(king_co_parcel) %>% 
  filter(is.na(MAJOR)) %>%
  glimpse()
  