##============================================================================##
## 1.01 - function to tidy data from Enverus on wells in the study region

# cleans and prepares raw Enverus input data for further analysis
tidyWellsData <- function(wells) {
  wells <- wells %>% 
    mutate(api_number      = as.factor(API_UWI),
           operator        = as.factor(Operator_Company_Name),
           county_parish   = as.factor(County_Parish),
           production_type = as.factor(Production_Type),
           drill_type      = as.factor(Drill_Type),
           cumulative_boe  = Cum_BOE,
           months_produced = Months_Produced,
           state           = as.factor(State),
           latitude        = latitude_WGS84,
           longitude       = longitude_WGS84,
           spud_date       = Spud_Date,  # date the well was first drilled 
           completion_date = Completion_Date, 
           first_prod_date = First_Prod_Date, #1st date of production
           last_prod_date  = Last_Prod_Date) %>% #Last date of production
    dplyr::select(api_number:last_prod_date)
  return(wells)
}

##============================================================================##
