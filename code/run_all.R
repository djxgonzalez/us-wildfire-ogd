##============================================================================##
## run_all - This script is a sort of table of contents for this R project.
## Most of the scripts necessary to conduct this project were written to run
## independently. In this `run_all` script, we assembled the elements of the 
## R project sequentially. However, we do not advise running this script in 
## whole, as the memory demands may cause R to crash.

## 0. Setup ==================================================================
# loads necessary packages and defines global variables
source("code/0-setup/01-setup.R")

## 1. Data Tidying ===========================================================
# attaches functions for tidying raw data
source("code/1-data_tidying/01-fxn-tidy_wells_data.R")
# imports raw data, calls tidying functions, exports interim data
source("code/1-data_tidying/02-tidy_wells_data.R")
source("code/1-data_tidying/03-tidy_wildfire_data.R")
source("code/1-data_tidying/04-tidy_kbdi_risk_data.R")
source("code/1-data_tidying/05-tidy_gridded_pop_data.R")

## 2. Assessment of Wells in Wildfires =======================================

source("code/2-assessment/01-fxn-count_wells_in_wildfires.R")
source("code/2-assessment/02-prep_wells_wildfires_data.R")
source("code/2-assessment/03-count_wells_wildfires.R")
source("code/2-assessment/04-count_wells_wildfires_with_dates.R")
source("code/2-assessment/05-assemble_wells_wildfires_data.R")
source("code/2-assessment/06-generate_wildfire_years_layers.R")
source("code/2-assessment/07-count_wells_wildfire_years.R")
source("code/2-assessment/08-count_wells_wildfire_years_with_dates.R")
source("code/2-assessment/09-assemble_wells_wildfire_years_data.R")
source("code/2-assessment/10-prep_wells_wildfires_intersection_shapefiles.R")
source("code/2-assessment/11-population_exposed_wells_wildfires.R")
source("code/2-assessment/12-assemble_population_exposure_data.R")
source("code/2-assessment/13-assess_wells_projected_wildfire_risk.R")
source("code/2-assessment/14-label_wells_on_federal_lands.R")
source("code/2-assessment/15-label_wells_on_tribal_lands.R")

## 3. Results ===============================================================
 
# each results file is a separate Rmd document, to be run individually

## 4. Communication ==========================================================
# generates figures and tables for main text
source("code/4-communication/01-make_figure_1a.R")
source("code/4-communication/02-make_figure_1a_inset.R")
source("code/4-communication/03-make_figure_1b_1c.R")
source("code/4-communication/04-make_figure_2.R")
source("code/4-communication/05-make_figure_3.R")
source("code/4-communication/06-make_table_1.R")
source("code/4-communication/07-make_figure_s1.R")
source("code/4-communication/08-make_figure_s2.R")
source("code/4-communication/09-make_figure_s3.R")
source("code/4-communication/10-make_table_s4.R")
source("code/4-communication/11-make_table_s6.R")

##============================================================================##