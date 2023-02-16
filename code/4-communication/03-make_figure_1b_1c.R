##============================================================================##
## makes Figure 1b and 1c, describing the total area burned and the cumulative
## number of oil and gas wells by year for the study period, 1984-2020

## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")
library("lubridate")
# library("units")  # I don't think we need this package

# data input
wells_all <- readRDS("data/processed/wells_all.rds")
wildfires_wells_population <- 
  readRDS("data/processed/wildfires_wells_population.rds")


## manuscript figure ---------------------------------------------------------

# figure 1b ................................................................
# total area burned by year
figure_1b <- wildfires_wells_population %>%
  filter(year %in% c(1984:2019)) %>% 
  mutate(year = as.factor(year),
         wildfire_area_km2 = (as.numeric(wildfire_area_m2) / 1000000)) %>%  
  group_by(year) %>% 
  summarize(area_burned_km2 = sum(wildfire_area_km2)) %>% 
  ggplot() +
  geom_bar(aes(year, area_burned_km2), stat = "identity") + 
  labs(x = "", y = "") + 
  theme_classic() +
  theme(axis.line.x  = element_blank(),  # removes x-axis
        axis.ticks.x = element_blank(),
        axis.text.x  = element_blank(),axis.text.y  = element_blank(),
        legend.position = "none")
# exports figures
ggsave(filename = "figure_1b.png", plot = figure_1b, device = "png",
       height = 2.5, width = 10, path = "output/figures/components/")

# figure 1c ................................................................
# count of oil and gas wells in wildfire burn areas by year

# preps data
data_1c <- wells_all %>% 
  as_tibble() %>% 
  mutate(date_earliest = replace_na(date_earliest, as.Date("1900-01-01"))) %>%
  select(date_earliest) %>%  
  mutate(year = year(date_earliest)) %>% 
  group_by(year) %>% 
  summarize(n_wells = n()) %>% 
  mutate(n_wells_cumulative = cumsum(n_wells)) %>% 
  filter(year %in% c(1984:2019)) %>% 
  mutate(year = as.factor(year))

# makes figure
figure_1c <- data_1c %>% 
  ggplot()  +
  geom_bar(aes(year, n_wells_cumulative), stat = "identity") + 
  labs(x = "", y = "") + 
  theme_classic() +
  theme(axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        legend.position = "none")
# exports figures
ggsave(filename = "figure_1c.png", plot = figure_1c, device = "png",
       height = 2.667, width = 10, path = "output/figures/components/")

##============================================================================##