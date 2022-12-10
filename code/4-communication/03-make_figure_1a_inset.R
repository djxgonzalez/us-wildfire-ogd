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

# combined 1 km well buffers for Alaska
buffers_ak_buffer_1km <- 
  readRDS("data/interim/wells_buffers/wells_ak_buffer_1km.rds")

# Alaska wildfire data by year
wildfires_1984 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1984.rds")
wildfires_1985 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1985.rds")
wildfires_1986 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1986.rds")
wildfires_1987 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1987.rds")
wildfires_1988 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1988.rds")
wildfires_1989 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1989.rds")
wildfires_1990 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1990.rds")
wildfires_1991 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1991.rds")
wildfires_1992 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1992.rds")
wildfires_1993 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1993.rds")
wildfires_1994 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1994.rds")
wildfires_1995 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1995.rds")
wildfires_1996 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1996.rds")
wildfires_1997 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1997.rds")
wildfires_1998 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1998.rds")
wildfires_1999 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_1999.rds")
wildfires_2000 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2000.rds")
wildfires_2001 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2001.rds")
wildfires_2002 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2002.rds")
wildfires_2003 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2003.rds")
wildfires_2004 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2004.rds")
wildfires_2005 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2005.rds")
wildfires_2006 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2006.rds")
wildfires_2007 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2007.rds")
wildfires_2008 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2008.rds")
wildfires_2009 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2009.rds")
wildfires_2010 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2010.rds")
wildfires_2011 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2011.rds")
wildfires_2012 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2012.rds")
wildfires_2013 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2013.rds")
wildfires_2014 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2014.rds")
wildfires_2015 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2015.rds")
wildfires_2016 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2016.rds")
wildfires_2017 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2017.rds")
wildfires_2018 <-
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2018.rds")
wildfires_2019 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2019.rds")
wildfires_2020 <- 
  readRDS("data/interim/wildfires_by_year/wildfires_union_alaska_2020.rds")


## Figure 1a inset ----------------------------------------------------------
## Wildfires (shaded by decade) and 1 km buffers around all wells in the 
## Alaska; similar to code for 4.02 to make figure 1a

# makes figure
figure_1a_inset <- ggplot() +
  geom_sf(data = rus_can,
          fill = "#DCDCDC", color = "white", lwd = 0.3, alpha = 0.7) +
  geom_sf(data = us_states_ak, 
          fill = "#E6E9E0", color = "white", lwd = 0.3) +
  geom_sf(data = wildfires_1984, fill = "#ffffb2", color = NA, alpha = 0.3) +
  geom_sf(data = wildfires_1985, fill = "#ffffb2", color = NA, alpha = 0.3) +
  geom_sf(data = wildfires_1986, fill = "#ffffb2", color = NA, alpha = 0.3) +
  geom_sf(data = wildfires_1987, fill = "#ffffb2", color = NA, alpha = 0.3) +
  geom_sf(data = wildfires_1988, fill = "#ffffb2", color = NA, alpha = 0.3) +
  geom_sf(data = wildfires_1989, fill = "#ffffb2", color = NA, alpha = 0.3) +
  geom_sf(data = wildfires_1990, fill = "#fecc5c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1991, fill = "#fecc5c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1992, fill = "#fecc5c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1993, fill = "#fecc5c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1994, fill = "#fecc5c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1995, fill = "#fecc5c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1996, fill = "#fecc5c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1997, fill = "#fecc5c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1998, fill = "#fecc5c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1999, fill = "#fecc5c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2000, fill = "#fd8d3c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2001, fill = "#fd8d3c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2002, fill = "#fd8d3c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2003, fill = "#fd8d3c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2004, fill = "#fd8d3c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2005, fill = "#fd8d3c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2006, fill = "#fd8d3c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2007, fill = "#fd8d3c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2008, fill = "#fd8d3c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2009, fill = "#fd8d3c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2010, fill = "#e31a1c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2011, fill = "#e31a1c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2012, fill = "#e31a1c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2013, fill = "#e31a1c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2014, fill = "#e31a1c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2015, fill = "#e31a1c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2016, fill = "#e31a1c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2017, fill = "#e31a1c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2018, fill = "#e31a1c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2019, fill = "#e31a1c", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2020, fill = "#e31a1c", color = NA, alpha = 0.6) +
  geom_sf(data = buffers_ak_buffer_1km,
          fill = "black", color = NA, alpha = 0.3) +
  xlim(-1100000, 1240000) + ylim(500000, 2300000) +
  labs(x = "", y = "") +
  theme_void() +
  theme(panel.background = element_rect(fill  = "#e9f5f8"),
        panel.grid       = element_line(color = "#e9f5f8"),
        legend.position = "none")

# export
ggsave(filename = "figure_1a_inset.png", plot = figure_1a_inset, device = "png",
       height = 4.8, width = 6.2, path = "output/figures/components/")


##============================================================================##