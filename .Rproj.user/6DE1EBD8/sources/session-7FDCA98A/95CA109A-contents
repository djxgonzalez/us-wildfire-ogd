##============================================================================##
## 2.03 - assembles individual state-level wildfires datasets into one dataset;
## this script focuses on wells with any prod date before the wildfire started

## all wells - with dates - no buffer ----------------------------------------
## assesses exposure to wells within  

# imports, binds, and tidies up wildfire x wells data
wildfires_wells_all_dates_0km <- 
  #readRDS("data/interim/wildfires_wells_ak_all_dates_0km.rds") %>% 
  #bind_rows(readRDS("data/interim/wildfires_wells_az_all_dates_0km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_ca_all_dates_0km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_co_all_dates_0km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_id_all_dates_0km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_ks_all_dates_0km.rds")) %>% 
  #bind_rows(readRDS("data/interim/wildfires_wells_la_all_dates_0km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_mt_all_dates_0km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_nd_all_dates_0km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_ne_all_dates_0km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_nm_all_dates_0km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_nv_all_dates_0km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_ok_all_dates_0km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_or_all_dates_0km.rds")) %>% 
  #bind_rows(readRDS("data/interim/wildfires_wells_sd_all_dates_0km.rds")) %>% 
  #bind_rows(readRDS("data/interim/wildfires_wells_tx_all_dates_0km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_ut_all_dates_0km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_wa_all_dates_0km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_wy_all_dates_0km.rds")) %>% 
  ##### add more states
  select(-State_Name) %>% 
  rename(event_id      = Event_ID,
         incident_name = Incid_Name,
         ignition_year = Ig_Year)
# exports processed the dataset as CSV (for ease of sharing)
write_csv(wildfires_wells_all_dates_0km,
          "data/processed/wildfires_wells_all_dates_0km.csv")


## all wells - with dates - 1 km buffer --------------------------------------
## wildfire burn areas)

# imports, binds, and tidies up wildfire x wells data
wildfires_wells_all_dates_1km <- 
  readRDS("data/interim/wildfires_wells_az_all_dates_1km.rds") %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_ca_all_dates_1km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_co_all_dates_1km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_nm_all_dates_1km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_nv_all_dates_1km.rds")) %>% 
  #bind_rows(readRDS("data/interim/wildfires_wells_ok_all_dates_1km.rds")) %>% 
  bind_rows(readRDS("data/interim/wildfires_wells_ut_all_dates_1km.rds")) %>% 
  ##### add more states
  select(-State_Name) %>% 
  rename(event_id      = Event_ID,
         incident_name = Incid_Name,
         ignition_year = Ig_Year)
# exports processed the dataset as CSV (for ease of sharing)
write_csv(wildfires_wells_all_dates_1km,
          "data/processed/wildfires_wells_all_dates_1km.csv")




## extra --------------------------------------------------------------------
## extra code to tidy up the interim wells data, i.e., rename columns

fires_wells_id_all_dates_0km <-
  readRDS("data/interim/wildfires_wells_id_all_dates_0km.rds") %>%
  rename(wells_all_dates_0km = wells_ID_all_dates_0km)
saveRDS(fires_wells_id_all_dates_0km,
        "data/interim/wildfires_wells_id_all_dates_0km.rds")

##============================================================================##