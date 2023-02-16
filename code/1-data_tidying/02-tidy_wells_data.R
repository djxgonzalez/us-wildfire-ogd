##============================================================================##
## 1.02 - Tidies data on wells from Enverus DrillingInfo for all oil and gas 
## wells in the study region

## setup ---------------------------------------------------------------------

# attaches necessary packages and functions
source("code/0-setup/01-setup.R")
source("code/1-data_tidying/01-fxn-tidy_wells_data.R")

# data input
wells_raw    <- read_csv("data/raw/enverus/enverus_wells_us.csv")

## tidies and exports data  --------------------------------------------------

# restricts to study region and passes wells through custom tidying function
wells_all <- wells_raw %>% 
  filter(State %in% c("AK", "OR", "CA", "NV", "AZ", "MT", "WY", "UT", "CO", 
                      "NM", "ND", "SD", "NE", "KS", "OK", "TX", "MO", "AR", "LA")) %>% 
  tidyWellsData()

# re-attaches factor variables to collapsed date variables and finalizes data
wells_all2 <- wells_all %>%
  # adds var with earliest and latest observed dates across all date columns
  mutate(date_earliest = pmin(spud_date, completion_date, first_prod_date,
                              last_prod_date, na.rm = TRUE),
         date_latest   = pmax(spud_date, completion_date, first_prod_date,
                              last_prod_date, na.rm = TRUE)) %>%
  # excludes wells where the earliest date was after December 31, 2020, the last
  # date in the study period (retaining NAs)
  filter(date_earliest <= "2019-12-31" | is.na(date_earliest)) %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>% 
  st_make_valid()

# exports processed data ...................................................
saveRDS(wells_all2, "data/processed/wells_all.rds")

# removes datasets we no longer need .......................................
rm(wells_raw, wells_all, wells_all2)

##============================================================================##