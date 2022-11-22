##============================================================================##

# import and Merge csv files. 
source("code/1-data_tidying/1-tidy_enverus_data.R")

# imports and processes Enverus wells data
setwd("data/raw/enverus/")  # need to point working directory to the data
enverus_wells <- do.call(rbind,
                     lapply(list.files(pattern = ".csv"),
                            FUN = read_csv)) %>%
  rename('long' = `Surface Hole Longitude (WGS84)`,
         'lat'  = `Surface Hole Latitude (WGS84)`) %>% 
  drop_na(long,lat) %>% 
  st_as_sf(coords = c('long','lat'),
           crs = crs_nad83) %>% 
  mutate(across(c(`Spud Date`,`First Prod Date`,`Completion Date`,
                  `Last Prod Date`,`First Well Test Date`,
                  `Last Well Test Date`,`EUR Calc Date`),
                ~ as.Date(as.character(.x),"%Y"))) %>% 
  tidyEnverusWellsData() %>% 
  st_make_valid()
setwd("../../../")  # resets working directory

# exports processed dataset
saveRDS(enverus_wells,
        file = "data/interim/enverus_wells.rds")

##============================================================================##