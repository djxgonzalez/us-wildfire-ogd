##============================================================================##
## makes Table S6, count and percentage of wells on federal land with KBDI ≥ 450

## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")
library("lubridate")

wells_kbdi <- readRDS("data/processed/wells_kbdi.rds")

## makes table ---------------------------------------------------------------

# makes table elements, one column at a time
table_s6a <- wells_kbdi %>% group_by(state) %>% summarize(wells_all_n = n())
table_s6b <- wells_kbdi %>% 
  filter(well_on_federal_land == 1) %>% 
  group_by(state) %>% 
  summarize(wells_fed_land_n = n())
table_s6c <- wells_kbdi %>% 
  filter(well_on_federal_land == 1) %>% 
  filter(kbdi_max_2017 >= 450) %>% 
  group_by(state) %>% 
  summarize(wells_fed_land_n_kbdi450_2017 = n())
table_s6d <- wells_kbdi %>% 
  filter(well_on_federal_land == 1) %>% 
  filter(kbdi_max_2050 >= 450) %>% 
  group_by(state) %>% 
  summarize(wells_fed_land_n_kbdi450_2050 = n())
table_s6e <- wells_kbdi %>% 
  filter(well_on_federal_land == 1) %>% 
  filter(kbdi_max_2090 >= 450) %>% 
  group_by(state) %>% 
  summarize(wells_fed_land_n_kbdi450_2090 = n())

# assembles table columns
table_s6 <- table_s6a %>% 
  left_join(table_s6b, by = "state") %>% 
  left_join(table_s6c, by = "state") %>% 
  left_join(table_s6d, by = "state") %>% 
  left_join(table_s6e, by = "state") %>% 
  mutate(wells_fed_land_n = replace_na(wells_fed_land_n, 0),
         wells_fed_land_n_kbdi450_2017 = 
           replace_na(wells_fed_land_n_kbdi450_2017, 0),
         wells_fed_land_n_kbdi450_2050 = 
           replace_na(wells_fed_land_n_kbdi450_2050, 0),
         wells_fed_land_n_kbdi450_2090 = 
           replace_na(wells_fed_land_n_kbdi450_2090, 0))

# exports table
write_csv(table_s6, "output/tables/table_s6.csv")

##============================================================================##