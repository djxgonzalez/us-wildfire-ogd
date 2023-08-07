##============================================================================##
## 2.16 - in this script, we add a label for whether each well was located
## on tribal public lands; exploratory, not planning to report, but in detail

## setup ---------------------------------------------------------------------
source("code/0-setup/01-setup.R")

# data input
wells_kbdi <- readRDS("data/processed/wells_kbdi.rds")
tribal_lands <- 
  st_read("data/raw/us_census/tl_2019_us_aiannh/tl_2019_us_aiannh.shp") %>% 
  st_transform(crs_albers) %>% 
  as_tibble() %>% 
  mutate(well_on_tribal_land = 1) %>% 
  st_as_sf()

# makes dataset with well ID and geometry only
wells <- wells_kbdi %>% 
  select(api_number, state, geometry) %>% 
  st_as_sf() %>% 
  st_transform(crs_albers)

## assessment ----------------------------------------------------------------

# separately for each state

# AR .......................................................................
tribal_lands_ar <- tribal_lands %>% filter(STATE == "AR") %>% 
  st_geometry() %>% 
  st_union()
wells_ar <- wells %>% filter(state == "AR")
wells_tribal_lands_ar <- st_intersection(wells_ar, tribal_lands_ar)
saveRDS(wells_tribal_lands_ar,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_ar.rds")

# AZ .......................................................................
tribal_lands_az <- tribal_lands %>% filter(STATE == "AZ") %>% 
  st_geometry() %>% 
  st_union()
wells_az <- wells %>% filter(state == "AZ")
wells_tribal_lands_az <- st_intersection(wells_az, tribal_lands_az)
saveRDS(wells_tribal_lands_az,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_az.rds")

# CA .......................................................................
tribal_lands_ca <- tribal_lands %>% filter(STATE == "CA") %>% 
  st_geometry() %>% 
  st_union()
wells_ca <- wells %>% filter(state == "CA")
wells_tribal_lands_ca <- st_intersection(wells_ca, tribal_lands_ca)
saveRDS(wells_tribal_lands_ca,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_ca.rds")

# CO .......................................................................
tribal_lands_co <- tribal_lands %>% filter(STATE == "CO") %>% 
  st_geometry() %>% 
  st_union()
wells_co <- wells %>% filter(state == "CO")
wells_tribal_lands_co <- st_intersection(wells_co, tribal_lands_co)
saveRDS(wells_tribal_lands_co,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_co.rds")

# KS .......................................................................
tribal_lands_ks <- tribal_lands %>% filter(STATE == "KS") %>% 
  st_geometry() %>% 
  st_union()
wells_ks <- wells %>% filter(state == "KS")
wells_tribal_lands_ks <- st_intersection(wells_ks, tribal_lands_ks)
saveRDS(wells_tribal_lands_ks,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_ks.rds")

# LA .......................................................................
tribal_lands_la <- tribal_lands %>% filter(STATE == "LA") %>% 
  st_geometry() %>% 
  st_union()
wells_la <- wells %>% filter(state == "LA")
wells_tribal_lands_la <- st_intersection(wells_la, tribal_lands_la)
saveRDS(wells_tribal_lands_la,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_la.rds")

# MO .......................................................................
tribal_lands_mo <- tribal_lands %>% filter(STATE == "MO") %>% 
  st_geometry() %>% 
  st_union()
wells_mo <- wells %>% filter(state == "MO")
wells_tribal_lands_mo <- st_intersection(wells_mo, tribal_lands_mo)
saveRDS(wells_tribal_lands_mo,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_mo.rds")

# MT .......................................................................
tribal_lands_mt <- tribal_lands %>% filter(STATE == "MT") %>% 
  st_geometry() %>% 
  st_union()
wells_mt <- wells %>% filter(state == "MT")
wells_tribal_lands_mt <- st_intersection(wells_mt, tribal_lands_mt)
saveRDS(wells_tribal_lands_mt,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_mt.rds")

# ND .......................................................................
tribal_lands_nd <- tribal_lands %>% filter(STATE == "ND") %>% 
  st_geometry() %>% 
  st_union()
wells_nd <- wells %>% filter(state == "ND")
wells_tribal_lands_nd <- st_intersection(wells_nd, tribal_lands_nd)
saveRDS(wells_tribal_lands_nd,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_nd.rds")

# NE .......................................................................
tribal_lands_ne <- tribal_lands %>% filter(STATE == "NE") %>% 
  st_geometry() %>% 
  st_union()
wells_ne <- wells %>% filter(state == "NE")
wells_tribal_lands_ne <- st_intersection(wells_ne, tribal_lands_ne)
saveRDS(wells_tribal_lands_ne,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_ne.rds")

# NM .......................................................................
tribal_lands_nm <- tribal_lands %>% filter(STATE == "NM") %>% 
  st_geometry() %>% 
  st_union()
wells_nm <- wells %>% filter(state == "NM")
wells_tribal_lands_nm <- st_intersection(wells_nm, tribal_lands_nm)
saveRDS(wells_tribal_lands_nm,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_nm.rds")

# NV .......................................................................
tribal_lands_nv <- tribal_lands %>% filter(STATE == "NV") %>% 
  st_geometry() %>% 
  st_union()
wells_nv <- wells %>% filter(state == "NV")
wells_tribal_lands_nv <- st_intersection(wells_nv, tribal_lands_nv)
saveRDS(wells_tribal_lands_nv,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_nv.rds")

# OK .......................................................................
tribal_lands_ok <- tribal_lands %>% filter(STATE == "OK") %>% 
  st_geometry() %>% 
  st_union()
wells_ok <- wells %>% filter(state == "OK")
wells_tribal_lands_ok <- st_intersection(wells_ok, tribal_lands_ok)
saveRDS(wells_tribal_lands_ok,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_ok.rds")

# OR .......................................................................
wells_or <- wells %>% filter(state == "OR")
wells_tribal_lands_or <- st_intersection(wells_or, tribal_lands_or)
saveRDS(wells_tribal_lands_or,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_or.rds")

# SD .......................................................................
wells_sd <- wells %>% filter(state == "SD")
wells_tribal_lands_sd <- st_intersection(wells_sd, tribal_lands_sd)
saveRDS(wells_tribal_lands_sd,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_sd.rds")

# TX .......................................................................
wells_tx <- wells %>% filter(state == "TX")
wells_tribal_lands_tx <- st_intersection(wells_tx, tribal_lands_tx)
saveRDS(wells_tribal_lands_tx,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_tx.rds")

# UT .......................................................................
wells_ut <- wells %>% filter(state == "UT")
wells_tribal_lands_ut <- st_intersection(wells_ut, tribal_lands)
saveRDS(wells_tribal_lands_ut,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_ut.rds")

# WY .......................................................................
wells_wy <- wells %>% filter(state == "WY")
wells_tribal_lands_wy <- st_intersection(wells_wy, tribal_lands_wy)
saveRDS(wells_tribal_lands_wy,
        "data/interim/wells_on_tribal_lands/wells_tribal_lands_wy.rds")


## finalize and export -------------------------------------------------------

# merges datasets
wells_tribal_lands <- 
  readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_ar.rds") %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_az.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_ca.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_co.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_ks.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_la.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_mo.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_mt.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_nd.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_ne.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_nm.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_nv.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_ok.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_or.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_sd.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_tx.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_ut.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_tribal_lands/wells_tribal_lands_wy.rds")) %>% 
  as_tibble() %>% 
  mutate(well_on_tribal_land = 1 ) %>% 
  select("api_number", "state", "well_on_tribal_land")

# joins federal lands identifier to wells_kbdi dataset
wells_kbdi2 <- wells_kbdi %>% 
  left_join(wells_tribal_lands, by = c("api_number", "state")) %>% 
  mutate(well_on_tribal_land = replace_na(well_on_tribal_land, 0))

# exports processed dataset
saveRDS(wells_kbdi2, "data/processed/wells_kbdi.rds")

##============================================================================##