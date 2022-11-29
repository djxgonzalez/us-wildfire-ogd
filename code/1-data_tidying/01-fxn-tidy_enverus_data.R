##============================================================================##
## 1.1 - function to tidy the Enverus wells data

# cleans and prepares raw Enverus input data for further analysis
tidyEnverusWellsData <- function(wells) {
  
  # captures well coordinates so we can re-join them later
  wells <- wells %>% 
    mutate(api_number      = as.factor(API_UWI),
           #county_parish   = as.factor(`County/Parish`),
           state           = as.factor(State),
           #latitude        = latitude_WGS84,
           #longitude       = longitude_WGS84,
           #cumulative_boe  = `Cum BOE`,  # BOE = barrels of oil equivalent
           production_type = as.factor(Production_Type),
           drill_type      = as.factor(Drill_Type),
           #operator        = TBD,
           spud_date       = Spud_Date, #Spud Date = date the well was 1st drilled 
           completion_date = Completion_Date, 
           first_prod_date = First_Prod_Date, #1st date of production
           last_prod_date  = Last_Prod_Date) %>% #Last date of production
    dplyr::select(api_number:last_prod_date)
  
  # returns tidied dataset
  return(wells)
}

##============================================================================##
