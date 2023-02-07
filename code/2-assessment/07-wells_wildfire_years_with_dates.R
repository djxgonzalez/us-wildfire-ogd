##============================================================================##
## 2.07 - Similar to script 2.06, but restricted to wells that have operation dates

## setup ---------------------------------------------------------------------

# attaches functions .....................................................
source("code/0-setup/01-setup.R")
library("lubridate")  # for `year()` function

# data input .............................................................
us_states <- st_read("data/raw/esri/USA_States_Generalized.shp") %>% 
  rename(state = STATE_ABBR) %>% 
  select(state, geometry) %>% 
  filter(state %in% 
           c("OR", "CA", "NV", "AZ", "MT", "WY", "UT", "CO", "NM",
             "ND", "SD", "NE", "KS", "OK", "TX", "MO", "AR", "LA")) %>%
  st_transform(crs_albers)
alaska    <- st_read("data/raw/esri/USA_States_Generalized.shp") %>% 
  filter(STATE_ABBR == "AK") %>%
  st_geometry() %>% 
  st_transform(crs_alaska)
wells_all <- readRDS("data/processed/wells_all.rds") %>% 
  drop_na(date_earliest)

##### copy below from 2.06; add `no_dates` suffix

## assessments by state-year =================================================

##### copy below and adapt for Alaska (rm Alaska)


# AR -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 

# generates tibble to capture data
wells_wildfire_year_ar <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())

# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "AR") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_ar_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .

# for each year in the study period, intersects   
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                  year,
                  ".rds",
                  sep = "")) %>% 
    st_transform(crs = crs_albers) %>% 
    st_intersection(subset(us_states, state == "AR"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                  year,
                  ".rds",
                  sep = "")) %>% 
    st_transform(crs = crs_albers) %>% 
    st_intersection(subset(us_states, state == "AR")) %>% 
    st_buffer(dist = 1000)
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <- sum(unlist(st_intersects(wells_state_year,
                                                 wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "AR",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_ar <- wells_wildfire_year_ar %>% 
    bind_rows(output)
  print(paste("AR", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

write_csv(wells_wildfire_year_ar, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_ar.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_ar)


##### copy above for other states


##============================================================================##