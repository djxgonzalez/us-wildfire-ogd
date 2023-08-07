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
us_states_ak <- st_read("data/raw/esri/USA_States_Generalized.shp") %>% 
  filter(STATE_ABBR == "AK") %>%
  st_geometry() %>%
  st_transform(crs_alaska)
rus_can <- st_read("data/raw/esri/Countries_WGS84.shp") %>%  # for AK map
  filter(CNTRY_NAME %in% c("Canada", "Russia")) %>%
  st_geometry() %>%
  st_transform(crs_alaska)
# Alaska wildfires
wildfires_ak_union <- readRDS("data/interim/wildfires_all.rds") %>%
  filter(state == "AK") %>%
  st_as_sf() %>%  
  st_transform(crs_alaska) %>%  # note distinct CRS: NAD83/Alaska Albers
  st_union()
# combined 1 km well buffers for Alaska
wells_ak_buffer_1km <- 
  readRDS("data/interim/wells_buffers/wells_ak_buffer_1km.rds") %>% 
  st_transform(crs_alaska)  # note distinct CRS: NAD83/Alaska Albers

## Figure 1a inset ----------------------------------------------------------
## Wildfires (shaded by decade) and 1 km buffers around all wells in the 
## Alaska; similar to code for 4.02 to make figure 1a

# makes figure
figure_1a_inset <- ggplot() +
  geom_sf(data = rus_can,      color = NA, fill = "#c1c2c7", alpha = 0.8) +
  geom_sf(data = us_states_ak, color = NA, fill = "#dedfe4", alpha = 0.7) +
  geom_sf(data = wildfires_ak_union, fill = "#e31a1c", color = NA, alpha = 0.7) +
  geom_sf(data = us_states_ak, color = "white", fill = NA, lwd = 0.3) +
  geom_sf(data = wells_ak_buffer_1km, fill = "black", color = NA, alpha = 0.7) +
  xlim(-1100000, 1240000) + ylim(500000, 2300000) +
  labs(x = "", y = "") +
  theme_void() +  
  theme(panel.background = element_rect(fill  = "#d6ecf3"),
        panel.grid       = element_line(color = "#d6ecf3"),
        legend.position = "none")
# export
ggsave(filename = "figure_1a_inset.png", plot = figure_1a_inset, device = "png",
       height = 4.8, width = 6.2, path = "output/figures/components/")


##============================================================================##