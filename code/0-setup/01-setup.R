##============================================================================##
## 0.1 - attaches necessary packages and defines global variables

# installs packages necessary in this project; only need to run once
#install.packages(c("tidyverse", "sf"))  # uncomment as needed

# attaches generally needed packages
library("sf")
library("tidyverse")
library("RColorBrewer")
library("viridis")

# defines "not in" operator, the inverse of %in%
'%!in%' <- function(x,y)!('%in%'(x,y))

# coordinate reference system (CRS) for the project
crs_nad83  <- st_crs(4269)  # NAD83 coordinate reference system
crs_wgs84  <- st_crs(4326)  # WGS84 coordinate reference system
crs_albers <- st_crs(5070)  # Albers Equal-Area Conic projection, contiguous US
crs_alaska <- st_crs(3338)  # Albers Equal-Area Conic projection, Alaska 

##============================================================================##

