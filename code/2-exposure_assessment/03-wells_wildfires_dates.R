##============================================================================##
## 2.03 - Sets up and runs assessment, for all states included in study, of
## the count of wells in wildfires (excluding wells known to have been drilled
## after the wildfire occurred)

## setup ---------------------------------------------------------------------

# attaches functions .....................................................
source("code/2-exposure_assessment/01-fxn-count_wells_in_wildfires.R")
library("parallel")   # for the `mclapply()` fxn
library("lubridate")  # for `Year()` fxn

# data input .............................................................
wells_all     <- readRDS("data/processed/wells_all.rds")
wildfires_all <- readRDS("data/processed/wildfires_all.rds")


## assessments by state ======================================================

# AK -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "AK") %>% 
  st_as_sf() %>%
  st_transform(crs_alaska) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_ak_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_all %>% 
  filter(state == "AK") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_ak_buffer_1km.rds"))) %>% 
  st_transform(crs_alaska)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_ak <- 
  mclapply(wildfires_in,  # if not using MacOS, use `lapply()` instead
           FUN          = assessExposureCount,
           wells        = wells_in,
           buffer_dist  = 0,  # in meters
           exp_variable = "n_wells") 
wildfires_wells_ak <- 
  do.call("rbind", wildfires_wells_ak)  # converts from list
write_csv(wildfires_wells_ak, 
          "data/processed/wildfires_wells/wildfires_wells_ak.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_ak_buffer_1km <- 
  mclapply(wildfires_in,
           FUN          = assessExposureCount,
           wells        = wells_in,
           buffer       = 1000,  # in meters
           exp_variable = "n_wells_buffer_1km") 
wildfires_wells_ak_buffer_1km <- 
  do.call("rbind", wildfires_wells_ak_buffer_1km)
write_csv(wildfires_wells_ak_buffer_1km, 
          "data/processed/wildfires_wells/wildfires_wells_ak_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_ak, 
   wildfires_wells_ak_buffer_1km)


# AR -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "AR") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_ar_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_all %>% 
  filter(state == "AR") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_ar_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_ar <- 
  mclapply(wildfires_in,
           FUN          = assessExposureCount,
           wells        = wells_in,
           buffer_dist  = 0,  # in meters
           exp_variable = "n_wells") 
wildfires_wells_ar <- 
  do.call("rbind", wildfires_wells_ar)  # converts from list
write_csv(wildfires_wells_ar, 
          "data/processed/wildfires_wells/wildfires_wells_ar.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_ar_buffer_1km <- 
  mclapply(wildfires_in,
           FUN          = assessExposureCount,
           wells        = wells_in,
           buffer       = 1000,  # in meters
           exp_variable = "n_wells_buffer_1km") 
wildfires_wells_ar_buffer_1km <- 
  do.call("rbind", wildfires_wells_ar_buffer_1km)
write_csv(wildfires_wells_ar_buffer_1km, 
          "data/processed/wildfires_wells/wildfires_wells_ar_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_ar, 
   wildfires_wells_ar_buffer_1km)


# AZ -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "AZ") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_az_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_all %>% 
  filter(state == "AZ") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_az_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_az <- 
  mclapply(wildfires_in,
           FUN          = assessExposureCount,
           wells        = wells_in,
           buffer_dist  = 0,  # in meters
           exp_variable = "n_wells") 
wildfires_wells_az <- 
  do.call("rbind", wildfires_wells_az)  # converts from list
write_csv(wildfires_wells_az, 
          "data/processed/wildfires_wells/wildfires_wells_az.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_az_buffer_1km <- 
  mclapply(wildfires_in,
           FUN          = assessExposureCount,
           wells        = wells_in,
           buffer       = 1000,  # in meters
           exp_variable = "n_wells_buffer_1km") 
wildfires_wells_az_buffer_1km <- 
  do.call("rbind", wildfires_wells_az_buffer_1km)
write_csv(wildfires_wells_az_buffer_1km, 
          "data/processed/wildfires_wells/wildfires_wells_az_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_az, 
   wildfires_wells_az_buffer_1km)


##### NEXT: add the rest of the states!


##============================================================================##