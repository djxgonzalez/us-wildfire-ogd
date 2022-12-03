##============================================================================##
## 4.02 - makes Figure 1 - (a) map of U.S. with study region with extent of
## wildfires by year and areas with oil and gas wells

##---------------------------------------------------------------------------
## sets up environment
library("ggrepel")
library("ggspatial")

# data input, prep layers for mapping ......................................
us_states_west <- st_read("data/raw/us_census/tl_2018_us_state.shp") %>% 
  filter(STUSPS %in% c("WA", "OR", "CA", "ID", "NV", "AZ", "MT", "WY", "UT",
                      "CO", "NM", "ND", "SD", "NE", "KS", "OK", "TX", "MO",
                      "AR", "LA")) %>%
  st_geometry() %>%
  st_transform(crs_nad83)
us_states_east <- st_read("data/raw/us_census/tl_2018_us_state.shp") %>%
  filter(STUSPS %!in% c("WA", "OR", "CA", "ID", "NV", "AZ", "MT", "WY", "UT",
                        "CO", "NM", "ND", "SD", "NE", "KS", "OK", "TX", "MO",
                        "AR", "LA")) %>% 
  filter(NAME %!in% c("American Samoa", "Guam", "Puerto Rico", 
                      "Commonwealth of the Northern Mariana Islands",
                      "United States Virgin Islands", "Hawaii")) %>%
  st_geometry() %>%
  st_transform(crs_nad83)
mex_can <- st_read("data/raw/esri/Countries_WGS84.shp") %>% 
  filter(CNTRY_NAME %in% c("Canada", "Mexico")) %>%
  st_geometry() %>%
  st_transform(crs_nad83)
rus_can <- st_read("data/raw/esri/Countries_WGS84.shp") %>% 
  filter(CNTRY_NAME %in% c("Canada", "Russia")) %>%
  st_geometry() %>%
  st_transform(crs_nad83)

##### note: we need to re-generate these datasets to add the new states (MN>LA)
# fires data
wildfires_1984 <- readRDS("data/interim/wildfires_union_contiguous_1984.rds") %>%
  st_geometry()
wildfires_1985 <- readRDS("data/interim/wildfires_union_contiguous_1985.rds") %>%
  st_geometry()
wildfires_1986 <- readRDS("data/interim/wildfires_union_contiguous_1986.rds") %>%
  st_geometry()
wildfires_1987 <- readRDS("data/interim/wildfires_union_contiguous_1987.rds") %>%
  st_geometry()
wildfires_1988 <- readRDS("data/interim/wildfires_union_contiguous_1988.rds") %>%
  st_geometry()
wildfires_1989 <- readRDS("data/interim/wildfires_union_contiguous_1989.rds") %>%
  st_geometry()
wildfires_1990 <- readRDS("data/interim/wildfires_union_contiguous_1990.rds") %>%
  st_geometry()
wildfires_1991 <- readRDS("data/interim/wildfires_union_contiguous_1991.rds") %>%
  st_geometry()
wildfires_1992 <- readRDS("data/interim/wildfires_union_contiguous_1992.rds") %>%
  st_geometry()
wildfires_1993 <- readRDS("data/interim/wildfires_union_contiguous_1993.rds") %>%
  st_geometry()
wildfires_1994 <- readRDS("data/interim/wildfires_union_contiguous_1994.rds") %>%
  st_geometry()
wildfires_1995 <- readRDS("data/interim/wildfires_union_contiguous_1995.rds") %>%
  st_geometry()
wildfires_1996 <- readRDS("data/interim/wildfires_union_contiguous_1996.rds") %>%
  st_geometry()
wildfires_1997 <- readRDS("data/interim/wildfires_union_contiguous_1997.rds") %>%
  st_geometry()
wildfires_1998 <- readRDS("data/interim/wildfires_union_contiguous_1998.rds") %>%
  st_geometry()
wildfires_1999 <- readRDS("data/interim/wildfires_union_contiguous_1999.rds") %>%
  st_geometry()
wildfires_2000 <- readRDS("data/interim/wildfires_union_contiguous_2000.rds") %>%
  st_geometry()
wildfires_2001 <- readRDS("data/interim/wildfires_union_contiguous_2001.rds") %>%
  st_geometry()
wildfires_2002 <- readRDS("data/interim/wildfires_union_contiguous_2002.rds") %>%
  st_geometry()
wildfires_2003 <- readRDS("data/interim/wildfires_union_contiguous_2003.rds") %>%
  st_geometry()
wildfires_2004 <- readRDS("data/interim/wildfires_union_contiguous_2004.rds") %>%
  st_geometry()
wildfires_2005 <- readRDS("data/interim/wildfires_union_contiguous_2005.rds") %>%
  st_geometry()
##### error making 2006 data; need to fix
# wildfires_2006 <- readRDS("data/interim/wildfires_union_contiguous_2006.rds") %>%
#   st_geometry()
wildfires_2007 <- readRDS("data/interim/wildfires_union_contiguous_2007.rds") %>%
  st_geometry()
wildfires_2008 <- readRDS("data/interim/wildfires_union_contiguous_2008.rds") %>%
  st_geometry()
wildfires_2009 <- readRDS("data/interim/wildfires_union_contiguous_2009.rds") %>%
  st_geometry()
wildfires_2010 <- readRDS("data/interim/wildfires_union_contiguous_2010.rds") %>%
  st_geometry()
wildfires_2011 <- readRDS("data/interim/wildfires_union_contiguous_2011.rds") %>%
  st_geometry()
wildfires_2012 <- readRDS("data/interim/wildfires_union_contiguous_2012.rds") %>%
  st_geometry()
wildfires_2013 <- readRDS("data/interim/wildfires_union_contiguous_2013.rds") %>%
  st_geometry()
wildfires_2014 <- readRDS("data/interim/wildfires_union_contiguous_2014.rds") %>%
  st_geometry()
wildfires_2015 <- readRDS("data/interim/wildfires_union_contiguous_2015.rds") %>%
  st_geometry()
wildfires_2016 <- readRDS("data/interim/wildfires_union_contiguous_2016.rds") %>%
  st_geometry()
wildfires_2017 <- readRDS("data/interim/wildfires_union_contiguous_2017.rds") %>%
  st_geometry()
wildfires_2018 <- readRDS("data/interim/wildfires_union_contiguous_2018.rds") %>%
  st_geometry()
wildfires_2019 <- readRDS("data/interim/wildfires_union_contiguous_2019.rds") %>%
  st_geometry()
wildfires_2020 <- readRDS("data/interim/wildfires_union_contiguous_2020.rds") %>%
  st_geometry()


##### may need to edit this; computationally intensive!


####


# lakes <- st_read("data/raw/noaa/gshhg-shp-2.3.7/GSHHS_shp/l/GSHHS_l_L2.shp") %>%
#   st_make_valid() %>%
#   st_transform(crs_nad83) %>%
#   st_union()


##---------------------------------------------------------------------------
## Manuscript figures

#.........................................................................
# panel a1 - western states (except AL)

# makes figure
figure_1a <- ggplot() +
  geom_sf(data = mex_can, fill = "#DCDCDC", color = NA, alpha = 0.7) +
  geom_sf(data = us_states_east, fill = "#DCDCDC", color = "#ffffff", lwd = 0.3) +
  geom_sf(data = us_states_west, fill = "#E6E9E0", color = "#ffffff", lwd = 0.3) +
  geom_sf(data = wildfires_1984, fill = "purple", color = NA, alpha = 0.3) +
  geom_sf(data = wildfires_1985, fill = "purple", color = NA, alpha = 0.3) +
  geom_sf(data = wildfires_1986, fill = "purple", color = NA, alpha = 0.3) +
  geom_sf(data = wildfires_1987, fill = "purple", color = NA, alpha = 0.3) +
  geom_sf(data = wildfires_1988, fill = "purple", color = NA, alpha = 0.3) +
  geom_sf(data = wildfires_1989, fill = "purple", color = NA, alpha = 0.3) +
  geom_sf(data = wildfires_1990, fill = "yellow", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1991, fill = "yellow", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1992, fill = "yellow", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1993, fill = "yellow", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1994, fill = "yellow", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1995, fill = "yellow", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1996, fill = "yellow", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1997, fill = "yellow", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1998, fill = "yellow", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_1999, fill = "yellow", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2000, fill = "orange", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2001, fill = "orange", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2002, fill = "orange", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2003, fill = "orange", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2004, fill = "orange", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2005, fill = "orange", color = NA, alpha = 0.6) +
  # geom_sf(data = wildfires_2006, fill = "orange", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2007, fill = "orange", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2008, fill = "orange", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2009, fill = "orange", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2010, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2011, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2012, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2013, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2014, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2015, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2016, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2017, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2018, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2019, fill = "red", color = NA, alpha = 0.6) +
  geom_sf(data = wildfires_2020, fill = "red", color = NA, alpha = 0.6) +
  #geom_sf(data = lakes, fill = "#e9f5f8", color = NA) +  ##### may not need this
  ##### add wildfires layer
  xlim(-125, -89) + ylim(26, 49) +
  labs(x = "", y = "") +
  theme_bw() +
  theme(panel.background = element_rect(fill  = "#e9f5f8"),  # d0ecfd
        panel.grid       = element_line(color = "#e9f5f8"),  # e8f4f8
        legend.position = "none")
#figure_1a
# export
ggsave(filename = "figure_1a.png", plot = figure_1a, device = "png",
       height = 9.75, width = 10, path = "output/figures/components/")

#.........................................................................
# panel aa - same as A, but including Alaska

# makes figure
figure_1aa <- ggplot()
figure_1aa

# export
ggsave(filename = "figure_1aa.png", plot = figure_1aa, device = "png",
       height = 5, width = 5, path = "output/figures/")


#.........................................................................
# panel b - 

# makes figure
figure_1b <- ggplot()

# export
ggsave(filename = "figure_1b.png", plot = figure_1b, device = "png",
       height = 5, width = 5, path = "output/figures/")



##============================================================================##