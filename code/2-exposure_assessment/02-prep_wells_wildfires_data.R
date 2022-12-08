##============================================================================##
## 2.02 - preps data needed to count wells in wildfires


## setup ---------------------------------------------------------------------

# attaches packages ........................................................
source("code/0-setup/01-setup.R")

# data input
#wells_all <- readRDS("data/processed/wells_all.rds")
wildfires_all <- readRDS("data/processed/wildfires_all.rds")


## wells data ----------------------------------------------------------------

# processing and export ....................................................
wells_ak_buffer_1km <- wells_all %>%
  filter(state == "AK") %>%
  st_transform(crs_alaska) %>%  # note distinct CRS: NAD83/Alaska Albers
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_ak_buffer_1km,
        "data/interim/buffers_wells/buffers_ak_buffer_1km.rds")
wells_ar_buffer_1km <- wells_all %>% 
  filter(state == "AR") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_ar_buffer_1km, 
        "data/interim/buffers_wells/buffers_ar_buffer_1km.rds")
wells_az_buffer_1km <- wells_all %>% 
  filter(state == "AZ") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_az_buffer_1km, 
        "data/interim/buffers_wells/buffers_az_buffer_1km.rds")
wells_ca_buffer_1km <- wells_all %>% 
  filter(state == "CA") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_ca_buffer_1km,
        "data/interim/buffers_wells/buffers_ca_buffer_1km.rds")
wells_co_buffer_1km <- wells_all %>% 
  filter(state == "CO") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_co_buffer_1km, 
        "data/interim/buffers_wells/buffers_co_buffer_1km.rds")
wells_id_buffer_1km <- wells_all %>% 
  filter(state == "ID") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%  
  st_union()
saveRDS(wells_id_buffer_1km, 
        "data/interim/buffers_wells/buffers_id_buffer_1km.rds")
wells_ks_buffer_1km <- wells_all %>% 
  filter(state == "KS") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_ks_buffer_1km,
        "data/interim/buffers_wells/buffers_ks_buffer_1km.rds")
wells_la_buffer_1km <- wells_all %>% 
  filter(state == "LA") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_la_buffer_1km, 
        "data/interim/buffers_wells/buffers_la_buffer_1km.rds")
wells_mo_buffer_1km <- wells_all %>% 
  filter(state == "MO") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_mo_buffer_1km, 
        "data/interim/buffers_wells/buffers_mo_buffer_1km.rds")
wells_mt_buffer_1km <- wells_all %>% 
  filter(state == "MT") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_mt_buffer_1km, 
        "data/interim/buffers_wells/buffers_mt_buffer_1km.rds")
wells_nd_buffer_1km <- wells_all %>% 
  filter(state == "ND") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_nd_buffer_1km, 
        "data/interim/buffers_wells/buffers_nd_buffer_1km.rds")
wells_ne_buffer_1km <- wells_all %>% 
  filter(state == "NE") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_ne_buffer_1km, "data/interim/buffers_wells/buffers_ne_buffer_1km.rds")
wells_nm_buffer_1km <- wells_all %>% 
  filter(state == "NM") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_nm_buffer_1km, "data/interim/buffers_wells/buffers_nm_buffer_1km.rds")
wells_nv_buffer_1km <- wells_all %>% 
  filter(state == "NV") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_nv_buffer_1km, 
        "data/interim/buffers_wells/buffers_nv_buffer_1km.rds")
wells_ok_buffer_1km <- wells_all %>% 
  filter(state == "OK") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_ok_buffer_1km, "data/interim/buffers_wells/buffers_ok_buffer_1km.rds")
wells_or_buffer_1km <- wells_all %>% 
  filter(state == "OR") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_or_buffer_1km, "data/interim/buffers_wells/buffers_or_buffer_1km.rds")
wells_sd_buffer_1km <- wells_all %>%
  filter(state == "SD") %>%
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_sd_buffer_1km, "data/interim/buffers_wells/buffers_sd_buffer_1km.rds")
wells_tx_buffer_1km <- wells_all %>% 
  filter(state == "TX") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_tx_buffer_1km, "data/interim/buffers_wells/buffers_tx_buffer_1km.rds")
wells_ut_buffer_1km <- wells_all %>% 
  filter(state == "UT") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_ut_buffer_1km, "data/interim/buffers_wells/buffers_ut_buffer_1km.rds")
wells_wa_buffer_1km <- wells_all %>% 
  filter(state == "WA") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_wa_buffer_1km, "data/interim/buffers_wells/buffers_wa_buffer_1km.rds")
wells_wy_buffer_1km <- wells_all %>% 
  filter(state == "WY") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_wy_buffer_1km, "data/interim/buffers_wells/buffers_wy_buffer_1km.rds")


# unionizes and exports wells buffers ...................................
wells_all_buffer_1km <- wells_ar_buffer_1km %>% 
  st_union(wells_az_buffer_1km) %>% 
  st_union(wells_ca_buffer_1km) %>% 
  st_union(wells_co_buffer_1km) %>% 
  st_union(wells_id_buffer_1km) %>% 
  st_union(wells_ks_buffer_1km) %>% 
  st_union(wells_mt_buffer_1km) %>% 
  st_union(wells_nd_buffer_1km) %>% 
  st_union(wells_ne_buffer_1km) %>% 
  st_union(wells_la_buffer_1km) %>% 
  st_union(wells_mo_buffer_1km) %>% 
  st_union(wells_nm_buffer_1km) %>% 
  st_union(wells_nv_buffer_1km) %>% 
  st_union(wells_ok_buffer_1km) %>% 
  st_union(wells_or_buffer_1km) %>% 
  st_union(wells_sd_buffer_1km) %>% 
  st_union(wells_tx_buffer_1km) %>% 
  st_union(wells_ut_buffer_1km) %>% 
  st_union(wells_wa_buffer_1km) %>% 
  st_union(wells_wy_buffer_1km)
saveRDS(wells_all_buffer_1km,
        "data/interim/buffers_wells/buffers_all_buffer_1km.rds")


##============================================================================##