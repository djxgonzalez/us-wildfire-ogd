##============================================================================##
## 1.04 - imports NetCDF data from Brown et al. (2021) paper with projected
## wildfire risk in 2017, mid-century, and late century; combines data
## for spring+summer+fall seasons with max KBDI value for each; identifies
## wildfires in high risk areas (KBDI ≥ 600)

## setup ---------------------------------------------------------------------

# attaches packages we need for this script
library("ncdf4")
#library("graphics")
#library("usethis")
library("raster")
#library("tidync")


## 2017 (present) ------------------------------------------------------------
## note: for memory purposes, I suggest running this code for one time period
## at a time then clearing the R workspace in-between

# data input ...............................................................
latlon_2017 <- nc_open("data/raw/kbdi_wildfire_risk/KBDI/2017/PRISMlatlon.nc")
nc_spring_2017 <-
  nc_open("data/raw/kbdi_wildfire_risk/KBDI/2017/Mean_KBDI_Spring_2017.nc")
nc_summer_2017 <-
  nc_open("data/raw/kbdi_wildfire_risk/KBDI/2017/Mean_KBDI_Summer_2017.nc")
nc_fall_2017 <-
  nc_open("data/raw/kbdi_wildfire_risk/KBDI/2017/Mean_KBDI_Fall_2017.nc")

# data prep ................................................................

# gets necessary variables as numeric vectors

# latitude and longitude data common to all 2017 layers
lon_2017     <- ncvar_get(latlon_2017, "lon")
lat_2017     <- ncvar_get(latlon_2017, "lat")
lon_lat_2017 <- as.matrix(expand.grid(lon_2017, lat_2017))
rm(latlon_2017, lon_2017, lat_2017)

# KBDI data for spring 2017
kbdi_2017_spring      <- ncvar_get(nc_spring_2017, "KBDI")
fill_value            <- ncatt_get(nc_spring_2017, "KBDI", "_FillValue")
kbdi_2017_spring[kbdi_2017_spring == fill_value$value] <- NA
kbdi_2017_spring_long <- as.vector(kbdi_2017_spring)

# KBDI data for summer 2017
kbdi_2017_summer      <- ncvar_get(nc_summer_2017, "KBDI")
fill_value            <- ncatt_get(nc_summer_2017, "KBDI", "_FillValue")
kbdi_2017_summer[kbdi_2017_summer == fill_value$value] <- NA
kbdi_2017_summer_long <- as.vector(kbdi_2017_summer)

# KBDI data for fall 2017
kbdi_2017_fall      <- ncvar_get(nc_fall_2017, "KBDI")
fill_value          <- ncatt_get(nc_fall_2017, "KBDI", "_FillValue")
kbdi_2017_fall[kbdi_2017_fall == fill_value$value] <- NA
kbdi_2017_fall_long <- as.vector(kbdi_2017_fall)

# assembles all KBDI layers for 2017
kbdi_2017 <- data.frame(cbind(lon_lat_2017, kbdi_2017_spring_long,
                              kbdi_2017_summer_long, kbdi_2017_fall_long))
colnames(kbdi_2017) <- c("lon", "lat", "kbdi_spring", "kbdi_summer",
                         "kbdi_fall")

# finds max KBDI value for across the three seasons
kbdi_max_2017 <- kbdi_2017 %>%
  as_tibble() %>%
  dplyr::mutate(kbdi_max_2017 = pmax(kbdi_spring, kbdi_summer, kbdi_fall)) %>%
  dplyr::filter(kbdi_max_2017 > 0) %>%
  dplyr::select(lon, lat, kbdi_max_2017) %>%
  dplyr::rename(x = lon, y = lat) %>%
  as.data.frame()

saveRDS(kbdi_max_2017, "data/processed/kbdi_max_2017.rds")

# removes files we no longer need
rm(fill_value, kbdi_2017_fall, kbdi_2017_spring, kbdi_2017_summer, nc_fall_2017,
   kbdi_2017_spring_long, kbdi_2017_summer_long,
   nc_spring_2017, nc_summer_2017, kbdi_2017_fall_long, lon_lat_2017)

# converts raster with maximum 2017 KBDI to a raster for export
raster_kbdi_max_2017 <- 
  rasterFromXYZ(kbdi_max_2017,  crs = CRS("+init=epsg:4269")) %>% 
  st_transform(crs_albers)

# restricts raster to pixels with high KBDI, i.e., ≥ 600; makes this a binary
# indicator to set up for the next step, which is to intersect with wells
raster_kbdi_high_2017 <- raster_kbdi_max_2017
raster_kbdi_high_2017[raster_kbdi_high_2017$kbdi_max_2017 <  600] <- NA
raster_kbdi_high_2017[raster_kbdi_high_2017$kbdi_max_2017 >= 600] <- 1

# visualizes wildfire risk
plot(raster_kbdi_max_2017, col = viridis(n = 20, option = "inferno"))
# visualizes wildfire risk
plot(raster_kbdi_high_2017, col = "red")

# exports processed raster data ............................................
saveRDS(raster_kbdi_max_2017,  "data/processed/raster_max_kbdi_2017.rds")
saveRDS(raster_kbdi_high_2017, "data/processed/raster_high_kbdi_2017.rds")


## 2050 (mid-century) --------------------------------------------------------
## note: these estimates are for 2046-2054, but I use 2090 as short-hand

# data input ...............................................................
latlon_2050 <- nc_open("data/raw/kbdi_wildfire_risk/KBDI/MidCen/WRFlatlon.nc")
nc_spring_2050 <-
  nc_open("data/raw/kbdi_wildfire_risk/KBDI/MidCen/Mean_KBDI_Spring_2046-2054_R8Y4.nc")
nc_summer_2050 <-
  nc_open("data/raw/kbdi_wildfire_risk/KBDI/MidCen/Mean_KBDI_Summer_2046-2054_R8Y4.nc")
nc_fall_2050 <-
  nc_open("data/raw/kbdi_wildfire_risk/KBDI/MidCen/Mean_KBDI_Fall_2046-2054_R8Y4.nc")

# data prep ................................................................

# gets necessary variables as numeric vectors

# latitude and longitude data common to all 2050 layers
lon_2050     <- ncvar_get(latlon_2050, "lon") %>% as.vector()
lat_2050     <- ncvar_get(latlon_2050, "lat") %>% as.vector()
lon_lat_2050 <- bind_cols(lon_2050, lat_2050)
colnames(lon_lat_2050) <- c("lon", "lat")
lon_lat_2050 <- as.matrix(lon_lat_2050)
rm(latlon_2050)

# KBDI data for spring 2050
kbdi_2050_spring      <- ncvar_get(nc_spring_2050, "KBDI")
fill_value            <- ncatt_get(nc_spring_2050, "KBDI", "_FillValue")
kbdi_2050_spring[kbdi_2050_spring == fill_value$value] <- NA
kbdi_2050_spring_long <- as.vector(kbdi_2050_spring)

# KBDI data for summer 2050
kbdi_2050_summer      <- ncvar_get(nc_summer_2050, "KBDI")
fill_value            <- ncatt_get(nc_summer_2050, "KBDI", "_FillValue")
kbdi_2050_summer[kbdi_2050_summer == fill_value$value] <- NA
kbdi_2050_summer_long <- as.vector(kbdi_2050_summer)

# KBDI data for fall 2050
kbdi_2050_fall      <- ncvar_get(nc_fall_2050, "KBDI")
fill_value          <- ncatt_get(nc_fall_2050, "KBDI", "_FillValue")
kbdi_2050_fall[kbdi_2050_fall == fill_value$value] <- NA
kbdi_2050_fall_long <- as.vector(kbdi_2050_fall)

# assembles all KBDI layers for 2050
kbdi_2050 <- data.frame(cbind(lon_lat_2050, kbdi_2050_spring_long,
                              kbdi_2050_summer_long, kbdi_2050_fall_long))
colnames(kbdi_2050) <- c("lon", "lat", "kbdi_spring", "kbdi_summer",
                         "kbdi_fall")

# finds max KBDI value for across the three seasons
kbdi_max_2050 <- kbdi_2050 %>%
  as_tibble() %>%
  filter(lon >= -124.79 & lon <= -85) %>%  # or <= -66.96 for entire lower U.S.
  filter(lat >= 24.50 & lat <= 49.42) %>%
  dplyr::mutate(kbdi_max_2050 = pmax(kbdi_spring, kbdi_summer, kbdi_fall)) %>%
  dplyr::select(lon, lat, kbdi_max_2050) %>%
  dplyr::rename(x = lon, y = lat) %>%
  as.data.frame()

# removes files we no longer need
rm(fill_value, kbdi_2050_fall, kbdi_2050_spring, kbdi_2050_summer, nc_fall_2050,
   kbdi_2050_spring_long, kbdi_2050_summer_long,
   nc_spring_2050, nc_summer_2050, kbdi_2050_fall_long, lon_lat_2050)

# converts raster with maximum 2050 KBDI to a raster for export
kbdi_max_2050_extent <- extent(kbdi_max_2050[, (1:2)])
kbdi_max_2050_extent_raster <-
  raster(kbdi_max_2050_extent, 
         ncol = 362, nrow = 227,
         crs = "+init=epsg:4269 +proj=longlat +ellps=GRS80
                        +datum=NAD83 +no_defs +towgs84=0,0,0")
        #crs = CRS("+init=epsg:3310 +"))
        #ncol = 362, nrow = 227, crs = CRS("+init=epsg:4326"))
        #ncol = 362, nrow = 227, crs = CRS("+init=epsg:4269"))
raster_kbdi_max_2050 <- 
  rasterize(kbdi_max_2050[, 1:2], kbdi_max_2050_extent_raster,
            kbdi_max_2050[, 3], fun = max)

# restricts raster to pixels with high KBDI, i.e., ≥ 600; makes this a binary
# indicator to set up for the next step, which is to intersect with wells
raster_kbdi_high_2050 <- raster_kbdi_max_2050
raster_kbdi_high_2050[raster_kbdi_high_2050$layer <  600] <- NA
raster_kbdi_high_2050[raster_kbdi_high_2050$layer >= 600] <- 1

# visualizes wildfire risk
plot(raster_kbdi_max_2050, col = viridis(n = 20, option = "inferno"))
# visualizes wildfire risk
plot(raster_kbdi_high_2050, col = "red")

# exports processed raster data ............................................
saveRDS(raster_kbdi_max_2050,  "data/processed/raster_max_kbdi_2050.rds")
saveRDS(raster_kbdi_high_2050, "data/processed/raster_high_kbdi_2050.rds")


## 2090 (late-century) --------------------------------------------------------
## note: these estimates are for 2086-2094, but I use 2090 as short-hand

# data input ...............................................................
latlon_2090 <- nc_open("data/raw/kbdi_wildfire_risk/KBDI/EndCen/WRFlatlon.nc")
nc_spring_2090 <-
  nc_open("data/raw/kbdi_wildfire_risk/KBDI/EndCen/Mean_KBDI_Spring_2086-2094_R8Y8.nc")
nc_summer_2090 <-
  nc_open("data/raw/kbdi_wildfire_risk/KBDI/EndCen/Mean_KBDI_Summer_2086-2094_R8Y8.nc")
nc_fall_2090 <-
  nc_open("data/raw/kbdi_wildfire_risk/KBDI/EndCen/Mean_KBDI_Fall_2086-2094_R8Y8.nc")

# data prep ................................................................

# gets necessary variables as numeric vectors

# latitude and longitude data common to all 2090 layers
lon_2090     <- ncvar_get(latlon_2090, "lon") %>% as.vector()
lat_2090     <- ncvar_get(latlon_2090, "lat") %>% as.vector()
lon_lat_2090 <- bind_cols(lon_2090, lat_2090)
colnames(lon_lat_2090) <- c("lon", "lat")
lon_lat_2090 <- as.matrix(lon_lat_2090)
rm(latlon_2090, lon_2090, lat_2090)

# KBDI data for spring 2090
kbdi_2090_spring      <- ncvar_get(nc_spring_2090, "KBDI")
fill_value            <- ncatt_get(nc_spring_2090, "KBDI", "_FillValue")
kbdi_2090_spring[kbdi_2090_spring == fill_value$value] <- NA
kbdi_2090_spring_long <- as.vector(kbdi_2090_spring)

# KBDI data for summer 2090
kbdi_2090_summer      <- ncvar_get(nc_summer_2090, "KBDI")
fill_value            <- ncatt_get(nc_summer_2090, "KBDI", "_FillValue")
kbdi_2090_summer[kbdi_2090_summer == fill_value$value] <- NA
kbdi_2090_summer_long <- as.vector(kbdi_2090_summer)

# KBDI data for fall 2090
kbdi_2090_fall      <- ncvar_get(nc_fall_2090, "KBDI")
fill_value          <- ncatt_get(nc_fall_2090, "KBDI", "_FillValue")
kbdi_2090_fall[kbdi_2090_fall == fill_value$value] <- NA
kbdi_2090_fall_long <- as.vector(kbdi_2090_fall)

# assembles all KBDI layers for 2090
kbdi_2090 <- data.frame(cbind(lon_lat_2090, kbdi_2090_spring_long,
                              kbdi_2090_summer_long, kbdi_2090_fall_long))
colnames(kbdi_2090) <- c("lon", "lat", "kbdi_spring", "kbdi_summer",
                         "kbdi_fall")

# finds max KBDI value for across the three seasons
kbdi_max_2090 <- kbdi_2090 %>%
  as_tibble() %>%
  filter(lon >= -124.79 & lon <= -85) %>%  # or <= -66.96 for entire lower U.S.
  filter(lat >= 24.50 & lat <= 49.42) %>%
  dplyr::mutate(kbdi_max_2090 = pmax(kbdi_spring, kbdi_summer, kbdi_fall)) %>%
  dplyr::select(lon, lat, kbdi_max_2090) %>%
  dplyr::rename(x = lon, y = lat) %>%
  as.data.frame()

# exports dataset as datafrae
saveRDS(kbdi_max_2090, "data/processed/kbdi_max_2090.rds")

# removes files we no longer need
rm(fill_value, kbdi_2090_fall, kbdi_2090_spring, kbdi_2090_summer, nc_fall_2090,
   kbdi_2090_spring_long, kbdi_2090_summer_long,
   nc_spring_2090, nc_summer_2090, kbdi_2090_fall_long, lon_lat_2090)

# converts raster with maximum 2090 KBDI to a raster for export
kbdi_max_2090_extent <- extent(kbdi_max_2090[, (1:2)])
kbdi_max_2090_extent_raster <-
  raster(kbdi_max_2090_extent,
         ncol = 362, nrow = 227, crs = CRS("+init=epsg:4269"))
raster_kbdi_max_2090 <- 
  rasterize(kbdi_max_2090[, 1:2], kbdi_max_2090_extent_raster,
            kbdi_max_2090[, 3], fun = max)

# restricts raster to pixels with high KBDI, i.e., ≥ 600; makes this a binary
# indicator to set up for the next step, which is to intersect with wells
raster_kbdi_high_2090 <- raster_kbdi_max_2090
raster_kbdi_high_2090[raster_kbdi_high_2090$layer <  600] <- NA
raster_kbdi_high_2090[raster_kbdi_high_2090$layer >= 600] <- 1


# visualizes wildfire risk
plot(raster_kbdi_max_2090, col = viridis(n = 20, option = "inferno"))
# visualizes wildfire risk
plot(raster_kbdi_high_2090, col = "red")

# exports processed raster data ............................................
saveRDS(raster_kbdi_max_2090,  "data/processed/raster_max_kbdi_2090.rds")
saveRDS(raster_kbdi_high_2090, "data/processed/raster_high_kbdi_2090.rds")



##============================================================================##