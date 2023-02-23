##============================================================================##
## 2.04 - Sets up and runs assessment, for all states included in study, of
## the count of wells in wildfires, excluding wells known to have been drilled
## after the wildfire occurred and omitting wells that don't have any 
## operational dates. This is nearly identical to script 2.03, but we 
## drop wells that have no operation dates in the data input step.

## setup ---------------------------------------------------------------------

# attaches functions .....................................................
source("code/0-setup/01-setup.R")
source("code/2-assessment/01-fxn-count_wells_in_wildfires.R")
library("parallel")   # for the `mclapply()` fxn, if using MacOS
library("lubridate")  # for `Year()` fxn

# data input .............................................................
wells_with_dates <- readRDS("data/interim/wells_all.rds") %>% 
  drop_na(date_earliest) %>% 
  st_as_sf()
wildfires_all <- readRDS("data/interim/wildfires_all.rds")


## assessments by state ======================================================

# AK -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "AK") %>% 
  st_as_sf() %>%
  st_transform(crs_alaska) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_ak_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "AK") %>% 
  st_intersection(
    st_make_valid(
      readRDS("data/interim/wildfires_buffers/wildfires_ak_buffer_1km.rds"))) %>% 
  st_transform(crs_alaska)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_ak <- 
  lapply(wildfires_in,  # if not using MacOS, use `lapply()` instead
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_ak <- 
  do.call("rbind", wildfires_wells_dates_ak)  # converts from list
write_csv(wildfires_wells_dates_ak, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_ak.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_ak_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_ak_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_ak_buffer_1km)
write_csv(wildfires_wells_dates_ak_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_ak_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_ak, 
   wildfires_wells_dates_ak_buffer_1km)


# AR -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "AR") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_ar_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "AR") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_ar_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_ar <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_ar <- 
  do.call("rbind", wildfires_wells_dates_ar)  # converts from list
write_csv(wildfires_wells_dates_ar, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_ar.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_ar_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_ar_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_ar_buffer_1km)
write_csv(wildfires_wells_dates_ar_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_ar_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_ar, 
   wildfires_wells_dates_ar_buffer_1km)


# AZ -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "AZ") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_az_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "AZ") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_az_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_az <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_az <- 
  do.call("rbind", wildfires_wells_dates_az)  # converts from list
write_csv(wildfires_wells_dates_az, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_az.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_az_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_az_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_az_buffer_1km)
write_csv(wildfires_wells_dates_az_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_az_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_az, 
   wildfires_wells_dates_az_buffer_1km)


# CA -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "CA") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_ca_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "CA") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_ca_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_ca <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_ca <- 
  do.call("rbind", wildfires_wells_dates_ca)  # converts from list
write_csv(wildfires_wells_dates_ca, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_ca.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_ca_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_ca_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_ca_buffer_1km)
write_csv(wildfires_wells_dates_ca_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_ca_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_ca, 
   wildfires_wells_dates_ca_buffer_1km)


# CO -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "CO") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_co_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "CO") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_co_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_co <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_co <- 
  do.call("rbind", wildfires_wells_dates_co)  # converts from list
write_csv(wildfires_wells_dates_co, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_co.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_co_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_co_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_co_buffer_1km)
write_csv(wildfires_wells_dates_co_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_co_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_co, 
   wildfires_wells_dates_co_buffer_1km)


# KS -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "KS") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_ks_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "KS") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_ks_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_ks <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_ks <- 
  do.call("rbind", wildfires_wells_dates_ks)  # converts from list
write_csv(wildfires_wells_dates_ks, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_ks.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_ks_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_ks_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_ks_buffer_1km)
write_csv(wildfires_wells_dates_ks_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_ks_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_ks, 
   wildfires_wells_dates_ks_buffer_1km)


# LA -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "LA") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_la_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "LA") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_la_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_la <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_la <- 
  do.call("rbind", wildfires_wells_dates_la)  # converts from list
write_csv(wildfires_wells_dates_la, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_la.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_la_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_la_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_la_buffer_1km)
write_csv(wildfires_wells_dates_la_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_la_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_la, 
   wildfires_wells_dates_la_buffer_1km)


# MO -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "MO") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_mo_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "MO") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_mo_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_mo <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_mo <- 
  do.call("rbind", wildfires_wells_dates_mo)  # converts from list
write_csv(wildfires_wells_dates_mo, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_mo.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_mo_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_mo_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_mo_buffer_1km)
write_csv(wildfires_wells_dates_mo_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_mo_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_mo, 
   wildfires_wells_dates_mo_buffer_1km)


# MT -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "MT") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_mt_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "MT") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_mt_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_mt <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_mt <- 
  do.call("rbind", wildfires_wells_dates_mt)  # converts from list
write_csv(wildfires_wells_dates_mt, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_mt.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_mt_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_mt_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_mt_buffer_1km)
write_csv(wildfires_wells_dates_mt_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_mt_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_mt, 
   wildfires_wells_dates_mt_buffer_1km)


# ND -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "ND") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_nd_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "ND") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_nd_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_nd <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_nd <- 
  do.call("rbind", wildfires_wells_dates_nd)  # converts from list
write_csv(wildfires_wells_dates_nd, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_nd.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_nd_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_nd_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_nd_buffer_1km)
write_csv(wildfires_wells_dates_nd_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_nd_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_nd, 
   wildfires_wells_dates_nd_buffer_1km)


# NE -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "NE") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_ne_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "NE") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_ne_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_ne <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_ne <- 
  do.call("rbind", wildfires_wells_dates_ne)  # converts from list
write_csv(wildfires_wells_dates_ne, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_ne.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_ne_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_ne_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_ne_buffer_1km)
write_csv(wildfires_wells_dates_ne_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_ne_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_ne, 
   wildfires_wells_dates_ne_buffer_1km)


# NM -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "NM") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_nm_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "NM") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_nm_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_nm <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_nm <- 
  do.call("rbind", wildfires_wells_dates_nm)  # converts from list
write_csv(wildfires_wells_dates_nm, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_nm.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_nm_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_nm_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_nm_buffer_1km)
write_csv(wildfires_wells_dates_nm_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_nm_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_nm, 
   wildfires_wells_dates_nm_buffer_1km)


# NV -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "NV") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_nv_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "NV") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_nv_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_nv <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_nv <- 
  do.call("rbind", wildfires_wells_dates_nv)  # converts from list
write_csv(wildfires_wells_dates_nv, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_nv.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_nv_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_nv_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_nv_buffer_1km)
write_csv(wildfires_wells_dates_nv_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_nv_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_nv, 
   wildfires_wells_dates_nv_buffer_1km)


# OK -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "OK") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_ok_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "OK") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_ok_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_ok <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_ok <- 
  do.call("rbind", wildfires_wells_dates_ok)  # converts from list
write_csv(wildfires_wells_dates_ok, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_ok.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_ok_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_ok_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_ok_buffer_1km)
write_csv(wildfires_wells_dates_ok_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_ok_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_ok, 
   wildfires_wells_dates_ok_buffer_1km)


# OR -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "OR") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_or_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "OR") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_or_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_or <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_or <- 
  do.call("rbind", wildfires_wells_dates_or)  # converts from list
write_csv(wildfires_wells_dates_or, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_or.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_or_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_or_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_or_buffer_1km)
write_csv(wildfires_wells_dates_or_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_or_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_or, 
   wildfires_wells_dates_or_buffer_1km)


# SD -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "SD") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_sd_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "SD") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_sd_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_sd <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_sd <- 
  do.call("rbind", wildfires_wells_dates_sd)  # converts from list
write_csv(wildfires_wells_dates_sd, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_sd.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_sd_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_sd_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_sd_buffer_1km)
write_csv(wildfires_wells_dates_sd_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_sd_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_sd, 
   wildfires_wells_dates_sd_buffer_1km)


# TX -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "TX") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_tx_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "TX") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_tx_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_tx <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_tx <- 
  do.call("rbind", wildfires_wells_dates_tx)  # converts from list
write_csv(wildfires_wells_dates_tx, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_tx.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_tx_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_tx_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_tx_buffer_1km)
write_csv(wildfires_wells_dates_tx_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_tx_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_tx, 
   wildfires_wells_dates_tx_buffer_1km)


# UT -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "UT") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_ut_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "UT") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_ut_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_ut <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_ut <- 
  do.call("rbind", wildfires_wells_dates_ut)  # converts from list
write_csv(wildfires_wells_dates_ut, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_ut.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_ut_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_ut_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_ut_buffer_1km)
write_csv(wildfires_wells_dates_ut_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_ut_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_ut, 
   wildfires_wells_dates_ut_buffer_1km)


# WY -----------------------------------------------------------------------

# data prep ..............................................................

# restricts to wildfires near wells (i.e., intersect with 1 km well buffer)
wildfires_in <- wildfires_all %>%
  filter(state == "WY") %>% 
  st_as_sf() %>%
  st_transform(crs_albers) %>% 
  st_intersection(readRDS("data/interim/wells_buffers/wells_wy_buffer_1km.rds"))
wildfires_in <- split(wildfires_in, seq(1, nrow(wildfires_in))) #converts to list
# restricts to wells near wildfires (i.e., w/in 1 km of wildfire boundaries)
wells_in <- wells_with_dates %>% 
  filter(state == "WY") %>% 
  st_intersection(
    readRDS("data/interim/wildfires_buffers/wildfires_wy_buffer_1km.rds")) %>% 
  st_transform(crs_albers)

# wells inside wildfire boundary  . . . . . . . . . . . . . . . . . . .
wildfires_wells_dates_wy <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer_dist  = 0,  # in meters
         exp_variable = "n_wells") 
wildfires_wells_dates_wy <- 
  do.call("rbind", wildfires_wells_dates_wy)  # converts from list
write_csv(wildfires_wells_dates_wy, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_wy.csv")

# wells w/in 1km of wildfire boundary  . . . . . . . . . . . . . . . . 
wildfires_wells_dates_wy_buffer_1km <- 
  lapply(wildfires_in,
         FUN          = assessExposureCount,
         wells        = wells_in,
         buffer       = 1000,  # in meters
         exp_variable = "n_wells_buffer_1km") 
wildfires_wells_dates_wy_buffer_1km <- 
  do.call("rbind", wildfires_wells_dates_wy_buffer_1km)
write_csv(wildfires_wells_dates_wy_buffer_1km, 
          "data/processed/wildfires_wells_dates/wildfires_wells_dates_wy_buffer_1km.csv")

# removes datasets before moving on to the next state
rm(wildfires_in, wells_in, wildfires_wells_dates_wy, 
   wildfires_wells_dates_wy_buffer_1km)

##============================================================================##

