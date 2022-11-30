##============================================================================##
## 1.02 - Tidies data on wells from Enverus DrillingInfo for all oil and gas 
## wells in the study region

## setup ---------------------------------------------------------------------

# attaches necessary packages and functions
source("code/0-setup/01-setup.R")
source("code/1-data_tidying/01-fxn-tidy_wells_data.R")

# data input
wells_raw <- read_csv("data/raw/enverus/ogd_usa_small.csv") 

## tidies and exports data  --------------------------------------------------

# restricts to study region and passes wells through tidying function
wells_all <- wells_raw %>% 
  filter(API_UWI > 0) %>%  # drops wells with missing API number
  # restricts to wells in the study region
  filter(State %in% c("AK", "WA", "OR", "CA", "ID", "NV", "AZ", "MT", "WY", 
                      "UT", "CO", "NM", "ND", "SD", "NE", "KS", "OK", "TX",
                      "MN", "IA", "MO", "AR", "LA")) %>% 
  tidyWellsData()

# collapses wells that have duplicate API numbers
wells_all2 <- wells_all %>% ##### remove later
  group_by(api_number) %>% 
  summarize(cumulative_boe  = max(cumulative_boe,  na.rm = TRUE),
            months_produced = max(months_produced, na.rm = TRUE),
            spud_date       = min(spud_date,       na.rm = TRUE),
            completion_date = min(completion_date, na.rm = TRUE),
            first_prod_date = min(first_prod_date, na.rm = TRUE),
            last_prod_date  = max(last_prod_date,  na.rm = TRUE))
# addresses issue where -Inf or Inf is generated where NA's should be
wells_all2$cumulative_boe[!is.finite(wells_all2$cumulative_boe)]   <- NA
wells_all2$months_produced[!is.finite(wells_all2$months_produced)] <- NA
wells_all2$spud_date[!is.finite(wells_all2$spud_date)]             <- NA
wells_all2$completion_date[!is.finite(wells_all2$completion_date)] <- NA
wells_all2$first_prod_date[!is.finite(wells_all2$first_prod_date)] <- NA
wells_all2$last_prod_date[!is.finite(wells_all2$last_prod_date)]   <- NA

# isolates API number and factors to re-join with numeric/date vars in prev step
wells_all3 <- wells_all %>% 
  select(api_number, operator, county_parish, production_type, drill_type,
         state, latitude, longitude) %>% 
  distinct(api_number, .keep_all = TRUE)

# re-attaches factor variables to collapsed date variables and finalizes data
wells_all4 <- left_join(wells_all3, wells_all2, by = "api_number") %>%
  # adds var with earliest and latest observed dates across all date columns
  mutate(date_earliest = pmin(spud_date, completion_date, first_prod_date,
                              last_prod_date, na.rm = TRUE),
         date_latest   = pmax(spud_date, completion_date, first_prod_date,
                              last_prod_date, na.rm = TRUE)) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>% 
  st_make_valid()


# exports processed data ...................................................
saveRDS(wells_all4, "data/processed/wells_all.rds")


# removes datasets we no longer need .......................................
rm(wells_all, wells_all2, wells_all3, wells_all4)

##============================================================================##