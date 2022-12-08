##============================================================================##
## makes Figure 4 - ...

##### to do: sort out how to get data into raster form so that pixel size
##### is correct


## setup ---------------------------------------------------------------------

# attaches necessary packages
source("code/0-setup/01-setup.R")

# data input and prep
us_states <- st_read("data/raw/us_census/tl_2018_us_state.shp") %>%    ## update
  filter(STUSPS %in% c("WA", "OR", "CA", "ID", "NV", "AZ", "MT", "WY",
                       "UT", "CO", "NM", "ND", "SD", "NE", "KS", "OK", "TX",
                       "MN", "IA", "MO", "AR", "LA", "WI", "MI", "IL", "IN", 
                       "KY", "TN", "MS", "AL", "GA", "FL")) %>% 
  st_transform(crs_nad83)
us_boundary <- us_states %>% st_union()
mex_can <- st_read("data/raw/esri/Countries_WGS84.shp") %>% 
  filter(CNTRY_NAME %in% c("Canada", "Mexico")) %>%
  st_geometry() %>%
  st_transform(crs_nad83)

oil_basin_union <- ##### replace with wells buffer
  st_read("data/raw/us_eia/SedimentaryBasins_US_EIA/SedimentaryBasins_US_May2011_v2.shp") %>%
  st_transform(crs_nad83) %>%
  st_make_valid() %>% 
  st_union()

kbdi_high_2017_sf <- readRDS("data/processed/kbdi_max_2017.rds") %>% 
  as_tibble() %>%
  st_as_sf(coords = c("x", "y"), crs = crs_nad83) %>% 
  st_intersection(study_region_sf) %>% 
  mutate(kbdi_over_400 = case_when(kbdi_max_2017 >= 400 ~ 1,
                                   kbdi_max_2017 <  400 ~ 0),
         kbdi_over_600 = case_when(kbdi_max_2017 >= 600 ~ 1,
                                   kbdi_max_2017 <  600 ~ 0))
kbdi_high_2050_sf <- readRDS("data/processed/kbdi_max_2050.rds") %>% 
  as_tibble() %>%
  st_as_sf(coords = c("x", "y"), crs = crs_nad83) %>% 
  st_intersection(study_region_sf) %>% 
  mutate(kbdi_over_400 = case_when(kbdi_max_2050 >= 400 ~ 1,
                                   kbdi_max_2050 <  400 ~ 0),
         kbdi_over_600 = case_when(kbdi_max_2050 >= 600 ~ 1,
                                   kbdi_max_2050 <  600 ~ 0))
kbdi_high_2090_sf <- readRDS("data/processed/kbdi_max_2090.rds") %>% 
  as_tibble() %>%
  st_as_sf(coords = c("x", "y"), crs = crs_nad83) %>% 
  st_intersection(study_region_sf) %>% 
  mutate(kbdi_over_400 = case_when(kbdi_max_2090 >= 400 ~ 1,
                                   kbdi_max_2090 <  400 ~ 0),
         kbdi_over_600 = case_when(kbdi_max_2090 >= 600 ~ 1,
                                   kbdi_max_2090 <  600 ~ 0))

# preps layers
kbdi_400_2017 <-
  kbdi_high_2017_sf %>% filter(kbdi_over_400 == 1) %>% st_geometry()
kbdi_400_2050 <-
  kbdi_high_2050_sf %>% filter(kbdi_over_400 == 1) %>% st_geometry()
kbdi_400_2090 <-
  kbdi_high_2090_sf %>% filter(kbdi_over_400 == 1) %>% st_geometry()
kbdi_600_2017 <-
  kbdi_high_2017_sf %>% filter(kbdi_over_600 == 1) %>% st_geometry()
kbdi_600_2050 <-
  kbdi_high_2050_sf %>% filter(kbdi_over_600 == 1) %>% st_geometry()
kbdi_600_2090 <-
  kbdi_high_2090_sf %>% filter(kbdi_over_600 == 1) %>% st_geometry()

# removes data no longer needed
rm(kbdi_high_2017_sf, kbdi_high_2050_sf, kbdi_high_2090_sf, study_region_sf)


## manuscript figure ---------------------------------------------------------

# figure 4a ................................................................
figure_4a <- ggplot() +
  geom_sf(data = mex_can,       fill = "#DCDCDC", color = NA, alpha = 0.7) +
  geom_sf(data = us_states,     color = NA, fill = "white") +
  geom_sf(data = lakes,         fill = "#e9f5f8", color = NA) +
  geom_sf(data = kbdi_600_2090, color = "yellow", size = 0.1) +
  geom_sf(data = kbdi_600_2050, color = "orange", size = 0.1) +
  geom_sf(data = kbdi_600_2017, color = "red",    size = 0.1) +
  geom_sf(data = us_states,     color = "black", fill = NA, lwd = 0.2) +
  geom_sf(data = us_boundary,   color = "black", fill = NA, lwd = 0.4) +
  xlim(-125, -89) + ylim(26, 49) +
  theme_bw() +
  theme(panel.background = element_rect(fill  = "#e9f5f8"),  # d0ecfd
        panel.grid       = element_line(color = "#e9f5f8"))  # e8f4f8)
# export
ggsave(filename = "figure_4a.png", plot = figure_4a, device = "png",
       height = 5, width = 6, path = "output/figures/components/")

# figure 4b ................................................................
figure_4b <- ggplot() +
  geom_sf(data = mex_can, fill = "#DCDCDC", color = NA, alpha = 0.7) +
  geom_sf(data = us_states,     color = NA, fill = "white") +
  geom_sf(data = lakes,         fill = "#e9f5f8", color = NA) +
  geom_sf(data = kbdi_400_2090, color = "yellow", size = 0.1) +
  geom_sf(data = kbdi_400_2050, color = "orange", size = 0.1) +
  geom_sf(data = kbdi_400_2017, color = "red",    size = 0.1) +
  geom_sf(data = us_states,   color = "black", fill = NA, lwd = 0.2) +
  geom_sf(data = us_boundary, color = "black", fill = NA, lwd = 0.4) +
  xlim(-125, -89) + ylim(26, 49) +
  theme_bw() +
  theme(panel.background = element_rect(fill  = "#e9f5f8"),  # d0ecfd
        panel.grid       = element_line(color = "#e9f5f8"))  # e8f4f8)
# export
ggsave(filename = "figure_4b.png", plot = figure_4b, device = "png",
       height = 5, width = 6, path = "output/figures/components/")

##============================================================================##