##============================================================================##
## 1.05 - imports and prepares SocScape gridded population data for assessment
## of the number of people who reside near wells that burned in wildfires


##### consisder moving this straight to the assessment script; not sure if any
##### prep is actually needed!

## setup ---------------------------------------------------------------------

# attaches packages we need for this script
source("code/0-setup/01-setup.R")
library("terra")

# reads in gridded population data
population_1990 <- rast("data/raw/socscape/us_pop1990myc.tif")
# population_2000 <- rast("data/raw/socscape/us_pop2000myc.tif")
# population_2010 <- rast("data/raw/socscape/us_pop2010myc.tif")
# population_2020 <- rast("data/raw/socscape/us_pop2020myc.tif")

# generates and exports mask of study region using sf package, to import later
study_region_mask <-
  st_read("data/raw/esri/USA_States_Generalized.shp") %>%
  filter(STATE_ABBR %in%
           c("OR", "CA", "NV", "AZ", "MT", "WY", "UT", "CO", "NM",
             "ND", "SD", "NE", "KS", "OK", "TX", "MO", "AR", "LA")) %>%
  st_transform(crs(population_1990)) %>%
  st_union()


## data prep -----------------------------------------------------------------


# clips population data to states to study region mask
##### next up: troubleshoot why there's no extent in study_region_mask;
##### can I convert the terra object back to raster?
population_1990_mask <- crop(population_1990, study_region_mask, mask = TRUE)
population_1990_cropped <- mask(population_1990, study_region_mask)


##============================================================================##