##============================================================================##
## 2.13 - for each well, matches the KBDI wildfire risk values for the nearest
## terrestrial point for each of the three time periods: current (2017), 
## mid-century (2046-2054, called 2050 here for convenience) and end-century
## (2086-2094, called 2090 here)


## setup ---------------------------------------------------------------------
source("code/0-setup/01-setup.R")

# data prep, part 1 ........................................................

# only need to run this once; un-comment and run if needed:
# study_region_sf <- st_read("data/raw/noaa/us_states/s_22mr22.shp") %>%
#   filter(STATE %in% c("OR", "CA", "NV", "AZ", "MT", "WY", "UT", "CO", "NM",
#                       "ND", "SD", "NE", "KS", "OK", "TX", "MO", "AR", "LA")) %>%
#   st_make_valid() %>%
#   st_transform() %>%
#   st_union() %>%
#   st_geometry()
# # # exports processed data sine this step takes a minute
# saveRDS(study_region_sf, "data/interim/study_region_sf.rds")

## data prep, part 2 ........................................................

# reads in file generated in data prep part 1
study_region_sf <- readRDS("data/interim/study_region_sf.rds")

kbdi_max_2017_sf <- readRDS("data/interim/kbdi_max_2017.rds") %>% 
  as_tibble() %>%
  st_as_sf(coords = c("x", "y"), crs = crs_nad83) %>% 
  st_intersection(study_region_sf)
kbdi_max_2050_sf <- readRDS("data/interim/kbdi_max_2050.rds") %>% 
  as_tibble() %>%
  st_as_sf(coords = c("x", "y"), crs = crs_nad83) %>% 
  st_intersection(study_region_sf)
kbdi_max_2090_sf <- readRDS("data/interim/kbdi_max_2090.rds") %>% 
  as_tibble() %>%
  st_as_sf(coords = c("x", "y"), crs = crs_nad83) %>% 
  st_intersection(study_region_sf)

wells_all <- readRDS("data/interim/wells_all.rds")


## exposure assessment -------------------------------------------------------

## 2017 ....................................................................
# for each well, gets index of nearest KBDI point
wells_kbdi_index_2017 <- 
  st_nearest_feature(wells_all, kbdi_max_2017_sf)
# we use that index to attach the nearest KBDI to each well
wells_kbdi_2017 <- wells_all %>% 
  dplyr::select(api_number) %>% 
  as_tibble() %>% 
  mutate(kbdi_max_2017_index = wells_kbdi_index_2017) %>% 
  mutate(kbdi_max_2017 = kbdi_max_2017_sf$kbdi_max_2017[kbdi_max_2017_index]) %>% 
  dplyr::select(-c(kbdi_max_2017_index, geometry)) %>% 
  filter(api_number != "0")

## 2050 ....................................................................
# for each well, gets index of nearest KBDI point
wells_kbdi_index_2050 <- 
  st_nearest_feature(wells_all, kbdi_max_2050_sf)
# we use that index to attach the nearest KBDI to each well
wells_kbdi_2050 <- wells_all %>% 
  dplyr::select(api_number) %>% 
  as_tibble() %>% 
  mutate(kbdi_max_2050_index = wells_kbdi_index_2050) %>% 
  mutate(kbdi_max_2050 = kbdi_max_2050_sf$kbdi_max_2050[kbdi_max_2050_index]) %>% 
  dplyr::select(-c(kbdi_max_2050_index, geometry)) %>% 
  filter(api_number != "0")

## 2090 ....................................................................
# for each well, gets index of nearest KBDI point
wells_kbdi_index_2090 <- 
  st_nearest_feature(wells_all, kbdi_max_2090_sf)
# we use that index to attach the nearest KBDI to each well
wells_kbdi_2090 <- wells_all %>% 
  dplyr::select(api_number) %>% 
  as_tibble() %>% 
  mutate(kbdi_max_2090_index = wells_kbdi_index_2090) %>% 
  mutate(kbdi_max_2090 = kbdi_max_2090_sf$kbdi_max_2090[kbdi_max_2090_index]) %>% 
  dplyr::select(-c(kbdi_max_2090_index, geometry)) %>% 
  filter(api_number != "0")


## finalization and export ---------------------------------------------------

rm(kbdi_max_2017_sf, kbdi_max_2050_sf, kbdi_max_2090_sf, study_region_sf)

# binds columns for max KBDI for each well and each time period
wells_kbdi <- wells_all %>% 
  filter(api_number != "0") %>% 
  as_tibble() %>% 
  left_join(wells_kbdi_2017, by = "api_number") %>% 
  left_join(wells_kbdi_2050, by = "api_number") %>% 
  left_join(wells_kbdi_2090, by = "api_number")

# exports processed dataset
saveRDS(wells_kbdi, "data/processed/wells_kbdi.rds")


##============================================================================##