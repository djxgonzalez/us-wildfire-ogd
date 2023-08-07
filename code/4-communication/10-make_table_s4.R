##============================================================================##
## makes Table S4, count and percentage of wells on federal land with KBDI ≥ 600

## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")
library("lubridate")

wells_kbdi <- readRDS("data/processed/wells_kbdi.rds")

## makes table ---------------------------------------------------------------

# makes table elements, one column at a time
table_s4a <- wells_kbdi %>% group_by(state) %>% summarize(wells_all_n = n())
table_s4b <- wells_kbdi %>% 
  filter(well_on_federal_land == 1) %>% 
  group_by(state) %>% 
  summarize(wells_fed_land_n = n())
table_s4c <- wells_kbdi %>% 
  filter(well_on_federal_land == 1) %>% 
  filter(kbdi_max_2017 >= 600) %>% 
  group_by(state) %>% 
  summarize(wells_fed_land_n_kbdi600_2017 = n())
table_s4d <- wells_kbdi %>% 
  filter(well_on_federal_land == 1) %>% 
  filter(kbdi_max_2050 >= 600) %>% 
  group_by(state) %>% 
  summarize(wells_fed_land_n_kbdi600_2050 = n())
table_s4e <- wells_kbdi %>% 
  filter(well_on_federal_land == 1) %>% 
  filter(kbdi_max_2090 >= 600) %>% 
  group_by(state) %>% 
  summarize(wells_fed_land_n_kbdi600_2090 = n())

# assembles table columns
table_s4 <- table_s4a %>% 
  left_join(table_s4b, by = "state") %>% 
  left_join(table_s4c, by = "state") %>% 
  left_join(table_s4d, by = "state") %>% 
  left_join(table_s4e, by = "state") %>% 
  mutate(wells_fed_land_n = replace_na(wells_fed_land_n, 0),
         wells_fed_land_n_kbdi600_2017 = 
           replace_na(wells_fed_land_n_kbdi600_2017, 0),
         wells_fed_land_n_kbdi600_2050 = 
           replace_na(wells_fed_land_n_kbdi600_2050, 0),
         wells_fed_land_n_kbdi600_2090 = 
           replace_na(wells_fed_land_n_kbdi600_2090, 0))

# exports table
write_csv(table_s4, "output/tables/table_s4.csv")

##============================================================================##