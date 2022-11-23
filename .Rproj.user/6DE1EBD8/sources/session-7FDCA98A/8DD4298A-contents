##============================================================================##
## Figure 2 - exposure assessment

#----------------------------------------------------------------------------
# set-up

library("ggdark")
library("ggspatial")
source("code/1-data_tidying/02-tidy_calgem_wells_data.R")

# data input
acs_exposure <- readRDS("data/processed/acs_exposure_2005_2019.rds")
la_county <- st_read("data/raw/us_census/admin_shp/CA_counties.shp") %>%
  st_transform(crs_nad83) %>%
  filter(NAME == "Los Angeles")
wells_2005_2019 <- readRDS("data/interim/wells_interim.rds") %>% 
  tidyCalgemWellsData2("1/1/2005", "12/31/2019")

#.........................................................................
# sets up map layers

lyr_block_groups <- st_read("data/raw/us_census/acs/2019/2019_BlockGroups") %>%
  st_transform(crs_nad83) %>%
  st_intersection(la_county)
lyr_wells_preproduction <- wells_2005_2019 %>%
  filter(preprod_during_period == 1) %>%
  as_tibble() %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  st_intersection(la_county)
lyr_wells_production <- wells_2005_2019 %>%
  filter(prod_during_period == 1) %>%
  as_tibble() %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  st_intersection(la_county)
lyr_wells_postproduction <- wells_2005_2019 %>%
  filter(postprod_during_period == 1) %>%
  as_tibble() %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  st_intersection(la_county)

# generates buffers
lyr_preproduction_buffer <- lyr_wells_preproduction %>%
  st_transform(crs_projected) %>%
  st_buffer(dist = 1000) %>%
  st_transform(crs_nad83) %>%
  st_union()
lyr_production_buffer <- lyr_wells_production %>%
  st_transform(crs_projected) %>%
  st_buffer(dist = 1000) %>%
  st_transform(crs_nad83) %>%
  st_union()
lyr_postproduction_buffer <- lyr_wells_postproduction %>%
  st_transform(crs_projected) %>%
  st_buffer(dist = 1000) %>%
  st_transform(crs_nad83) %>%
  st_union()

# generates other mapping elements
lyr_highlight <- read_sf("data/raw/us_census/acs/2019/2019_BlockGroups") %>%
  filter(GEOID == "060375437031")
lyr_highlight2 <- read_sf("data/raw/us_census/acs/2019/2019_BlockGroups") %>%
  filter(GEOID == "060375437022")
lyr_centroid <- read_sf("data/raw/us_census/acs/2019/2019_BlockGroups") %>%
  filter(GEOID == "060375437031") %>%
  select(GEOID, geometry) %>% 
  st_centroid()
lyr_buffer_1km <- lyr_centroid %>%
  st_transform(crs_projected) %>%
  st_buffer(dist = 1000) %>%
  st_transform(crs_nad83)


#----------------------------------------------------------------------------
# makes manuscript figure

#.........................................................................
# Fig. 2a - areal apportionment 

figure_2a <- ggplot () + 
  geom_sf(data = lyr_block_groups,
          fill = "grey87", color = "white", alpha = 0.9, lwd = 0.3) +
          # fill = "grey87", color = "white", alpha = 0.9, lwd = 0.3) +
  #geom_sf_label(data = lyr_block_groups, aes(label = GEOID)) +
  geom_sf(data = lyr_postproduction_buffer,
          fill = "black", linetype = "dashed", alpha = 0.05) +
  geom_sf(data = lyr_production_buffer,
          fill = "#8A2BE2", color = "#8A2BE2", linetype = "dashed", alpha = 0.05) +
  geom_sf(data = lyr_preproduction_buffer,
          fill = "#FF7F00", color = "#FF7F00", linetype = "dashed", alpha = 0.05) +
  geom_sf(data = lyr_highlight,  # highlighted block group
          fill = "gold", color = "white", alpha = 0.5, lwd = 0.6) +
  geom_sf(data = lyr_wells_postproduction, 
          color = "#909090", shape = 7, size = 2) +  # dark gray
  geom_sf(data = lyr_wells_production,     
          color = "#8A2BE2", shape = 4, size = 3) +  # purple
  geom_sf(data = lyr_wells_preproduction,  
          color = "#FF7F00", shape = 4, size = 3) +  # orange
  xlim(-118.30, -118.24) + ylim(33.779, 33.829) +
  theme_void()
ggsave(filename = "figure_2a.png", plot = figure_2a, device = "png",
       width = 5, height = 5, path = "output/figures/components/")

#.........................................................................
# Fig. 2b - centroid + buffer

figure_2b <- ggplot () + 
  geom_sf(data = lyr_block_groups,
          fill = "grey87", color = "white", alpha = 0.9, lwd = 0.3) +
  geom_sf(data = lyr_buffer_1km, fill = "black", color = NA, alpha = 0.2) +
  geom_sf(data = lyr_highlight,  # highlighted block group
          fill = "gold", color = "white", alpha = 0.5, lwd = 0.6) +
  geom_sf(data = lyr_wells_postproduction, 
          color = "#909090", shape = 7, size = 2) +  # dark gray
  geom_sf(data = lyr_wells_production,     
          color = "#8A2BE2", shape = 4, size = 3) +  # purple
  geom_sf(data = lyr_wells_preproduction,  
          color = "#FF7F00", shape = 4, size = 3) +  # orange
  geom_sf(data = lyr_centroid) +
  geom_sf(data = lyr_buffer_1km, fill = NA) +
  xlim(-118.30, -118.24) + ylim(33.779, 33.829) +
  annotation_scale() +
  theme_void()
ggsave(filename = "figure_2b.png", plot = figure_2b, device = "png",
       width = 5, height = 5, path = "output/figures/components/")



#----------------------------------------------------------------------------
# makes presentation figure

#.........................................................................
# i - base figure
pres_figure_2_i <- ggplot () + 
  geom_sf(data = lyr_block_groups,
          fill = "black", color = "white", alpha = 0.3, lwd = 0.4) +
  geom_sf(data = lyr_highlight,  # highlighted block group
          fill = "gold", color = "white", alpha = 0.5, lwd = 1) +
  geom_sf(data = lyr_wells_production, color = "black", shape = 4, size = 3) +
  xlim(-118.332, -118.296) + ylim(33.799, 33.823) +
  theme_void() +
  theme(legend.position = "bottom") +
  annotation_scale()
# exports figure
ggsave(filename = "pres_figure_2_i.png", plot = pres_figure_2_i, device = "png",
       width = 6, height = 4.8, path = "output/figures/")

#.........................................................................
# ii - areal apportionment
pres_figure_2_ii <- ggplot () + 
  geom_sf(data = lyr_block_groups,
          fill = "black", color = "white", alpha = 0.3, lwd = 0.4) +
  geom_sf(data = lyr_wells_buffer, fill  = "black", color = "black", alpha = 0.3) +
  geom_sf(data = lyr_highlight,  # highlighted block group
          fill = "gold", color = "white", alpha = 0.5, lwd = 1) +
  geom_sf(data = lyr_wells_production, color = "black", shape = 4, size = 3) +
  xlim(-118.332, -118.296) + ylim(33.799, 33.823) +
  theme_void() +
  theme(legend.position = "bottom") +
  annotation_scale()
# exports figure
ggsave(filename = "pres_figure_2_ii.png", plot = pres_figure_2_ii, device = "png",
       width = 6, height = 4.8, path = "output/figures/")

#.........................................................................
# iii - areal apportionment, second block group
pres_figure_2_iii <- ggplot () + 
  geom_sf(data = lyr_block_groups,
          fill = "black", color = "white", alpha = 0.3, lwd = 0.4) +
  geom_sf(data = lyr_wells_buffer, fill  = "black", color = "black", alpha = 0.3) +
  geom_sf(data = lyr_highlight2,  # highlighted block group
          fill = "gold", color = "white", alpha = 0.5, lwd = 1) +
  geom_sf(data = lyr_wells_buffer, fill  = NA, color = "black", alpha = 0.3) +
  geom_sf(data = lyr_wells_production, color = "black", shape = 4, size = 3) +
  xlim(-118.332, -118.296) + ylim(33.799, 33.823) +
  theme_void() +
  theme(legend.position = "bottom") +
  annotation_scale()
# exports figure
ggsave(filename = "pres_figure_2_iii.png", plot = pres_figure_2_iii, device = "png",
       width = 6, height = 4.8, path = "output/figures/")

#.........................................................................
# iv - centroid

pres_figure_2_iv <- ggplot () + 
  geom_sf(data = lyr_block_groups,
          fill = "black", color = "white", alpha = 0.3, lwd = 0.4) +
  geom_sf(data = lyr_highlight,  # highlighted block group
          fill = "gold", color = "white", alpha = 0.5, lwd = 1) +
  geom_sf(data = lyr_wells_production, color = "black", shape = 4, size = 3) +
  geom_sf(data = lyr_centroid) +
  xlim(-118.332, -118.296) + ylim(33.799, 33.823) +
  theme_void() +
  theme(legend.position = "bottom") +
  annotation_scale()
# exports figure
ggsave(filename = "pres_figure_2_iv.png", plot = pres_figure_2_iv, device = "png",
       width = 6, height = 4.8, path = "output/figures/")

#.........................................................................
# v - centroid + buffer

pres_figure_2_v <- ggplot () + 
  geom_sf(data = lyr_block_groups,
          fill = "black", color = "white", alpha = 0.3, lwd = 0.4) +
  geom_sf(data = lyr_highlight,  # highlighted block group
          fill = "gold", color = "white", alpha = 0.5, lwd = 1) +
  geom_sf(data = lyr_wells_production, color = "black", shape = 4, size = 3) +
  geom_sf(data = lyr_centroid) +
  geom_sf(data = lyr_buffer_1km, fill = NA, linetype = "dashed") +
  xlim(-118.332, -118.296) + ylim(33.799, 33.823) +
  theme_void() +
  theme(legend.position = "bottom") +
  annotation_scale()
# exports figure
ggsave(filename = "pres_figure_2_v.png", plot = pres_figure_2_v, device = "png",
       width = 6, height = 4.8, path = "output/figures/")

##============================================================================##