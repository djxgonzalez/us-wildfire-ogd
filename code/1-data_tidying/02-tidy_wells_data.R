##============================================================================##
## 1.02 - 

## setup ---------------------------------------------------------------------

# attaches necessary packages and functions
source("code/0-setup/01-setup.R")
source("code/1-data_tidying/01-fxn-tidy_wells_data.R")

# data input
wells_raw <- read_csv("data/raw/enverus/ogd_usa_small.csv") 


## tidies and exports data  --------------------------------------------------

wells_all <- wells_raw %>% 
  filter(API_UWI > 0) %>%  # drops wells with missing API number
  # restricts to wells in the study region
  filter(State %in% c("AK", "WA", "OR", "CA", "ID", "NV", "AZ", "MT", "WY", 
                      "UT", "CO", "NM", "ND", "SD", "NE", "KS", "OK", "TX",
                      "MN", "IA", "MO", "AR", "LA")) %>% 
  tidyWellsData() #%>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>% 
    ##### pick up here
  # honestly not sure what this does...
  # mutate(across(c(Spud_Date, Completion_Date, First_Prod_Date, Last_Prod_Date),
  #               ~ as.Date(as.character(.x), "%Y"))) %>%
  st_make_valid() #%>% 
  #distinct(api_number, .keep_all = TRUE) ##### do something else to retain dates across rows

# exports processed data
saveRDS(wells_all, file = "data/processed/wells_all.rds")

##============================================================================##
