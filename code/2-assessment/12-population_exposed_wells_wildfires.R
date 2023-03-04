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

# CA .......................................................................

# makes tibble to capture data
ca_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
#for(year in c(1984:2013, 2015:2010)) {
for(year in c(1984:1985)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "CA", state_lower = "ca", year = year)
  ca_pop_exposed <- ca_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(ca_pop_exposed, "output/results/ca_pop_exposed.csv")






for(year in c(1984:2013, 2015:2010)) {
  
  state_year_wells_in_wildfires <- 
    vect(eval(parse(text = (paste(state_lower, year, sep = "_")))))
  # series of if else statements to make sure we're using the correct
  # population dataset
  if(year %in% c(1984:1994)){
    
    dat <- dat %>% bind_rows(estimate_out)
  } else if(year %in% c(1995:2004)) {
    pop_estimate <- 
      terra::crop(pop_2000, 
                  vect(eval(parse(text = (paste("ca_", year, sep = ""))))))
    pop_estimate <-
      terra::mask(pop_estimate,
                  vect(eval(parse(text = (paste("ca_", year, sep = ""))))), 
                  touches = TRUE)
    pop_estimate <- pop_estimate %>% 
      as.data.frame() %>%  # coerce to dataframe
      as_tibble()  # then coerce to tibble (most comfortable to work with)
    estimate_out <- 
      tibble(state       = "CA", 
             year        = year, 
             pop_exposed = sum(pop_estimate$us_pop2000myc.population_data, 
                               na.rm = TRUE))
    dat <- dat %>% bind_rows(estimate_out)
  } else if(year %in% c(2005:2014)) {
    pop_estimate <- 
      terra::crop(pop_2010, 
                  vect(eval(parse(text = (paste("ca_", year, sep = ""))))))
    pop_estimate <-
      terra::mask(pop_estimate,
                  vect(eval(parse(text = (paste("ca_", year, sep = ""))))), 
                  touches = TRUE)
    pop_estimate <- pop_estimate %>% 
      as.data.frame() %>%  # coerce to dataframe
      as_tibble()  # then coerce to tibble (most comfortable to work with)
    estimate_out <- 
      tibble(state       = "CA", 
             year        = year, 
             pop_exposed = sum(pop_estimate$us_pop2010myc.population_data, 
                               na.rm = TRUE))
    dat <- dat %>% bind_rows(estimate_out)
  } else if(year %in% c(2015:2019)) {
    pop_estimate <- 
      terra::crop(pop_2020, 
                  vect(eval(parse(text = (paste("ca_", year, sep = ""))))))
    pop_estimate <-
      terra::mask(pop_estimate,
                  vect(eval(parse(text = (paste("ca_", year, sep = ""))))), 
                  touches = TRUE)
    pop_estimate <- pop_estimate %>% 
      as.data.frame() %>%  # coerce to dataframe
      as_tibble()  # then coerce to tibble (most comfortable to work with)
    estimate_out <- 
      tibble(state       = "CA", 
             year        = year, 
             pop_exposed = sum(pop_estimate$us_pop2020myc, 
                               na.rm = TRUE))
    dat <- dat %>% bind_rows(estimate_out)
  }
}

dat %>% 
  ggplot(aes(year, pop_exposed)) +
  geom_point() +
  theme_classic()

##============================================================================##

# clips population data to states to study region mask
# pop_2020_cropped <- terra::crop(pop_2020, vect(ar_2018))
# pop_2020_masked  <- terra::mask(pop_2020_cropped,
#                                 vect(ar_2018), 
#                                 touches = TRUE)
# plot(pop_2020_masked)
# # to calculate population in the mask...
# pop_2020_in_mask <- pop_2020_masked %>% 
#   as.data.frame() %>%  # coerce to dataframe
#   as_tibble() %>%   # then coerce to tibble (most comfortable to work with)
#   drop_na(us_pop2020myc)  # drop NA cells, i.e., outside mask
# # now we can take the sum
# sum(pop_2020_in_mask$us_pop2020myc)

#### do this for each state-year and WE'RE GOLDEN

##============================================================================##