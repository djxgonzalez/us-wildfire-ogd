##============================================================================##
## 2.07 - 


## setup ---------------------------------------------------------------------

# attaches packages we need for this script
library("ncdf4")
library("graphics")
library("usethis") 
library("raster")
library("tidync")

# data input



## header 1 --------------------------------------------------------
## description




## header 2 --------------------------------------------------------
## description


##============================================================================##
## code from ___ at Columbia, adapt as needed

wells <- read_csv("enverus_wells_CA.csv")
wells$latit <- gsub("[()]", "", wells$latit)
wells$latit <- as.numeric(wells$latit)

# set path and filename
ncpath <- "~/Desktop/joan-nc/"
ncname2 <- "WRFlatlon"  
ncfname2 <- paste(ncpath, ncname2, ".nc", sep="")
dname2 <- "wfirelatlong" 

# open a netCDF file
ncin2 <- nc_open(ncfname2)
print(ncin2)


# get longitude and latitude
lon <- ncvar_get(ncin2,"lon")
nlon <- dim(lon)
head(lon)

lat <- ncvar_get(ncin2,"lat")
nlat <- dim(lat)
head(lat)

################################################################################

# set path and filename
ncpath <- "~/Desktop/joan-nc/"
ncname <- "Mean_KBDI_Summer_2086-2094_R8Y8"  
ncfname <- paste(ncpath, ncname, ".nc", sep="")
dname <- "KBDI" 

# open a netCDF file
ncin <- nc_open(ncfname)
print(ncin)

#read in wildfire raster
wf_raster <- raster(ncfname)

plot(wf_raster)

# get wildfire risk variable
tmp_array <- ncvar_get(ncin,dname)
dlname <- ncatt_get(ncin,dname,"long_name")
dunits <- ncatt_get(ncin,dname,"units")
fillvalue <- ncatt_get(ncin,dname,"_FillValue") # fills as na which is what we would want
dim(tmp_array)

wf_risk <- tmp_array


# put together lat long and risk into a dataframe:

x <- as.vector(lon)
y <- as.vector(lat)
z <- as.vector(wf_risk)

xyz <- as.data.frame(cbind(x=x, y=y,z=z))


wf_risk <- ggplot(data = xyz,aes(x = x, y = y, fill = z)) +
  geom_point()
wf_risk 



ggplot(data = xyz, aes(x = x, y = y, color = z)) +
  geom_point(size = 1, alpha = 0.5) +
  scale_color_viridis(direction = -1) + 
  theme_minimal()+
  geom_point(data = wells,aes(x = longitude, y = latit), color = "red") 


# it overlays
# zoom on cali

cali_xyz <- xyz %>%
  filter(x > -127 & x < -112 & y > 30 & y < 44)

ggplot(data = cali_xyz, aes(x = x, y = y, color = z)) +
  geom_point(size = 2, alpha = 0.5) +
  scale_color_viridis(direction = -1) + 
  theme_minimal()+
  geom_point(data = wells,aes(x = longitude, y = latit), color = "red", alpha = .5) 

# filter to active wells:
active_wells <- wells %>% filter(well_status == "ACTIVE")

ggplot(data = cali_xyz, aes(x = x, y = y, color = z)) +
  geom_point(size = 2, alpha = 0.5) +
  scale_color_viridis(direction = -1) + 
  theme_minimal()+
  geom_point(data = active_wells,aes(x = longitude, y = latit), color = "red", alpha = .5) +
  coord_cartesian()

##============================================================================##