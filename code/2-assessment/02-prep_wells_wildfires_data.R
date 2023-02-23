##============================================================================##
## 2.02 - preps data needed to count wells in wildfires


## setup ---------------------------------------------------------------------

# attaches packages ........................................................
source("code/0-setup/01-setup.R")

# data input
wells_all <- readRDS("data/interim/wells_all.rds")
wildfires_all <- readRDS("data/interim/wildfires_all.rds")

## makes wells buffers -------------------------------------------------------

# processing and export ....................................................
wells_ak_buffer_1km <- wells_all %>%
  filter(state == "AK") %>%
  st_transform(crs_alaska) %>%  # note distinct CRS: NAD83/Alaska Albers
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_ak_buffer_1km,
        "data/interim/wells_buffers/wells_ak_buffer_1km.rds")
wells_ar_buffer_1km <- wells_all %>% 
  filter(state == "AR") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_ar_buffer_1km, 
        "data/interim/wells_buffers/wells_ar_buffer_1km.rds")
wells_az_buffer_1km <- wells_all %>% 
  filter(state == "AZ") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_az_buffer_1km, 
        "data/interim/wells_buffers/wells_az_buffer_1km.rds")
wells_ca_buffer_1km <- wells_all %>% 
  filter(state == "CA") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_ca_buffer_1km,
        "data/interim/wells_buffers/wells_ca_buffer_1km.rds")
wells_co_buffer_1km <- wells_all %>% 
  filter(state == "CO") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_co_buffer_1km, 
        "data/interim/wells_buffers/wells_co_buffer_1km.rds")
wells_ks_buffer_1km <- wells_all %>% 
  filter(state == "KS") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_ks_buffer_1km,
        "data/interim/wells_buffers/wells_ks_buffer_1km.rds")
wells_la_buffer_1km <- wells_all %>% 
  filter(state == "LA") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_la_buffer_1km, 
        "data/interim/wells_buffers/wells_la_buffer_1km.rds")
wells_mo_buffer_1km <- wells_all %>% 
  filter(state == "MO") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_mo_buffer_1km, 
        "data/interim/wells_buffers/wells_mo_buffer_1km.rds")
wells_mt_buffer_1km <- wells_all %>% 
  filter(state == "MT") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_mt_buffer_1km, 
        "data/interim/wells_buffers/wells_mt_buffer_1km.rds")
wells_nd_buffer_1km <- wells_all %>% 
  filter(state == "ND") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_nd_buffer_1km, 
        "data/interim/wells_buffers/wells_nd_buffer_1km.rds")
wells_ne_buffer_1km <- wells_all %>% 
  filter(state == "NE") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_ne_buffer_1km, "data/interim/wells_buffers/wells_ne_buffer_1km.rds")
wells_nm_buffer_1km <- wells_all %>% 
  filter(state == "NM") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_nm_buffer_1km, "data/interim/wells_buffers/wells_nm_buffer_1km.rds")
wells_nv_buffer_1km <- wells_all %>% 
  filter(state == "NV") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_nv_buffer_1km, 
        "data/interim/wells_buffers/wells_nv_buffer_1km.rds")
wells_ok_buffer_1km <- wells_all %>% 
  filter(state == "OK") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_ok_buffer_1km, "data/interim/wells_buffers/wells_ok_buffer_1km.rds")
wells_or_buffer_1km <- wells_all %>% 
  filter(state == "OR") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_or_buffer_1km, "data/interim/wells_buffers/wells_or_buffer_1km.rds")
wells_sd_buffer_1km <- wells_all %>%
  filter(state == "SD") %>%
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_sd_buffer_1km, "data/interim/wells_buffers/wells_sd_buffer_1km.rds")
wells_tx_buffer_1km <- wells_all %>% 
  filter(state == "TX") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_tx_buffer_1km, "data/interim/wells_buffers/wells_tx_buffer_1km.rds")
wells_ut_buffer_1km <- wells_all %>% 
  filter(state == "UT") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_ut_buffer_1km, "data/interim/wells_buffers/wells_ut_buffer_1km.rds")
wells_wy_buffer_1km <- wells_all %>% 
  filter(state == "WY") %>% 
  st_transform(crs_albers) %>% 
  st_buffer(dist = 1000) %>%
  st_union()
saveRDS(wells_wy_buffer_1km, "data/interim/wells_buffers/wells_wy_buffer_1km.rds")

# unionizes and exports wells buffers ...................................
wells_all_buffer_1km <- wells_ar_buffer_1km %>% 
  st_union(wells_az_buffer_1km) %>% 
  st_union(wells_ca_buffer_1km) %>% 
  st_union(wells_co_buffer_1km) %>% 
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
  st_union(wells_wy_buffer_1km)
saveRDS(wells_all_buffer_1km,
        "data/interim/wells_buffers/wells_all_buffer_1km.rds")

## makes wildfires buffers ---------------------------------------------------

# processing and export ....................................................
wildfires_all %>%
  filter(state == "AK") %>%
  st_as_sf() %>% 
  st_transform(crs_alaska) %>%  # note Alaska-specific Albers projection
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_ak_buffer_1km.rds")
wildfires_all %>%
  filter(state == "AR") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_ar_buffer_1km.rds")
wildfires_all %>%
  filter(state == "AZ") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_az_buffer_1km.rds")
wildfires_all %>%
  filter(state == "CA") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_ca_buffer_1km.rds")
wildfires_all %>%
  filter(state == "CO") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_co_buffer_1km.rds")
wildfires_all %>%
  filter(state == "ID") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_id_buffer_1km.rds")
wildfires_all %>%
  filter(state == "KS") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_ks_buffer_1km.rds")
wildfires_all %>%
  filter(state == "LA") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_la_buffer_1km.rds")
wildfires_all %>%
  filter(state == "MO") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_mo_buffer_1km.rds")
wildfires_all %>%
  filter(state == "MT") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_mt_buffer_1km.rds")
wildfires_all %>%
  filter(state == "ND") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_nd_buffer_1km.rds")
wildfires_all %>%
  filter(state == "NE") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_ne_buffer_1km.rds")
wildfires_all %>%
  filter(state == "NM") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_nm_buffer_1km.rds")
wildfires_all %>%
  filter(state == "NV") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_nv_buffer_1km.rds")
wildfires_all %>%
  filter(state == "OK") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_ok_buffer_1km.rds")
wildfires_all %>%
  filter(state == "OR") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_or_buffer_1km.rds")
wildfires_all %>%
  filter(state == "SD") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_sd_buffer_1km.rds")
wildfires_all %>%
  filter(state == "TX") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_tx_buffer_1km.rds")
wildfires_all %>%
  filter(state == "UT") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_ut_buffer_1km.rds")
wildfires_all %>%
  filter(state == "WA") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_wa_buffer_1km.rds")
wildfires_all %>%
  filter(state == "WY") %>%
  st_as_sf() %>% 
  st_transform(crs_albers) %>%
  st_buffer(dist = 1000) %>%
  st_union() %>% 
  st_transform(crs_nad83) %>%
  saveRDS("data/interim/wildfires_buffers/wildfires_wy_buffer_1km.rds")

##============================================================================##