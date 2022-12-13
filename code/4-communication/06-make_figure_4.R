##============================================================================##
## 4.06 - makes Figure 4...

## setup ---------------------------------------------------------------------

# attaches packages ........................................................
source("code/0-setup/01-setup.R")

# data input, prep layers for mapping ......................................
us_states <- st_read("data/raw/esri/USA_States_Generalized.shp") %>% 
  filter(STATE_ABBR %!in% c("AK", "HI")) %>% 
  st_geometry() %>%
  st_transform(crs_albers)
us_boundary <- us_states %>% st_union()
us_states_west <- st_read("data/raw/esri/USA_States_Generalized.shp") %>% 
  filter(STATE_ABBR %in% c("WA", "OR", "CA", "ID", "NV", "AZ", "MT", "WY", "UT",
                           "CO", "NM", "ND", "SD", "NE", "KS", "OK", "TX", "MO",
                           "AR", "LA")) %>%
  st_geometry() %>%
  st_transform(crs_albers)
us_states_east <- st_read("data/raw/esri/USA_States_Generalized.shp") %>% 
  filter(STATE_ABBR %!in% c("WA", "OR", "CA", "ID", "NV", "AZ", "MT", "WY", "UT",
                            "CO", "NM", "ND", "SD", "NE", "KS", "OK", "TX", "MO",
                            "AR", "LA")) %>%
  st_geometry() %>%
  st_transform(crs_albers)
mex_can <- st_read("data/raw/esri/Countries_WGS84.shp", crs = crs_wgs84) %>% 
  filter(CNTRY_NAME %in% c("Canada", "Mexico")) %>%
  st_geometry() %>%
  st_transform(crs_albers)

# combined 1 km well buffers for contiguous states
wells_all_buffer_1km <- 
  readRDS("data/interim/wells_buffers/wells_all_buffer_1km.rds")

kbdi_high_2017_sf <- readRDS("data/processed/kbdi_max_2017.rds") %>% 
  as_tibble() %>% 
  mutate(kbdi_over_450 = case_when(kbdi_max_2017 >= 450 ~ 1,
                                   kbdi_max_2017 <  450 ~ 0),
         kbdi_over_600 = case_when(kbdi_max_2017 >= 600 ~ 1,
                                   kbdi_max_2017 <  600 ~ 0)) %>%
  st_as_sf(coords = c("x", "y"), crs = crs_nad83) %>% 
  st_transform(crs_albers) %>% 
  st_intersection(us_states_west)
kbdi_high_2050_sf <- readRDS("data/processed/kbdi_max_2050.rds") %>% 
  as_tibble() %>% 
  mutate(kbdi_over_450 = case_when(kbdi_max_2050 >= 450 ~ 1,
                                   kbdi_max_2050 <  450 ~ 0),
         kbdi_over_600 = case_when(kbdi_max_2050 >= 600 ~ 1,
                                   kbdi_max_2050 <  600 ~ 0)) %>%
  st_as_sf(coords = c("x", "y"), crs = crs_nad83) %>% 
  st_transform(crs_albers) %>% 
  st_intersection(us_states_west)
kbdi_high_2090_sf <- readRDS("data/processed/kbdi_max_2090.rds") %>% 
  as_tibble() %>% 
  mutate(kbdi_over_450 = case_when(kbdi_max_2090 >= 450 ~ 1,
                                   kbdi_max_2090 <  450 ~ 0),
         kbdi_over_600 = case_when(kbdi_max_2090 >= 600 ~ 1,
                                   kbdi_max_2090 <  600 ~ 0)) %>%
  st_as_sf(coords = c("x", "y"), crs = crs_nad83) %>% 
  st_transform(crs_albers) %>% 
  st_intersection(us_states_west)

# preps layers
kbdi_450_2017 <-
  kbdi_high_2017_sf %>% filter(kbdi_over_450 == 1) %>% st_geometry()
kbdi_450_2050 <-
  kbdi_high_2050_sf %>% filter(kbdi_over_450 == 1) %>% st_geometry()
kbdi_450_2090 <-
  kbdi_high_2090_sf %>% filter(kbdi_over_450 == 1) %>% st_geometry()
kbdi_600_2017 <-
  kbdi_high_2017_sf %>% filter(kbdi_over_600 == 1) %>% st_geometry()
kbdi_600_2050 <-
  kbdi_high_2050_sf %>% filter(kbdi_over_600 == 1) %>% st_geometry()
kbdi_600_2090 <-
  kbdi_high_2090_sf %>% filter(kbdi_over_600 == 1) %>% st_geometry()

# removes data no longer needed
rm(kbdi_high_2017_sf, kbdi_high_2050_sf, kbdi_high_2090_sf)


## generates figure ----------------------------------------------------------

# figure 4a ................................................................
figure_4a <- ggplot() +
  geom_sf(data = mex_can,   color = NA, fill = "#DCDCDC", alpha = 0.7) +
  geom_sf(data = us_states, color = NA, fill = "white") +
  geom_sf(data = kbdi_450_2090,  color = "#7a0177", size = 0.2) +
  geom_sf(data = kbdi_450_2050,  color = "#f768a1", size = 0.2) +
  geom_sf(data = kbdi_450_2017,  color = "#fcc5c0", size = 0.05) +
  geom_sf(data = us_states_east, 
          color = "black", fill = "#DCDCDC", lwd = 0.2, alpha = 0.7) +
  geom_sf(data = us_states,   color = "black", fill = NA, lwd = 0.2) +
  geom_sf(data = us_boundary, color = "black", fill = NA, lwd = 0.4) +
  geom_sf(data = wells_all_buffer_1km,
          fill = "black", color = NA, alpha = 0.2) +
  xlim(-2300000, 560000) + ylim(340000, 3100000) +  # origin: 96W, 23N
  labs(x = "", y = "") +
  theme_void() +  
  theme(panel.background = element_rect(fill  = "#e9f5f8"),
        panel.grid       = element_line(color = "#e9f5f8"),
        legend.position = "none")
# export
ggsave(filename = "figure_4a.png", plot = figure_4a, device = "png",
       height = 5.25, width = 5, path = "output/figures/components/")

# figure 4b ................................................................
figure_4b <- ggplot() +
  geom_sf(data = mex_can,   color = NA, fill = "#DCDCDC", alpha = 0.7) +
  geom_sf(data = us_states, color = NA, fill = "white") +
  geom_sf(data = kbdi_600_2090,  color = "#7a0177", size = 0.2) +
  geom_sf(data = kbdi_600_2050,  color = "#f768a1", size = 0.2) +
  geom_sf(data = kbdi_600_2017,  color = "#fcc5c0", size = 0.05) +
  geom_sf(data = us_states_east, 
          color = "black", fill = "#DCDCDC", lwd = 0.2, alpha = 0.7) +
  geom_sf(data = us_states,   color = "black", fill = NA, lwd = 0.2) +
  geom_sf(data = us_boundary, color = "black", fill = NA, lwd = 0.4) +
  geom_sf(data = wells_all_buffer_1km,
          fill = "black", color = NA, alpha = 0.2) +
  xlim(-2300000, 560000) + ylim(340000, 3100000) +  # origin: 96W, 23N
  labs(x = "", y = "") +
  theme_void() +  
  theme(panel.background = element_rect(fill  = "#e9f5f8"),
        panel.grid       = element_line(color = "#e9f5f8"),
        legend.position = "none")
# export
ggsave(filename = "figure_4b.png", plot = figure_4b, device = "png",
       height = 5.25, width = 5, path = "output/figures/components/")

##============================================================================##