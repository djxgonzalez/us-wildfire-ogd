##============================================================================##
## 2.11 - defines function to flexibility estimate, for each wildfire, the 
## number of people that lived within 1 km of wells that were in the burn area

assessPopulationWellsWildfire <- 
  function(wildfire, 
           wells,
           pop_grid,
           exp_variable) {
    
    # omits wells where the year of the earliest operational date was after the
    # year of the wildfire; retains NA dates, too, presumed to pre-date the
    # study period given poor record keeping prior to 1980s
    wells <- wells %>% filter(year(date_earliest) <= wildfire$year |
                                is.na(date_earliest))
    
    # identifies wells that intersect with the wildfire
    wells_wildfires_buffer <- st_intersection(wildfire, wells) %>% 
      # generates 1 km buffer around wells that intersect with the wildfire
      st_buffer(dist = 1000) %>% 
      st_union()
    
    # sums population in the intersection between wildfires and wells buffer
    wildfire <- wildfire %>%  
      mutate(!!as.name(exp_variable) :=  # flexibly names the variable on input
               ###### edit this line:
               sum(unlist(st_intersects(wells, wildfire)))) %>%
      as_tibble() %>% 
      dplyr::select(-geometry) 
    
    # returns the processed exposure data ..................................
    return(wildfire)
    
  }

##============================================================================##