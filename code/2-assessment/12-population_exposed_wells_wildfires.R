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
  # flexibly imports relevant state-year wells in wildfire data
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
write_csv(ar_pop_exposed, "output/results/ar_pop_exposed.csv")  # export


# CA .......................................................................
# makes tibble to capture data
ca_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
for(year in c(1984:2010, 2012:2013, 2015:2019)) {
  #for(year in c(1984:2013, 2015:2010)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "CA", state_lower = "ca", year = year)
  ca_pop_exposed <- ca_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(ca_pop_exposed, "output/results/ca_pop_exposed.csv")  # export


# CO .......................................................................
# makes tibble to capture data
co_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
for(year in c(1985:1987, 1989, 1994, 1996, 2000:2002, 2004:2008, 2011:2019)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "CO", state_lower = "co", year = year)
  co_pop_exposed <- co_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(co_pop_exposed, "output/results/co_pop_exposed.csv")  # export


# KS .......................................................................
# makes tibble to capture data
ks_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
##### need to fix 2011
#for(year in c(1986:1998, 2000:2019)) {
for(year in c(1986:1998, 2000:2010, 2012:2019)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "KS", state_lower = "ks", year = year)
  ks_pop_exposed <- ks_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(ks_pop_exposed, "output/results/ks_pop_exposed.csv")  # export


# LA .......................................................................
# makes tibble to capture data
la_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
##### errors with LA for 2012; fix and incorporate; confirm we should do 2012!
for(year in c(1985, 1987, 1989, 1993, 1995:2007, 2009:2011, 2013:2019)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "LA", state_lower = "la", year = year)
  la_pop_exposed <- la_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(la_pop_exposed, "output/results/la_pop_exposed.csv")  # export


# MT .......................................................................
# makes tibble to capture data
mt_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
for(year in c(1988, 1991, 1999, 2003:2004, 2006:2008, 2010, 2012, 2017:2018)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "MT", state_lower = "mt", year = year)
  mt_pop_exposed <- mt_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(mt_pop_exposed, "output/results/mt_pop_exposed.csv")  # export


# ND .......................................................................
# makes tibble to capture data
nd_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
for(year in c(1988:1989, 1992, 1994, 1999:2000, 2003:2005, 2007:2008, 2012,
              2015, 2017)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "ND", state_lower = "nd", year = year)
  nd_pop_exposed <- nd_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(nd_pop_exposed, "output/results/nd_pop_exposed.csv")  # export


# NE .......................................................................
# makes tibble to capture data
ne_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
pop_exposed_out <-
  assessPopulationExposed(state_upper = "NE", state_lower = "ne", year = 2002)
ne_pop_exposed <- ne_pop_exposed %>% bind_rows(pop_exposed_out)
write_csv(ne_pop_exposed, "output/results/ne_pop_exposed.csv")  # export


# NM .......................................................................
# makes tibble to capture data
nm_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
for(year in c(1986:2001, 2005:2014, 2016:2019)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "NM", state_lower = "nm", year = year)
  nm_pop_exposed <- nm_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(nm_pop_exposed, "output/results/nm_pop_exposed.csv")  # export


# OK .......................................................................
# makes tibble to capture data
ok_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
#for(year in c(1991, 1994:1998, 2000:2019)) {  ###### error with 2014, will fix
for(year in c(1991, 1994:1998, 2000:2013, 2015:2019)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "OK", state_lower = "ok", year = year)
  ok_pop_exposed <- ok_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(ok_pop_exposed, "output/results/ok_pop_exposed.csv")  # export


# SD .......................................................................
# makes tibble to capture data
sd_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
for(year in c(1984:1985, 1988, 1999:2003, 2006:2007, 2011:2012, 2015:2016)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "SD", state_lower = "sd", year = year)
  sd_pop_exposed <- sd_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(sd_pop_exposed, "output/results/sd_pop_exposed.csv")  # export


# TX .......................................................................
# makes tibble to capture data
tx_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
for(year in c(1986:2019)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "TX", state_lower = "tx", year = year)
  tx_pop_exposed <- tx_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(tx_pop_exposed, "output/results/tx_pop_exposed.csv")  # export


# UT .......................................................................
# makes tibble to capture data
ut_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
for(year in c(1988:1989, 1994:1995, 1998:2002, 2004:2010, 2012, 2016:2018)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "UT", state_lower = "ut", year = year)
  ut_pop_exposed <- ut_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(ut_pop_exposed, "output/results/ut_pop_exposed.csv")  # export


# WY .......................................................................
# makes tibble to capture data
wy_pop_exposed <- tibble(state       = "",
                         year        = as.numeric(),
                         pop_exposed = as.numeric())
# for each state-year with >= 1 wells in wildfire burn areas (previously 
# assessed), estimates population within 1 km of those wells
for(year in c(1988, 1991:1992, 1996, 1998:2007, 2009:2012, 2015:2019)) {
  pop_exposed_out <-
    assessPopulationExposed(state_upper = "WY", state_lower = "wy", year = year)
  wy_pop_exposed <- wy_pop_exposed %>% bind_rows(pop_exposed_out)
}
write_csv(wy_pop_exposed, "output/results/wy_pop_exposed.csv")  # export


## assemble dataset ----------------------------------------------------------

##### generate blank tibble for each state-year, then left_join with each
##### of the exposure datasets generated above, replaces NAs with 0s, and export
##### could use wells_wildfires_state_year dataset


##============================================================================##