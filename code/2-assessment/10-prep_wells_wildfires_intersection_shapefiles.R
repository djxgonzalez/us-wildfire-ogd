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
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1984.rds") %>% 
  st_transform(crs_albers)
wildfires_1985 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1985.rds") %>% 
  st_transform(crs_albers)
wildfires_1986 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1986.rds") %>% 
  st_transform(crs_albers)
wildfires_1987 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1987.rds") %>% 
  st_transform(crs_albers)
wildfires_1988 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1988.rds") %>% 
  st_transform(crs_albers)
wildfires_1989 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1989.rds") %>% 
  st_transform(crs_albers)
wildfires_1990 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1990.rds") %>% 
  st_transform(crs_albers)
wildfires_1991 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1991.rds") %>% 
  st_transform(crs_albers)
wildfires_1992 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1992.rds") %>% 
  st_transform(crs_albers)
wildfires_1993 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1993.rds") %>% 
  st_transform(crs_albers)
wildfires_1994 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1994.rds") %>% 
  st_transform(crs_albers)
wildfires_1995 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1995.rds") %>% 
  st_transform(crs_albers)
wildfires_1996 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1996.rds") %>% 
  st_transform(crs_albers)
wildfires_1997 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1997.rds") %>% 
  st_transform(crs_albers)
wildfires_1998 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1998.rds") %>% 
  st_transform(crs_albers)
wildfires_1999 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_1999.rds") %>% 
  st_transform(crs_albers)
wildfires_2000 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2000.rds") %>% 
  st_transform(crs_albers)
wildfires_2001 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2001.rds") %>% 
  st_transform(crs_albers)
wildfires_2002 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2002.rds") %>% 
  st_transform(crs_albers)
wildfires_2003 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2003.rds") %>% 
  st_transform(crs_albers)
wildfires_2004 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2004.rds") %>% 
  st_transform(crs_albers)
wildfires_2005 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2005.rds") %>% 
  st_transform(crs_albers)
wildfires_2006 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2006.rds") %>% 
  st_transform(crs_albers)
wildfires_2007 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2007.rds") %>% 
  st_transform(crs_albers)
wildfires_2008 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2008.rds") %>% 
  st_transform(crs_albers)
wildfires_2009 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2009.rds") %>% 
  st_transform(crs_albers)
wildfires_2010 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2010.rds") %>% 
  st_transform(crs_albers)
wildfires_2011 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2011.rds") %>% 
  st_transform(crs_albers)
wildfires_2012 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2012.rds") %>% 
  st_transform(crs_albers)
wildfires_2013 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2013.rds") %>% 
  st_transform(crs_albers)
wildfires_2014 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2014.rds") %>% 
  st_transform(crs_albers)
wildfires_2015 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2015.rds") %>% 
  st_transform(crs_albers)
wildfires_2016 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2016.rds") %>% 
  st_transform(crs_albers)
wildfires_2017 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2017.rds") %>% 
  st_transform(crs_albers)
wildfires_2018 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2018.rds") %>% 
  st_transform(crs_albers)
wildfires_2019 <-
  readRDS("data/interim/wildfire_years/wildfires_union_contiguous_2019.rds") %>% 
  st_transform(crs_albers)


## assessment by state -------------------------------------------------------
# defines function to identify wells within wildfire boundaries, generate  1 km
# buffers around those wells for each state-year, and flexibly export each
# layer as a RDS file with a unique name for each state-year
makeIntersectionZone <- function(wells_in, year, state_prefix){
  wells_in %>% 
    filter(year(date_earliest) <= year | is.na(date_earliest)) %>% 
    st_intersection(
      st_make_valid(
        eval(parse(text = 
                     (paste("wildfires_", year, sep = "")))))) %>% 
    st_buffer(dist = 1000) %>% 
    st_union() %>% 
    st_make_valid() %>% 
    saveRDS(paste("data/interim/wells_wildfire_intersection_state_year/",
                  state_prefix, "_", year, ".rds", sep = ""))
}


## assessment by state -------------------------------------------------------
# for each state-year *with* > 0 wells in wildfire burn areas (which we 
# previously assessed), calls the function defined above to outputs
# state-year `sf` objects with 1 km buffers around wells in wildfire burn areas

# AR .......................................................................
wells_in <- wells_all %>% filter(state == "AR")
for(year in c(1986:1987, 1989, 1995, 1998, 2000, 2003:2007, 2010:2011, 
              2013:2019)) {
  makeIntersectionZone(wells_in, year, "ar")
}

# CA .......................................................................
wells_in <- wells_all %>% filter(state == "CA")
for(year in c(1984:2013, 2015:2019)) { 
  makeIntersectionZone(wells_in, year, "ca")
}

# CO .......................................................................
wells_in <- wells_all %>% filter(state == "CO")
for(year in c(1985:1987, 1989, 1994, 1996, 2000:2002, 2004:2008, 2011:2019)) {
  makeIntersectionZone(wells_in, year, "co")
}

# KS .......................................................................
wells_in <- wells_all %>% filter(state == "KS")
#for(year in c(1986:1998, 2000:2019)) {
for(year in c(2014, 2017)) { ##### need to fix 2011, 2014, 2017
  makeIntersectionZone(wells_in, year, "ks")
}

# LA .......................................................................
wells_in <- wells_all %>% filter(state == "LA")
for(year in c(1985, 1987, 1989, 1993, 1995:2007, 2009:2011, 2013:2019)) {
  makeIntersectionZone(wells_in, year, "la")
}

# MT .......................................................................
wells_in <- wells_all %>% filter(state == "MT")
for(year in c(1988, 1991, 1999, 2003:2004, 2006:2008, 2010, 2012, 2017:2018)) {
  makeIntersectionZone(wells_in, year, "mt")
}

# ND .......................................................................
wells_in <- wells_all %>% filter(state == "ND")
for(year in c(1988:1989, 1992, 1994, 1999:2000, 2003:2005, 2007:2008, 2012,
              2015, 2017)) {
  makeIntersectionZone(wells_in, year, "nd")
}

# NE .......................................................................
wells_in <- wells_all %>% filter(state == "NE")
makeIntersectionZone(wells_in, 2002, "ne") # only 1 year with wells in wildfires

# NM .......................................................................
wells_in <- wells_all %>% filter(state == "NM")
for(year in c(1986:2001, 2005:2014, 2016:2019)) {
  makeIntersectionZone(wells_in, year, "nm")
}

# OK .......................................................................
wells_in <- wells_all %>% filter(state == "OK")
#for(year in c(1991, 1994:1998, 2000:2019)) {
for(year in c(2014)) {  ###### need to fix 2014
  makeIntersectionZone(wells_in, year, "ok")
}

# SD .......................................................................
wells_in <- wells_all %>% filter(state == "SD")
for(year in c(1984:1985, 1988, 1999:2003, 2006:2007, 2011:2012, 2015:2016)) {
  makeIntersectionZone(wells_in, year, "sd")
}

# TX .......................................................................
wells_in <- wells_all %>% filter(state == "TX")
for(year in c(1986:2019)) {
  makeIntersectionZone(wells_in, year, "tx")
}

# UT .......................................................................
wells_in <- wells_all %>% filter(state == "UT")
for(year in c(1988:1989, 1994:1995, 1998:2002, 2004:2010, 2012, 2016:2018)) {
  makeIntersectionZone(wells_in, year, "ut")
}

# WY .......................................................................
wells_in <- wells_all %>% filter(state == "WY")
for(year in c(1988, 1991:1992, 1996, 1998:2007, 2009:2012, 2015:2019)) {
  makeIntersectionZone(wells_in, year, "wy")
}

# Note: We opted to use a for loop to run this assessment, but it may make sense
# to do this with lapply. To do so, we'd need to generate a list object with, 
# for each state-year, the wells that were drilled during or prior to that year.
# Given that this list object will take up a good amount of RAM, it was unclear
# to us whether it'd be more efficient than the for loop approach.

##============================================================================##