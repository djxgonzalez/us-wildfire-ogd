##============================================================================##
## makes Figure 3 - plots the top four wildfires with the most wells that were
## had operation dates before the fire year or were plugged with no operation 
## dates (and likely abandoned before the study period)

##---------------------------------------------------------------------------
## sets up environment

library("ggspatial")
library("lubridate")

# data input
wildfires_all <- readRDS("data/interim/wildfires_all.rds")
wells_ca <- readRDS("data/interim/enverus_wells.rds") %>%
  filter(state == "CA") %>%
  mutate(plugged_no_dates = 
           ifelse(well_status %in% c("ABANDONED", "P & A") &
                    (is.na(spud_date) * is.na(completion_date) &
                       is.na(first_prod_date) & is.na(last_prod_date) &
                       is.na(first_test_date) & is.na(last_test_date)),
                  1, 0),) %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83)
wells_ok <- readRDS("data/interim/enverus_wells.rds") %>%
  filter(state == "OK") %>%
  mutate(plugged_no_dates = 
           ifelse(well_status %in% c("ABANDONED", "P & A") &
                    (is.na(spud_date) * is.na(completion_date) &
                       is.na(first_prod_date) & is.na(last_prod_date) &
                       is.na(first_test_date) & is.na(last_test_date)),
                  1, 0),) %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83)
# counties_ok <- st_read("data/raw/la_county/Census_Tracts_2010.shp") %>%
#   st_transform(crs_nad83) %>%
#   st_union()

# data prep
wildfire_a <- wildfires_all %>% 
  filter(wildfire_id == "OK3431309744020090409") %>%  # Loco-Healdton fire in OK
  st_as_sf(crs = crs_nad83)
wildfire_a_buffer_1km <- wildfires_all %>% 
  filter(wildfire_id == "OK3431309744020090409") %>%  # Loco-Healdton fire in OK
  st_as_sf(crs = crs_nad83) %>% 
  st_buffer(dist = 1000) %>% 
  st_difference(wildfire_a)
wildfire_a_buffer_20km <- wildfires_all %>% 
  filter(wildfire_id == "OK3431309744020090409") %>%  # Loco-Healdton fire in OK
  st_as_sf(crs = crs_nad83) %>% 
  st_buffer(dist = 40000) %>% 
  st_difference(wildfire_a)
wells_a <- wells_ok %>% 
  filter(plugged_no_dates == 1 |
           (year(spud_date)         <= wildfire_a$year |
              year(completion_date) <= wildfire_a$year |
              year(first_prod_date) <= wildfire_a$year |
              year(last_prod_date)  <= wildfire_a$year |
              year(first_test_date) <= wildfire_a$year |
              year(last_test_date)  <= wildfire_a$year)) %>% 
  st_intersection(wildfire_a)
wells_a_buffer <- wells_ok %>%
  filter(plugged_no_dates == 1 |
           (year(spud_date)         <= wildfire_a$year |
              year(completion_date) <= wildfire_a$year |
              year(first_prod_date) <= wildfire_a$year |
              year(last_prod_date)  <= wildfire_a$year |
              year(first_test_date) <= wildfire_a$year |
              year(last_test_date)  <= wildfire_a$year)) %>% 
  st_intersection(wildfire_a_buffer_20km)

wildfire_b <- wildfires_all %>% 
  filter(wildfire_id == "CA3531811949919970519") %>%  # Loco-Healdton fire in OK
  st_as_sf(crs = crs_nad83)
wildfire_b_buffer_1km <- wildfires_all %>% 
  filter(wildfire_id == "CA3531811949919970519") %>%  # Loco-Healdton fire in OK
  st_as_sf(crs = crs_nad83) %>% 
  st_buffer(dist = 1000) %>% 
  st_difference(wildfire_a)
wildfire_b_buffer_20km <- wildfires_all %>% 
  filter(wildfire_id == "CA3531811949919970519") %>%  # Loco-Healdton fire in OK
  st_as_sf(crs = crs_nad83) %>% 
  st_buffer(dist = 40000) %>% 
  st_difference(wildfire_a)
wells_b <- wells_ca %>% 
  filter(plugged_no_dates == 1 |
           (year(spud_date)         <= wildfire_a$year |
              year(completion_date) <= wildfire_a$year |
              year(first_prod_date) <= wildfire_a$year |
              year(last_prod_date)  <= wildfire_a$year |
              year(first_test_date) <= wildfire_a$year |
              year(last_test_date)  <= wildfire_a$year)) %>% 
  st_intersection(wildfire_b)
wells_b_buffer <- wells_ca %>%
  filter(plugged_no_dates == 1 |
           (year(spud_date)         <= wildfire_a$year |
              year(completion_date) <= wildfire_a$year |
              year(first_prod_date) <= wildfire_a$year |
              year(last_prod_date)  <= wildfire_a$year |
              year(first_test_date) <= wildfire_a$year |
              year(last_test_date)  <= wildfire_a$year)) %>% 
  st_intersection(wildfire_b_buffer_20km)


##---------------------------------------------------------------------------
## manuscript figure

#.........................................................................
# makes figure 3a - Loco-Healdton fire in OK (2009) - OK3431309744020090409
figure_3a <- ggplot() +
  geom_sf(data = wells_a_buffer, shape = 4, size = 2, color = "gray", 
          alpha = 0.2) +
  geom_sf(data = wildfire_a_buffer_1km, fill = "orange", color = NA, alpha = 0.3) +
  geom_sf(data = wildfire_a, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wells_a, shape = 4, size = 2, alpha = 0.2) +
  geom_sf(data = wildfire_a, fill = NA, color = "red") +
  annotation_scale(location = "bl", width_hint = 0.25) +
  #annotation_north_arrow(location = "tr", which_north = "true", 
  #                        style = north_arrow_minimal) +
  xlim(-97.8, -97.25) + ylim(34.20, 34.45) +
  theme_void() +
  theme(legend.position = "none",
        panel.background = element_rect(fill = "white"))
figure_3a
# exports figures
ggsave(filename = "figure_3a.png", plot = figure_3a, device = "png",
       height = 4, width = 6, path = "output/figures/components/")

#.........................................................................
# makes figure 3b - Lokern fire in CA (1997) - CA3531811949919970519
figure_3b <- ggplot() +
  geom_sf(data = wells_b_buffer, shape = 4, size = 2, color = "gray", 
          alpha = 0.2) +
  geom_sf(data = wildfire_b_buffer_1km, fill = "orange", color = NA, alpha = 0.3) +
  geom_sf(data = wildfire_b, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wells_b, shape = 4, size = 2, alpha = 0.2) +
  geom_sf(data = wildfire_b, fill = NA, color = "red") +
  annotation_scale(location = "bl", width_hint = 0.25) +
  xlim(-119.72, -119.27) + ylim(35.19, 35.44) +
  theme_void() +
  theme(legend.position = "none",
        panel.background = element_rect(fill = "white"))
figure_3b
# exports figures
ggsave(filename = "figure_3b.png", plot = figure_3b, device = "png",
       height = 4, width = 6, path = "output/figures/components/")

##### add panels c and d, fires with most wells + people
#.........................................................................
# makes figure 3c - 
panel_3c <- ggplot()

#.........................................................................
# makes figure 3d - 
panel_3d <- ggplot()


##============================================================================##