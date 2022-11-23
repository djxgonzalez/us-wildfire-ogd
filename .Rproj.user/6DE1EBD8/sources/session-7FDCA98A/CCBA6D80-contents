##============================================================================##
## 2.02 - generalized function to assess exposure by counting the number of
## wells in buffer out from centroid

# takes centroid coordinates ('centroid') as an sf object, generates 1-km annuli
# around the centroid out to 3 km, and counts the number of well sites in 
# preproduction within the annulus

assessExposureAnnuliCount <- function(data_polygon, 
                                      wells,
                                      exp_variable) {
  
  
  # prepares the centroid dataset ........................................
  centroid      <- st_centroid(data_polygon)
  centroid_lat  <- st_coordinates(centroid)[2]
  centroid_long <- st_coordinates(centroid)[1]
  
  # prepares wells data ..................................................
  
  # generates 3 km buffer as a mask around centroid coordinates
  centroid_mask <- centroid %>% 
    st_transform(crs_projected) %>%
    st_buffer(dist = 3000) %>%
    st_transform(crs_nad83)
  
  # restricts to wells near centroid to improve efficiency
  wells_within_3km = wells %>% st_intersection(centroid_mask)
  
  # makes annuli around the block group centroids in the 'centroid' data
  annulus_0_1km <- centroid %>%
    st_transform(crs_projected) %>%
    st_buffer(dist = 1000) %>%
    st_transform(crs_nad83)
  annulus_1_2km <- centroid %>% 
    st_transform(crs_projected) %>%
    st_buffer(dist = 2000) %>%
    st_transform(crs_nad83)
  annulus_2_3km <- centroid_mask
  
  # finalizes annuli by successively clipping differences in reverse order
  annulus_2_3km <- st_difference(annulus_2_3km, annulus_1_2km)
  annulus_1_2km <- st_difference(annulus_1_2km, annulus_0_1km)
  
  # counts wells within each 1-km annulus ................................
  data_polygon <- data_polygon %>%  
    mutate(!!as.name(paste(exp_variable, sep = "_", "0_1km")) :=   
             sum(unlist(st_intersects(wells_within_3km, annulus_0_1km))),
           !!as.name(paste(exp_variable, sep = "_", "1_2km")) := 
             sum(unlist(st_intersects(wells_within_3km, annulus_1_2km))),
           !!as.name(paste(exp_variable, sep = "_", "2_3km")) := 
             sum(unlist(st_intersects(wells_within_3km, annulus_2_3km)))) %>%
    as_tibble() %>% 
    dplyr::select(-geometry) 
  
  # returns the processed exposure data ..................................
  return(data_polygon)
  
}

##============================================================================##