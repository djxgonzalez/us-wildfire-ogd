##============================================================================##
## makes Figure 3, showing the primary results for all parts of the analysis:
## (a) wells in wildfire burn areas by year; (c) people near wells in burn areas,
## and wells in areas with projected (b) moderately high and (d) high wildfire 
## risk currently, in mid-century, and in late century 

## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")
library("viridis")

# data input

wells_kbdi <- readRDS("data/processed/wells_kbdi.rds")
wells_wildfire_state_year <- 
  readRDS("data/processed/wells_wildfire_state_year.rds")
wildfires_wells_population <- 
  readRDS("data/processed/wildfires_wells_population.rds")


## retrospective assessments - panels a, b -----------------------------------

# figure 3a ................................................................
# count of oil and gas wells in wildfire burn areas by year
figure_3a <- wells_wildfire_state_year %>% 
  filter(year %in% c(1984:2019)) %>% 
  group_by(year) %>% 
  summarize(n_wells = sum(n_wells),
            state   = state) %>% 
  ggplot(aes(year, n_wells))  +
  geom_smooth(method = "lm", formula = y ~ x, 
              color = "black", lwd = 0.3, linetype = "longdash", alpha = 0.3) +
  # geom_smooth(method = "lm", formula = y ~ poly(x, 2), 
  #             color = "blue", fill = "blue", lwd = 0.3, alpha = 0.3) +
  geom_point(size = 0.6) + 
  labs(x = "", y = "") + 
  theme_classic() +
  theme(axis.line.x  = element_blank(),  # removes x-axis
        axis.ticks.x = element_blank(),
        axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        legend.position = "none")
# exports figures
ggsave(filename = "figure_3a.png", plot = figure_3a, device = "png",
       height = 2.2, width = 4, path = "output/figures/components/")

# figure 3b ................................................................
# estimated total U.S. population within 1 km of oil and gas wells that were in 
# wildfire burn areas by year
##### EDIT THIS; shows wells count right now
figure_3b <- wildfires_wells_population %>% 
  filter(year %in% c(1984:2019)) %>% 
  filter(n_wells > 0) %>% 
  group_by(year) %>% 
  summarize(n = n()) %>% 
  ggplot()  +
  geom_bar(aes(year, n), stat = "identity") + 
  labs(x = "", y = "") + 
  theme_classic() +
  theme(#axis.text.x  = element_blank(),
    axis.text.y  = element_blank(),
    legend.position = "none")
# exports figures
ggsave(filename = "figure_3b.png", plot = figure_3b, device = "png",
       height = 2.4, width = 4, path = "output/figures/components/")


## prospective assessments - panel c -----------------------------------------

# figure 3c ................................................................
# count of oil and gas wells in moderately high wildfire risk areas by period

# summarizes results to feed into ggplot
data_3c <- 
  tibble(period  = c("2017", "2046-2054", "2086-2094",
                     "2017", "2046-2054", "2086-2094"),
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
figure_3c <- data_3c %>% 
  ggplot()  +
  geom_bar(aes(period, n_wells, fill = kbdi), 
           stat = "identity", position = "stack") + 
  scale_fill_manual(values = c("#AD8ABB", "#ffb3df")) + 
  #scale_fill_grey(start = 0.6, end = 0.25) +
  labs(x = "", y = "") + 
  ylim(0, 1200000) +
  theme_classic() +
  theme(axis.text.y  = element_blank(),
        legend.position = "none")
# exports figures
ggsave(filename = "figure_3c.png", plot = figure_3c, device = "png",
       height = 2.4, width = 4, path = "output/figures/components/")

##============================================================================##