* Descriptives
* Michele Belot, Xiaoying Liu, Vaios Triantafyllou
* 2.descriptives.do 

*-----------------------------------------------------------------*
* Purpose: This file produces descriptive statistics
*-----------------------------------------------------------------*

*------------ ACS 2022 Sample Description --------------*

import delimited using $raw_data/american_community_survey/acs2022.csv, varn(1) clear

keep if wkhp >= 35

drop if wagp == 0 	// drop those employed with no wage

label var agep "Age"
label var wkhp "Usual hours worked per week past 12 months"

gen gender = (sex == 1)
label var gender "Gender - Male"

gen salary = wagp / 1000
// top codign the salary
replace salary = 100 if salary >= 100
label var salary "Annual salary (in thousands)"


#delimit ;
estpost sum agep gender wkhp salary;
esttab using $tables/summary_stat_acs.csv, replace varwidth(10) 
	cell("count mean(fmt(%5.2f)) sd(fmt(%5.2f)) min(fmt(%5.2f)) max(fmt(%5.2f))") 
	nonumbers noobs label title("Summary Statistics");
#delimit cr

gen occupation = .
replace occupation = 16 if inrange(occp,10, 440)
replace occupation = 4 if inrange(occp,500, 960)
replace occupation = 6 if inrange(occp,1005, 1240)
replace occupation = 1 if inrange(occp,1305, 1560)
replace occupation = 14 if inrange(occp,1600, 1980)
replace occupation = 5 if inrange(occp,2001, 2060)
replace occupation = 15 if inrange(occp,2100, 2180)
replace occupation = 8 if inrange(occp,2205, 2555)
replace occupation = 2 if inrange(occp,2600, 2970)
replace occupation = 11 if inrange(occp,3000, 3550)
replace occupation = 12 if inrange(occp,3601, 3655)
replace occupation = 21 if inrange(occp,3700, 3960)
replace occupation = 10 if inrange(occp,4000, 4160)
replace occupation = 3 if inrange(occp,4200, 4255)
replace occupation = 19 if inrange(occp,4330, 4655)
replace occupation = 22 if inrange(occp,4700, 4965)
replace occupation = 18 if inrange(occp,5000, 5940)
replace occupation = 9 if inrange(occp,6005, 6130)
replace occupation = 7 if inrange(occp,6200, 6950)
replace occupation = 13 if inrange(occp,7000, 7640)
replace occupation = 20 if inrange(occp,7700, 8990)
replace occupation = 23 if inrange(occp,9005, 9430)
replace occupation = 17 if inrange(occp,9510, 9760)


*** occupational distribution ***
#delimit ;
graph hbar , over(occupation, sort(1) des gap(*0.5)
	relabel(1	"Architecture and engineering"	
	2	`""Arts, design, entertainment," "sports, and media""'
	3	`""Building and grounds" "cleaning and maintenance""'
	4	`""Business and" "financial operations""'
	5	`""Community and" "social service""'
	6	"Computer and mathematical"
	7	"Construction and extraction"
	8	`""Educational instruction," "and library""'
	9	`""Farming, fishing," "and forestry""'
	10	`""Food preparation" "and serving related""'
	11	`""Healthcare practitioners" "and technical""'
	12	"Healthcare support"
	13	`""Installation, maintenance," "and repair""'
	14	`""Life, physical, and" "social science""'
	15	"Legal"	
	16	"Management"	
	17	"Material moving"	
	18	`""Office and" "administrative support""'
	19	"Personal care and service"	
	20	"Production"	
	21	"Protective service"	
	22	"Sales and related"	
	23	"Transportation")
	label(labsize(*0.6))	)
	bar(1,color("130 176 210") fi(inten100))
	blabel(bar, format(%3.1f) size(tiny) gap(0.3))
	ylabel(, nolabels noticks nogrid) yscale(noline)
	title("") ytitle("") ysize(4) xsize(4) graphregion(margin(zero));
#delimit cr

graph export $figures/occupation_distribution_acs.pdf, replace


*------------ Survey Sample Description --------------*

use $processed_data/formal_survey_features_demographics_crosssection, clear

*** summary statistics ***

// have previous job
gen has_prv_job = (numberofpastjobs != 1)
label var has_prv_job "Hold more than one job in the past decade"
label var salary_curr_4 "Current annual salary (in thousands)"
label var salary_last_4 "Annual salary when leaving last job (in thousands)"
label var gender "Gender - Male"

#delimit ;
estpost sum age gender workhourscurrent salary_curr_4 tenure_current
	has_prv_job workhourslast salary_last_4 tenure_last;
esttab using $tables/summary_stat.csv, replace varwidth(10) 
	cell("count mean(fmt(%5.2f)) sd(fmt(%5.2f)) min(fmt(%5.2f)) max(fmt(%5.2f))") 
	nonumbers noobs label title("Summary Statistics");
#delimit cr

#delimit ;
estpost sum tenure_current satis_curr_4 salary_curr_4 perform_curr_4 skillfit_curr_4
	tenure_last satis_last_4 salary_last_4 perform_last_4 skillfit_last_4;
esttab using $tables/summary_stat_metrics.csv, replace varwidth(10) 
	cell("mean(fmt(%5.2f)) sd(fmt(%5.2f))") 
	nonumbers noobs label title("Basic descriptives");
#delimit cr

*** occupational distribution ***

#delimit ;
graph hbar , over(occupationcurrent, sort(1) des gap(*0.5)
	relabel(1	"Architecture and engineering"	
	2	`""Arts, design, entertainment," "sports, and media""'
	3	`""Building and grounds" "cleaning and maintenance""'
	4	`""Business and" "financial operations""'
	5	`""Community and" "social service""'
	6	"Computer and mathematical"
	7	"Construction and extraction"
	8	`""Educational instruction," "and library""'
	9	`""Farming, fishing," "and forestry""'
	10	`""Food preparation" "and serving related""'
	11	`""Healthcare practitioners" "and technical""'
	12	"Healthcare support"
	13	`""Installation, maintenance," "and repair""'
	14	`""Life, physical, and" "social science""'
	15	"Legal"	
	16	"Management"	
	17	"Material moving"	
	18	`""Office and" "administrative support""'
	19	"Personal care and service"	
	20	"Production"	
	21	"Protective service"	
	22	"Sales and related"	
	23	"Transportation")
	label(labsize(*0.6))	)
	bar(1,color("130 176 210") fi(inten100))
	blabel(bar, format(%3.1f) size(tiny) gap(0.3))
	ylabel(, nolabels noticks nogrid) yscale(noline)
	title("") ytitle("") ysize(4) xsize(4) graphregion(margin(zero));
#delimit cr
graph export $figures/occupation_distribution.pdf, replace


*** Correlation Matrices

// the correlation between measures in current year
asdoc pwcorr tenure_current satis_curr_1 salary_curr_1 perform_curr_1 skillfit_curr_1 , sig star(all) replace
// the correlation between measures in last job
asdoc pwcorr tenure_last satis_last_1 salary_last_1 perform_last_1 skillfit_last_1, sig star(all) replace

****************************************************************
*** Normalized Metrics over Tenure Length
****************************************************************

use $working_data/formal_survey_features_demographics_panel, clear

gen tenure_curr_year = round(tenure_curr_)
gen tenure_last_year = round(tenure_last_)

label var tenure_curr_year "Tenure for current job, invariant"
label var tenure_last_year "Tenure for last job, invariant"

* overall in current job

preserve
local variables="std_satis_curr_ std_salary_curr_ std_perform_curr_ std_skillfit_curr_"
foreach var of local variables {
    gen d_`var' = `var'		// compute the se
	gen n_`var' = `var'		// compute the count
}

collapse (mean) std* (semean) d_std* (count) n_std*, by(time)

// for large groups, 1.96 a good estimate for invttail(n-1,0.025)
gen std_satis_ci_l = std_satis_curr_ - invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_
gen std_satis_ci_h = std_satis_curr_ + invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_

gen std_salary_ci_l = std_salary_curr_ - invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_
gen std_salary_ci_h = std_salary_curr_ + invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_

gen std_perform_ci_l = std_perform_curr_ - invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_
gen std_perform_ci_h = std_perform_curr_ + invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_

gen std_skillfit_ci_l = std_skillfit_curr_ - invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_
gen std_skillfit_ci_h = std_skillfit_curr_ + invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_

drop d_std*

#delimit ;
tw  (connected std_satis_curr_ time,lc(blue) lp(solid) msymbol(Oh) msize(small) mcolor(grey2))
	(rarea std_satis_ci_l std_satis_ci_h time,color(blue%25) fintensity(10) lpattern(dot)) 
	(connected std_salary_curr_ time,lc(red) lp(solid) msymbol(Th) msize(small) mcolor(grey5))
	(rarea std_salary_ci_l std_salary_ci_h time,color(red%25) fintensity(10) lpattern(dot)) 
	(connected std_perform_curr_ time,lc(dkgreen) lp(solid) msymbol(Dh) msize(small) mcolor(grey3))
	(rarea std_perform_ci_l std_perform_ci_h time,color(dkgreen%25) fintensity(10) lpattern(dot)) 
	(connected std_skillfit_curr_ time,lc(cranberry) lp(solid) msymbol(Sh) msize(small) mcolor(grey6))
	(rarea std_skillfit_ci_l std_skillfit_ci_h time,color(cranberry%25) fintensity(10) lpattern(dot))
	, xlabel(1 "Year 1" 2 "Year 2" 3 "Year 3" 4 "Current") ylabel(-1(0.25)1) 
	legend(pos(6) r(1) order(1 "Satisfaction" 3 "Salary" 5 "Performance" 7 "Skill fit")) 
	xtitle("# of years in current job") title("") ;
#delimit cr
graph export $figures/std_tenure_curr_4.pdf, replace
restore

// test the difference of the slopes for current job
gen trend_curr = time
replace trend_curr = tenure_curr_ if trend == 4

eststo clear
eststo: qui reg std_salary_curr_ trend_curr if satis_curr_decrease == 0, absorb(id)
eststo: qui reg std_salary_curr_ trend_curr if satis_curr_decrease == 1, absorb(id)
eststo: qui reg std_salary_curr_ c.trend_curr##i.satis_curr_decrease, absorb(id)

eststo: qui reg std_perform_curr_ trend_curr if satis_curr_decrease == 0, absorb(id)
eststo: qui reg std_perform_curr_ trend_curr if satis_curr_decrease == 1, absorb(id)
eststo: qui reg std_perform_curr_ c.trend_curr##i.satis_curr_decrease, absorb(id)

eststo: qui reg std_skillfit_curr_ trend_curr if satis_curr_decrease == 0, absorb(id)
eststo: qui reg std_skillfit_curr_ trend_curr if satis_curr_decrease == 1, absorb(id)
eststo: qui reg std_skillfit_curr_ c.trend_curr##i.satis_curr_decrease, absorb(id)

#delimit ;
esttab using $tables/reg_slope_diff.csv, replace 
	star(* 0.1 ** 0.05 *** 0.01)  se(%9.3f) b(%9.3f)
	compress nogaps label varwidth(20) noconstant
	stats(N r2_a, fmt(%12.0f %9.3f) labels("N" "Adjusted R-square")) ;
#delimit cr


* overall in current job, for people whose satisfaction increased

preserve
local variables="std_satis_curr_ std_salary_curr_ std_perform_curr_ std_skillfit_curr_"
foreach var of local variables {
    gen d_`var' = `var'  // compute the se
	gen n_`var' = `var'  // compute the count
}

collapse (mean) std* (semean) d_std* (count) n_std* , by(time satis_curr_decrease)

gen std_satis_ci_l = std_satis_curr_ - invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_
gen std_satis_ci_h = std_satis_curr_ + invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_

gen std_salary_ci_l = std_salary_curr_ - invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_
gen std_salary_ci_h = std_salary_curr_ + invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_

gen std_perform_ci_l = std_perform_curr_ - invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_
gen std_perform_ci_h = std_perform_curr_ + invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_

gen std_skillfit_ci_l = std_skillfit_curr_ - invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_
gen std_skillfit_ci_h = std_skillfit_curr_ + invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_

drop d_std* n_std*

keep if satis_curr_decrease == 0 

#delimit ;
tw  (connected std_satis_curr_ time,lc(blue) lp(solid) ms(small) msymbol(Oh) mcolor(grey2))
	(rarea std_satis_ci_l std_satis_ci_h time,color(blue%25) fintensity(10) lpattern(dot)) 
	(connected std_salary_curr_ time,lc(red) lp(solid) ms(small) msymbol(Th) mcolor(grey5))
	(rarea std_salary_ci_l std_salary_ci_h time,color(red%25) fintensity(10) lpattern(dot)) 
	(connected std_perform_curr_ time,lc(dkgreen) lp(solid) ms(small) msymbol(Dh) mcolor(grey3))
	(rarea std_perform_ci_l std_perform_ci_h time,color(dkgreen%25) fintensity(10) lpattern(dot)) 
	(connected std_skillfit_curr_ time,lc(cranberry) lp(solid) ms(small) msymbol(Sh) mcolor(grey6))
	(rarea std_skillfit_ci_l std_skillfit_ci_h time,color(cranberry%25) fintensity(10) lpattern(dot))
	, xlabel(1 "Year 1" 2 "Year 2" 3 "Year 3" 4 "Current") ylabel(-1(0.25)1) 
	legend(pos(6) r(1)  order(1 "Satisfaction" 3 "Salary" 5 "Performance" 7 "Skill fit")) 
	xtitle("# of years in current job") title("") ;
#delimit cr
graph export $figures/std_tenure_curr_inc_4.pdf, replace
restore



* overall in current job, for people whose satisfaction decreased

preserve
local variables="std_satis_curr_ std_salary_curr_ std_perform_curr_ std_skillfit_curr_"
foreach var of local variables {
    gen d_`var' = `var'
	gen n_`var' = `var'
}

collapse (mean) std* (semean) d_std* (count) n_std*, by(time satis_curr_decrease)

gen std_satis_ci_l = std_satis_curr_ - invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_
gen std_satis_ci_h = std_satis_curr_ + invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_

gen std_salary_ci_l = std_salary_curr_ - invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_
gen std_salary_ci_h = std_salary_curr_ + invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_

gen std_perform_ci_l = std_perform_curr_ - invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_
gen std_perform_ci_h = std_perform_curr_ + invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_

gen std_skillfit_ci_l = std_skillfit_curr_ - invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_
gen std_skillfit_ci_h = std_skillfit_curr_ + invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_

drop d_std* n_std*

keep if satis_curr_decrease == 1 

#delimit ;
tw  (connected std_satis_curr_ time,lc(blue) lp(solid) ms(small) msymbol(Oh) mcolor(grey2))
	(rarea std_satis_ci_l std_satis_ci_h time,color(blue%25) fintensity(10) lpattern(dot)) 
	(connected std_salary_curr_ time,lc(red) lp(solid) ms(small) msymbol(Th) mcolor(grey5))
	(rarea std_salary_ci_l std_salary_ci_h time,color(red%25) fintensity(10) lpattern(dot)) 
	(connected std_perform_curr_ time,lc(dkgreen) lp(solid) ms(small) msymbol(Dh) mcolor(grey3))
	(rarea std_perform_ci_l std_perform_ci_h time,color(dkgreen%25) fintensity(10) lpattern(dot)) 
	(connected std_skillfit_curr_ time,lc(cranberry) lp(solid) ms(small) msymbol(Sh) mcolor(grey6))
	(rarea std_skillfit_ci_l std_skillfit_ci_h time,color(cranberry%25) fintensity(10) lpattern(dot))
	, xlabel(1 "Year 1" 2 "Year 2" 3 "Year 3" 4 "Current") ylabel(-1(0.25)1) 
	legend(pos(6) r(1)  order(1 "Satisfaction" 3 "Salary" 5 "Performance" 7 "Skill fit")) 
	xtitle("# of years in current job") title("") ;
#delimit cr
graph export $figures/std_tenure_curr_dec_4.pdf, replace
restore


* overall in last job

preserve
local variables="stdl_satis_last_ stdl_salary_last_ stdl_perform_last_ stdl_skillfit_last_"
foreach var of local variables {
    gen d_`var' = `var'
	gen n_`var' = `var'
}

collapse (mean) std* (semean) d_std* (count) n_std*, by(time)

gen std_satis_ci_l = stdl_satis_last_ - invttail(n_stdl_satis_last_-1,0.025)*d_stdl_satis_last_
gen std_satis_ci_h = stdl_satis_last_ + invttail(n_stdl_satis_last_-1,0.025)*d_stdl_satis_last_

gen std_salary_ci_l = stdl_salary_last_ - invttail(n_stdl_salary_last_-1,0.025)*d_stdl_salary_last_
gen std_salary_ci_h = stdl_salary_last_ + invttail(n_stdl_salary_last_-1,0.025)*d_stdl_salary_last_

gen std_perform_ci_l = stdl_perform_last_ - invttail(n_stdl_perform_last_-1,0.025)*d_stdl_perform_last_
gen std_perform_ci_h = stdl_perform_last_ + invttail(n_stdl_perform_last_-1,0.025)*d_stdl_perform_last_

gen std_skillfit_ci_l = stdl_skillfit_last_ - invttail(n_stdl_skillfit_last_-1,0.025)*d_stdl_skillfit_last_
gen std_skillfit_ci_h = stdl_skillfit_last_ + invttail(n_stdl_skillfit_last_-1,0.025)*d_stdl_skillfit_last_

drop d_std* n_std*

#delimit ;
tw  (connected stdl_satis_last_ time,lc(blue) lp(solid) msize(small) msymbol(Oh) mcolor(grey2))
	(rarea std_satis_ci_l std_satis_ci_h time,color(blue%25) fintensity(10) lpattern(dot)) 
	(connected stdl_salary_last_ time,lc(red) lp(solid) msize(small) msymbol(Th) mcolor(grey5))
	(rarea std_salary_ci_l std_salary_ci_h time,color(red%25) fintensity(10) lpattern(dot)) 
	(connected stdl_perform_last_ time,lc(dkgreen) lp(solid) msize(small) msymbol(Dh) mcolor(grey3))
	(rarea std_perform_ci_l std_perform_ci_h time,color(dkgreen%25) fintensity(10) lpattern(dot)) 
	(connected stdl_skillfit_last_ time,lc(cranberry) lp(solid) msize(small) msymbol(Sh) mcolor(grey6))
	(rarea std_skillfit_ci_l std_skillfit_ci_h time,color(cranberry%25) fintensity(10) lpattern(dot))
	, xlabel(1 "Year 1" 2 "Year 2" 3 "Year 3" 4 "Last") ylabel(-1(0.25)1) 
	legend(pos(6) r(1)  order(1 "Satisfaction" 3 "Salary" 5 "Performance" 7 "Skill fit")) 
	xtitle("# of years in last job") title("") ;
#delimit cr
graph export $figures/std_tenure_last_4.pdf, replace
restore

// test the difference of the slopes

reg stdl_satis_last_ time, absorb(id)
estimates store satisfaction

reg stdl_salary_last_ time, absorb(id)
estimates store salary

reg stdl_perform_last_ time, absorb(id)
estimates store performance

reg stdl_skillfit_last_ time, absorb(id)
estimates store skillfit

suest satisfaction salary performance skillfit

di _b[satisfaction_mean:time] - _b[salary_mean:time]
test _b[satisfaction_mean:time] = _b[salary_mean:time]

di _b[satisfaction_mean:time] - _b[performance_mean:time]
test _b[satisfaction_mean:time] = _b[performance_mean:time]

di _b[satisfaction_mean:time] - _b[skillfit_mean:time]
test _b[satisfaction_mean:time] = _b[skillfit_mean:time]

di _b[salary_mean:time] - _b[performance_mean:time]
test _b[salary_mean:time] = _b[performance_mean:time]

di _b[salary_mean:time] - _b[skillfit_mean:time]
test _b[salary_mean:time] = _b[skillfit_mean:time]

di _b[performance_mean:time] - _b[skillfit_mean:time]
test _b[performance_mean:time] = _b[skillfit_mean:time]

* job satisfaction over time by tenure length

preserve
collapse (mean) std_satis_curr_ (semean) d_std_satis_curr_ = std_satis_curr_  ///
	(count) n_std_satis_curr_ = std_satis_curr_, by(tenure_curr_year time)
replace time = tenure_curr_year if time == 4

gen std_satis_ci_l = std_satis_curr_ - invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_
gen std_satis_ci_h = std_satis_curr_ + invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_

#delimit ;
tw (connected std_satis_curr_ time if tenure_curr_year == 4,lc(red)) 
   (connected std_satis_curr_ time if tenure_curr_year == 5,lc(blue))
   (connected std_satis_curr_ time if tenure_curr_year == 6,lc(green))
   (connected std_satis_curr_ time if tenure_curr_year == 7,lc(orange))
   , 
   ylabel(-1(0.25)1) xlabel(1(1)7)
   legend(pos(6) r(1) order(1 "Tenure = 4" 2 "Tenure = 5" 3 "Tenure = 6" 4 "Tenure = 7"))
   xtitle("# of years in current job") ytitle("")
   title("");
#delimit cr
graph export $figures/std_satisfaction_tenure_curr.pdf, replace
restore


* job satisfaction over time by tenure length, by gender

preserve
local variables="std_satis_curr_ std_salary_curr_ std_perform_curr_ std_skillfit_curr_"
foreach var of local variables {
    gen d_`var' = `var'		// compute the se
	gen n_`var' = `var'		// compute the count
}

collapse (mean) std* (semean) d_std* (count) n_std*, by(time gender)

// for large groups, 1.96 a good estimate for invttail(n-1,0.025)
gen std_satis_ci_l = std_satis_curr_ - invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_
gen std_satis_ci_h = std_satis_curr_ + invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_

gen std_salary_ci_l = std_salary_curr_ - invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_
gen std_salary_ci_h = std_salary_curr_ + invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_

gen std_perform_ci_l = std_perform_curr_ - invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_
gen std_perform_ci_h = std_perform_curr_ + invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_

gen std_skillfit_ci_l = std_skillfit_curr_ - invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_
gen std_skillfit_ci_h = std_skillfit_curr_ + invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_

drop d_std* n_std*

keep if gender == 0
#delimit ;
tw  (connected std_satis_curr_ time,lc(blue) lp(solid) msymbol(Oh) msize(small) mcolor(grey2))
	(rarea std_satis_ci_l std_satis_ci_h time,color(blue%25) fintensity(10) lpattern(dot)) 
	(connected std_salary_curr_ time,lc(red) lp(solid) msymbol(Th) msize(small) mcolor(grey5))
	(rarea std_salary_ci_l std_salary_ci_h time,color(red%25) fintensity(10) lpattern(dot)) 
	(connected std_perform_curr_ time,lc(dkgreen) lp(solid) msymbol(Dh) msize(small) mcolor(grey3))
	(rarea std_perform_ci_l std_perform_ci_h time,color(dkgreen%25) fintensity(10) lpattern(dot)) 
	(connected std_skillfit_curr_ time,lc(cranberry) lp(solid) msymbol(Sh) msize(small) mcolor(grey6))
	(rarea std_skillfit_ci_l std_skillfit_ci_h time,color(cranberry%25) fintensity(10) lpattern(dot))
	, xlabel(1 "Year 1" 2 "Year 2" 3 "Year 3" 4 "Current") ylabel(-1(0.25)1) 
	legend(pos(6) r(1) order(1 "Satisfaction" 3 "Salary" 5 "Performance" 7 "Skill fit")) 
	xtitle("# of years in current job") title("") ;
#delimit cr
graph export $figures/std_tenure_curr_4_women.pdf, replace
restore
preserve
local variables="std_satis_curr_ std_salary_curr_ std_perform_curr_ std_skillfit_curr_"
foreach var of local variables {
    gen d_`var' = `var'		// compute the se
	gen n_`var' = `var'		// compute the count
}

collapse (mean) std* (semean) d_std* (count) n_std*, by(time gender)

// for large groups, 1.96 a good estimate for invttail(n-1,0.025)
gen std_satis_ci_l = std_satis_curr_ - invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_
gen std_satis_ci_h = std_satis_curr_ + invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_

gen std_salary_ci_l = std_salary_curr_ - invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_
gen std_salary_ci_h = std_salary_curr_ + invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_

gen std_perform_ci_l = std_perform_curr_ - invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_
gen std_perform_ci_h = std_perform_curr_ + invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_

gen std_skillfit_ci_l = std_skillfit_curr_ - invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_
gen std_skillfit_ci_h = std_skillfit_curr_ + invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_

drop d_std* n_std*

keep if gender == 1
#delimit ;
tw  (connected std_satis_curr_ time,lc(blue) lp(solid) msymbol(Oh) msize(small) mcolor(grey2))
	(rarea std_satis_ci_l std_satis_ci_h time,color(blue%25) fintensity(10) lpattern(dot)) 
	(connected std_salary_curr_ time,lc(red) lp(solid) msymbol(Th) msize(small) mcolor(grey5))
	(rarea std_salary_ci_l std_salary_ci_h time,color(red%25) fintensity(10) lpattern(dot)) 
	(connected std_perform_curr_ time,lc(dkgreen) lp(solid) msymbol(Dh) msize(small) mcolor(grey3))
	(rarea std_perform_ci_l std_perform_ci_h time,color(dkgreen%25) fintensity(10) lpattern(dot)) 
	(connected std_skillfit_curr_ time,lc(cranberry) lp(solid) msymbol(Sh) msize(small) mcolor(grey6))
	(rarea std_skillfit_ci_l std_skillfit_ci_h time,color(cranberry%25) fintensity(10) lpattern(dot))
	, xlabel(1 "Year 1" 2 "Year 2" 3 "Year 3" 4 "Current") ylabel(-1(0.25)1) 
	legend(pos(6) r(1) order(1 "Satisfaction" 3 "Salary" 5 "Performance" 7 "Skill fit")) 
	xtitle("# of years in current job") title("") ;
#delimit cr
graph export $figures/std_tenure_curr_4_men.pdf, replace
restore

* job satisfaction over time by tenure length, by white-collar vs. blue-collar jobs

/*
White-Collar Jobs:

Management occupations
Business and financial operations occupations
Computer and mathematical occupations
Architecture and engineering occupations
Life, physical, and social science occupations
Community and social service occupations
Legal occupations
Education, training, and library occupations
Arts, design, entertainment, sports, and media occupations
Healthcare practitioners and technical occupations
Sales and related occupations
Office and administrative support occupations


Blue-Collar Jobs:

Healthcare support occupations
Protective service occupations
Food preparation and serving related occupations
Building and grounds cleaning and maintenance occupations
Personal care and service occupations
Farming, fishing, and forestry occupations
Construction and extraction occupations
Installation, maintenance, and repair occupations
Production occupations
Transportation occupations
Material Moving Occupations
*/

gen whitecollar = .
replace whitecollar = 1 if inlist(occupationcurrent,1,2,4,5,6,8,11,14,15,16,18,22)
replace whitecollar = 0 if inlist(occupationcurrent,3,7,9,10,12,13,17,19,20,21,23)

preserve
local variables="std_satis_curr_ std_salary_curr_ std_perform_curr_ std_skillfit_curr_"
foreach var of local variables {
    gen d_`var' = `var'		// compute the se
	gen n_`var' = `var'		// compute the count
}

collapse (mean) std* (semean) d_std* (count) n_std*, by(time whitecollar)

gen std_satis_ci_l = std_satis_curr_ - invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_
gen std_satis_ci_h = std_satis_curr_ + invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_

gen std_salary_ci_l = std_salary_curr_ - invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_
gen std_salary_ci_h = std_salary_curr_ + invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_

gen std_perform_ci_l = std_perform_curr_ - invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_
gen std_perform_ci_h = std_perform_curr_ + invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_

gen std_skillfit_ci_l = std_skillfit_curr_ - invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_
gen std_skillfit_ci_h = std_skillfit_curr_ + invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_

drop d_std* n_std*

keep if whitecollar == 0
#delimit ;
tw  (connected std_satis_curr_ time,lc(blue) lp(solid) msymbol(Oh) msize(small) mcolor(grey2))
	(rarea std_satis_ci_l std_satis_ci_h time,color(blue%25) fintensity(10) lpattern(dot)) 
	(connected std_salary_curr_ time,lc(red) lp(solid) msymbol(Th) msize(small) mcolor(grey5))
	(rarea std_salary_ci_l std_salary_ci_h time,color(red%25) fintensity(10) lpattern(dot)) 
	(connected std_perform_curr_ time,lc(dkgreen) lp(solid) msymbol(Dh) msize(small) mcolor(grey3))
	(rarea std_perform_ci_l std_perform_ci_h time,color(dkgreen%25) fintensity(10) lpattern(dot)) 
	(connected std_skillfit_curr_ time,lc(cranberry) lp(solid) msymbol(Sh) msize(small) mcolor(grey6))
	(rarea std_skillfit_ci_l std_skillfit_ci_h time,color(cranberry%25) fintensity(10) lpattern(dot))
	, xlabel(1 "Year 1" 2 "Year 2" 3 "Year 3" 4 "Current") ylabel(-1(0.25)1) 
	legend(pos(6) r(1) order(1 "Satisfaction" 3 "Salary" 5 "Performance" 7 "Skill fit")) 
	xtitle("# of years in current job") title("") ;
#delimit cr
graph export $figures/std_tenure_curr_4_bluecollar.pdf, replace
restore
preserve
local variables="std_satis_curr_ std_salary_curr_ std_perform_curr_ std_skillfit_curr_"
foreach var of local variables {
    gen d_`var' = `var'		// compute the se
	gen n_`var' = `var'		// compute the count
}

collapse (mean) std* (semean) d_std* (count) n_std*, by(time whitecollar)

gen std_satis_ci_l = std_satis_curr_ - invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_
gen std_satis_ci_h = std_satis_curr_ + invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_

gen std_salary_ci_l = std_salary_curr_ - invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_
gen std_salary_ci_h = std_salary_curr_ + invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_

gen std_perform_ci_l = std_perform_curr_ - invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_
gen std_perform_ci_h = std_perform_curr_ + invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_

gen std_skillfit_ci_l = std_skillfit_curr_ - invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_
gen std_skillfit_ci_h = std_skillfit_curr_ + invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_

drop d_std* n_std*

keep if whitecollar == 1
#delimit ;
tw  (connected std_satis_curr_ time,lc(blue) lp(solid) msymbol(Oh) msize(small) mcolor(grey2))
	(rarea std_satis_ci_l std_satis_ci_h time,color(blue%25) fintensity(10) lpattern(dot)) 
	(connected std_salary_curr_ time,lc(red) lp(solid) msymbol(Th) msize(small) mcolor(grey5))
	(rarea std_salary_ci_l std_salary_ci_h time,color(red%25) fintensity(10) lpattern(dot)) 
	(connected std_perform_curr_ time,lc(dkgreen) lp(solid) msymbol(Dh) msize(small) mcolor(grey3))
	(rarea std_perform_ci_l std_perform_ci_h time,color(dkgreen%25) fintensity(10) lpattern(dot)) 
	(connected std_skillfit_curr_ time,lc(cranberry) lp(solid) msymbol(Sh) msize(small) mcolor(grey6))
	(rarea std_skillfit_ci_l std_skillfit_ci_h time,color(cranberry%25) fintensity(10) lpattern(dot))
	, xlabel(1 "Year 1" 2 "Year 2" 3 "Year 3" 4 "Current") ylabel(-1(0.25)1) 
	legend(pos(6) r(1) order(1 "Satisfaction" 3 "Salary" 5 "Performance" 7 "Skill fit")) 
	xtitle("# of years in current job") title("") ;
#delimit cr
graph export $figures/std_tenure_curr_4_whitecollar.pdf, replace
restore


* job satisfaction over time by tenure length, by age 40

gen age40 = (age < 40)

preserve
local variables="std_satis_curr_ std_salary_curr_ std_perform_curr_ std_skillfit_curr_"
foreach var of local variables {
    gen d_`var' = `var'		// compute the se
	gen n_`var' = `var'		// compute the count
}

collapse (mean) std* (semean) d_std* (count) n_std*, by(time age40)

gen std_satis_ci_l = std_satis_curr_ - invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_
gen std_satis_ci_h = std_satis_curr_ + invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_

gen std_salary_ci_l = std_salary_curr_ - invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_
gen std_salary_ci_h = std_salary_curr_ + invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_

gen std_perform_ci_l = std_perform_curr_ - invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_
gen std_perform_ci_h = std_perform_curr_ + invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_

gen std_skillfit_ci_l = std_skillfit_curr_ - invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_
gen std_skillfit_ci_h = std_skillfit_curr_ + invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_

drop d_std* n_std*

keep if age40 == 0
#delimit ;
tw  (connected std_satis_curr_ time,lc(blue) lp(solid) msymbol(Oh) msize(small) mcolor(grey2))
	(rarea std_satis_ci_l std_satis_ci_h time,color(blue%25) fintensity(10) lpattern(dot)) 
	(connected std_salary_curr_ time,lc(red) lp(solid) msymbol(Th) msize(small) mcolor(grey5))
	(rarea std_salary_ci_l std_salary_ci_h time,color(red%25) fintensity(10) lpattern(dot)) 
	(connected std_perform_curr_ time,lc(dkgreen) lp(solid) msymbol(Dh) msize(small) mcolor(grey3))
	(rarea std_perform_ci_l std_perform_ci_h time,color(dkgreen%25) fintensity(10) lpattern(dot)) 
	(connected std_skillfit_curr_ time,lc(cranberry) lp(solid) msymbol(Sh) msize(small) mcolor(grey6))
	(rarea std_skillfit_ci_l std_skillfit_ci_h time,color(cranberry%25) fintensity(10) lpattern(dot))
	, xlabel(1 "Year 1" 2 "Year 2" 3 "Year 3" 4 "Current") ylabel(-1(0.25)1) 
	legend(pos(6) r(1) order(1 "Satisfaction" 3 "Salary" 5 "Performance" 7 "Skill fit")) 
	xtitle("# of years in current job") title("") ;
#delimit cr
graph export $figures/std_tenure_curr_4_agebelow40.pdf, replace
restore
preserve
local variables="std_satis_curr_ std_salary_curr_ std_perform_curr_ std_skillfit_curr_"
foreach var of local variables {
    gen d_`var' = `var'		// compute the se
	gen n_`var' = `var'		// compute the count
}

collapse (mean) std* (semean) d_std* (count) n_std*, by(time age40)

gen std_satis_ci_l = std_satis_curr_ - invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_
gen std_satis_ci_h = std_satis_curr_ + invttail(n_std_satis_curr_-1,0.025)*d_std_satis_curr_

gen std_salary_ci_l = std_salary_curr_ - invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_
gen std_salary_ci_h = std_salary_curr_ + invttail(n_std_salary_curr_-1,0.025)*d_std_salary_curr_

gen std_perform_ci_l = std_perform_curr_ - invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_
gen std_perform_ci_h = std_perform_curr_ + invttail(n_std_perform_curr_-1,0.025)*d_std_perform_curr_

gen std_skillfit_ci_l = std_skillfit_curr_ - invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_
gen std_skillfit_ci_h = std_skillfit_curr_ + invttail(n_std_skillfit_curr_-1,0.025)*d_std_skillfit_curr_

drop d_std* n_std*

keep if age40 == 1
#delimit ;
tw  (connected std_satis_curr_ time,lc(blue) lp(solid) msymbol(Oh) msize(small) mcolor(grey2))
	(rarea std_satis_ci_l std_satis_ci_h time,color(blue%25) fintensity(10) lpattern(dot)) 
	(connected std_salary_curr_ time,lc(red) lp(solid) msymbol(Th) msize(small) mcolor(grey5))
	(rarea std_salary_ci_l std_salary_ci_h time,color(red%25) fintensity(10) lpattern(dot)) 
	(connected std_perform_curr_ time,lc(dkgreen) lp(solid) msymbol(Dh) msize(small) mcolor(grey3))
	(rarea std_perform_ci_l std_perform_ci_h time,color(dkgreen%25) fintensity(10) lpattern(dot)) 
	(connected std_skillfit_curr_ time,lc(cranberry) lp(solid) msymbol(Sh) msize(small) mcolor(grey6))
	(rarea std_skillfit_ci_l std_skillfit_ci_h time,color(cranberry%25) fintensity(10) lpattern(dot))
	, xlabel(1 "Year 1" 2 "Year 2" 3 "Year 3" 4 "Current") ylabel(-1(0.25)1) 
	legend(pos(6) r(1) order(1 "Satisfaction" 3 "Salary" 5 "Performance" 7 "Skill fit")) 
	xtitle("# of years in current job") title("") ;
#delimit cr
graph export $figures/std_tenure_curr_4_age40andabove.pdf, replace
restore

