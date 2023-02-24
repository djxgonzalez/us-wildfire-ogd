##============================================================================##
## 1.05 - imports and prepares SocScape gridded population data for assessment
## of the number of people who reside near wells that burned in wildfires

## setup ---------------------------------------------------------------------

# attaches packages we need for this script
source("code/0-setup/01-setup.R")
library("terra")

# reads in gridded population data
population_1990 <- rast("data/raw/socscape/us_pop1990myc.tif")
# population_2000 <- rast("data/raw/socscape/us_pop2000myc.tif")
# population_2010 <- rast("data/raw/socscape/us_pop2010myc.tif")
# population_2020 <- rast("data/raw/socscape/us_pop2020myc.tif")

# generates and exports mask of study region usfing sf package, to import later
# only need to run this once; uncomment if necessary
# study_region_mask <-
#   st_read("data/raw/esri/USA_States_Generalized.shp") %>%
#   filter(STATE_ABBR %in%
#            c("OR", "CA", "NV", "AZ", "MT", "WY", "UT", "CO", "NM",
#              "ND", "SD", "NE", "KS", "OK", "TX", "MO", "AR", "LA")) %>%
#   st_transform(crs(population_1990)) %>%
#   st_union()
# st_write(study_region_mask, "data/interim/study_region_mask.shp")
# rm(study_region_mask)

# reads back in study region mask using terra package
study_region_mask <- terra::vect("data/interim/study_region_mask.shp")


## data prep -----------------------------------------------------------------


# clips population data to states to study region mask
population_1990_mask <- crop(population_1990, study_region_mask,mask = TRUE)
population_1990_cropped <- mask(population_1990, study_region_mask)


##============================================================================##