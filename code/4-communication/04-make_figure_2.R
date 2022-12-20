##============================================================================##
## makes Figure 2 - ...

## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")
library("ggspatial")
library("lubridate")
library("units")

# data input
wildfires_wells_population <- 
  readRDS("data/processed/wildfires_wells_population.rds")


## manuscript figure ---------------------------------------------------------

# figure 2a ................................................................
# total area burned by year
figure_2a <- wildfires_wells_population %>%
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
        axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        legend.position = "none")
# exports figures
ggsave(filename = "figure_2a.png", plot = figure_2a, device = "png",
       height = 1.5, width = 6, path = "output/figures/components/")

# figure 2b ................................................................
# count of oil and gas wells in wildfire burn areas by year
figure_2b <- wildfires_wells_population %>% 
  group_by(year) %>% 
  summarize(n_wells = sum(n_wells)) %>% 
  ggplot()  +
  geom_bar(aes(year, n_wells), stat = "identity") + 
  labs(x = "", y = "") + 
  theme_classic() +
  theme(axis.line.x  = element_blank(),  # removes x-axis
        axis.ticks.x = element_blank(),
        axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        legend.position = "none")
# exports figures
ggsave(filename = "figure_2b.png", plot = figure_2b, device = "png",
       height = 1.5, width = 6, path = "output/figures/components/")

# figure 2c ................................................................
# estimated total U.S. population within 1 km of oil and gas wells that were in 
# wildfire burn areas by year.
figure_2c <- wildfires_wells_population %>% 
  filter(n_wells > 0) %>% 
  group_by(year) %>% 
  summarize(n = n()) %>% 
  ggplot()  +
  geom_bar(aes(year, n), stat = "identity") + 
  labs(x = "", y = "") + 
  theme_classic() +
  theme(axis.line.x  = element_blank(),  # removes x-axis
        axis.ticks.x = element_blank(),
        axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        legend.position = "none")
# exports figures
ggsave(filename = "figure_2c.png", plot = figure_2c, device = "png",
       height = 1.5, width = 6, path = "output/figures/components/")

##============================================================================##