##============================================================================##
## makes Figure 0, the visual abstract, showing the headline results

## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")
library("viridis")

# data input
wildfires_area_year <- 
  read_csv("data/processed/wells_individual_wildfires.csv") %>%
  filter(year %in% c(1984:2019)) %>% 
  mutate(wildfire_area_ha = (as.numeric(wildfire_area_m2) / 10000)) %>%  
  group_by(year) %>% 
  summarize(area_burned_ha = sum(wildfire_area_ha)) %>% 
  mutate(area_burned_ha = area_burned_ha / max(area_burned_ha))
wells_wildfires_year <-
  read_csv("data/processed/wells_wildfire_state_year.csv") %>% 
  filter(year %in% c(1984:2019)) %>% 
  group_by(year) %>% 
  summarize(n_wells = sum(n_wells)) %>% 
  mutate(n_wells = (n_wells / max(n_wells)) * 2.5 + 0.15)
pop_exposed_year <- 
  read_csv("data/processed/pop_exposed_state_year.csv") %>% 
  group_by(year) %>% 
  summarize(pop_exposed_n = sum(pop_exposed_n)) %>% 
  mutate(pop_exposed_n = (pop_exposed_n / max(pop_exposed_n)) * 2.5)
wells_kbdi <- readRDS("data/processed/wells_kbdi.rds")


## makes figure components ---------------------------------------------------

# figure 0a ................................................................
# count of oil and gas wells in wildfire burn areas by year
figure_0a <-
  ggplot()  +
  geom_vline(aes(xintercept = 1990), lwd = 0.2, color = "gray") +
  geom_vline(aes(xintercept = 2000), lwd = 0.2, color = "gray") +
  geom_vline(aes(xintercept = 2010), lwd = 0.2, color = "gray") +
  geom_bar(data = wildfires_area_year, aes(year, area_burned_ha), 
           stat = "identity", fill = "red", alpha = 0.2) +
  # geom_smooth(data = wildfires_area_year, aes(year, area_burned_ha),
  #             method = "lm", formula = y ~ x, se = FALSE,
  #             color = "red", lwd = 0.6, alpha = 0.3) +
  geom_smooth(data = wells_wildfires_year, aes(year, n_wells), 
              method = "lm", formula = y ~ x, se = FALSE, 
              color = "black", lwd = 0.8, alpha = 0.3) +
  geom_smooth(data = pop_exposed_year, aes(year, pop_exposed_n), 
              method = "lm", formula = y ~ x, se = FALSE, 
              color = "black", linetype = "dashed", lwd = 0.8, alpha = 0.3) +
  labs(x = "", y = "") + 
  theme_classic() +
  theme(axis.text.y  = element_blank(),
        axis.line.y  = element_blank(),
        axis.ticks.y  = element_blank(),
        legend.position = "none")
figure_0a
# exports figures
ggsave(filename = "figure_0a.png", plot = figure_0a, device = "png",
       height = 2, width = 4, path = "output/figures/components/")

# figure 0b ................................................................
# estimated total U.S. population within 1 km of oil and gas wells that were in 
# wildfire burn areas by year

# summarizes results to feed into ggplot
data_0b <- 
  tibble(period  = c("1996–2004", "2046–2054", "2086–2094",
                     "1996–2004", "2046–2054", "2086–2094"),
         kbdi    = c("450", "450", "450", 
                     "600", "600", "600"),
         n_wells = c(nrow(subset(wells_kbdi, kbdi_max_2017 >= 450 &
                                   kbdi_max_2017 < 600)),
                     nrow(subset(wells_kbdi, kbdi_max_2050 >= 450 &
                                   kbdi_max_2050 < 600)),
                     nrow(subset(wells_kbdi, kbdi_max_2090 >= 450 &
                                   kbdi_max_2090 < 600)),
                     nrow(subset(wells_kbdi, kbdi_max_2017 >= 600)),
                     nrow(subset(wells_kbdi, kbdi_max_2050 >= 600)),
                     nrow(subset(wells_kbdi, kbdi_max_2090 >= 600))))

# makes figure
figure_0b <- data_0b %>% 
  ggplot()  +
  geom_bar(aes(period, n_wells), fill = "darkgray", stat = "identity") + 
  # scale_fill_manual(values = c("darkgray", "darkgray")) + 
  labs(x = "", y = "") + 
  ylim(0, 1200000)  +
  theme_classic() +
  theme(axis.text.y  = element_blank(),
        legend.position = "none")
figure_0b
# exports figures
ggsave(filename = "figure_0b.png", plot = figure_0b, device = "png",
       height = 2, width = 4, path = "output/figures/components/")


## prospective assessments - panel c -----------------------------------------

# figure 0c ................................................................
# count of oil and gas wells in moderately high wildfire risk areas by period

# summarizes results to feed into ggplot
data_0b <- 
  tibble(period  = c("1996–2004", "2046–2054", "2086–2094",
                     "1996–2004", "2046–2054", "2086–2094"),
         kbdi    = c("450", "450", "450", 
                     "600", "600", "600"),
         n_wells = c(nrow(subset(wells_kbdi, kbdi_max_2017 >= 450 &
                                   kbdi_max_2017 < 600)),
                     nrow(subset(wells_kbdi, kbdi_max_2050 >= 450 &
                                   kbdi_max_2050 < 600)),
                     nrow(subset(wells_kbdi, kbdi_max_2090 >= 450 &
                                   kbdi_max_2090 < 600)),
                     nrow(subset(wells_kbdi, kbdi_max_2017 >= 600)),
                     nrow(subset(wells_kbdi, kbdi_max_2050 >= 600)),
                     nrow(subset(wells_kbdi, kbdi_max_2090 >= 600))))

# makes figure
figure_0b <- data_0b %>% 
  ggplot()  +
  geom_bar(aes(period, n_wells, fill = kbdi), 
           stat = "identity", position = "stack") + 
  scale_fill_manual(values = c("#AD8ABB", "#ffb3df")) + 
  labs(x = "", y = "") + 
  ylim(0, 1200000)  +
  scale_y_continuous("",
                     # adds second y-axis with % wells in high risk areas
                     sec.axis = 
                       sec_axis(~ . / nrow(wells_kbdi) * 100, name = "")) +
  theme_classic() +
  theme(axis.text.y  = element_blank(),
        legend.position = "none")
figure_0b
# exports figures
ggsave(filename = "figure_0b.png", plot = figure_0b, device = "png",
       height = 2.4, width = 4, path = "output/figures/components/")

##============================================================================##

###### same as above but with geofacet --- move to supplemental
# figure_0a <- wells_wildfire_state_year %>% 
#   filter(year %in% c(1984:2019)) %>% 
#   group_by(year) %>% 
#   summarize(n_wells = sum(n_wells),
#             state   = state) %>% 
#   ggplot(aes(year, n_wells))  +
#   geom_smooth(method = "lm", formula = y ~ x, 
#               color = "black", lwd = 0.3, linetype = "longdash", alpha = 0.3) +
#   # geom_smooth(method = "lm", formula = y ~ poly(x, 2), 
#   #             color = "blue", fill = "blue", lwd = 0.3, alpha = 0.3) +
#   geom_point(size = 0.6) + 
#   labs(x = "", y = "") + 
#   facet_geo(~ state) +
#   theme_classic() +
#   theme(axis.line.x  = element_blank(),  # removes x-axis
#         axis.ticks.x = element_blank(),
#         axis.text.x  = element_blank(),
#         axis.text.y  = element_blank(),
#         legend.position = "none")
# # exports figures
# ggsave(filename = "figure_0a.png", plot = figure_0a, device = "png",
#        height = 2.2, width = 4, path = "output/figures/components/")

##============================================================================##