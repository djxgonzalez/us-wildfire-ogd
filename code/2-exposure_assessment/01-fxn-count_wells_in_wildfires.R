##============================================================================##
## 2.01 - defines function to flexibily count wells in individual wildfires,
## either within the wildfire boundaries (buffer_dist of 0) or within 1 km

assessExposureCount <- function(fire, 
                                wells,
                                buffer_dist,
                                exp_variable,
                                coord_ref) {
  # generates buffer of given distance around the polygon
  fire <- fire %>% 
    st_transform(coord_ref) %>% 
    st_buffer(dist = buffer_dist) %>%
    st_transform(crs_nad83)
  
  # counts wells within the polygon ......................................
  fire <- fire %>%  
    mutate(!!as.name(exp_variable) :=  # flexibly names the variable on input
             sum(unlist(st_intersects(wells, fire)))) %>%
    as_tibble() %>% 
    dplyr::select(-geometry) 
  
  # returns the processed exposure data ..................................
  return(fire)
  
}

##============================================================================##