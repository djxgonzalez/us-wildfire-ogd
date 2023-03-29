##============================================================================##
## makes Figure S5, population exposed to oil and gas wells located in wildfire
## burn areas by state and year

## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")
library("lubridate")

pop_exposed_state_year <- read_csv("data/processed/pop_exposed_state_year.csv")

## manuscript figure ---------------------------------------------------------

# estimated total U.S. population within 1 km of oil and gas wells that were in 
# wildfire burn areas by state and year
figure_s5 <- pop_exposed_state_year %>% 
  group_by(year, state) %>% 
  summarize(pop_exposed_n = sum(pop_exposed_n)) %>% 
  ggplot(aes(year, pop_exposed_n))  +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, 
              color = "black", lwd = 0.3, linetype = "longdash", alpha = 0.3) +
  geom_point(size = 0.6) + 
  labs(x = "Year", y = "Population (n)") +
  theme_classic() +
  theme(legend.position = "none") +
  facet_wrap(~ state)
# exports figures
ggsave(filename = "figure_s5.png", plot = figure_s5, device = "png",
       height = 5.6, width = 8.2, path = "output/figures/components/")

##============================================================================##