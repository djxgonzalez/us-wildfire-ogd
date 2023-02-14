##============================================================================##
## makes Figure 3, showing the primary results for all parts of the analysis:
## (a) wells in wildfire burn areas by year; (c) people near wells in burn areas,
## and wells in areas with projected (b) moderately high and (d) high wildfire 
## risk currently, in mid-century, and in late century 

## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")
# library("lubridate")

# data input
wells_kbdi <- readRDS("data/processed/wells_kbdi.rds")
wildfires_wells_population <- 
  readRDS("data/processed/wildfires_wells_population.rds")


## retrospective assessments - panels a, c -----------------------------------

# figure 3a ................................................................
# count of oil and gas wells in wildfire burn areas by year
figure_3a <- wildfires_wells_population %>% 
  group_by(year) %>% 
  summarize(n_wells = sum(n_wells)) %>% 
  ggplot()  +
  geom_bar(aes(year, n_wells), stat = "identity") + 
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

# figure 3c ................................................................
# estimated total U.S. population within 1 km of oil and gas wells that were in 
# wildfire burn areas by year.
figure_3c <- wildfires_wells_population %>% 
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
ggsave(filename = "figure_3c.png", plot = figure_3c, device = "png",
       height = 2.4, width = 4, path = "output/figures/components/")


## prospective assessments - panels a, c -------------------------------------

# figure 3b ................................................................
# count of oil and gas wells in moderately high wildfire areas by period

# preps data
data_3b <- tibble(period = c("Current", "Mid-century", "Late century"))

# makes figure
figure_3b <- wells %>% 
  group_by(year) %>% 
  summarize(n_wells = sum(n_wells)) %>% 
  ggplot()  +
  geom_bar(aes(year, n_wells), stat = "identity") + 
  labs(x = "", y = "") + 
  theme_classic() +
  theme(axis.line.x  = element_blank(),  # removes x-axis
        axis.ticks.x = element_blank(),
        axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        legend.position = "none")
# exports figures
ggsave(filename = "figure_3b.png", plot = figure_3b, device = "png",
       height = 2.2, width = 4, path = "output/figures/components/")


##============================================================================##