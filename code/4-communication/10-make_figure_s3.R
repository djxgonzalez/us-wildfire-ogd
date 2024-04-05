##============================================================================##
## makes Figure S3, showing density of (a) population and (b) wells in areas
## where wildfires and wells intersected (1 km buffer around said wells)

## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")
library("lubridate")

# data input
pop_exposed_state_year <- read_csv("data/processed/pop_exposed_state_year.csv")

## manuscript figure ---------------------------------------------------------

# figure s3a ................................................................
# cumulative number of oil and gas wells in the study region by year, 1984–2019

# figure s3a ................................................................
# density of oil and gas wells in wildfire burn areas by year
figure_34a <- wells_wildfire_3tate_year %>% 
  filter(year %in% c(1984:2019)) %>% 
  filter(intersection_area_km2 > 0) %>% 
  group_by(year, state) %>%
  summarize(well_density = sum(n_wells) / sum(intersection_area_km2)) %>%
  ggplot(aes(year, well_density))  +
  geom_vline(aes(xintercept = 1990), lwd = 0.2, color = "gray") +
  geom_vline(aes(xintercept = 2000), lwd = 0.2, color = "gray") +
  geom_vline(aes(xintercept = 2010), lwd = 0.2, color = "gray") +
  geom_smooth(method = "glm", formula = y ~ x, se = FALSE,
              color = "black", lwd = 0.3, linetype = "longdash", alpha = 0.3) +
  geom_point(size = 0.6, alpha = 0.3) + 
  labs(x = "", y = "") + 
  theme_classic() +
  theme(axis.line.x  = element_blank(),  # removes x-axis
        axis.ticks.x = element_blank(),
        axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        legend.position = "none")
# exports figures
ggsave(filename = "figure_34a.png", plot = figure_34a, device = "png",
       height = 2.2, width = 4, path = "output/figures/components/")

# figure s3b ................................................................
# estimated total U.S. population within 1 km of oil and gas wells that were in 
# wildfire burn areas by year
figure_34b <- pop_exposed_state_year %>% 
  filter(intersection_area_km2 > 0) %>% 
  group_by(year, state) %>% 
  summarize(pop_density = (sum(pop_exposed_n) / sum(intersection_area_km2))) %>%
  ggplot(aes(year, pop_density))  +
  geom_vline(aes(xintercept = 1990), lwd = 0.2, color = "gray") +
  geom_vline(aes(xintercept = 2000), lwd = 0.2, color = "gray") +
  geom_vline(aes(xintercept = 2010), lwd = 0.2, color = "gray") +
  geom_smooth(method = "glm", formula = y ~ x, se = FALSE,
              color = "black", lwd = 0.3, linetype = "longdash", alpha = 0.3) +
  geom_point(size = 0.6, alpha = 0.3) + 
  labs(x = "", y = "") +
  theme_classic() +
  theme(axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        legend.position = "none")
# exports figures
ggsave(filename = "figure_34b.png", plot = figure_34b, device = "png",
       height = 2.4, width = 4, path = "output/figures/components/")

##============================================================================##