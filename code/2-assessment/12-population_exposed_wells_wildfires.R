##============================================================================##
## 2.12 - imports and prepares SocScape gridded population data for assessment
## of the number of people who reside near wells that burned in wildfires


## setup ---------------------------------------------------------------------

# attaches packages we need for this script
source("code/0-setup/01-setup.R")
library("terra")

# data input
pop_1990 <- rast("data/raw/socscape/us_pop1990myc.tif")
pop_2000 <- rast("data/raw/socscape/us_pop2000myc.tif")
pop_2010 <- rast("data/raw/socscape/us_pop2010myc.tif")
pop_2020 <- rast("data/raw/socscape/us_pop2020myc.tif")


# defines function to count population within 1 km of wells in wildfire burn
# areas for each state-year and outputs the estimate
assessPopulationExposed <- function(state_upper, state_lower, year) {
  # imports relevant state-year wells in wildfire data
  state_year_wells_in_wildfires <- 
    readRDS(paste("data/interim/wells_wildfire_intersection_state_year/", 
                  state_lower, "_", year, ".rds", sep = "")) %>%  
    st_as_sf() %>% 
    st_make_valid() %>% 
    mutate(dummy_index = 1) %>%  # necessary to pass to vect()
    vect()
  # based on input year, defines appropriate population raster and variable
  pop_raster <-
    case_when(year %in% c(1984:1994) ~ "pop_1990",
              year %in% c(1994:2004) ~ "pop_2000",
              year %in% c(2005:2014) ~ "pop_2010",
              year %in% c(2015:2020) ~ "pop_2020")
  pop_variable <- 
    case_when(year %in% c(1984:1994) ~ 
                "pop_estimate$us_pop1990myc.population_data",
              year %in% c(1994:2004) ~ 
                "pop_estimate$us_pop2000myc.population_data",
              year %in% c(2005:2014) ~ 
                "pop_estimate$us_pop2010myc.population_data",
              year %in% c(2015:2020) ~ 
                "pop_estimate$us_pop2020myc")
  # crops and masks gridded population data
  pop_estimate <- 
    terra::crop(eval(parse(text = pop_raster)), state_year_wells_in_wildfires)
  pop_estimate <-
    terra::mask(pop_estimate, state_year_wells_in_wildfires, touches = TRUE)
  # captures estimated population living in mask
  pop_estimate <- pop_estimate %>% 
    as.data.frame() %>%  # coerce to dataframe
    as_tibble()  # then coerce to tibble (most comfortable to work with)
  estimate_out <- 
    tibble(state       = state_upper, 
           year        = year, 
           pop_exposed = sum(eval(parse(text = pop_variable)), na.rm = TRUE))
           #pop_exposed = sum(as.name(pop_variable), na.rm = TRUE))
  return(estimate_out)
}


## assessment ----------------------------------------------------------------

# AR .......................................................................
# makes tibble to capture data
ar_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
for(year in c(1986:1987, 1989, 1995, 1998, 2000, 2003:2007, 2010:2011, 
              2013:2019)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "AR", state_lower = "ar", year = year)
  ar_pop_exposed <- ar_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(ar_pop_exposed, "output/results/ar_pop_exposed.csv")

# CA .......................................................................
# makes tibble to capture data
ca_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
for(year in c(1984:2013, 2015:2010)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "CA", state_lower = "ca", year = year)
  ca_pop_exposed <- ca_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(ca_pop_exposed, "output/results/ca_pop_exposed.csv")


##### add the rest of the states once the well-wildfire data are done


## assemble dataset ----------------------------------------------------------

##### generate blank tibble for each state-year, then left_join with each
##### of the exposure datasets generated above, replaces NAs with 0s, and export



##============================================================================##