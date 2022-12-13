##============================================================================##
## 2.07 - assembles analytic dataset for wildfires, including for each wildfire: 
## (1) n wells in wildfire burn areas, (2) n wells within 1 km of the burn area,
## (3) estimate population within 1 km of burn areas and wells

## setup ---------------------------------------------------------------------

# attaches functions
source("code/0-setup/01-setup.R")

# data input
wildfires_all <- readRDS("data/processed/wildfires_all.rds")


## n wells by wildfire, operate dates before fire ----------------------------

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
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_id.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ks.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_la.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_mo.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_mt.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_nd.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ne.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_nm.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_nv.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ok.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_or.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_sd.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_tx.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ut.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_wa.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_wy.csv")) %>% 
  as_tibble() %>% 
  # retain wildfire_id to join with other datasets below
  select(wildfire_id, data_source, n_wells)


## n wells by wildfire, operate dates before fire, 1 km buffer  --------------

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
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_id_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ks_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_la_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_mo_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_mt_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_nd_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ne_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_nm_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_nv_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ok_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_or_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_sd_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_tx_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_ut_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_wa_buffer_1km.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells/wildfires_wells_wy_buffer_1km.csv")) %>% 
  as_tibble() %>% 
  # retain wildfire_id to join with other datasets below
  select(wildfire_id, data_source, n_wells_buffer_1km)


## population exposed to wells in wildfires ----------------------------------

# assembles dataset with the estimated number of residents within 1 km of wells
# that were situated in wildfire burn areas
wildfires_wells_population <- 
  read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_ak.csv") %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_ar.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_az.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_ca.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_co.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_id.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_ks.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_la.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_mo.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_mt.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_nd.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_ne.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_nm.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_nv.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_ok.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_or.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_sd.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_tx.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_ut.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_wa.csv")) %>% 
  bind_rows(read_csv("data/processed/wildfires_wells_population/wildfires_wells_pop_wy.csv")) %>% 
  as_tibble() %>% 
  # retain wildfire_id to join with other datasets below
  select(wildfire_id, data_source, n_population_exposed)


## merge and export analytic dataset -----------------------------------------

# merges assessments of wells in/near wildfires and exposed populations
wildfires_wells_population <- wildfires_all %>% 
  left_join(wildfires_wells_dates, by = c(wildfire_id, data_source)) %>% 
  left_join(wildfires_wells_dates_buffer_1km, by = c(wildfire_id, data_source)) %>% 
  left_join(wildfires_wells_dates, by = c(wildfire_id, data_source)) %>% 
  # replaces NAs with 0s, for wildfires omitted from above analyses because
  # they were not near wells
  mutate(n_wells              = replace_na(n_wells, 0),
         n_wells_buffer_1km   = replace_na(n_wells_buffer_1km, 0),
         n_population_exposed = replace_na(n_population_exposed, 0))

# export
saveRDS("data/processed/wildfires_wells_population.rds")
write_csv("data/processed/wildfires_wells_population.csv")


##============================================================================##