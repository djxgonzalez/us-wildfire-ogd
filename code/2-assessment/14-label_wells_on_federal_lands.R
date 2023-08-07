##============================================================================##
## 2.14 - in this script, we add a label for whether each well was located
## on federal public lands, for inclusion in the analyses of projected risks

## setup ---------------------------------------------------------------------
source("code/0-setup/01-setup.R")

# data input
wells_kbdi <- readRDS("data/processed/wells_kbdi.rds")
us_states_included <- st_read("data/raw/esri/USA_States_Generalized.shp") %>% 
  filter(STATE_ABBR %in% 
           c("OR", "CA", "NV", "AZ", "MT", "WY", "UT", "CO", "NM",
             "ND", "SD", "NE", "KS", "OK", "TX", "MO", "AR", "LA")) %>%
  st_geometry() %>%
  st_transform(crs_albers) %>% 
  st_union()
federal_lands <- 
  st_read("data/raw/stanford_geo/federal_lands/fedlanp020.shp") %>% 
  filter(STATE %in% c("OR", "CA", "NV", "AZ", "MT", "WY", "UT", "CO", "NM",
                      "ND", "SD", "NE", "KS", "OK", "TX", "MO", "AR", "LA")) %>% 
  st_transform(crs_albers) %>% 
  as_tibble() %>% 
  mutate(well_on_federal_land = 1) %>% 
  st_as_sf() %>% 
  st_intersection(us_states_included)

# makes dataset with well ID and geometry only
wells <- wells_kbdi %>% 
  select(api_number, state, geometry) %>% 
  st_as_sf() %>% 
  st_transform(crs_albers)

## assessment ----------------------------------------------------------------

# separately for each state

# AR .......................................................................
fedlands_ar <- federal_lands %>% filter(STATE == "AR") %>% 
  st_geometry() %>% 
  st_union()
wells_ar <- wells %>% filter(state == "AR")
wells_fedlands_ar <- st_intersection(wells_ar, fedlands_ar)
saveRDS(wells_fedlands_ar,
        "data/interim/wells_on_public_lands/wells_fedlands_ar.rds")

# AZ .......................................................................
fedlands_az <- federal_lands %>% filter(STATE == "AZ") %>% 
  st_geometry() %>% 
  st_union()
wells_az <- wells %>% filter(state == "AZ")
wells_fedlands_az <- st_intersection(wells_az, fedlands_az)
saveRDS(wells_fedlands_az,
        "data/interim/wells_on_public_lands/wells_fedlands_az.rds")

# CA .......................................................................
fedlands_ca <- federal_lands %>% filter(STATE == "CA") %>% 
  st_geometry() %>% 
  st_union()
wells_ca <- wells %>% filter(state == "CA")
wells_fedlands_ca <- st_intersection(wells_ca, fedlands_ca)
saveRDS(wells_fedlands_ca,
        "data/interim/wells_on_public_land/wells_fedlands_ca.rds")

# CO .......................................................................
fedlands_co <- federal_lands %>% filter(STATE == "CO") %>% 
  st_geometry() %>% 
  st_union()
wells_co <- wells %>% filter(state == "CO")
wells_fedlands_co <- st_intersection(wells_co, fedlands_co)
saveRDS(wells_fedlands_co,
        "data/interim/wells_on_public_lands/wells_fedlands_co.rds")

# KS .......................................................................
fedlands_ks <- federal_lands %>% filter(STATE == "KS") %>% 
  st_geometry() %>% 
  st_union()
wells_ks <- wells %>% filter(state == "KS")
wells_fedlands_ks <- st_intersection(wells_ks, fedlands_ks)
saveRDS(wells_fedlands_ks,
        "data/interim/wells_on_public_lands/wells_fedlands_ks.rds")

# LA .......................................................................
fedlands_la <- federal_lands %>% filter(STATE == "LA") %>% 
  st_geometry() %>% 
  st_union()
wells_la <- wells %>% filter(state == "LA")
wells_fedlands_la <- st_intersection(wells_la, fedlands_la)
saveRDS(wells_fedlands_la,
        "data/interim/wells_on_public_lands/wells_fedlands_la.rds")

# MO .......................................................................
fedlands_mo <- federal_lands %>% filter(STATE == "MO") %>% 
  st_geometry() %>% 
  st_union()
wells_mo <- wells %>% filter(state == "MO")
wells_fedlands_mo <- st_intersection(wells_mo, fedlands_mo)
saveRDS(wells_fedlands_mo,
        "data/interim/wells_on_public_lands/wells_fedlands_mo.rds")

# MT .......................................................................
fedlands_mt <- federal_lands %>% filter(STATE == "MT") %>% 
  st_geometry() %>% 
  st_union()
wells_mt <- wells %>% filter(state == "MT")
wells_fedlands_mt <- st_intersection(wells_mt, fedlands_mt)
saveRDS(wells_fedlands_mt,
        "data/interim/wells_on_public_lands/wells_fedlands_mt.rds")

# ND .......................................................................
fedlands_nd <- federal_lands %>% filter(STATE == "ND") %>% 
  st_geometry() %>% 
  st_union()
wells_nd <- wells %>% filter(state == "ND")
wells_fedlands_nd <- st_intersection(wells_nd, fedlands_nd)
saveRDS(wells_fedlands_nd,
        "data/interim/wells_on_public_lands/wells_fedlands_nd.rds")

# NE .......................................................................
fedlands_ne <- federal_lands %>% filter(STATE == "NE") %>% 
  st_geometry() %>% 
  st_union()
wells_ne <- wells %>% filter(state == "NE")
wells_fedlands_ne <- st_intersection(wells_ne, fedlands_ne)
saveRDS(wells_fedlands_ne,
        "data/interim/wells_on_public_lands/wells_fedlands_ne.rds")

# NM .......................................................................
fedlands_nm <- federal_lands %>% filter(STATE == "NM") %>% 
  st_geometry() %>% 
  st_union()
wells_nm <- wells %>% filter(state == "NM")
wells_fedlands_nm <- st_intersection(wells_nm, fedlands_nm)
saveRDS(wells_fedlands_nm,
        "data/interim/wells_on_public_lands/wells_fedlands_nm.rds")

# NV .......................................................................
fedlands_nv <- federal_lands %>% filter(STATE == "NV") %>% 
  st_geometry() %>% 
  st_union()
wells_nv <- wells %>% filter(state == "NV")
wells_fedlands_nv <- st_intersection(wells_nv, fedlands_nv)
saveRDS(wells_fedlands_nv,
        "data/interim/wells_on_public_lands/wells_fedlands_nv.rds")

# OK .......................................................................
fedlands_ok <- federal_lands %>% filter(STATE == "OK") %>% 
  st_geometry() %>% 
  st_union()
wells_ok <- wells %>% filter(state == "OK")
wells_fedlands_ok <- st_intersection(wells_ok, fedlands_ok)
saveRDS(wells_fedlands_ok,
        "data/interim/wells_on_public_lands/wells_fedlands_ok.rds")

# OR .......................................................................
fedlands_or <- federal_lands %>% filter(STATE == "OR") %>% 
  st_geometry() %>% 
  st_union()
wells_or <- wells %>% filter(state == "OR")
wells_fedlands_or <- st_intersection(wells_or, fedlands_or)
saveRDS(wells_fedlands_or,
        "data/interim/wells_on_public_lands/wells_fedlands_or.rds")

# SD .......................................................................
fedlands_sd <- federal_lands %>% filter(STATE == "SD") %>% 
  st_geometry() %>% 
  st_union()
wells_sd <- wells %>% filter(state == "SD")
wells_fedlands_sd <- st_intersection(wells_sd, fedlands_sd)
saveRDS(wells_fedlands_sd,
        "data/interim/wells_on_public_lands/wells_fedlands_sd.rds")

# TX .......................................................................
fedlands_tx <- federal_lands %>% filter(STATE == "TX") %>% 
  st_geometry() %>% 
  st_union()
wells_tx <- wells %>% filter(state == "TX")
wells_fedlands_tx <- st_intersection(wells_tx, fedlands_tx)
saveRDS(wells_fedlands_tx,
        "data/interim/wells_on_public_lands/wells_fedlands_tx.rds")

# UT .......................................................................
fedlands_ut <- federal_lands %>% filter(STATE == "UT") %>% 
  st_geometry() %>% 
  st_union()
wells_ut <- wells %>% filter(state == "UT")
wells_fedlands_ut <- st_intersection(wells_ut, fedlands_ut)
saveRDS(wells_fedlands_ut,
        "data/interim/wells_on_public_lands/wells_fedlands_ut.rds")

# WY .......................................................................
fedlands_wy <- federal_lands %>% filter(STATE == "WY") %>% 
  st_geometry() %>% 
  st_union()
wells_wy <- wells %>% filter(state == "WY")
wells_fedlands_wy <- st_intersection(wells_wy, fedlands_wy)
saveRDS(wells_fedlands_wy,
        "data/interim/wells_on_public_lands/wells_fedlands_wy.rds")


## finalize and export -------------------------------------------------------

# merges datasets
wells_fedlands <- 
  readRDS("data/interim/wells_on_public_lands/wells_fedlands_ar.rds") %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_az.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_ca.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_co.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_ks.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_la.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_mo.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_mt.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_nd.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_ne.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_nm.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_nv.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_ok.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_or.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_sd.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_tx.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_ut.rds")) %>% 
  bind_rows(readRDS("data/interim/wells_on_public_lands/wells_fedlands_wy.rds")) %>% 
  as_tibble() %>% 
  mutate(well_on_federal_land = 1 ) %>% 
  select("api_number", "state", "well_on_federal_land")

# joins federal lands identifier to wells_kbdi dataset
wells_kbdi2 <- wells_kbdi %>% 
  left_join(wells_fedlands, by = c("api_number", "state")) %>% 
  mutate(well_on_federal_land = replace_na(well_on_federal_land, 0))

# exports processed dataset
saveRDS(wells_kbdi2, "data/processed/wells_kbdi.rds")

##============================================================================##