##============================================================================##
## 1.01 - function to tidy data from Enverus on wells in the study region

# cleans and prepares raw Enverus input data for further analysis
tidyWellsData <- function(wells) {
  wells <- wells %>% 
    mutate(api_number      = as.factor(API_UWI),
           operator        = as.factor(`Operator Company Name`),
           county_parish   = as.factor(`County/Parish`),
           state           = as.factor(State),
           cumulative_boe  = `Cum BOE`,
           cumulative_oil  = `Cum Oil`,
           cumulative_gas  = `Cum Gas`,
           production_type = as.factor(Production_Type),
           drill_type      = as.factor(Drill_Type),
           latitude        = Latitude,
           longitude       = Longitude,
           spud_date       = Spud_Date,  # date the well was first drilled 
           completion_date = as.Date(Completion_Date, format = "%d%b%Y"), 
           first_prod_date = First_Prod_Date, #  first date of production
           last_prod_date  = as.Date(Last_Prod_Date,  format = "%d%b%Y"),
           earliest_date   = earliest_date) %>% 
    dplyr::select(api_number:last_prod_date)
  return(wells)
}

##============================================================================##