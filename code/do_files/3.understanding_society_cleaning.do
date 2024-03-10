* Understanding society cleaning
* Michele Belot, Xiaoying Liu, Vaios Triantafyllou
* 3.understanding_sociaty_cleaning.do 

*-----------------------------------------------------------------*
* Purpose: This file cleans the survey raw data
*-----------------------------------------------------------------*

* ----------- Part 4: Merging ------------- *

** a

use "$raw_data/understanding_society/a_indresp.dta", replace

foreach var of varlist a_* {
   	local newname = substr("`var'", 3, .)
   	rename `var' `newname'
}

gen waveno = 1

keep pidp hidp pno waveno jbsat sclfsat2 age_dv sex payg_dv payn_dv payu_dv payusl paygl paynl j2has j2pay ethn_dv marstat hiqual_dv nchild_dv jbsize jbbgy jbbgm employ jbsemp jbiindb_dv jbft_dv birthy jbsoc10 qfhigh_dv

save "$processed_data/understanding_society/1_indresp.dta", replace

** b

use "$raw_data/understanding_society/b_indresp.dta", replace

foreach var of varlist b_* {
   	local newname = substr("`var'", 3, .)
   	rename `var' `newname'
}

gen waveno = 2

keep pidp hidp pno waveno jbsat sclfsat2 age_dv sex payg_dv payn_dv payu_dv payusl paygl paynl j2has j2pay ethn_dv marstat hiqual_dv nchild_dv jbsize jbbgy jbbgm employ jbsemp jbiindb_dv jbft_dv empchk birthy samejob jbsoc10 qfhigh_dv

save "$processed_data/understanding_society/2_indresp.dta", replace

** c

use "$raw_data/understanding_society/c_indresp.dta", replace

foreach var of varlist c_* {
   	local newname = substr("`var'", 3, .)
   	rename `var' `newname'
}

gen waveno = 3

keep pidp hidp pno waveno jbsat sclfsat2 age_dv sex payg_dv payn_dv payu_dv payusl paygl paynl j2has j2pay ethn_dv marstat hiqual_dv nchild_dv jbsize jbbgy jbbgm employ jbsemp jbiindb_dv jbft_dv empchk birthy samejob jbsoc10 qfhigh_dv	
 
save "$processed_data/understanding_society/3_indresp.dta", replace

** d

use "$raw_data/understanding_society/d_indresp.dta", replace

foreach var of varlist d_* {
   	local newname = substr("`var'", 3, .)
   	rename `var' `newname'
}

gen waveno = 4

keep pidp hidp pno waveno jbsat sclfsat2 age_dv sex payg_dv payn_dv payu_dv payusl paygl paynl j2has j2pay ethn_dv marstat hiqual_dv nchild_dv jbsize jbbgy jbbgm employ jbsemp jbiindb_dv jbft_dv empchk birthy samejob jbsoc10 qfhigh_dv	
 

save "$processed_data/understanding_society/4_indresp.dta", replace

** e

use "$raw_data/understanding_society/e_indresp.dta", replace

foreach var of varlist e_* {
   	local newname = substr("`var'", 3, .)
   	rename `var' `newname'
}

gen waveno = 5

keep pidp hidp pno waveno jbsat sclfsat2 age_dv sex payg_dv payn_dv payu_dv payusl paygl paynl j2has j2pay ethn_dv marstat hiqual_dv nchild_dv jbsize jbbgy jbbgm employ jbsemp jbiindb_dv jbft_dv empchk birthy samejob jbsoc10 qfhigh_dv	

save "$processed_data/understanding_society/5_indresp.dta", replace

** f
use "$raw_data/understanding_society/f_indresp.dta", replace

foreach var of varlist f_* {
   	local newname = substr("`var'", 3, .)
   	rename `var' `newname'
}

gen waveno = 6

keep pidp hidp pno waveno jbsat sclfsat2 age_dv sex payg_dv payn_dv payu_dv payusl paygl paynl j2has j2pay ethn_dv marstat hiqual_dv nchild_dv jbsize jbbgy jbbgm employ jbsemp jbiindb_dv jbft_dv empchk birthy samejob jbsoc10 qfhigh_dv	

save "$processed_data/understanding_society/6_indresp.dta", replace

** g

use "$raw_data/understanding_society/g_indresp.dta", replace

foreach var of varlist g_* {
   	local newname = substr("`var'", 3, .)
   	rename `var' `newname'
}

gen waveno = 7

keep pidp hidp pno waveno jbsat sclfsat2 age_dv sex payg_dv payn_dv payu_dv payusl paygl paynl j2has j2pay ethn_dv marstat hiqual_dv nchild_dv jbsize jbbgy jbbgm employ jbsemp jbiindb_dv jbft_dv empchk birthy samejob jbsoc10 qfhigh_dv	

save "$processed_data/understanding_society/7_indresp.dta", replace

** h

use "$raw_data/understanding_society/h_indresp.dta", replace

foreach var of varlist h_* {
   	local newname = substr("`var'", 3, .)
   	rename `var' `newname'
}

gen waveno = 8

keep pidp hidp pno waveno jbsat sclfsat2 age_dv sex payg_dv payn_dv payu_dv payusl paygl paynl j2has j2pay ethn_dv marstat hiqual_dv nchild_dv jbsize jbbgy jbbgm employ jbsemp jbiindb_dv jbft_dv empchk birthy samejob jbsoc10 qfhigh_dv	

save "$processed_data/understanding_society/8_indresp.dta", replace

** i

use "$raw_data/understanding_society/i_indresp.dta", replace

foreach var of varlist i_* {
   	local newname = substr("`var'", 3, .)
   	rename `var' `newname'
}

gen waveno = 9

keep pidp hidp pno waveno jbsat sclfsat2 age_dv sex payg_dv payn_dv payu_dv payusl paygl paynl j2has j2pay ethn_dv marstat hiqual_dv nchild_dv jbsize jbbgy jbbgm employ jbsemp jbiindb_dv jbft_dv empchk birthy samejob jbsoc10 qfhigh_dv	

save "$processed_data/understanding_society/9_indresp.dta", replace

** j

use "$raw_data/understanding_society/j_indresp.dta", replace

foreach var of varlist j_* {
   	local newname = substr("`var'", 3, .)
   	rename `var' `newname'
}

gen waveno = 10

keep pidp hidp pno waveno jbsat sclfsat2 age_dv sex payg_dv payn_dv payu_dv payusl paygl paynl j2has j2pay ethn_dv marstat hiqual_dv nchild_dv jbsize jbbgy jbbgm employ jbsemp jbiindb_dv jbft_dv empchk birthy samejob jbsoc10 qfhigh_dv	

save "$processed_data/understanding_society/10_indresp.dta", replace

** k

use "$raw_data/understanding_society/k_indresp.dta", replace

foreach var of varlist k_* {
   	local newname = substr("`var'", 3, .)
   	rename `var' `newname'
}

gen waveno = 11

keep pidp hidp pno waveno jbsat sclfsat2 age_dv sex payg_dv payn_dv payu_dv payusl paygl paynl j2has j2pay ethn_dv marstat hiqual_dv nchild_dv jbsize jbbgy jbbgm employ jbsemp jbiindb_dv jbft_dv empchk birthy samejob jbsoc10 qfhigh_dv	

save "$processed_data/understanding_society/11_indresp.dta", replace

use "$processed_data/understanding_society/1_indresp.dta", clear

forval i =2/11{
	append using "$processed_data/understanding_society/`i'_indresp.dta"
}

foreach var of varlist _all {
	replace `var' =. if `var'<0
}

*forval i =1/11{
*	replace waveno = 18+`i' if  waveno == `i'
*}

gen age = .
replace age = waveno - 11 + 2000 - birthy 

save "$processed_data/complete_ukhls.dta", replace

* This resulting files were transfered to the Box folder under "~/understanding_society/data/processed/ukhls"

* ----------- Append ------------- *

use "$processed_data/complete_ukhls.dta", clear

replace waveno = 2009 if waveno == 1
replace waveno = 2010 if waveno == 2
replace waveno = 2011 if waveno == 3
replace waveno = 2012 if waveno == 4
replace waveno = 2013 if waveno == 5
replace waveno = 2014 if waveno == 6
replace waveno = 2015 if waveno == 7
replace waveno = 2016 if waveno == 8
replace waveno = 2017 if waveno == 9
replace waveno = 2018 if waveno == 10
replace waveno = 2019 if waveno == 11

* Note: Although we are appending here UKHLS and BHPS, we only end up using the former, as discussed.

** Note 2: I have not used the month of finding a job to not complicate things- we can incorporate it if necessary.

* ----------- Keep relevant observations ------------- *

sort pidp waveno
br pidp waveno jbbgy employ

* ----------- Keep only people that are present throughout ------------- *

duplicates tag pidp, gen(aux)
tab aux
keep if aux == 10
drop aux

unique pidp

* ----------- Deal with highest qualification variable ------------- *

* keep only people for which there is an educational attaiment throughout
bys pidp(waveno): gen aux = 1 if (qfhigh_dv==-9 | qfhigh_dv==-8)
bys pidp(waveno): egen aux2 = min(aux)
keep if aux2 !=1
drop aux aux2

replace qfhigh_dv = 17 if qfhigh_dv == 96

* ----------- Create a variable for years in employment within dataset ------------- *

* keep only people for which there is a yes or no value for employment always
bys pidp(waveno): gen aux = 1 if (employ==.)
bys pidp(waveno): egen aux2 = min(aux)
keep if aux2 !=1
drop aux aux2

* create within sample start of employment variable 
gen employ2 = 0 
replace employ2 = 1 if employ == 1
gen ds_emp = 0
bys pidp(waveno): replace ds_emp = 1 if employ2[1] == 1 & _n ==1
bys pidp(waveno): replace ds_emp = employ2[_n] + ds_emp[_n-1] if _n>1

* ----------- Keep people for which date started coincides with first empl ------------- *

bys pidp(waveno): gen aux = 1 if (jbbgy[_n]!=.)
bys pidp(waveno): gen aux2 = 1 if (ds_emp[_n]==1)
bys pidp(waveno): gen aux3 = 1 if (aux[_n] == aux2[_n] & aux[_n]!=. & aux2[_n]!=.) 
bys pidp(waveno): egen aux4 = max(aux3)
keep if aux4 !=.
drop aux aux2 aux3 aux4

* ----------- Keep people that are not self-employed and without second job ------------- *

gen aux = 0
bys pidp(waveno): replace aux = 1 if jbsemp==2 | j2has==1
bys pidp(waveno): egen aux2 = max(aux)
keep if aux2 == 0
drop aux aux2

* ----------- Drop observations for which entries do not make sense ------------- *

gen aux = 0
bys pidp(waveno): replace aux = 1 if (employ == 2 & jbsoc10_cc !=.) | (employ == 2 & jbiindb_dv !=.)
bys pidp(waveno): egen aux2 = max(aux)
keep if aux2 == 0
drop aux aux2

gen aux = 0
bys pidp(waveno): replace aux = 1 if (employ[_n-1] == 2 & samejob[_n] ==1)
bys pidp(waveno): egen aux2 = max(aux)
keep if aux2 == 0
drop aux aux2

br pidp waveno jbbgy samejob

* ----------- Create imputed same job variable ------------- *

* treat missings depending on occupation and industry
** note: this takes care of cases where the occupation or indusry is missing in one year and appears in the other, but the second of the two is there in both years

br pidp waveno jbbgy samejob ds_emp jbiindb_dv jbsoc10_cc employ

gen samejob_imp= samejob
by pidp(waveno): replace samejob_imp = 1 if ((jbsoc10_cc[_n-1] == jbsoc10_cc[_n] & jbiindb_dv[_n-1] == jbiindb_dv[_n] & employ[_n-1] == 1 & employ[_n]==1 & jbiindb_dv[_n] !=0) | (jbsoc10_cc[_n-1] == . & jbiindb_dv[_n-1] == jbiindb_dv[_n] & employ[_n-1] == 1 & employ[_n]==1 & jbiindb_dv[_n] !=0) | (jbsoc10_cc[_n] == . & jbiindb_dv[_n-1] == jbiindb_dv[_n] & employ[_n-1] == 1 & employ[_n]==1 & jbiindb_dv[_n] !=0) | (jbsoc10_cc[_n-1] == jbsoc10_cc[_n] & jbiindb_dv[_n-1] == . & employ[_n-1] == 1 & employ[_n]==1 & jbiindb_dv[_n] !=0) | (jbsoc10_cc[_n-1] == jbsoc10_cc[_n] & jbiindb_dv[_n] == . & employ[_n-1] == 1 & employ[_n]==1 & jbiindb_dv[_n] !=0)) & samejob!=2

br pidp waveno jbbgy samejob ds_emp jbiindb_dv jbsoc10_cc employ samejob_imp

* ----------- Create tenure, jobnumber and number of jobs variables ------------- *

gen tenure =.
gen jobnumber =.
gen nojobs =.

* whenever they start working in the sample, designate this as their first jobnumber
bys pidp(waveno): replace jobnumber = 1 if (ds_emp[_n] == 1 & employ[_n] == 1)
bys pidp(waveno): replace tenure = waveno[_n] - jbbgy[_n] if jobnumber == 1 

* keep adding tenure, as long as the job is the same as before
bys pidp(waveno): replace tenure = tenure[_n-1] + 1 if (samejob_imp[_n]==1 & employ[_n]==1) 

* accordingly, update job number
bys pidp(waveno): replace jobnumber = jobnumber[_n-1] if (jobnumber == . & samejob_imp[_n]==1 & employ[_n]==1 & jobnumber[_n]==.) 

* accordingly, update total number of jobs
bys pidp(waveno): replace nojobs = jobnumber if jobnumber[_n]==1

bys pidp(waveno): replace nojobs = jobnumber[_n-1] if jobnumber[_n-1]==1 & nojobs[_n]==.

* drop all people for whom tenure turns out to be negative
by pidp(waveno): egen aux = min(tenure)
by pidp(waveno): drop if aux<0
drop aux

br pidp waveno jbbgy samejob ds_emp jbiindb_dv jbsoc10_cc employ samejob_imp jobnumber

* repeat this to take care of all jobs up to job number 5 (which is the most we have)
forvalues i = 1/5 {

	* initiate tenure for all new jobs during the observed period
	by pidp(waveno): replace tenure = 1 if ((samejob_imp[_n]==. | samejob_imp[_n]==2) & employ == 1 & _n != 1)

	* accordingly, update job number
	by pidp(waveno): replace jobnumber = nojobs[_n-1]+1 if (jobnumber == . & (samejob_imp[_n]==. | samejob_imp[_n]==2) & employ == 1 & tenure[_n]==1)

	* carry forward tenure for all new jobs during the observed period
	by pidp(waveno): replace tenure = tenure[_n-1]+1 if (samejob_imp[_n]==1 & employ == 1 & tenure[_n]==.)

	* accordingly, update job number
	by pidp(waveno): replace jobnumber = jobnumber[_n-1] if (jobnumber == . & samejob_imp[_n]==1 & employ == 1 & jobnumber[_n]==.)

	* accordingly, update total number of jobs
	bys pidp(waveno): replace nojobs = jobnumber if jobnumber[_n]!=. &  nojobs[_n]==.
	bys pidp(waveno): replace nojobs = jobnumber[_n-1] if jobnumber[_n-1]!=. &  nojobs[_n]==.

}

* ----------- Only keep jobs where people stayed for at least 4 years ------------- *

bys pidp(waveno): gen aux = 1 if jobnumber == 1
bys pidp(waveno): gen aux1 = 1 if jobnumber == 2
bys pidp(waveno): gen aux2 = 1 if jobnumber == 3
bys pidp(waveno): gen aux3 = 1 if jobnumber == 4
bys pidp(waveno): gen aux4 = 1 if jobnumber == 5
bys pidp(waveno): gen auxa = sum(aux)
bys pidp(waveno): egen auxaa = max(auxa)
bys pidp(waveno): gen aux1a = sum(aux1)
bys pidp(waveno): egen aux1aa = max(aux1a)
bys pidp(waveno): gen aux2a = sum(aux2)
bys pidp(waveno): egen aux2aa = max(aux2a)
bys pidp(waveno): gen aux3a = sum(aux3)
bys pidp(waveno): egen aux3aa = max(aux3a)
bys pidp(waveno): gen aux4a = sum(aux4)
bys pidp(waveno): egen aux4aa = max(aux4a)

bys pidp(waveno): drop if jobnumber == 1 & auxaa < 4
bys pidp(waveno): drop if jobnumber == 2 & aux1aa < 4
bys pidp(waveno): drop if jobnumber == 3 & aux2aa < 4 
bys pidp(waveno): drop if jobnumber == 4 & aux3aa < 4
bys pidp(waveno): drop if jobnumber == 5 & aux4aa < 4
drop aux*

* ----------- Genereate a skill match variable ------------- *

egen qual_mod = mode(qfhigh_dv), by(jbsoc10_cc)
gen skill_fit = qfhigh_dv - qual_mod

* ----------- Normalize variables ------------- *

* normalize
foreach i in jbsat payg_dv payn_dv skill_fit {
	egen std_`i' = std(`i')
}


local variables="std_jbsat std_payg_dv std_payn_dv std_skill_fit"
foreach var of local variables {
    gen d_`var' = `var'		// compute the se
	gen n_`var' = `var'		// compute the count
}

save "$processed_data/clean_uhkls.dta", replace
