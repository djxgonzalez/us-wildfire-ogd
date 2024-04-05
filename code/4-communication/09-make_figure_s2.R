##============================================================================##
## makes Figure S2, showing the count of people residing within 1 km of oil
## and gas wells located inside wildfire burn areas by state

## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")
library("lubridate")

# data input
pop_exposed_state_year <- 
  read_csv("data/processed/pop_exposed_state_year.csv")

## manuscript figure ---------------------------------------------------------

# figure s2 ................................................................
# total area burned by year
figure_s2 <- pop_exposed_state_year %>%
  filter(state %!in% c("ID", "WA")) %>% 
  filter(year %in% c(1984:2019)) %>% 
  group_by(year, state) %>% 
  mutate(year = as.numeric(year)) %>% 
  summarize(pop_exposed_n = sum(pop_exposed_n)) %>% 
  ggplot(aes(year, pop_exposed_n)) +
  geom_vline(aes(xintercept = 1990), lwd = 0.2, color = "gray") +
  geom_vline(aes(xintercept = 2000), lwd = 0.2, color = "gray") +
  geom_vline(aes(xintercept = 2010), lwd = 0.2, color = "gray") +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, 
              color = "black", lwd = 0.3, linetype = "longdash", alpha = 0.3) +
  geom_point(size = 0.6) + 
  labs(x = "Year", y = "Wells (n)") + 
  theme_classic() +
  theme(legend.position = "none") +
  facet_wrap(~ state, scales = "free_y")
# exports figures
ggsave(filename = "figure_s2.png", plot = figure_s2, device = "png",
       height = 5.6, width = 8.2, path = "output/figures/components/")

##============================================================================##