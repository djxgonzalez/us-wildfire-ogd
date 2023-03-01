##============================================================================##
## 2.10 - preps data needed to estimate population exposed to wells in wildfires
## by buffering 


## setup ---------------------------------------------------------------------

# attaches packages ........................................................
source("code/0-setup/01-setup.R")
library("lubridate")

# data input ...............................................................
wells_all <- readRDS("data/interim/wells_all.rds") %>% 
  st_transform(crs_albers)
wildfires_1984 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1984.rds")
wildfires_1985 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1985.rds")
wildfires_1986 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1986.rds")
wildfires_1987 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1987.rds")
wildfires_1988 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1988.rds")
wildfires_1989 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1989.rds")
wildfires_1990 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1990.rds")
wildfires_1991 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1991.rds")
wildfires_1992 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1992.rds")
wildfires_1993 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1993.rds")
wildfires_1994 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1994.rds")
wildfires_1995 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1995.rds")
wildfires_1996 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1996.rds")
wildfires_1997 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1997.rds")
wildfires_1998 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1998.rds")
wildfires_1999 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1999.rds")
wildfires_2000 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2000.rds")
wildfires_2001 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2001.rds")
wildfires_2002 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2002.rds")
wildfires_2003 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2003.rds")
wildfires_2004 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2004.rds")
wildfires_2005 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2005.rds")
wildfires_2006 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2006.rds")
wildfires_2007 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2007.rds")
wildfires_2008 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2008.rds")
wildfires_2009 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2009.rds")
wildfires_2010 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2010.rds")
wildfires_2011 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2011.rds")
wildfires_2012 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2012.rds")
wildfires_2013 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2013.rds")
wildfires_2014 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2014.rds")
wildfires_2015 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2015.rds")
wildfires_2016 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2016.rds")
wildfires_2017 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2017.rds")
wildfires_2018 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2018.rds")
wildfires_2019 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2019.rds")


## assessment by state -------------------------------------------------------
## for state-years with >= 1 well within wildfire burn areas, identifies wells
## within wildfire boundaries and buffers those areas by 1 km

# AR .......................................................................
wells_in <- wells_all %>% filter(state == "AR")
for(year in c(1986:1987, 1989, 1995, 1998, 2000, 2003:2007, 2010:2011, 
              2013:2019)) {
  wells_in %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest)) %>% 
    st_intersection(eval(parse(text = (paste("wildfires_", year, sep = ""))))) %>% 
    st_buffer(dist = 1000) %>% 
    st_union() %>% 
    saveRDS(paste("data/interim/wells_wildfire_intersection_state_year/ar_",
                  year, sep = ""))
}

# CA .......................................................................
wells_in <- wells_all %>% filter(state == "CA")
for(year in c(1984:2019)) {
  wells_in %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest)) %>% 
    st_intersection(eval(parse(text = (paste("wildfires_", year, sep = ""))))) %>% 
    st_buffer(dist = 1000) %>% 
    st_union() %>% 
    saveRDS(paste("data/interim/wells_wildfire_intersection_state_year/ca_",
                  year, sep = ""))
}




##============================================================================##