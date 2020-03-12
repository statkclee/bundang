# install packages...
list.of.packages <- c("tidyverse", "flexdashboard", "leaflet", "httr", "jsonlite")

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if(length(new.packages)) install.packages(new.packages)

