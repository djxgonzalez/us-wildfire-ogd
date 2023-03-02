##============================================================================##
## 2.12 - imports and prepares SocScape gridded population data for assessment
## of the number of people who reside near wells that burned in wildfires

## setup ---------------------------------------------------------------------

# attaches packages we need for this script
source("code/0-setup/01-setup.R")
library("terra")

# data input
# pop_2020 <- rast("data/raw/socscape/us_pop1990myc.tif")
# pop_2000 <- rast("data/raw/socscape/us_pop2000myc.tif")
# pop_2010 <- rast("data/raw/socscape/us_pop2010myc.tif")
pop_2020 <- rast("data/raw/socscape/us_pop2020myc.tif")



ar_1989 <- 
  readRDS("data/interim/wells_wildfire_intersection_state_year/ar_1989.rds") %>% 
  st_as_sf() %>% 
  mutate(i = 1)
ar_2018 <- 
  readRDS("data/interim/wells_wildfire_intersection_state_year/ar_2018.rds") %>% 
  st_as_sf() %>% 
  mutate(i = 1)


## data prep -----------------------------------------------------------------

# clips population data to states to study region mask
pop_2020_cropped <- terra::crop(pop_2020, vect(ar_2018))
pop_2020_masked  <- terra::mask(pop_2020_cropped,
                                vect(ar_2018), 
                                touches = TRUE)
plot(pop_2020_masked)
# to calculate population in the mask...
pop_2020_in_mask <- pop_2020_masked %>% 
  as.data.frame() %>%  # coerce to dataframe
  as_tibble() %>%   # then coerce to tibble (most comfortable to work with)
  drop_na(us_pop2020myc)  # drop NA cells, i.e., outside mask
# now we can take the sum
sum(pop_2020_in_mask$us_pop2020myc)

#### do this for each state-year and WE'RE GOLDEN



##============================================================================##