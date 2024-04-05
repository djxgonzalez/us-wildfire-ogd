##============================================================================##
## 4.05 -  makes Figure 3 plots the top four wildfires with the most oil and gas 
## wells drilled before the fire year, including wells without operation dates,
## presumed to have been drilled before 1984

## setup ---------------------------------------------------------------------

# attaches packages ........................................................
source("code/0-setup/01-setup.R")
library("ggspatial")
library("ggmap")
library("lubridate")

# data input ...............................................................
wildfires_all <- readRDS("data/interim/wildfires_all.rds")
wells_all     <- readRDS("data/interim/wells_all.rds")

# data prep ................................................................

# Figure 3a - East Amarillo Complex Fire - T - 2006
wildfire_a <- wildfires_all %>%  
  filter(wildfire_id == "TX3551510078020060312") %>%  
  st_as_sf() %>%
  st_transform(crs_nad83)
wildfire_a_buffer_1km <- wildfire_a %>% 
  st_buffer(dist = 1000) %>%
  st_difference(wildfire_a)
wildfire_a_buffer_40km <- wildfire_a %>% 
  st_buffer(dist = 40000) %>% 
  st_difference(wildfire_a)
wells_a <- wells_all %>% 
  filter(state == "TX") %>% 
  filter(year(date_earliest) <= wildfire_a$year | is.na(date_earliest)) %>% 
  st_transform(crs_nad83) %>% 
  st_intersection(wildfire_a)
wells_a_buffer <- wells_all %>%
  filter(state == "TX") %>% 
  filter(year(date_earliest) <= wildfire_a$year | is.na(date_earliest)) %>%  
  st_transform(crs_nad83) %>% 
  st_intersection(wildfire_a_buffer_40km)

# Figure 3b - Loco-Healdton Fire - OK - 2009
wildfire_b <- wildfires_all %>%  
  filter(wildfire_id == "OK3431309744020090409") %>%  
  st_as_sf() %>% 
  st_transform(crs_nad83)
wildfire_b_buffer_1km <- wildfire_b %>% 
  st_buffer(dist = 1000) %>%
  st_difference(wildfire_b)
wildfire_b_buffer_30km <- wildfire_b %>% 
  st_buffer(dist = 30000) %>% 
  st_difference(wildfire_b)
wells_b <- wells_all %>% 
  filter(state == "OK") %>% 
  filter(year(date_earliest) <= wildfire_b$year | is.na(date_earliest)) %>% 
  st_transform(crs_nad83) %>% 
  st_intersection(wildfire_b)
wells_b_buffer <- wells_all %>%
  filter(state == "OK") %>% 
  filter(year(date_earliest) <= wildfire_b$year | is.na(date_earliest)) %>%  
  st_transform(crs_nad83) %>% 
  st_intersection(wildfire_b_buffer_30km)

# Figure 3c - Thomas Fire - CA - 2017
wildfire_c <- wildfires_all %>%  
  filter(wildfire_id == "CA3442911910020171205") %>%  
  st_as_sf() %>% 
  st_transform(crs_nad83)
wildfire_c_buffer_1km <- wildfire_c %>% 
  st_buffer(dist = 1000) %>%
  st_difference(wildfire_c)
wildfire_c_buffer_30km <- wildfire_c %>% 
  st_buffer(dist = 30000) %>% 
  st_difference(wildfire_c)
wells_c <- wells_all %>% 
  filter(state == "CA") %>% 
  filter(year(date_earliest) <= wildfire_c$year | is.na(date_earliest)) %>% 
  st_transform(crs_nad83) %>% 
  st_intersection(wildfire_c)
wells_c_buffer <- wells_all %>%
  filter(state == "CA") %>% 
  filter(year(date_earliest) <= wildfire_c$year | is.na(date_earliest)) %>%  
  st_transform(crs_nad83) %>% 
  st_intersection(wildfire_c_buffer_30km)

# Figure 3d - Simi Fire - CA - 2003
wildfire_d <- wildfires_all %>%  
  filter(wildfire_id == "CA3433511879220031025") %>%  
  st_as_sf() %>% 
  st_transform(crs_nad83)
wildfire_d_buffer_1km <- wildfire_d %>% 
  st_buffer(dist = 1000) %>%
  st_difference(wildfire_d)
wildfire_d_buffer_30km <- wildfire_d %>% 
  st_buffer(dist = 30000) %>% 
  st_difference(wildfire_d)
wells_d <- wells_all %>% 
  filter(state == "CA") %>% 
  filter(year(date_earliest) <= wildfire_d$year | is.na(date_earliest)) %>% 
  st_transform(crs_nad83) %>% 
  st_intersection(wildfire_d)
wells_d_buffer <- wells_all %>%
  filter(state == "CA") %>% 
  filter(year(date_earliest) <= wildfire_d$year | is.na(date_earliest)) %>%  
  st_transform(crs_nad83) %>% 
  st_intersection(wildfire_d_buffer_30km)

## generates figure ----------------------------------------------------------

# Figure 3a ................................................................
# East Amarillo Complex Fire - CA - 2006 - TX3551510078020060312
figure_3a <- ggplot() +
  geom_sf(data = wells_a_buffer, shape = 4, size = 2, color = "gray", alpha = 0.2) +
  geom_sf(data = wildfire_a_buffer_1km, fill = "orange", color = NA, alpha = 0.3) +
  geom_sf(data = wildfire_a, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wells_a, shape = 4, size = 2, alpha = 0.2) +
  geom_sf(data = wildfire_a, fill = NA, color = "red") +
  annotation_scale(location = "br", width_hint = 0.25) +
  annotation_north_arrow(location = "tr", which_north = "true",
                         style = north_arrow_minimal) +
  xlim(-101.5, -100.2) + ylim(35.0, 36.1) +
  theme_void() +
  theme(legend.position = "none",
        panel.background = element_rect(fill = "white"))
ggsave(filename = "figure_3a.png", plot = figure_3a, device = "png",
       height = 6, width = 6, path = "output/figures/components/")

# Figure 3b ................................................................
# Loco-Healdton Fire - OK - 2009 - OK3431309744020090409
figure_3b <- ggplot() +
  geom_sf(data = wells_b_buffer, shape = 4, size = 2, color = "gray", alpha = 0.2) +
  geom_sf(data = wildfire_b_buffer_1km, fill = "orange", color = NA, alpha = 0.3) +
  geom_sf(data = wildfire_b, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wells_b, shape = 4, size = 2, alpha = 0.2) +
  geom_sf(data = wildfire_b, fill = NA, color = "red") +
  annotation_scale(location = "bl", width_hint = 0.25) +
  xlim(-97.81, -97.25) + ylim(34.1, 34.55) +
  theme_void() +
  theme(legend.position = "none",
        panel.background = element_rect(fill = "white"))
figure_3b
ggsave(filename = "figure_3b.png", plot = figure_3b, device = "png",
       height = 6, width = 6, path = "output/figures/components/")

# Figure 3c ................................................................
# Thomas Fire - CA - 2017 - CA3442911910020171205
figure_3c <- ggplot() +
  geom_sf(data = wells_c_buffer, shape = 4, size = 2, color = "gray", alpha = 0.2) +
  geom_sf(data = wildfire_c_buffer_1km, fill = "orange", color = NA, alpha = 0.3) +
  geom_sf(data = wildfire_c, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wells_c, shape = 4, size = 2, alpha = 0.2) +
  geom_sf(data = wildfire_c, fill = NA, color = "red") +
  annotation_scale(location = "tr", width_hint = 0.25) +
  xlim(-119.8, -118.8) + ylim(34.05, 34.85) +
  theme_void() +
  theme(legend.position = "none",
        panel.background = element_rect(fill = "white"))
ggsave(filename = "figure_3c.png", plot = figure_3c, device = "png",
       height = 6, width = 6, path = "output/figures/components/")

# Figure 3d ................................................................
# Simi Fire - CA - 2003 - CA3433511879220031025
figure_3d <- ggplot() +
  geom_sf(data = wells_d_buffer, shape = 4, size = 2, color = "gray", alpha = 0.2) +
  geom_sf(data = wildfire_d_buffer_1km, fill = "orange", color = NA, alpha = 0.3) +
  geom_sf(data = wildfire_d, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wells_d, shape = 4, size = 2, alpha = 0.2) +
  geom_sf(data = wildfire_d, fill = NA, color = "red") +
  annotation_scale(location = "tl", width_hint = 0.25) +
  xlim(-119.2, -118.5) + ylim(34.05, 34.65) +
  theme_void() +
  theme(legend.position = "none",
        panel.background = element_rect(fill = "white"))
ggsave(filename = "figure_3d.png", plot = figure_3d, device = "png",
       height = 6, width = 6, path = "output/figures/components/")


##============================================================================##