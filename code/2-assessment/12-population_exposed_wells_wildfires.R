##============================================================================##
## 2.12 - 

## setup ---------------------------------------------------------------------

# attaches functions .....................................................
source("code/0-setup/01-setup.R")
source("code/2-assessment/10-fxn-assess_exposure_wells_population.R")
library("parallel")   # for the `mclapply()` fxn, if using MacOS
library("lubridate")  # for `Year()` fxn

# data input .............................................................
wells_all     <- readRDS("data/interim/wells_all.rds")
wildfires_all <- readRDS("data/interim/wildfires_all.rds")


## exposure assessments by state =============================================

# NM -----------------------------------------------------------------------

# 1984-1994 ............................................................

# restricts to wildfires near wells for 1984 to 1994
wildfires_in <- wildfires_all %>%
  filter(state == "NM" & year %in% c(1984:1994)) %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_nm_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_all %>% 
  filter(state == "NM") %>% 
  # drops wells drilled after the period
  filter(year(date_earliest) <= 1994 | is.na(date_earliest)) %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_nm_buffer_1km.rds")) %>% 
  st_transform(crs_albers)
pop_in <- 1

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
pop_wells_wildfires_nm <- 
  lapply(wildfires_in,
         FUN          = assessPopulationWellsWildfire,
         wells        = wells_in,
         pop_grid     = 0,  # 1990 pop grid
         exp_variable = "n_pop_exposed") 
pop_wells_wildfires_nm <- 
  do.call("rbind", pop_wells_wildfires_nm)  # converts from list
write_csv(pop_wells_wildfires_nm, 
          "data/processed/wildfires_wells_dates/pop_wells_wildfires_nm.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, pop_wells_wildfires_nm)




##============================================================================##