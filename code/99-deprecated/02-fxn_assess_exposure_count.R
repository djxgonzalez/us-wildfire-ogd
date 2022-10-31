##============================================================================##
## 2.02 - re-write description up here

assessExposureCount <- function(data_polygon, 
                                wells,
                                buffer,
                                exp_variable) {
  # prepares wells data ..................................................
  
  # generates buffer of given distance around the polygon
  data_polygon <- data_polygon %>% 
    st_transform(crs_projected) %>%
    st_buffer(dist = buffer) %>%
    st_transform(crs_nad83)
  
  # counts wells within the polygon ......................................
  data_polygon <- data_polygon %>%  
    mutate(!!as.name(exp_variable) :=  # flexibly names the variable on input
             sum(unlist(st_intersects(wells, data_polygon)))) %>%
    as_tibble() %>% 
    dplyr::select(-geometry) 
  
  # returns the processed exposure data ..................................
  return(data_polygon)
  
}

##============================================================================##