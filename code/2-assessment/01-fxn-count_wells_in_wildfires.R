##============================================================================##
## 2.01 - defines function to flexibility count wells in individual wildfires,
## either within the wildfire boundaries (buffer_dist of 0) or within 1 km

assessExposureCount <- 
  function(wildfire, 
           wells,
           buffer_dist,
           exp_variable) {
    
    # omits wells where the year of the earliest operational date was after the
    # year of the wildfire; retains NA dates, too, presumed to pre-date the
    # study period given poor record keeping prior to 1980s
    wells <- wells %>% filter(year(date_earliest) <= wildfire$year |
                                is.na(date_earliest))
    
    # generates buffer of given distance around the polygon
    wildfire <- wildfire %>% st_buffer(dist = buffer_dist)
    
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