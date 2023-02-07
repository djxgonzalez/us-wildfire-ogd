##============================================================================##
## 2.11 - assembles analytic dataset for wildfires, including for each wildfire: 
## (1) n wells in wildfire burn areas, (2) n wells within 1 km of the burn area,
## (3) estimate population within 1 km of burn areas and wells

## setup ---------------------------------------------------------------------

# attaches functions
source("code/0-setup/01-setup.R")

# data input
wildfires_all <- readRDS("data/processed/wildfires_all.rds")

## n wells by wildfire, operation dates before fire --------------------------

# assembles dataset with the number of oil and gas wells drilled before the 
# wildfire year or with no development dates within the wildfire burn area; 
# restricted to wildfires with ≥ 1 well within 1 km of the wildfire boundary,
# so we'll need to join with the full wildfires dataset and add 0s below
wildfires_wells <- 
  read_csv("data/processed/wildfires_wells/wildfires_wells_ak.csv") %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ar.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_az.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ca.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_co.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ks.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_la.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_mt.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_nd.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ne.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_nm.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_nv.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ok.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_sd.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_tx.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ut.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_wy.csv")) %>% 
  as_tibble() %>% 
  # retain wildfire_id to join with other datasets below
  mutate(wildfire_id = as.factor(wildfire_id),
         state       = as.factor(state)) %>% 
  select(wildfire_id, state, n_wells)


## n wells by wildfire, operation dates before fire, 1 km buffer  ------------

# assembles dataset with the number of oil and gas wells drilled before the 
# wildfire year or with no development dates within 1km of the burn area; 
# restricted to wildfires with ≥ 1 well within 1 km of the wildfire boundary,
# so we'll need to join with the full wildfires dataset and add 0s below
wildfires_wells_buffer_1km <- 
  read_csv("data/processed/wildfires_wells/wildfires_wells_ak_buffer_1km.csv") %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ar_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_az_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ca_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_co_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ks_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_la_buffer_1km.csv")) %>%  
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_mt_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_nd_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ne_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_nm_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_nv_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ok_buffer_1km.csv")) %>%  
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_sd_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_tx_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ut_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_wy_buffer_1km.csv")) %>% 
  as_tibble() %>% 
  # retain wildfire_id to join with other datasets below 
  mutate(wildfire_id = as.factor(wildfire_id),
         state       = as.factor(state)) %>% 
  select(wildfire_id, state, n_wells_buffer_1km)


## n wells by wildfire, operation dates before fire --------------------------
## *EXCLUDING* wells with missing dates

# assembles dataset with the number of oil and gas wells drilled before the 
# wildfire year or with no development dates within the wildfire burn area;  
# distinct from the above dataset, excludes wells with no reported dates;
# restricted to wildfires with ≥ 1 well within 1 km of the wildfire boundary,
# so we'll need to join with the full wildfires dataset and add 0s below
wildfires_wells_dates <- 
  read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_ak.csv") %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_ar.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_az.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_ca.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_co.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_ks.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_la.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_mt.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_nd.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_ne.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_nm.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_nv.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_ok.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_sd.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_tx.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_ut.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_wy.csv")) %>% 
  as_tibble() %>% 
  # retain wildfire_id to join with other datasets below
  mutate(wildfire_id.  = as.factor(wildfire_id),
         state         = as.factor(state)) %>% 
  rename(n_wells_dates = n_wells) %>% 
  select(wildfire_id, state, n_wells_dates)


## n wells by wildfire, operation dates before fire , 1 km buffer  ------------
## *EXCLUDING* wells with missing dates 

# assembles dataset with the number of oil and gas wells drilled before the 
# wildfire year or with no development dates within 1km of the burn area; 
# distinct from the above dataset, excludes wells with no reported dates;
# restricted to wildfires with ≥ 1 well within 1 km of the wildfire boundary,
# so we'll need to join with the full wildfires dataset and add 0s below
wildfires_wells_dates_buffer_1km <- 
  read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_ak_buffer_1km.csv") %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_ar_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_az_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_ca_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_co_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_ks_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_la_buffer_1km.csv")) %>%  
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_mt_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_nd_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_ne_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_nm_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_nv_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_ok_buffer_1km.csv")) %>%  
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_sd_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_tx_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_ut_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_dates/wildfires_wells_dates_wy_buffer_1km.csv")) %>% 
  as_tibble() %>% 
  # retain wildfire_id to join with other datasets below 
  mutate(wildfire_id = as.factor(wildfire_id),
         state       = as.factor(state)) %>% 
  rename(n_wells_dates_buffer_1km = n_wells_buffer_1km) %>% 
  select(wildfire_id, state, n_wells_dates_buffer_1km)


## merge and export analytic dataset -----------------------------------------

# merges assessments of wells in/near wildfires and exposed populations
wildfires_wells_population <- wildfires_all %>% 
  left_join(wildfires_wells,                  by = c("wildfire_id", "state")) %>% 
  left_join(wildfires_wells_buffer_1km,       by = c("wildfire_id", "state")) %>% 
  left_join(wildfires_wells_dates,            by = c("wildfire_id", "state")) %>% 
  left_join(wildfires_wells_dates_buffer_1km, by = c("wildfire_id", "state")) %>% 
  # replaces NAs with 0s, for wildfires omitted from above analyses because
  # they were not near wells
  mutate(wildfire_area_km2        = as.numeric(wildfire_area_m2) / 1000000,
         n_wells                  = replace_na(n_wells, 0),
         n_wells_buffer_1km       = replace_na(n_wells_buffer_1km, 0),
         n_wells_dates            = replace_na(n_wells_dates, 0),
         n_wells_dates_buffer_1km = replace_na(n_wells_dates_buffer_1km, 0)) %>%
  as_tibble() %>% 
  select(-geometry)
  
# export
saveRDS(wildfires_wells_population, 
        "data/processed/wildfires_wells_population.rds")
write_csv(wildfires_wells_population,
          "data/processed/wildfires_wells_population.csv")


##============================================================================##