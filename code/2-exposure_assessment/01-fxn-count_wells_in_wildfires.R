##============================================================================##
## 2.01 - defines function to flexibily count wells in individual wildwildfires,
## either within the wildwildfire boundaries (buffer_dist of 0) or within 1 km

assessExposureCount <- function(wildfire, 
                                wells,
                                buffer_dist,
                                exp_variable,
                                coord_ref) {
  # generates buffer of given distance around the polygon
  wildfire <- wildfire %>% 
    st_transform(st_crs(coord_ref)) %>%  # Albers for contiguous U.S. or Alaska
    st_buffer(dist = buffer_dist) %>%
    st_transform(crs_nad83)
  
  # counts wells within the polygon ......................................
  wildfire <- wildfire %>%  
    mutate(!!as.name(exp_variable) :=  # flexibly names the variable on input
             sum(unlist(st_intersects(wells, wildfire)))) %>%
    as_tibble() %>% 
    dplyr::select(-geometry) 
  
  # returns the processed exposure data ..................................
  return(wildfire)
  
}

##============================================================================##