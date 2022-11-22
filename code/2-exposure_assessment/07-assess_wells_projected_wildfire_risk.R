##============================================================================##
## 2.07 - for each well, matches the KBDI wildfire risk values for the nearest
## terrestrial point for each of the three time periods: current (2017), 
## mid-century (2046-2054, called 2050 here for convenience) and end-century
## (2086-2094, called 2090 here)


## setup ---------------------------------------------------------------------
source("code/0-setup/01-setup.R")

# data prep ................................................................

# only need to run this once; un-comment and run if needed:
# study_region_sf <- st_read("data/raw/noaa/us_states/s_22mr22.shp") %>%
#   filter(STATE %in% c("WA", "OR", "CA", "ID", "NV", "AZ", "MT", "WY",
#                       "UT", "CO", "NM", "ND", "SD", "NE", "KS", "OK", "TX", 
#                        "IA", "MO", "AR", "LA")) %>%  # MN isn't working
#   st_make_valid() %>%
#   st_transform()
#   st_union() %>%
#   st_geometry()
# # exports processed data sine this step takes a minute
# saveRDS(study_region_sf, "data/interim/study_region_sf.rds")

## data input...............................................................
study_region_sf <- readRDS("data/interim/study_region_sf.rds")

## processing ----------------------------------------------------------------

# 2017


# 2050
kbdi_max_2050_sf <- readRDS("data/processed/kbdi_max_2050.rds") %>% 
  as_tibble() %>%
  st_as_sf(coords = c("x", "y"), crs = crs_nad83) %>% 
  st_intersection(study_region_sf)
plot(kbdi_max_2050_sf)
wells_sf <- readRDS("data/interim/enverus_wells.rds") %>% 
  filter(well_status %in% c("ABANDONED", "ACTIVE", "COMPLETED", 
                            "DRILLED", "DRILLING", "INACTIVE", 
                            "P&A"))


# 2090



###### OLD CODE ######
## California 
# 
# # preps data for this analysis
# ca_boundary <- us_states %>% filter(STATE == "CA") %>% st_geometry()
# ca_kbdi_high_2017 <- crop(raster_kbdi_high_2017, as(ca_boundary, "Spatial"))
# ca_wells <- readRDS("data/interim/enverus_wells.rds") %>%
#   filter(state == "CA") %>% 
#   filter(well_status %in% c("ABANDONED", "ACTIVE", "COMPLETED", 
#                             "DRILLED", "DRILLING", "INACTIVE", 
#                             "P&A"))
# 
# # visualizes the data
# plot(ca_boundary, bg = NA, axes = F)
# plot(st_geometry(ca_wells), pch = 4, col = alpha("gray", 0.9), add = T)
# plot(ca_kbdi_high_2017, col = alpha("red", 0.5), add = T)
# par(bty = "n")
# 
# # for each well point, extrats the value of the KBDI raster
# ca_wells_risky_2017 <- 
#   raster::extract(raster_kbdi_high_2017, as(ca_wells,"Spatial"))
# 
# # since we've set pixels with ≥ 600 KBDI a value of 1, all we need to do is take 
# # the sum of the resulting vector (removing NAs) to get the count of wells
# sum(ca_wells_risky_2017, na.rm = T)  # n = 100,083


## 2050

# for each well, gets index of nearest KBDI point
wells_kbdi_index <- 
  st_nearest_feature(wells_sf, kbdi_max_2050_sf)
# we use that index to attach the nearest KBDI to each well
wells_kbdi <- wells_sf %>% 
  as_tibble() %>% 
  mutate(kbdi_max_2050_index = wells_kbdi_index) %>% 
  mutate(kbdi_max_2050 = kbdi_max_2050_sf$kbdi_max_2050[kbdi_max_2050_index]) %>% 
  dplyr::select(-kbdi_max_2050_index)

#### toy example / proof of concept

# preps data for this analysis
kbdi_high_2050 <- crop(raster_kbdi_high_2050, as(ca_boundary, "Spatial"))
enverus_wells <- readRDS("data/interim/enverus_wells.rds") %>%
  filter(state == "CA") %>% 
  filter(well_status %in% c("ABANDONED", "ACTIVE", "COMPLETED", 
                            "DRILLED", "DRILLING", "INACTIVE", 
                            "P&A"))

# in stepwise fashion, converts KBDI data into sf object then a raster
w <- ca_wells %>% sample_n(100)
a <- kbdi_max_2050 %>% 
  as_tibble() %>%
  st_as_sf(coords = c("x", "y"), crs = CRS("+init=epsg:4269")) 
plot(a)
# for each well, gets index of nearest KBDI point
b <- st_nearest_feature(w, a)
# we use that index to attach the nearest KBDI to each well
c <- w %>% 
  as_tibble() %>% 
  dplyr::select(api_number) %>% 
  mutate(index = b) %>% 
  mutate(kbdi  = a$kbdi_max_2050[b])



##============================================================================##