##============================================================================##
## 1.05 - imports and prepares SocScape gridded population data for assessment
## of the number of people who reside near wells that burned in wildfires

## setup ---------------------------------------------------------------------

# attaches packages we need for this script
source("code/0-setup/01-setup.R")
library("raster")
library("terra")

# data input
pop_gridded_1990 <- rast("data/raw/socscape/us_pop2010myc.tif")

us_states_west <- st_read("data/raw/esri/USA_States_Generalized.shp") %>% 
  filter(STATE_ABBR %in% c("WA", "OR", "CA", "ID", "NV", "AZ", "MT", "WY", "UT",
                           "CO", "NM", "ND", "SD", "NE", "KS", "OK", "TX", "MO",
                           "AR", "LA")) %>%
  st_transform(crs_albers)


## 1990 ----------------------------------------------------------------------

# data prep ................................................................

# gets necessary variables as numeric vectors[ri]



##============================================================================##