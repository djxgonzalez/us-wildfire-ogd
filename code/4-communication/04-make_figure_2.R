##============================================================================##
## makes Figure 2, showing the primary results for all parts of the analysis:
## (a) wells in wildfire burn areas by year; (c) people near wells in burn areas,
## and wells in areas with projected (b) moderately high and (d) high wildfire 
## risk currently, in mid,-century, and in late century 

## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")
##### this is for GEOFACET package
#library("rgeos")  ##### apparently not available for MacOS, try on server
#library("geofacet")
library("viridis")

# data input
wells_kbdi <- readRDS("data/processed/wells_kbdi.rds")
wells_wildfire_state_year <- 
  read_csv("data/processed/wells_wildfire_state_year.csv")
pop_exposed_state_year <- 
  read_csv("data/processed/pop_exposed_state_year.csv")


## retrospective assessments - panels a, b -----------------------------------

# figure 2a ................................................................
# count of oil and gas wells in wildfire burn areas by year
figure_2a <- wells_wildfire_state_year %>% 
  filter(year %in% c(1984:2019)) %>% 
  group_by(year) %>% 
  summarize(n_wells = sum(n_wells)) %>% 
  ggplot(aes(year, n_wells))  +
  geom_vline(aes(xintercept = 1990), lwd = 0.2, color = "gray") +
  geom_vline(aes(xintercept = 2000), lwd = 0.2, color = "gray") +
  geom_vline(aes(xintercept = 2010), lwd = 0.2, color = "gray") +
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
ggsave(filename = "figure_2a.png", plot = figure_2a, device = "png",
       height = 2.2, width = 4, path = "output/figures/components/")

# figure 2b ................................................................
# estimated total U.S. population within 1 km of oil and gas wells that were in 
# wildfire burn areas by year
figure_2b <- pop_exposed_state_year %>% 
  group_by(year) %>% 
  summarize(pop_exposed_n = sum(pop_exposed_n)) %>% 
  ggplot(aes(year, pop_exposed_n))  +
  geom_vline(aes(xintercept = 1990), lwd = 0.2, color = "gray") +
  geom_vline(aes(xintercept = 2000), lwd = 0.2, color = "gray") +
  geom_vline(aes(xintercept = 2010), lwd = 0.2, color = "gray") +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "black", lwd = 0.3, linetype = "longdash", alpha = 0.3) +
  geom_point(size = 0.6) + 
  labs(x = "", y = "") +
  theme_classic() +
  theme(axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        legend.position = "none")
# exports figures
ggsave(filename = "figure_2b.png", plot = figure_2b, device = "png",
       height = 2.4, width = 4, path = "output/figures/components/")


## prospective assessments - panel c -----------------------------------------

# figure 2c ................................................................
# count of oil and gas wells in moderately high wildfire risk areas by period

# summarizes results to feed into ggplot
data_3c <- 
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
figure_2c <- data_3c %>% 
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
figure_2c
# exports figures
ggsave(filename = "figure_2c.png", plot = figure_2c, device = "png",
       height = 2.4, width = 4, path = "output/figures/components/")

##============================================================================##

###### same as above but with geofacet --- move to supplemental
# figure_2a <- wells_wildfire_state_year %>% 
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
# ggsave(filename = "figure_2a.png", plot = figure_2a, device = "png",
#        height = 2.2, width = 4, path = "output/figures/components/")

##============================================================================##