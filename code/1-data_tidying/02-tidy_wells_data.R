##============================================================================##

# import and Merge csv files. 
source("code/1-data_tidying/01-fxn-tidy_enverus_data.R")

## original wells data for this project --------------------------------------

# # imports and processes Enverus wells data
# setwd("data/raw/enverus/")  # need to point working directory to the data
# enverus_wells <- do.call(rbind,
#                      lapply(list.files(pattern = ".csv"),
#                             FUN = read_csv)) %>%
#   rename('long' = `Surface Hole Longitude (WGS84)`,
#          'lat'  = `Surface Hole Latitude (WGS84)`) %>% 
#   drop_na(long,lat) %>% 
#   st_as_sf(coords = c('long','lat'),
#            crs = crs_nad83) %>% 
#   mutate(across(c(`Spud Date`,`First Prod Date`,`Completion Date`,
#                   `Last Prod Date`,`First Well Test Date`,
#                   `Last Well Test Date`,`EUR Calc Date`),
#                 ~ as.Date(as.character(.x),"%Y"))) %>% 
#   tidyEnverusWellsData() %>% 
#   st_make_valid()
# setwd("../../../")  # resets working directory
# 
# # exports processed dataset
# saveRDS(enverus_wells,
#         file = "data/interim/enverus_wells.rds")

## updated wells data as of 11.10.2022  --------------------------------------

enverus_wells <- read_csv("data/raw/enverus2/ogd_usa_small.csv") %>% 
  filter(API_UWI > 0) %>% 
  filter(State %in% c("AK", "WA", "OR", "CA", "ID", "NV", "AZ", "MT", "WY", 
                      "UT", "CO", "NM", "ND", "SD", "NE", "KS", "OK", "TX",
                      "MN", "IA", "MO", "AR", "LA")) %>% 
    ##### data are missing: OK, WA, MN, IA, and ID (known issue?)
  st_as_sf(coords = c("longitude_WGS84", "latitude_WGS84"), crs = crs_nad83) %>% 
  # honestly not sure what this does...
  mutate(across(c(Spud_Date, Completion_Date, First_Prod_Date, Last_Prod_Date),
                ~ as.Date(as.character(.x), "%Y"))) %>%
  tidyEnverusWellsData() %>% 
  st_make_valid() %>% 
  distinct(api_number, .keep_all = TRUE) # do something else to retain dates?

# exports processed data
saveRDS(enverus_wells, file = "data/interim/enverus_wells.rds")

##============================================================================##
