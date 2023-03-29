##============================================================================##
## makes Figure 1b and 1c, describing the total area burned and the cumulative
## number of oil and gas wells by year for the study period, 1984-2020

## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")
library("lubridate")
# library("units")  # I don't think we need this package

# data input
wells_all <- readRDS("data/interim/wells_all.rds")
wells_individual_wildfires <- 
  read_csv("data/processed/wells_individual_wildfires.csv")
pop_exposed_state_year <- read_csv("data/processed/pop_exposed_state_year.csv")


## manuscript figure ---------------------------------------------------------

# figure 1b ................................................................
# total area burned by year
figure_1b <- wells_individual_wildfires %>%
  filter(year %in% c(1984:2019)) %>% 
  mutate(year = as.factor(year),
         wildfire_area_ha = (as.numeric(wildfire_area_m2) / 10000)) %>%  
  group_by(year) %>% 
  summarize(area_burned_ha = sum(wildfire_area_ha)) %>% 
  mutate(year = as.numeric(year)) %>% 
  ggplot(aes(year, area_burned_ha)) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "black", lwd = 0.3, linetype = "longdash", alpha = 0.3) +
  geom_point(size = 0.6) + 
  labs(x = "", y = "") + 
  theme_classic() +
  theme(axis.line.x  = element_blank(),  # removes x-axis
        axis.ticks.x = element_blank(),
        axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        legend.position = "none")
# exports figures
ggsave(filename = "figure_1b.png", plot = figure_1b, device = "png",
       height = 2.5, width = 10, path = "output/figures/components/")

# figure 1c ................................................................
# cumulative number of oil and gas wells in the study region by year, 1984–2019

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