##============================================================================##
## 2.07 - Sets up and runs assessment, for all states included in study, of
## the count of wells in wildfires (excluding wells known to have been drilled
## after the wildfire occurred)

## setup ---------------------------------------------------------------------

# attaches functions .....................................................
source("code/0-setup/01-setup.R")

## data input and processing--------------------------------------------------

## assessments by state-year
wells_wildfire_state_year <- 
  read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_ak.csv") %>% 
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_ar.csv")) %>% 
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_az.csv")) %>% 
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_ca.csv")) %>% 
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_co.csv")) %>% 
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_ks.csv")) %>% 
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_la.csv")) %>% 
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_mo.csv")) %>% 
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_mt.csv")) %>% 
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_nd.csv")) %>% 
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_ne.csv")) %>% 
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_nm.csv")) %>% 
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_nv.csv")) %>%
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_ok.csv")) %>%
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_or.csv")) %>%
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_sd.csv")) %>%
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_tx.csv")) %>%
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_ut.csv")) %>%
  bind_rows(read_csv("data/interim/wells_wildfire_year/wells_wildfire_year_wy.csv"))

saveRDS(wells_wildfire_state_year,  
        "data/processed/wells_wildfire_state_year.rds")
write_csv(wells_wildfire_state_year, 
          "data/processed/wells_wildfire_state_year.csv")


#### FINISH SCRIPT

##============================================================================##