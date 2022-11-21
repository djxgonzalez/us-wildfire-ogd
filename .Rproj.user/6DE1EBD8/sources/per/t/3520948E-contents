##============================================================================##
## 2.07 - 


## setup ---------------------------------------------------------------------

# attaches packages we need for this script
library("raster")
library("scales")
#library("terra")

# data input
raster_kbdi_high_2017 <- readRDS("data/processed/raster_high_kbdi_2017.rds")
us_states             <- st_read("data/raw/us_census/tl_2018_us_state.shp")


## California -------------------------------------------------------

# preps data for this analysis
ca_boundary <- us_states %>% filter(NAME == "California") %>% st_geometry()
ca_kbdi_high_2017 <- crop(raster_kbdi_high_2017, as(ca_boundary, "Spatial"))
ca_wells <- readRDS("data/interim/enverus_wells.rds") %>%
  filter(well_status %in% c("ABANDONED", "ACTIVE", "COMPLETED", 
                            "DRILLED", "DRILLING", "INACTIVE", 
                            "P&A"))
  filter(state == "CA")

# visualizes the data
plot(ca_boundary, bg = NA, axes = F)
plot(st_geometry(ca_wells), pch = 4, col = alpha("gray", 0.9), add = T)
plot(ca_kbdi_high_2017, col = alpha("red", 0.5), add = T)
par(bty = "n")

# for each well point, extrats the value of the KBDI raster
ca_wells_risky <- raster::extract(raster_kbdi_high_2017, as(ca_wells,"Spatial"))

# since we've set pixels with ≥ 600 KBDI a value of 1, all we need to do is take 
# the sum of the resulting vector (removing NAs) to get the count of wells
sum(ca_wells_risky, na.rm = T)  # n = 100,083

# removes datasets we don't need anymore
rm(ca_boundary, ca_kbdi_high_2017, ca_wells, ca_wells_risky)


## header 1 --------------------------------------------------------
## description




## header 2 --------------------------------------------------------
## description




##============================================================================##