* Master
* Michele Belot, Xiaoying Liu, Vaios Triantafyllou
* master.do 

*-----------------------------------------------------------------*
* Purpose: This is the master file
*-----------------------------------------------------------------*

* ----------- Part 0: Setting -------------

// Set the memory and file directory
clear all
set more off
*set matsize 4000

if substr("`c(pwd)'",1,19)=="/Users/xiaoyingliu/" {
	global root_files "/Users/xiaoyingliu/Library/CloudStorage/Box-Box/Employee_Survey/match_quality"
}

if substr("`c(pwd)'",1,26)=="/Users/vaiostriantafyllou/"{
	global root_files "/Users/vaiostriantafyllou/Library/CloudStorage/Box-Box/Employee_Survey/match_quality"
}

global raw_data     "$root_files/data/raw_data"
global processed_data "$root_files/data/processed_data"
global dofiles      "$root_files/code/do_files"
global logfiles     "$root_files/code/log_files"
global tables       "$root_files/output/tables"
global figures      "$root_files/output/figures"

cd $root_files

*python script "ACS Demographics.py"

do "${dofiles}/1.formal_survey_features_cleaning.do"
do "${dofiles}/2.formal_survey_features_description.do"
do "${dofiles}/3.formal_survey_features_regression.do"
