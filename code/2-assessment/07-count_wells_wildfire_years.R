##============================================================================##
## 2.07 - Sets up and runs assessment, for all states included in study, of
## the count of wells in wildfires (excluding wells known to have been drilled
## after the wildfire occurred)

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
  rename(state = STATE_ABBR) %>% 
  select(state, geometry) %>% 
  filter(state == "AK") %>%
  st_transform(crs_alaska)
wells_all <- readRDS("data/interim/wells_all.rds")


## assessments by state-year =================================================

# AK -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_ak <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "AK") %>% 
  st_transform(crs_alaska) %>% 
  st_intersection(
    st_make_valid(
      st_transform(
        readRDS("data/interim/wildfires_buffers/wildfires_ak_buffer_1km.rds"),
                   crs_alaska)))

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    readRDS(paste("data/interim/wildfire_years/wildfires_union_alaska_",
                  year,
                  ".rds",
                  sep = "")) %>% 
    st_transform(crs = crs_alaska) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(alaska)
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    readRDS(paste("data/interim/wildfire_years/wildfires_union_alaska_",
                  year,
                  ".rds",
                  sep = "")) %>% 
    st_buffer(dist = 1000) %>% 
    st_transform(crs = crs_alaska) %>% 
    st_intersection(alaska)
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <- 
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "AK",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_ak <- wells_wildfire_year_ak %>% 
    bind_rows(output)
  print(paste("AK", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_ak, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_ak.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_ak, alaska)


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
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "AR"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "AR"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <-
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
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


# AZ -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_az <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "AZ") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_az_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "AZ"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "AZ"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <- 
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "AZ",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_az <- wells_wildfire_year_az %>% 
    bind_rows(output)
  print(paste("AZ", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_az, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_az.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_az)


# CA -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_ca <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "CA") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_ca_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "CA"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "CA"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <- 
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "CA",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_ca <- wells_wildfire_year_ca %>% 
    bind_rows(output)
  print(paste("CA", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_ca, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_ca.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_ca)


# CO -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_co <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "CO") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_co_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "CO"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "CO"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <- 
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "CO",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_co <- wells_wildfire_year_co %>% 
    bind_rows(output)
  print(paste("CO", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_co, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_co.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_co)


# KS -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_ks <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "KS") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_ks_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(
        paste("data/interim/wildfire_years/wildfires_union_contiguous_",
              year,
              ".rds",
              sep = ""))) %>% 
    st_transform(crs = crs_albers) %>%
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "KS"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(
        paste("data/interim/wildfire_years/wildfires_union_contiguous_",
              year,
              ".rds",
              sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "KS"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <- 
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "KS",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_ks <- wells_wildfire_year_ks %>% 
    bind_rows(output)
  print(paste("KS", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_ks, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_ks.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_ks)


# LA -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_la <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "LA") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_la_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "LA"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "LA"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <-
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "LA",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_la <- wells_wildfire_year_la %>% 
    bind_rows(output)
  print(paste("LA", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_la, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_la.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_la)


# MO -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_mo <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "MO") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_mo_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "MO"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "MO"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <-
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "MO",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_mo <- wells_wildfire_year_mo %>% 
    bind_rows(output)
  print(paste("MO", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_mo, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_mo.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_mo)


# MT -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_mt <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "MT") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_mt_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "MT"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "MT"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <- 
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "MT",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_mt <- wells_wildfire_year_mt %>% 
    bind_rows(output)
  print(paste("MT", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_mt, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_mt.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_mt)


# ND -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_nd <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "ND") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_nd_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "ND"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "ND"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <-
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "ND",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_nd <- wells_wildfire_year_nd %>% 
    bind_rows(output)
  print(paste("ND", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_nd, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_nd.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_nd)


# NE -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_ne <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "NE") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_ne_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "NE"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "NE"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <-
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "NE",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_ne <- wells_wildfire_year_ne %>% 
    bind_rows(output)
  print(paste("NE", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_ne, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_ne.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_ne)


# NM -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_nm <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "NM") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_nm_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "NM"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "NM"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <- 
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "NM",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_nm <- wells_wildfire_year_nm %>% 
    bind_rows(output)
  print(paste("NM", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_nm, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_nm.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_nm)


# NV -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_nv <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "NV") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_nv_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "NV"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "NV"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <- 
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "NV",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_nv <- wells_wildfire_year_nv %>% 
    bind_rows(output)
  print(paste("NV", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_nv, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_nv.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_nv)


# OK -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_ok <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "OK") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_ok_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "OK"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "OK"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <-
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "OK",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_ok <- wells_wildfire_year_ok %>% 
    bind_rows(output)
  print(paste("OK", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_ok, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_ok.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_ok)


# OR -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_or <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "OR") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_or_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "OR"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "OR"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <-
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "OR",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_or <- wells_wildfire_year_or %>% 
    bind_rows(output)
  print(paste("OR", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_or, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_or.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_or)


# SD -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_sd <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "SD") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_sd_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "SD"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "SD"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <- 
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "SD",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_sd <- wells_wildfire_year_sd %>% 
    bind_rows(output)
  print(paste("SD", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_sd, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_sd.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_sd)


# TX -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_tx <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "TX") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_tx_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "TX"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "TX"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <- 
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "TX",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_tx <- wells_wildfire_year_tx %>% 
    bind_rows(output)
  print(paste("TX", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_tx, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_tx.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_tx)


# UT -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_ut <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "UT") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_ut_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "UT"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "UT"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <- 
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "UT",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_ut <- wells_wildfire_year_ut %>% 
    bind_rows(output)
  print(paste("UT", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_ut, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_ut.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_ut)


# WY -----------------------------------------------------------------------

# setup  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
# generates tibble to capture data
wells_wildfire_year_wy <- 
  tibble(state              = "", 
         year               = as.numeric(), 
         n_wells            = as.numeric(),
         n_wells_buffer_1km = as.numeric())
# restricts to wells in the state that were near wildfire that burned in 
# any year, to improve efficiency
wells_state <- wells_all %>% 
  filter(state == "WY") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_wy_buffer_1km.rds"))) %>% 
  st_transform(crs_albers)

# assessment of wells in wildfire areas  . . . . . . . . . . . . . . . . . .
for(year in c(1984:2020)) {
  # restricts to wells drilled ≤ year or with no earliest_date
  # which we assume to have been drilled before the study period
  wells_state_year <- wells_state %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest))
  # restricts to wildfire burn areas in each year in the state
  wildfire_state_year <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 0) %>% 
    st_intersection(subset(us_states, state == "WY"))
  # same as above, but creates a 1 km buffer around the wildfire burn areas
  # for each year so that we can assess wells near the burn areas
  wildfire_state_year_buffer_1km <-
    st_make_valid(
      readRDS(paste("data/interim/wildfire_years/wildfires_union_contiguous_",
                    year,
                    ".rds",
                    sep = ""))) %>% 
    st_transform(crs = crs_albers) %>% 
    st_buffer(dist = 1000) %>% 
    st_intersection(subset(us_states, state == "WY"))
  # counts the number of wells that intersect with wildfire-year
  n_wells <- sum(unlist(st_intersects(wells_state_year, wildfire_state_year)))
  # counts the number of wells that intersect with wildfire-year + 1 km buffer
  n_wells_buffer_1km <- 
    sum(unlist(st_intersects(wells_state_year, wildfire_state_year_buffer_1km)))
  output <- tibble(state              = "WY",
                   year               = year,
                   n_wells            = n_wells,
                   n_wells_buffer_1km = n_wells_buffer_1km)
  wells_wildfire_year_wy <- wells_wildfire_year_wy %>% 
    bind_rows(output)
  print(paste("WY", year, sep = " "))
}

# export  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
write_csv(wells_wildfire_year_wy, 
          "data/interim/wells_wildfire_year/wells_wildfire_year_wy.csv")
# removes datasets before moving on to the next state
rm(wells_state, wells_wildfire_year_wy)


##============================================================================##