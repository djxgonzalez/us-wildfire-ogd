##============================================================================##
## 1.03 - Inputs data on extent and timing of wildfires from two sources (NIFC 
## and MTBS), harmonizes them, and binds them into an all wildfires dataset

## setup ---------------------------------------------------------------------

# attaches packages we need for this script
source("code/0-setup/01-setup.R")

## data prep -----------------------------------------------------------------

# preps NIFC data  .........................................................
# i.e., dataset on wildfires in all states that were 2.5 - 1,000 acres
wildfires_nifc <- readRDS("data/raw/nifc/nifc_wildfires_1000acre.rds") %>% 
  as_tibble() %>% 
  st_as_sf() %>% 
  mutate(wildfire_id   = as.factor(OBJECTID),
         wildfire_name = as.factor(INCIDENT),
         year          = as.numeric(FIRE_YEAR),
         state         = as.factor(STUSPS10),
         data_source   = as.factor("NIFC")) %>% 
  rename(geometry = SHAPE) %>% 
  select(wildfire_id:data_source, geometry)
#wildfires_mtbs$area = st_area(wildfires_mtbs) # units unclear, need to sort out

# preps MTBS data ............................................................
# i.e., dataset on wildfires in all states that > 1,000 acres
wildfires_mtbs <- readRDS("data/raw/mtbs/wildfires_mtbs.rds") %>% 
  mutate(wildfire_id   = as.factor(Event_ID),
         wildfire_name = as.factor(Incid_Name),
         year          = as.numeric(Ig_Year),
         state         = as.factor(State_Name),
         data_source   = as.factor("MTBS")) %>% 
  select(wildfire_id:data_source, geometry)

## finalize and export -------------------------------------------------------

# identify wildfire duplicates that are present in both the MTBS and NIFC data
wildfires_all <- bind_rows(wildfires_nifc, wildfires_mtbs)
wildfires_duplicated_ids <- 
  wildfires_all[duplicated(wildfires_all$wildfire_id), 1] %>% 
  as_tibble() %>% 
  select(wildfire_id)
# removes duplicates from the NIFC dataset
wildfires_nifc2 <- wildfires_nifc %>% 
  as_tibble() %>% 
  filter(wildfire_id %!in% wildfires_duplicated_ids$wildfire_id) %>% 
  st_as_sf()
# retains wildfires that are duplicated only within the NIFC dataset, i.e.,
# wildfires that cross state boundaries
wildfires_nifc3 <-  # set of wildfire_id's for fires that cross state boundaries
  wildfires_nifc[duplicated(wildfires_nifc$wildfire_id), 1] %>% 
  filter(wildfire_id %!in% wildfires_mtbs$wildfire_id)
# set of wildfires < 1,000 acres not present in MTBS dataset that cross
# state boundaries
wildfires_nifc4 <- wildfires_nifc %>% 
  filter(wildfire_id %in% wildfires_nifc3$wildfire_id)
# removes datasets we no longer need
rm(wildfires_all, wildfires_duplicated_ids, wildfires_nifc, wildfires_nifc3) 
# binds wildfires from the two datasets and adds additional data on size
wildfires_all <- bind_rows(wildfires_nifc2, wildfires_mtbs) %>% 
  # adds wildfires < 1,000 acres that cross state boundaries
  bind_rows(wildfires_nifc4) %>% 
  # restricts to wildfires in the study region
  filter(state %in% c("WA", "OR", "CA", "ID", "NV", "AZ", "MT", "WY", "UT", 
                      "CO", "NM", "ND", "SD", "NE", "KS", "OK", "TX", "MO", 
                      "AR", "LA", "AK")) %>% 
  drop_na(year) %>% 
  filter(year %in% c(1984:2020)) %>% 
  st_as_sf() %>% 
  st_transform(crs_albers)
# adds column with wildfire area in m^2
wildfires_all <- wildfires_all %>% 
  mutate(wildfire_area_km2 = st_area()) %>% 
  as_tibble()

# exports final wildfires dataset
saveRDS(wildfires_all, "data/processed/wildfires_all.rds")

#=============================================================================##