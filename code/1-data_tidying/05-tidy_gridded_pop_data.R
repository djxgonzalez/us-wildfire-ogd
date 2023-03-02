##============================================================================##
## 1.05 - imports and prepares SocScape gridded population data for assessment
## of the number of people who reside near wells that burned in wildfires


##### move this straight to the assessment script; not sure if any
##### prep is actually needed!

## setup ---------------------------------------------------------------------

# attaches packages we need for this script
source("code/0-setup/01-setup.R")
library("terra")


# generates and exports mask of study region using sf package, to import later
study_region <-
  st_read("data/raw/esri/USA_States_Generalized.shp") %>%
  filter(STATE_ABBR == "CO") %>% 
  # filter(STATE_ABBR %in%
  #          c("OR", "CA", "NV", "AZ", "MT", "WY", "UT", "CO", "NM",
  #            "ND", "SD", "NE", "KS", "OK", "TX", "MO", "AR", "LA")) %>%
  st_transform(crs_albers)
  #as(Class = "Spatial")  # convert to sp object

# reads in gridded population data
pop_1990 <- rast("data/raw/socscape/us_pop1990myc.tif") 
# pop_1990 <- pop_1990 %>% 
#   raster() %>% 
#   projectRaster(projectExtent(pop_1990, st_crs(study_region)))

#study_region <- study_region %>% as(Class = "Spatial")  # convert to sp object
# population_2000 <- rast("data/raw/socscape/us_pop2000myc.tif")
# population_2010 <- rast("data/raw/socscape/us_pop2010myc.tif")
# population_2020 <- rast("data/raw/socscape/us_pop2020myc.tif")


## data prep -----------------------------------------------------------------

# clips population data to states to study region mask
pop_1990_cropped <- terra::crop(pop_1990, vect(study_region))
pop_1990_masked  <- terra::mask(pop_1990_cropped,
                                vect(study_region), 
                                touches = TRUE)
#plot(pop_1990_masked)
# to calculate population in the mask...
pop_1990_in_mask <- pop_1990_masked %>% 
  as.data.frame() %>%  # coerce to dataframe
  as_tibble() %>%   # then coerce to tibble (most comfortable to work with)
  drop_na(us_pop1990myc.population_data)  # drop NA cells, i.e., outside mask
# now we can take the sum
sum(pop_1990_in_mask$us_pop1990myc.population_data)

#### do this for each state-year and WE'RE GOLDEN


##============================================================================##