##============================================================================##
## 4.02 - makes Figure 1 - (a) map of U.S. with study region with extent of
## wildfires by year and areas with oil and gas wells

# Note: There's a known issue that Windows graphics drivers may not fill in
# polygons that aren't completely within the view field. If that error occurs,
# consider running this script on MacOS or using the following package:
# https://cran.r-project.org/web/packages/ragg/index.html

## setup ---------------------------------------------------------------------

# attaches packages ........................................................
source("code/0-setup/01-setup.R")

# data input, prep layers for mapping ......................................
us_states <- st_read("data/raw/esri/USA_States_Generalized.shp") %>% 
  filter(STATE_ABBR %!in% c("AK", "HI")) %>% 
  st_geometry() %>%
  st_transform(crs_albers)
us_boundary <- us_states %>% st_union()
us_states_included <- st_read("data/raw/esri/USA_States_Generalized.shp") %>% 
  filter(STATE_ABBR %in% 
           c("OR", "CA", "NV", "AZ", "MT", "WY", "UT", "CO", "NM",
             "ND", "SD", "NE", "KS", "OK", "TX", "MO", "AR", "LA")) %>%
  st_geometry() %>%
  st_transform(crs_albers)
us_states_excluded <- st_read("data/raw/esri/USA_States_Generalized.shp") %>% 
  filter(STATE_ABBR %!in%
           c("OR", "CA", "NV", "AZ", "MT", "WY", "UT", "CO", "NM",
             "ND", "SD", "NE", "KS", "OK", "TX", "MO", "AR", "LA")) %>%
  st_geometry() %>%
  st_transform(crs_albers)
mex_can <- st_read("data/raw/esri/Countries_WGS84.shp", crs = crs_wgs84) %>% 
  filter(CNTRY_NAME %in% c("Canada", "Mexico")) %>%
  st_geometry() %>%
  st_transform(crs_albers)

# combined 1 km well buffers for contiguous states
wells_all_buffer_1km <- 
  readRDS("data/interim/wells_buffers/wells_all_buffer_1km.rds") %>% 
  st_intersection(us_states_included)

# unionizes wildfire buffers . . . . . . . . . . . . . . . . . . . . . . . .
# just need to run this once, uncomment and run if needed; otherwise, use
# the line below to import `wells_all_buffer_contiguous.rds`
# wildfires_all_union <- 
#   readRDS("data/processed/wildfires_all.rds") %>% 
#   filter(state %in% 
#            c("OR", "CA", "NV", "AZ", "MT", "WY", "UT", "CO", "NM",
#              "ND", "SD", "NE", "KS", "OK", "TX", "MO", "AR", "LA")) %>%
#   st_as_sf(crs = crs_albers) %>% 
#   st_union()
# saveRDS(wildfires_all_union,
#         "data/interim/wildfires_buffers/wildfires_all_union_no_buffer.rds")
wildfires_all_union <-
  readRDS("data/interim/wildfires_buffers/wildfires_all_union_no_buffer.rds")


## Figure 1a ----------------------------------------------------------------
## Wildfires (shaded by decade) and 1 km buffers around all wells in the 
## contiguous U.S.

# makes figure
figure_1a <- ggplot() +
  geom_sf(data = mex_can,   color = NA, fill = "#c1c2c7") +
  geom_sf(data = us_states, color = NA, fill = "#dedfe4") +
  geom_sf(data = wildfires_all_union, fill = "#e31a1c", color = NA, alpha = 0.7) +
  geom_sf(data = us_states_excluded, color = NA, fill = "#c1c2c7") +
  geom_sf(data = us_states,   color = "white", fill = NA, lwd = 0.4) +
  geom_sf(data = us_boundary, color = "white", fill = NA, lwd = 0.6) +
  geom_sf(data = wells_all_buffer_1km, fill = "black", color = NA, alpha = 0.6) +
  xlim(-2300000, 560000) + ylim(340000, 3100000) +  # origin: 96W, 23N
  labs(x = "", y = "") +
  theme_void() +  
  theme(panel.background = element_rect(fill  = "#d6ecf3"),
        panel.grid       = element_line(color = "#d6ecf3"),
        legend.position = "none")

# export
ggsave(filename = "figure_1a.png", plot = figure_1a, device = "png",
       height = 10.5, width = 10, path = "output/figures/components/")

##============================================================================##