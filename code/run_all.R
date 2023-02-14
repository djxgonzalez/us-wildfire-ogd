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
# 
source("code/2-assessment/.R")
source("code/2-assessment/.R")
source("code/2-assessment/.R")
source("code/2-assessment/.R")
source("code/2-assessment/.R")
source("code/2-assessment/.R")
source("code/2-assessment/.R")
source("code/2-assessment/.R")
source("code/2-assessment/.R")
source("code/2-assessment/.R")
source("code/2-assessment/.R")

## 3. Analyses ===============================================================
# 
source("code/3-analysis/.R")
source("code/3-analysis/.R")


## 4. Communication ==========================================================
# generates figures and tables for main text
source("code/4-communication/01-make_figure_1a.R")
source("code/4-communication/02-make_figure_1a_inset.R")
source("code/4-communication/03-make_figure_1b_1c.R")
source("code/4-communication/04-make_figure_2.R")
source("code/4-communication/05-make_figure_3.R")
source("code/4-communication/06-make_figure_4.R")
source("code/4-communication/07-make_table_1.R")
# generates figures and tables for supplemental materials


##============================================================================##