##============================================================================##
## 2.16 - takes previously generated geospatial data with wildfire-well
## intersections (with 1 km around wells) and determines area of that
## intersection in km^2


## setup ---------------------------------------------------------------------

# attaches packages we need for this script
source("code/0-setup/01-setup.R")


## assessment ----------------------------------------------------------------

# gets names of previously-generated files
file_names <- list.files("data/interim/wells_wildfire_intersection_state_year",
                         pattern = "*.rds")

# tibble to capture data
wells_wildfire_intersection_area <- 
  tibble(state               = "",
         year                = as.numeric(""),
         intersection_area_m = as.numeric(""))

# loops through files and adds area
for (i in 1:length(file_names)) {
  # data input
  intersection_state_year <-
    readRDS(paste("data/interim/wells_wildfire_intersection_state_year/",
                  file_names[i], sep = ""))
  # captures relevant variables
  intersection <- tibble(
    state = toupper(substr(file_names[i], 1, 2)),
    year = as.numeric(substr(file_names[i], 4, 7)),
    intersection_area_m = as.numeric(st_area(intersection_state_year))
  )
  # appends data to tibble
  wells_wildfire_intersection_area <- 
    bind_rows(wells_wildfire_intersection_area, intersection)
}

# final tidying
wells_wildfire_intersection_area <- 
  # removes first row with missing data
  drop_na(wells_wildfire_intersection_area, intersection_area_m) %>% 
  # converts from m^2 to km^2
  mutate(intersection_area_km2 = (intersection_area_m / 1000000)) %>% 
  select(-intersection_area_m)

# assemble and export ......................................................
write_csv(wells_wildfire_intersection_area, 
          "data/interim/wells_wildfire_intersection_state_year.csv")

# joins with existing datasets and re-exports
pop_exposed_state_year <- 
  read_csv("data/processed/pop_exposed_state_year.csv") %>%
  left_join(wells_wildfire_intersection_area) %>% 
  mutate(intersection_area_km2 = replace_na(intersection_area_km2, 0))
write_csv(pop_exposed_state_year, "data/processed/pop_exposed_state_year.csv")

wells_wildfire_state_year <- 
  read_csv("data/processed/wells_wildfire_state_year.csv") %>%
  left_join(wells_wildfire_intersection_area) %>% 
  mutate(intersection_area_km2 = replace_na(intersection_area_km2, 0))
write_csv(wells_wildfire_state_year, 
          "data/processed/wells_wildfire_state_year.csv")

##============================================================================##