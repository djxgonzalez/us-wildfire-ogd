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
source("code/1-data_tidying/01-tidy_enverus_data.R")

# imports raw data, calls tidying functions, exports interim data
source("code/1-data_tidying/04-call_data_tidying.R")


## 2. Assessment of Wells in Wildfires =======================================

# attaches functions for tidying raw data
source("code/2-assessment/01-fxn_assess_exposure_buffer.R")

# imports raw data, calls tidying functions, exports interim data
source("code/2-assessment/02-assess_exposure_cities.R")

# makes analytic dataset
source("code/2-assessment/06-make_analytic_dataset.R")


## 3. Analyses ===============================================================

# descriptive statistics are in the Rmd ##### edit this

# propensity scores ##### edit this

# models are in Rmds ##### edit this


## 4. Communication ==========================================================

# imports raw and processed data, preps data as needed, and generates main 
# and supplemental figures and tables
source("code/4-communication/01-prep_figure_1_data.R")
source("code/4-communication/02-make_figure_1a.R")
source("code/4-communication/03-make_figure_1a_inset.R")
source("code/4-communication/04-make_figure_2.R")
source("code/4-communication/05-make_figure_3.R")
source("code/4-communication/06-make_figure_4.R")
source("code/4-communication/07-make_table_1.R")

##============================================================================##