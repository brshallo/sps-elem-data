library(sf)
library(tidyverse)

# Elem school attendance areas
boundaries_path <- "C:/Users/bshallow/Downloads/Elementary_School_Attendance_Areas_2023-2024/Elementary_School_Attendance_Areas_2023-2024.shp"

boundaries <- sf::st_read(boundaries_path)

plot(boundaries)

# criteria document available here: https://www.documentcloud.org/documents/24784284-sps-wrs-update-6_26_24-final-copy-1?responsive=1&title=1
## pg 34 has data on buildings and capacity, etc.
## Note that school capacity charts don't line-up between 2020 and 2024 docs
## Note that enrollment numbers here are October whereas what I downloaded are Spring... 
###it may be worth pulling this here or from WA.DAT as well: https://data.wa.gov/education/Report-Card-Enrollment-2023-24-School-Year/q4ba-s3jc/about_data

# state test data is available here: https://data.wa.gov/education/Report-Card-Assessment-Data-2022-23-School-Year/xh7m-utwp/about_data

# School facilities info: https://www.seattleschools.org/wp-content/uploads/2021/09/2021_Facilities_Master_Plan_Update.pdf
## school facilities ratings available pg 32-34 here: 
## Actual capcity vs right-size starts pg 42
