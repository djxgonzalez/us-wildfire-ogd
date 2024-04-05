##============================================================================##
## makes Figure S1, showing the count of oil and gas wells located inside 
## wildfire burn areas by state

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
figure_s1 <- wells_wildfire_state_year %>%
  filter(state %!in% c("ID", "WA")) %>% 
  filter(year %in% c(1984:2019)) %>% 
  group_by(year, state) %>% 
  mutate(year = as.numeric(year)) %>% 
  summarize(n_wells = sum(n_wells)) %>% 
  ggplot(aes(year, n_wells)) +
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
ggsave(filename = "figure_s1.png", plot = figure_s1, device = "png",
       height = 5.6, width = 8.2, path = "output/figures/components/")

##============================================================================##