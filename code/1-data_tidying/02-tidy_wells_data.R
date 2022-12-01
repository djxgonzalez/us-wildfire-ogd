##============================================================================##
## 1.02 - Tidies data on wells from Enverus DrillingInfo for all oil and gas 
## wells in the study region

## setup ---------------------------------------------------------------------

# attaches necessary packages and functions
source("code/0-setup/01-setup.R")
source("code/1-data_tidying/01-fxn-tidy_wells_data.R")

# data input
wells_raw    <- read_csv("data/raw/enverus/ogd_usa_small.csv")
wells_id_raw <- read_csv("data/raw/enverus/Idaho_All.csv")
wells_wa_raw <- read_csv("data/raw/enverus/Washington_All.csv")

## tidies and exports data  --------------------------------------------------

# preps enverus data for ID and WA to match format of data from other states
# in the wells_raw dataset, so we can include them in the workflow below
wells_id_wa <- bind_rows(wells_id_raw, wells_wa_raw) %>% 
  mutate(API_UWI               = API14,
         Operator_Company_Name = `Operator Company Name`,
         County_Parish         = `County/Parish`,
         Production_Type       = `Production Type`,
         Drill_Type            = `Drill Type`,
         First_Prod_Date       = `First Prod Date`,
         Last_Prod_Date        = `Last Prod Date`,
         Cum_BOE               = `Cum BOE`,
         Completion_Date       = `Completion Date`,
         Months_Produced       = `Months Produced`,
         Spud_Date             = `Spud Date`,
         latitude_WGS84        = `Surface Hole Latitude (WGS84)`,
         longitude_WGS84       = `Surface Hole Longitude (WGS84)`) %>% 
  # restrict to necessary columns; need this to retain `State` in dataset
  select(API_UWI, Operator_Company_Name, County_Parish, Production_Type,
         Drill_Type, First_Prod_Date, Last_Prod_Date, Cum_BOE, Completion_Date,
         Months_Produced, Spud_Date, State, latitude_WGS84, longitude_WGS84) %>% 
  filter(Production_Type %in% c("GAS", "O&G", "OIL")) %>% 
  drop_na(latitude_WGS84)

# restricts to study region and passes wells through custom tidying function
wells_all <- wells_raw %>% 
  bind_rows(wells_id_wa) %>%  # adds data for ID and WA prepped above
  filter(API_UWI > 0) %>%  # drops wells with missing API number
  # restricts to wells in the study region
  filter(State %in% c("AK", "WA", "OR", "CA", "ID", "NV", "AZ", "MT", "WY", 
                      "UT", "CO", "NM", "ND", "SD", "NE", "KS", "OK", "TX",
                      "MO", "AR", "LA")) %>% 
  tidyWellsData()

# collapses wells that have duplicate API numbers
wells_all2 <- wells_all %>% 
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
  # excludes wells where the earliest date was after December 31, 2020, the last
  # date in the study period (retaining NAs)
  filter(date_earliest <= "2020-12-31" | is.na(date_earliest)) %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>% 
  st_make_valid()


# exports processed data ...................................................
saveRDS(wells_all4, "data/processed/wells_all.rds")


# removes datasets we no longer need .......................................
rm(wells_all, wells_all2, wells_all3, wells_all4, wells_id_raw, wells_wa_raw,
   wells_raw)

##============================================================================##