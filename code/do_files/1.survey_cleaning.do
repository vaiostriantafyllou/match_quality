* Survey cleaning
* Michele Belot, Xiaoying Liu, Vaios Triantafyllou
* 1.survey_cleaning.do 

*-----------------------------------------------------------------*
* Purpose: This file cleans the survey raw data
*-----------------------------------------------------------------*

* ----------- Part 1: Crossectional data cleaning -------------

import excel using $raw_data/qualtrics/formal_survey_features_demographics_gpt4.xlsx, firstrow clear

drop StartDate EndDate Status IPAddress Progress Finished RecordedDate Recipient*  ///
	ExternalReference Location* Distribution UserLanguage Submissionid-Archivedat Completioncode ///
	Countryofresidence Nationality

rename *, lower

*** rename variables to make consistent expression, curr for current, 1-4 means year 1,2,3, and current/last year

rename (satisfactioncurr_4 satisfactioncurr_5 satisfactioncurr_6) ///
	   (satis_curr_2    satis_curr_3    satis_curr_4)

rename (satisfactionlast_4 satisfactionlast_5 satisfactionlast_6) ///
	   (satis_last_2    satis_last_3    satis_last_4)
	   
rename (salarycurrent_1 salarycurrent_2 salarycurrent_3 salarycurrent_4) ///
	   (salary_curr_1	salary_curr_2	salary_curr_3	salary_curr_4)
	   
rename (salarylast_1 salarylast_2 salarylast_3 salarylast_4) ///
	   (salary_last_1 salary_last_2	salary_last_3 salary_last_4)

rename (evaluationcur_upd_15 evaluationcur_upd_16 evaluationcur_upd_17 evaluationcur_upd_18) ///
	   (perform_curr_1 perform_curr_2 perform_curr_3 perform_curr_4)
	   
rename (evaluationlast_upd_15 evaluationlast_upd_16 evaluationlast_upd_17 evaluationlast_upd_18) ///
	   (perform_last_1 perform_last_2 perform_last_3 perform_last_4)

rename (skillfitcurrent_3 skillfitcurrent_4 skillfitcurrent_5 skillfitcurrent_6) ///
	   (skillfit_curr_1 skillfit_curr_2 skillfit_curr_3 skillfit_curr_4)
	   
rename (skillfitlast_3 skillfitlast_4 skillfitlast_5 skillfitlast_6) ///
	   (skillfit_last_1 skillfit_last_2 skillfit_last_3 skillfit_last_4)

*** rename factor importance for current jobs at this moment
forv i = 1/20 {
	rename q102_`i' factors1current_`i'
	label var factors1current_`i' "Factors0 - current_`i'"
}

sum *

*** deal with missing values and outliers
foreach x of varlist satis* salary_curr_1-totalemployees_11_text {
	replace `x' = . if `x' == -99
}
sum *

*** Clean job spell, deal with outliers

sum jobspell*
sum jobspellcurrent_1
replace jobspellcurrent_1 = r(mean) if jobspellcurrent_1 == -1	// has year 1,2,3 and current year info

sum jobspellcurrent_2
disp "`r(mean)'"
replace jobspellcurrent_2 = r(mean) if jobspellcurrent_2 == 360

sum *
gen tenure_current = jobspellcurrent_1 + jobspellcurrent_2/12
gen tenure_last = jobspelllast_2 + jobspelllast_3/12
label var tenure_current "Job tenure for current job"
label var tenure_last "Job tenure for last job"

gen satis_curr_1 = (satisfactioncurr_1 + satisfactioncurr_3)/2
replace satis_curr_1 = satisfactioncurr_1 if satis_curr_1 == . 	// tenure less than 1 year

gen satis_last_1 = (satisfactionlast_1 + satisfactionlast_3)/2
replace satis_last_1 = satisfactionlast_1 if satis_last_1 == . 	// tenure less than 1 year


/* 
Because of the questionnaire structure, some workers whose tenure is less than 4 years need to report
their measures for the first year, second year, third year, and current year. Meaning that current year
information is asked twice. Some filled in both cases while some don't.
Need to fill in the values for cross-sectional data, and remove those in the panel case (where we implicitly
assume that time 4 is larger than 3 years.)
*/

foreach i in satis_curr_4 salary_curr_4 perform_curr_4 skillfit_curr_4 {
	// check who did not report current/last year information
	sum tenure_current if `i' == ., d		// satis_curr_4 95% whose tenure is less than 4 years (42/44 for satis)
	// check how many report twice
	count if tenure_current < 4		
	count if tenure_current < 4 & `i' != .		// satis_curr_4 125/167 report twice
}

*** ------- Fill in missing values ------------
/*
For current year information, fill in with year 1 information if tenure is in [0 2] and the person did
not report year 2 information;
Fill in with year 2 information if tenure is in [1,3] and the person did not report year 3 information;
and so on.
The logic is the following: a respondent with current tenure being 1.6 may only report year 1 information, 
fill in current year using year 1 information in this case. she may also report year 2 information, fill in
current year using year 2 information instead.
*/

ds *_curr_4
foreach i in `r(varlist)' {
	local i = subinstr("`i'","4","",.)
	disp "`i'"
	replace `i'4 = `i'1 if `i'4 == . & `i'2 == . & inrange(tenure_current,0,2)
	replace `i'4 = `i'2 if `i'4 == . & `i'3 == . & inrange(tenure_current,1,3)
	replace `i'4 = `i'3 if `i'4 == . & inrange(tenure_current,2,4)
}

ds *_last_4
foreach i in `r(varlist)' {
	local i = subinstr("`i'","4","",.)
	disp "`i'"
	replace `i'4 = `i'1 if `i'4 == . & `i'2 == . & inrange(tenure_last,0,2)
	replace `i'4 = `i'2 if `i'4 == . & `i'3 == . & inrange(tenure_last,1,3)
	replace `i'4 = `i'3 if `i'4 == . & inrange(tenure_last,2,4)
}


*** ------- Clean OPENAI results, convert yes, no answer to binary ------------

rename flexibilityinworkarrangement_ flexibility_bst
rename firmlocationandfirminfrastru firmlocation_bst
rename firmcultureandworkenvironmen firmculture_bst
rename lackofflexibilityinworkarra lackflexibility_lst
rename hf firmlocation_lst
rename hg firmculture_lst

ds *_bst *_lst
foreach i in `r(varlist)' {
	replace `i' = "0" if substr(`i',1,2) == "No"
	replace `i' = "1" if substr(`i',1,3) == "Yes"
	destring `i', replace
}

// check that the respondent copy and paste likebest answer to likeleast answer
// change the value to zero since other features were replaced as 0
foreach i in badnonmonetaryperks_lst firmculture_lst longdistancetowork_lst {
	replace `i' = "0" if inlist(`i',"0","1")==0
	destring `i', replace
}

ds *_bst
local j = 1
foreach i in `r(varlist)' {
	rename `i' bst_`j'
	local j = `j' + 1
}

ds *_lst
local j = 1
foreach i in `r(varlist)' {
	rename `i' lst_`j'
	local j = `j' + 1
}

global impt_lab 1 `" "Not at all" "important" "' 2 `" "Slightly" "important" "'  ///
	3 `" "Moderately" "important" "' 4 `" "Very" "important" "' 5 `" "Extremely" "important" "'

// clean the occupation
label def occ	1	"Architecture and Engineering Occupations"	
label def occ	2	"Arts, Design, Entertainment, Sports, and Media Occupations "	, add
label def occ	3	"Building and Grounds Cleaning and Maintenance Occupations "	, add
label def occ	4	"Business and Financial Operations Occupations"	, add
label def occ	5	"Community and Social Service Occupations"	, add
label def occ	6	"Computer and Mathematical Occupations"	, add
label def occ	7	"Construction and Extraction Occupations"	, add
label def occ	8	"Educational Instruction, and Library Occupations"	, add
label def occ	9	"Farming, Fishing, and Forestry Occupations"	, add
label def occ	10	"Food Preparation and Serving Related Occupations "	, add
label def occ	11	"Healthcare Practitioners and Technical Occupations "	, add
label def occ	12	"Healthcare Support Occupations"	, add
label def occ	13	"Installation, Maintenance, and Repair Occupations"	, add
label def occ	14	"Life, Physical, and Social Science Occupations"	, add
label def occ	15	"Legal Occupations"	, add
label def occ	16	"Management Occupations"	, add
label def occ	17	"Material Moving Occupations"	, add
label def occ	18	"Office and Administrative Support Occupations"	, add
label def occ	19	"Personal Care and Service Occupations"	, add
label def occ	20	"Production Occupations"	, add
label def occ	21	"Protective Service Occupations"	, add
label def occ	22	"Sales and Related Occupations"	, add
label def occ	23	"Transportation Occupations"	, add

label val occupationcurrent occ
label val occupationlast occ


// clean occupation of those select "None of the above"

tab occupationcurrent_24_text if occupationcurrent == 24
gen temp = strtrim(occupationcurrent_24_text) + ": "+ strtrim(jobtitlecurrent)

#delimit ;
replace occupationcurrent = 16 if inlist(temp,
"Consulting: Chief Systems Admin",
"Real Estate: Realtor",
"Real Estate: Real Estate Agent",
"Information Technology: Manager",
"Health and Wellness: Wellness Director",
"HOSPITILITY: HOTEL MANAGER",
"Hospitality and Tourism: Director of Operations",
"Hospitality/Recreation/Retail: Golf Course Management",
"manufacturing: supervisor");

replace occupationcurrent = 16 if inlist(temp,
"non-profit consulting: Account Executive");

replace occupationcurrent = 4 if inlist(temp,
"Professional services: SEO finance writer",
"Purchasing & procurement: Purchasing manager");

replace occupationcurrent = 6 if inlist(temp,
"Information Technology: Information Technology Specialist",
"Information Technology: IT Professional",
"Information Technology: IT Consultant",
"Information Technology: IT Junior Admin",
"Information Technology: Systems Administrator",
"Information Technology: Network Systems Analyst",
"Information Techology: Freelancer/Individual Contributor",
"Ecommerce quality assurance: Ecommerce Quality Assurance Evaluator",
"data services: Project Manager");

replace occupationcurrent = 14 if inlist(temp,
"Research participant: Research participant",
"research/healthcare: regulatory affairs coordinator");

replace occupationcurrent = 5 if inlist(temp,
"church work: Pastor",
"public service: program analyst");

replace occupationcurrent = 2 if inlist(temp,"Social media: Social media moderator");

replace occupationcurrent = 11 if inlist(temp,
"medical products: Quality Assurance Supervisor");

replace occupationcurrent = 12 if inlist(temp,
"Animal Rescue: Foster Coordinator");

replace occupationcurrent = 10 if inlist(temp,
"Hospitality- Event Planning: Event Coordinator");

replace occupationcurrent = 22 if inlist(temp,
"wholesale: Buyer's Assistant");

replace occupationcurrent = 18 if inlist(temp,
"Supervisor of shipping and more.: Supervisor",
"Microtasking: Microtasker",
"Apartment Management: Property Manager",
"Property Management: Property Manager",
"Professional Services: Scientific Writer and Editor",
"Professional Services: Data Entry Specialist",
"Data Entry: Keyer");

replace occupationcurrent = 18 if inlist(temp,
"Utilities: Executive Administrative Assistant",
"PUBLIC ADMINISTRATION: Public Administrator",
"government: leadman utilities",
"local government: operator");

replace occupationcurrent = 20 if inlist(temp,
"manufacturng: rope weaver");

replace occupationcurrent = 23 if inlist(temp,
"Freelance delivery / distribution: Freelance delivery driver");

replace occupationcurrent = 17 if inlist(temp,
"Logistics/warehouse: Warehouse manager",
"warehouse: warehouse associate");

#delimit cr

replace occupationcurrent = . if occupationcurrent == 24

drop temp
/* one is not recognizable, where the occupation says
"Most is realted to food/hotel but construction / logistics" 
and job title is "Self employed"
*/

*** ------- Define high skill and low skill occupations ------------

gen skilled = .
replace skilled = 1 if inlist(occupationcurrent,1,4,6,8,11,14,15,16)
replace skilled = 0 if inlist(occupationcurrent,3,7,9,10,12,13,17,18,19,20,21,22,23)

// gender
gen gender = (sex == "Male")
// age
replace age = 2023 - yob if age == .
// clean outliers
replace workhourscurrent = 55 if workhourscurrent == 550

// define satisfaction change, _1 is first 6 month, _3 is 7-12 month
gen satisfaction_change = satis_curr_4 - (satisfactioncurr_1+satisfactioncurr_3)/2
gen satis_curr_decrease = (satisfaction_change < 0)

gen satisfaction_change2 = satis_last_4 - (satisfactionlast_1+satisfactionlast_3)/2
gen satis_last_decrease = (satisfaction_change2 < 0)

save $processed_data/formal_survey_features_demographics_crosssection, replace

* ----------- Part 2: Panel cleaning -------------

use $processed_data/formal_survey_features_demographics_crosssection, clear

// reshape the data to panel, year 1,2,3, current/last year

drop satisfactioncurr_1 satisfactioncurr_3 satisfactionlast_1 satisfactionlast_3

forv i = 1/3 {
	gen tenure_curr_`i' = tenure_current
	gen tenure_last_`i' = tenure_last
}

rename tenure_current tenure_curr_4
rename tenure_last tenure_last_4

reshape long satis_curr_ satis_last_ salary_curr_ salary_last_ perform_curr_  ///
	perform_last_ skillfit_curr_ skillfit_last_ tenure_curr_ tenure_last_,  i(responseid) j(time)
	
egen id = group(responseid)
order id

// replace measures to NaN if time = 4 & tenure is no greater than 3
// since in panel structure, these information is already given in previous obs
foreach i in satis_curr_ salary_curr_ perform_curr_ skillfit_curr_ {
	replace `i' = . if time == 4 & inrange(tenure_curr_, 0, 3)
} 

foreach i in satis_last_ salary_last_ perform_last_ skillfit_last_ {
	replace `i' = . if time == 4 & inrange(tenure_last_, 0, 3)
} 

gen log_satis_curr = log(satis_curr_+1)
gen log_satis_last = log(satis_last_+1)

gen log_wage_curr = log(salary_curr_+1)
gen log_wage_last = log(salary_last_+1)

gen log_perform_curr = log(perform_curr_+1)
gen log_perform_last = log(perform_last_+1)

gen log_skill_curr = log(skillfit_curr_+1)
gen log_skill_last = log(skillfit_last_+1)

gen log_tenure_curr = log(tenure_curr_+1)
gen log_tenure_last = log(tenure_last_+1)

** generate interaction terms
gen male_currtenure = gender * tenure_curr_
gen male_lasttenure = gender * tenure_last_

gen male_2 = gender * (time == 2)
gen male_3 = gender * (time == 3)
gen male_4 = gender * (time == 4)

// standardize variables across individuals & time, std_* current job, stdl_* last job
foreach i in satis_curr_ salary_curr_ perform_curr_ skillfit_curr_ {
	egen std_`i' = std(`i')
}
foreach i in satis_last_ salary_last_ perform_last_ skillfit_last_ {
	egen stdl_`i' = std(`i')
}

label def time 1 "Year 1"
label def time 2 "Year 2", add
label def time 3 "Year 3", add
label def time 4 "Current/Last year", add
label val time time

save $processed_data/formal_survey_features_demographics_panel, replace
