##============================================================================##
## 2.04 - need to re-write this header

##---------------------------------------------------------------------------
## setup

# attaches functions .....................................................
library("parallel")  # for the `mclapply()` fxn
source("code/2-exposure_assessment/02-fxn_assess_exposure_count.R")

# data input .............................................................
fire_ok <- read_sf("") %>%  #make sure to point to the fire data we want
  select(GEOID, geometry) %>% mutate(GEOID = as.factor(GEOID))
wells_interim       <- readRDS("data/interim/wells_interim.rds")

# data prep ..............................................................
wells_ok <- wells_interim  # do whatever you need to do here to get OK wells

# well buffers . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
wells_ok_buffer_1km <- wells_ok %>% 
  makeWellBuffer(1000)

# wells for counting . . . . . . . . . . . . . . . . . . . . . . . . . 
wells_ok <- wells_ok %>%
  #filter(prod_during_period == 1) %>%  # change this to drop wells with no dates
                                        # or with non-sensical dates (i.e., < 1859)
  select(api_number, longitude, latitude) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83)

# removes data we don't need to improve efficiency
rm(wells_interim)


##---------------------------------------------------------------------------
## Oklahoma all wells with dates

# 0 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
fire_data_in <- fire_ok %>%
  st_intersection(wells_ok_buffer_1km)
fire_data_in <- fire_ok %>% filter(Event_id %in% fire_data_in$Event_id)  # verify Event_id
fire_data_in <- split(fire_data_in, seq(1, nrow(fire_data_in)))  # converts to list
fire_ok_exp_buffer <- 
  mclapply(fire_data_in,  # if not on MacOS, use `lapply()` instead
           FUN          = assessExposureCount,
           wells        = wells_ok,
           buffer       = 0,  # in m; 0 or 1,000
           exp_variable = "wells_ok_all_dates_0km")  # 0km is the buffer; for 1 use `_1km`
fire_ok_exp_buffer <- 
  do.call("rbind", fire_ok_exp_annuli) %>%  # converts from list
  mutate(state = as.factor("ok"))
saveRDS(fire_ok_exp_buffer,
        "data/interim/fire_ok_all_dates_0km.rds")

# 1 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 

# same as above, but use 1 km instead of 0 km buffer

# between states, make sure to `rm()` data we don't need anymore


##============================================================================##