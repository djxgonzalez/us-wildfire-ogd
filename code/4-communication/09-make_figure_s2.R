##============================================================================##
## makes Figure S2, showing the count of oil and gas wells located within 1 km 
## of wildfire burn areas

## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")
library("lubridate")

# data input
wells_wildfire_state_year <- 
  read_csv("data/processed/wells_wildfire_state_year.csv")

## manuscript figure ---------------------------------------------------------

# figure s1 ................................................................
# total area burned by year
figure_s2 <- wells_wildfire_state_year %>%
  filter(state %!in% c("ID", "WA")) %>% 
  filter(year %in% c(1984:2019)) %>% 
  group_by(year) %>% 
  mutate(year = as.numeric(year)) %>% 
  summarize(n_wells_buffer_1km = sum(n_wells_buffer_1km)) %>% 
  ggplot(aes(year, n_wells_buffer_1km)) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, 
              color = "black", lwd = 0.3, linetype = "longdash", alpha = 0.3) +
  geom_point(size = 0.6) + 
  labs(x = "Year", y = "Wells (n)") + 
  theme_classic() +
  theme(legend.position = "none")
# exports figures
ggsave(filename = "figure_s2.png", plot = figure_s2, device = "png",
       height = 5, width = 6, path = "output/figures/components/")

##============================================================================##