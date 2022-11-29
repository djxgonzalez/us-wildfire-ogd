##============================================================================##
## 1.03 - 

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
#wildfires_nifc$area = st_area(wildfires_nifc) # units unclear, need to sort out


# preps MTBS data ............................................................
# i.e., dataset on wildfires in all states that > 1,000 acres

wildfires_mtbs <- readRDS("data/raw/mtbs/wildfires_mtbs.rds") %>% 
  mutate(wildfire_id   = as.factor(Event_ID),
         wildfire_name = as.factor(Incid_Name),
         year          = as.numeric(Ig_Year),
         state         = as.factor(State_Name),
         data_source   = as.factor("MTBS")) %>% 
  select(wildfire_id:data_source, geometry)
#wildfires_mtbs$area = st_area(wildfires_mtbs) # units unclear, need to sort out


## finalize and export -------------------------------------------------------

# binds wildfires from the two datasets and adds additional data on size
wildfires_all <- bind_rows(wildfires_nifc, wildfires_mtbs)

# export
saveRDS(wildfires_all, "data/process/wildfires_all.rds")


##============================================================================##