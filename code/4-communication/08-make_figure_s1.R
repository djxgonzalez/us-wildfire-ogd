##============================================================================##
## makes Figure S1, showing the total wildfire area burned by state

## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")
library("lubridate")

# data input
wells_individual_wildfires <- 
  read_csv("data/processed/wells_individual_wildfires.csv")

## manuscript figure ---------------------------------------------------------

# figure s1 ................................................................
# total area burned by year
figure_s1 <- wells_individual_wildfires %>%
  filter(state %!in% c("ID", "WA")) %>% 
  filter(year %in% c(1984:2019)) %>% 
  mutate(wildfire_area_ha = (as.numeric(wildfire_area_m2) / 10000)) %>%  
  group_by(year, state) %>% 
  mutate(year = as.numeric(year)) %>% 
  summarize(area_burned_ha = sum(wildfire_area_ha)) %>% 
  ggplot(aes(year, area_burned_ha)) +
  geom_smooth(method = "lm", formula = y ~ x,  se = FALSE,
              color = "black", lwd = 0.3, linetype = "longdash", alpha = 0.3) +
  geom_point(size = 0.6) + 
  labs(x = "Year", y = "Wildfire burn area (ha)") + 
  theme_classic() +
  theme(legend.position = "none") +
  facet_wrap(~ state)
# exports figures
ggsave(filename = "figure_s1.png", plot = figure_s1, device = "png",
       height = 5.6, width = 8.2, path = "output/figures/components/")

##============================================================================##