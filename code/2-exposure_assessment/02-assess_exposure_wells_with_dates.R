##============================================================================##
## 2.04 - need to re-write this header

## setup ---------------------------------------------------------------------

# attaches functions .....................................................
library("parallel")  # for the `mclapply()` fxn
source("./code/2-exposure_assessment/02-fxn_assess_exposure_count.R")

# data input .............................................................
wells_all     <- readRDS("data/processed/wells_all.rds")
wildfires_all <- readRDS("data/processed/wildfires_all.rds")


## assessments by state ------------------------------------------------------

##### pick up here; maybe look at CA as model for this; edit line-by line
##### then expand to all states
##### change projections to (EPSG = 5070 for contiguous U.S., 3338 for AK)

# OK .......................................................................
wildfires_ok <- wildfires_all %>% filter(state == "OK")


## Oklahoma Wells
OK_buffer_fire <- fire_OK %>% st_union() %>% 
  st_transform(2267) %>% st_buffer(1000) %>% st_transform(crs_nad83) 
## Take all the fires in a state and melt them into 1 big blob. Then, buffer
## and transform as projected. 

wells_OK <- wells_all %>% st_intersection(OK_buffer_fire) %>% st_make_valid()  
#wells_OK <- wells_all %>% filter(State_Name == "OK") %>% st_make_valid()  
# Replace filter(state name) with st_intersection(Oklahoma all fires buffer 1 km)

# well buffers . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
wells_OK_buffer_1km <- wells_OK %>% 
  makeWellBuffer(radius = 1000, epsg = 2267)

# wells for counting . . . . . . . . . . . . . . . . . . . . . . . . . 

# removes data we don't need to improve efficiency
rm(wells_all)


##---------------------------------------------------------------------------
## Oklahoma all wells with dates

# 0 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
fire_data_in <- fire_OK %>%
  st_intersection(wells_OK_buffer_1km)
fire_data_in <- fire_data_in %>% filter(Event_ID %in% fire_data_in$Event_ID)  # verify Event_id
fire_data_in <- split(fire_data_in, seq(1, nrow(fire_data_in)))  # converts to list
fire_OK_exp_buffer <- 
  mclapply(fire_data_in,
           FUN          = assessExposureCount,
           wells        = wells_OK,
           buffer       = 0,  # in m; 0 or 1,000
           epsg         = 2267,
           exp_variable = "wells_ok_all_dates_0km")  # 0km is the buffer; for 1 use `_1km`
fire_OK_exp_buffer <- 
  do.call("rbind", fire_OK_exp_buffer) %>%  # converts from list
  mutate(state = as.factor("OK"))
saveRDS(fire_OK_exp_buffer,
        "../interim/fire_ok_all_dates_0km.rds")

# 1 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
fire_OK_exp_buffer1 <- 
  mclapply(fire_data_in,
           FUN          = assessExposureCount,
           wells        = wells_OK,
           buffer       = 1000,  # in m; 0 or 1,000
           epsg         = 2267,
           exp_variable = "wells_ok_all_dates_1km")  # 0km is the buffer; for 1 use `_1km`
fire_OK_exp_buffer1 <- 
  do.call("rbind", fire_OK_exp_buffer1) %>%  # converts from list
  mutate(state = as.factor("OK"))
saveRDS(fire_OK_exp_buffer1,
        "../interim/fire_ok_all_dates_1km.rds")
# between states, make sure to `rm()` data we don't need anymore


## California
CA_buffer_fire <- wildfires_all %>% 
  filter(State_Name == "CA") %>% st_make_valid() %>% 
  st_union() %>% st_transform(26911) %>% st_buffer(1000) %>% st_transform(crs_nad83) 

## Wells
wells_CA <- wells_all %>% st_intersection(CA_buffer_fire) %>% st_make_valid() 

## Buffered Wells
wells_CA_buffer_1km <- wells_CA %>% 
  makeWellBuffer(radius = 1000, epsg = 26911)

# 0 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
fire_data_in <- wildfires_all %>%
  filter(State_Name == "CA") %>% 
  st_intersection(wells_CA_buffer_1km)
fire_data_in <- fire_data_in %>% filter(Event_ID %in% fire_data_in$Event_ID)  # verify Event_id
fire_data_in <- split(fire_data_in, seq(1, nrow(fire_data_in)))  # converts to list
fire_CA_exp_buffer <- 
  mclapply(fire_data_in,
           FUN          = assessExposureCount,
           wells        = wells_CA,
           buffer       = 0,  # in m; 0 or 1,000
           epsg         = 26911,
           exp_variable = "wells_CA_all_dates_0km")  # 0km is the buffer; for 1 use `_1km`
fire_CA_exp_buffer <- 
  do.call("rbind", fire_CA_exp_buffer) %>%  # converts from list
  mutate(state = as.factor("CA"))
saveRDS(fire_CA_exp_buffer,
        "../interim/fire_CA_all_dates_0km.rds")

# 1 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
fire_CA_exp_buffer1 <- 
  mclapply(fire_data_in,
           FUN          = assessExposureCount,
           wells        = wells_CA,
           buffer       = 1000,  # in m; 0 or 1,000
           epsg         = 26911,
           exp_variable = "wells_CA_all_dates_1km")  # 0km is the buffer; for 1 use `_1km`
fire_CA_exp_buffer1 <- 
  do.call("rbind", fire_CA_exp_buffer1) %>%  # converts from list
  mutate(state = as.factor("CA"))
saveRDS(fire_CA_exp_buffer1,
        "../interim/fire_CA_all_dates_1km.rds")

##============================================================================##
## Texas
TX_buffer_fire <- wildfires_all %>% filter(State_Name == "TX") %>% st_make_valid() %>% 
  st_union() %>% st_transform(2267) %>% st_buffer(1000) %>% st_transform(crs_nad83) 

## Wells
wells_TX <- wells_all %>% st_intersection(TX_buffer_fire) %>% st_make_valid() 

## Buffered Wells
wells_TX_buffer_1km <- wells_TX %>% 
  makeWellBuffer(radius = 1000, epsg = 2267)

# 0 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
fire_data_in <- wildfires_all %>%
  filter(State_Name == "TX") %>% 
  st_intersection(wells_TX_buffer_1km)
fire_data_in <- fire_data_in %>% filter(Event_ID %in% fire_data_in$Event_ID)  # verify Event_id
fire_data_in <- split(fire_data_in, seq(1, nrow(fire_data_in)))  # converts to list
fire_TX_exp_buffer <- 
  mclapply(fire_data_in,
           FUN          = assessExposureCount,
           wells        = wells_TX,
           buffer       = 0,  # in m; 0 or 1,000
           epsg         = 2267,
           exp_variable = "wells_TX_all_dates_0km")  # 0km is the buffer; for 1 use `_1km`
fire_TX_exp_buffer <- 
  do.call("rbind", fire_TX_exp_buffer) %>%  # converts from list
  mutate(state = as.factor("TX"))
saveRDS(fire_TX_exp_buffer,
        "../interim/fire_TX_all_dates_0km.rds")

# 1 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
fire_TX_exp_buffer1 <- 
  mclapply(fire_data_in,
           FUN          = assessExposureCount,
           wells        = wells_TX,
           buffer       = 1000,  # in m; 0 or 1,000
           epsg         = 2267,
           exp_variable = "wells_TX_all_dates_1km")  # 0km is the buffer; for 1 use `_1km`
fire_TX_exp_buffer1 <- 
  do.call("rbind", fire_TX_exp_buffer1) %>%  # converts from list
  mutate(state = as.factor("TX"))
saveRDS(fire_TX_exp_buffer1,
        "../interim/fire_TX_all_dates_1km.rds")

##============================================================================##
## Colorado
CO_buffer_fire <- wildfires_all %>% filter(State_Name == "CO") %>% st_make_valid() %>% 
  st_union() %>% st_transform(2231) %>% st_buffer(1000) %>% st_transform(crs_nad83) 

## Wells
wells_CO <- wells_all %>% st_intersection(CO_buffer_fire) %>% st_make_valid() 

## Buffered Wells
wells_CO_buffer_1km <- wells_CO %>% 
  makeWellBuffer(radius = 1000, epsg = 2231)

# 0 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
fire_data_in <- wildfires_all %>%
  filter(State_Name == "CO") %>% 
  st_intersection(wells_CO_buffer_1km)
fire_data_in <- fire_data_in %>% filter(Event_ID %in% fire_data_in$Event_ID)  # verify Event_id
fire_data_in <- split(fire_data_in, seq(1, nrow(fire_data_in)))  # converts to list
fire_CO_exp_buffer <- 
  mclapply(fire_data_in,
           FUN          = assessExposureCount,
           wells        = wells_CO,
           buffer       = 0,  # in m; 0 or 1,000
           epsg         = 2231,
           exp_variable = "wells_CO_all_dates_0km")  # 0km is the buffer; for 1 use `_1km`
fire_CO_exp_buffer <- 
  do.call("rbind", fire_CO_exp_buffer) %>%  # converts from list
  mutate(state = as.factor("CO"))
saveRDS(fire_CO_exp_buffer,
        "../interim/fire_CO_all_dates_0km.rds")

# 1 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
fire_CO_exp_buffer1 <- 
  mclapply(fire_data_in,
           FUN          = assessExposureCount,
           wells        = wells_CO,
           buffer       = 1000,  # in m; 0 or 1,000
           epsg         = 2231,
           exp_variable = "wells_CO_all_dates_1km")  # 0km is the buffer; for 1 use `_1km`
fire_CO_exp_buffer1 <- 
  do.call("rbind", fire_CO_exp_buffer1) %>%  # converts from list
  mutate(state = as.factor("CO"))
saveRDS(fire_CO_exp_buffer1,
        "../interim/fire_CO_all_dates_1km.rds")

##============================================================================##
## Arizona
AZ_buffer_fire <- wildfires_all %>% filter(State_Name == "AZ") %>% st_make_valid() %>% 
  st_union() %>% st_transform(26712) %>% st_buffer(1000) %>% st_transform(crs_nad83) 

## Wells
wells_AZ <- wells_all %>% st_intersection(AZ_buffer_fire) %>% st_make_valid() 

## Buffered Wells
wells_AZ_buffer_1km <- wells_AZ %>% 
  makeWellBuffer(radius = 1000, epsg = 26712)

# 0 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
fire_data_in <- wildfires_all %>%
  filter(State_Name == "AZ") %>% 
  st_intersection(wells_AZ_buffer_1km)
fire_data_in <- fire_data_in %>% filter(Event_ID %in% fire_data_in$Event_ID)  # verify Event_id
fire_data_in <- split(fire_data_in, seq(1, nrow(fire_data_in)))  # converts to list
fire_AZ_exp_buffer <- 
  mclapply(fire_data_in,
           FUN          = assessExposureCount,
           wells        = wells_AZ,
           buffer       = 0,  # in m; 0 or 1,000
           epsg         = 26712,
           exp_variable = "wells_all_dates_0km")  # 0km is the buffer; for 1 use `_1km`
fire_AZ_exp_buffer <- 
  do.call("rbind", fire_AZ_exp_buffer) %>%  # converts from list
  mutate(state = as.factor("AZ"))
saveRDS(fire_AZ_exp_buffer,
        "../interim/fire_AZ_all_dates_0km.rds")

# 1 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
fire_AZ_exp_buffer1 <- 
  mclapply(fire_data_in,
           FUN          = assessExposureCount,
           wells        = wells_AZ,
           buffer       = 1000,  # in m; 0 or 1,000
           epsg         = 26712,
           exp_variable = "wells_all_dates_1km")  # 0km is the buffer; for 1 use `_1km`
fire_AZ_exp_buffer1 <- 
  do.call("rbind", fire_AZ_exp_buffer1) %>%  # converts from list
  mutate(state = as.factor("AZ"))
saveRDS(fire_AZ_exp_buffer1,
        "../interim/fire_AZ_all_dates_1km.rds")

##============================================================================##
## New Mexico
NM_buffer_fire <- wildfires_all %>% filter(State_Name == "NM") %>% st_make_valid() %>% 
  st_union() %>% st_transform(26715) %>% st_buffer(1000) %>% st_transform(crs_nad83) 

## Wells
wells_NM <- wells_all %>% st_intersection(NM_buffer_fire) %>% st_make_valid() 

## Buffered Wells
wells_NM_buffer_1km <- wells_NM %>% 
  makeWellBuffer(radius = 1000, epsg = 26715)

# 0 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
fire_data_in <- wildfires_all %>%
  filter(State_Name == "NM") %>% 
  st_intersection(wells_NM_buffer_1km)
fire_data_in <- fire_data_in %>% filter(Event_ID %in% fire_data_in$Event_ID)  # verify Event_id
fire_data_in <- split(fire_data_in, seq(1, nrow(fire_data_in)))  # converts to list
fire_NM_exp_buffer <- 
  mclapply(fire_data_in,
           FUN          = assessExposureCount,
           wells        = wells_NM,
           buffer       = 0,  # in m; 0 or 1,000
           epsg         = 26715,
           exp_variable = "wells_all_dates_0km")  # 0km is the buffer; for 1 use `_1km`
fire_NM_exp_buffer <- 
  do.call("rbind", fire_NM_exp_buffer) %>%  # converts from list
  mutate(state = as.factor("NM"))
saveRDS(fire_NM_exp_buffer,
        "../interim/fire_NM_all_dates_0km.rds")

# 1 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
fire_NM_exp_buffer1 <- 
  mclapply(fire_data_in,
           FUN          = assessExposureCount,
           wells        = wells_NM,
           buffer       = 1000,  # in m; 0 or 1,000
           epsg         = 26715,
           exp_variable = "wells_all_dates_1km")  # 0km is the buffer; for 1 use `_1km`
fire_NM_exp_buffer1 <- 
  do.call("rbind", fire_NM_exp_buffer1) %>%  # converts from list
  mutate(state = as.factor("NM"))
saveRDS(fire_NM_exp_buffer1,
        "../interim/fire_NM_all_dates_1km.rds")

##============================================================================##
## Utah
UT_buffer_fire <- wildfires_all %>% filter(State_Name == "UT") %>% st_make_valid() %>% 
  st_union() %>% st_transform(2281) %>% st_buffer(1000) %>% st_transform(crs_nad83) 

## Wells
wells_UT <- wells_all %>% st_intersection(UT_buffer_fire) %>% st_make_valid() 

## Buffered Wells
wells_UT_buffer_1km <- wells_UT %>% 
  makeWellBuffer(radius = 1000, epsg = 2281)

# 0 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
fire_data_in <- wildfires_all %>%
  filter(State_Name == "UT") %>% 
  st_intersection(wells_UT_buffer_1km)
fire_data_in <- fire_data_in %>% filter(Event_ID %in% fire_data_in$Event_ID)  # verify Event_id
fire_data_in <- split(fire_data_in, seq(1, nrow(fire_data_in)))  # converts to list
fire_UT_exp_buffer <- 
  mclapply(fire_data_in,
           FUN          = assessExposureCount,
           wells        = wells_UT,
           buffer       = 0,  # in m; 0 or 1,000
           epsg         = 2281,
           exp_variable = "wells_all_dates_0km")  # 0km is the buffer; for 1 use `_1km`
fire_UT_exp_buffer <- 
  do.call("rbind", fire_UT_exp_buffer) %>%  # converts from list
  mutate(state = as.factor("UT"))
saveRDS(fire_UT_exp_buffer,
        "../interim/fire_UT_all_dates_0km.rds")

# 1 km . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
fire_UT_exp_buffer1 <- 
  mclapply(fire_data_in,
           FUN          = assessExposureCount,
           wells        = wells_UT,
           buffer       = 1000,  # in m; 0 or 1,000
           epsg         = 2281,
           exp_variable = "wells_all_dates_1km")  # 0km is the buffer; for 1 use `_1km`
fire_UT_exp_buffer1 <- 
  do.call("rbind", fire_UT_exp_buffer1) %>%  # converts from list
  mutate(state = as.factor("UT"))
saveRDS(fire_UT_exp_buffer1,
        "../interim/fire_UT_all_dates_1km.rds")

##============================================================================##