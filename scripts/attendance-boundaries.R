library(sf)
library(tidyverse)

# Elem school attendance areas
boundaries_path <- "C:/Users/bshallow/Downloads/Elementary_School_Attendance_Areas_2023-2024/Elementary_School_Attendance_Areas_2023-2024.shp"

boundaries <- sf::st_read(boundaries_path)

plot(boundaries)

