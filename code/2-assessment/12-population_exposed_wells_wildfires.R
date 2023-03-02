##============================================================================##
## 2.12 - imports and prepares SocScape gridded population data for assessment
## of the number of people who reside near wells that burned in wildfires

## setup ---------------------------------------------------------------------

# attaches packages we need for this script
source("code/0-setup/01-setup.R")
library("terra")

# data input
pop_1990 <- rast("data/raw/socscape/us_pop1990myc.tif") 
pop_1990 <- pop_1990 %>%  # necessary so we can call projectExtent below
  raster() %>%  # converts to terra raster object
  projectRaster(projectExtent(pop_1990, st_crs(study_region)))
# population_2000 <- rast("data/raw/socscape/us_pop2000myc.tif")
# population_2010 <- rast("data/raw/socscape/us_pop2010myc.tif")
# population_2020 <- rast("data/raw/socscape/us_pop2020myc.tif")


## data prep -----------------------------------------------------------------

# clips population data to states to study region mask
pop_1990_cropped <- terra::crop(pop_1990, vect(study_region))
pop_1990_masked  <- terra::mask(pop_1990_cropped,
                                vect(study_region), 
                                touches = TRUE)
plot(pop_1990_masked)
# to calculate population in the mask...
pop_1990_in_mask <- pop_1990_masked %>% 
  as.data.frame() %>%  # coerce to dataframe
  as_tibble() %>%   # then coerce to tibble (most comfortable to work with)
  drop_na(us_pop1990myc.population_data)  # drop NA cells, i.e., outside mask
# now we can take the sum
sum(pop_1990_in_mask$us_pop1990myc.population_data)

#### do this for each state-year and WE'RE GOLDEN



##============================================================================##