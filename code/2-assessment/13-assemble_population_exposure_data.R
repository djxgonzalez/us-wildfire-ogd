##============================================================================##
## 2.13 - assembles human exposure data


## setup ---------------------------------------------------------------------

# attaches packages we need for this script
source("code/0-setup/01-setup.R")

## assemble dataset ----------------------------------------------------------

# imports previously-generated dataset with all state-years and joins
# state-year exposure data
ar_pop_exposed <- 
  read_csv("data/processed/wells_wildfire_state_year.csv") %>% 
  filter(state == "AR") %>% 
  left_join(read_csv("output/results/ar_pop_exposed.csv"), by = c("state", "year"))
ca_pop_exposed <- 
  read_csv("data/processed/wells_wildfire_state_year.csv") %>% 
  filter(state == "CA") %>% 
  left_join(read_csv("output/results/ca_pop_exposed.csv"), by = c("state", "year"))
co_pop_exposed <- 
  read_csv("data/processed/wells_wildfire_state_year.csv") %>% 
  filter(state == "CO") %>% 
  left_join(read_csv("output/results/co_pop_exposed.csv"), by = c("state", "year"))
ks_pop_exposed <- 
  read_csv("data/processed/wells_wildfire_state_year.csv") %>% 
  filter(state == "KS") %>% 
  left_join(read_csv("output/results/ks_pop_exposed.csv"), by = c("state", "year"))
la_pop_exposed <- 
  read_csv("data/processed/wells_wildfire_state_year.csv") %>% 
  filter(state == "LA") %>% 
  left_join(read_csv("output/results/la_pop_exposed.csv"), by = c("state", "year"))
mt_pop_exposed <- 
  read_csv("data/processed/wells_wildfire_state_year.csv") %>% 
  filter(state == "MT") %>% 
  left_join(read_csv("output/results/mt_pop_exposed.csv"), by = c("state", "year"))
nd_pop_exposed <- 
  read_csv("data/processed/wells_wildfire_state_year.csv") %>% 
  filter(state == "ND") %>% 
  left_join(read_csv("output/results/nd_pop_exposed.csv"), by = c("state", "year"))
ne_pop_exposed <- 
  read_csv("data/processed/wells_wildfire_state_year.csv") %>% 
  filter(state == "NE") %>% 
  left_join(read_csv("output/results/ne_pop_exposed.csv"), by = c("state", "year"))
nm_pop_exposed <- 
  read_csv("data/processed/wells_wildfire_state_year.csv") %>% 
  filter(state == "NM") %>% 
  left_join(read_csv("output/results/nm_pop_exposed.csv"), by = c("state", "year"))
ok_pop_exposed <- 
  read_csv("data/processed/wells_wildfire_state_year.csv") %>% 
  filter(state == "OK") %>% 
  left_join(read_csv("output/results/ok_pop_exposed.csv"), by = c("state", "year"))
tx_pop_exposed <- 
  read_csv("data/processed/wells_wildfire_state_year.csv") %>% 
  filter(state == "TX") %>% 
  left_join(read_csv("output/results/tx_pop_exposed.csv"), by = c("state", "year"))
ut_pop_exposed <- 
  read_csv("data/processed/wells_wildfire_state_year.csv") %>% 
  filter(state == "UT") %>% 
  left_join(read_csv("output/results/ut_pop_exposed.csv"), by = c("state", "year"))
wy_pop_exposed <- 
  read_csv("data/processed/wells_wildfire_state_year.csv") %>% 
  filter(state == "WY") %>% 
  left_join(read_csv("output/results/wy_pop_exposed.csv"), by = c("state", "year"))


#  binds with state-year exposure data, binds rows, then replaces NAs with 0s
pop_exposed_state_year <- ar_pop_exposed %>% 
  bind_rows(ca_pop_exposed) %>% 
  bind_rows(co_pop_exposed) %>% 
  bind_rows(ks_pop_exposed) %>% 
  bind_rows(la_pop_exposed) %>% 
  bind_rows(mt_pop_exposed) %>% 
  bind_rows(nd_pop_exposed) %>% 
  bind_rows(ne_pop_exposed) %>% 
  bind_rows(nm_pop_exposed) %>% 
  bind_rows(ok_pop_exposed) %>% 
  # bind_rows(sd_pop_exposed) %>% 
  bind_rows(tx_pop_exposed) %>% 
  bind_rows(ut_pop_exposed) %>% 
  bind_rows(wy_pop_exposed) %>% 
  mutate(pop_exposed = replace_na(pop_exposed, 0)) %>% 
  filter(year %in% c(1984:2019)) %>% 
  rename("pop_exposed_n" = "pop_exposed") %>% 
  select(state, year, pop_exposed_n)

# exports data
write_csv(pop_exposed_state_year, "data/processed/pop_exposed_state_year.csv")

##============================================================================##