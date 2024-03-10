* Understanding society descriptives
* Michele Belot, Xiaoying Liu, Vaios Triantafyllou
* 3.understanding_sociaty_descriptives.do 

*-----------------------------------------------------------------*
* Purpose: This file cleans the survey raw data
*-----------------------------------------------------------------*

* ----------- Part 4: Merging ------------- *


* ----------- Keep relevant observations ------------- *

use "$processed_data/clean_uhkls.dta", clear
asdoc pwcorr tenure jbsat payg_dv skill_fit, sig star(all) replace
asdoc pwcorr tenure jbsat payn_dv skill_fit, sig star(all) replace


gen satinc = .
bys pidp(waveno): replace satinc = 1 if jbsat[_N] - jbsat[1]>=0
bys pidp(waveno): replace satinc = 0 if jbsat[_N] - jbsat[1]<0

collapse (mean) std* (semean) d_std* (count) n_std*, by(tenure)

// for large groups, 1.96 a good estimate for invttail(n-1,0.025)
gen std_jbsat_ci_l = std_jbsat - invttail(n_std_jbsat-1,0.025)*d_std_jbsat
gen std_jbsat_ci_h = std_jbsat + invttail(n_std_jbsat-1,0.025)*d_std_jbsat

gen std_payg_dv_ci_l = std_payg_dv - invttail(n_std_payg_dv-1,0.025)*d_std_payg_dv
gen std_payg_dv_ci_h = std_payg_dv + invttail(n_std_payg_dv-1,0.025)*d_std_payg_dv

gen std_payn_dv_ci_l = std_payn_dv - invttail(n_std_payn_dv-1,0.025)*d_std_payn_dv
gen std_payn_dv_ci_h = std_payn_dv + invttail(n_std_payn_dv-1,0.025)*d_std_payn_dv

gen std_skill_fit_ci_l = std_skill_fit - invttail(n_std_skill_fit-1,0.025)*d_std_skill_fit
gen std_skill_fit_ci_h = std_skill_fit + invttail(n_std_skill_fit-1,0.025)*d_std_skill_fit

drop d_std*

preserve
keep if tenure<5
tw (connected std_jbsat tenure,lc(blue)  msymbol(Oh) mcolor(grey2))(rarea std_jbsat_ci_l std_jbsat_ci_h tenure,color(blue%35) fintensity(10) lpattern(dot)) (connected std_payn_dv tenure,lc(red)  msymbol(Th) mcolor(grey5))(rarea std_payn_dv_ci_l std_payn_dv_ci_h tenure,color(red%35) fintensity(10) lpattern(dot)) (connected std_payg_dv tenure,lc(green)  msymbol(Dh) mcolor(grey3))(rarea std_payg_dv_ci_l std_payg_dv_ci_h tenure,color(green%35) fintensity(10) lpattern(dot))(connected std_skill_fit tenure,lc(purple)  msymbol(Dh) mcolor(grey3))(rarea std_skill_fit_ci_l std_skill_fit_ci_h tenure,color(purple%35) fintensity(10) lpattern(dot)), xlabel(0 "Year 0" 1 "Year 1" 2 "Year 2" 3 "Year 3" 4 "Year 5") ylabel(-0.5(0.25)0.5) legend(pos(6) r(1)  order(1 "Satisfaction" 3 "Salary net" 5 "Salary gross" 7 "Skill fit")) xtitle("# of years in job")
graph export "${figures}/ukhls_tenure.png", as(png) name("Graph") replace
restore

use "$processed_data/clean_uhkls.dta", clear

gen satinc = .
bys pidp(waveno): replace satinc = 1 if jbsat[_N] - jbsat[1]>=0
bys pidp(waveno): replace satinc = 0 if jbsat[_N] - jbsat[1]<0

collapse (mean) std* (semean) d_std* (count) n_std*, by(tenure satinc)

// for large groups, 1.96 a good estimate for invttail(n-1,0.025)
gen std_jbsat_ci_l = std_jbsat - invttail(n_std_jbsat-1,0.025)*d_std_jbsat
gen std_jbsat_ci_h = std_jbsat + invttail(n_std_jbsat-1,0.025)*d_std_jbsat

gen std_payg_dv_ci_l = std_payg_dv - invttail(n_std_payg_dv-1,0.025)*d_std_payg_dv
gen std_payg_dv_ci_h = std_payg_dv + invttail(n_std_payg_dv-1,0.025)*d_std_payg_dv

gen std_payn_dv_ci_l = std_payn_dv - invttail(n_std_payn_dv-1,0.025)*d_std_payn_dv
gen std_payn_dv_ci_h = std_payn_dv + invttail(n_std_payn_dv-1,0.025)*d_std_payn_dv

gen std_skill_fit_ci_l = std_skill_fit - invttail(n_std_skill_fit-1,0.025)*d_std_skill_fit
gen std_skill_fit_ci_h = std_skill_fit + invttail(n_std_skill_fit-1,0.025)*d_std_skill_fit

drop d_std*

preserve
keep if tenure<5 & satinc == 1
tw (connected std_jbsat tenure,lc(blue)  msymbol(Oh) mcolor(grey2))(rarea std_jbsat_ci_l std_jbsat_ci_h tenure,color(blue%35) fintensity(10) lpattern(dot)) (connected std_payn_dv tenure,lc(red)  msymbol(Th) mcolor(grey5))(rarea std_payn_dv_ci_l std_payn_dv_ci_h tenure,color(red%35) fintensity(10) lpattern(dot)) (connected std_payg_dv tenure,lc(green)  msymbol(Dh) mcolor(grey3))(rarea std_payg_dv_ci_l std_payg_dv_ci_h tenure,color(green%35) fintensity(10) lpattern(dot))(connected std_skill_fit tenure,lc(purple)  msymbol(Dh) mcolor(grey3))(rarea std_skill_fit_ci_l std_skill_fit_ci_h tenure,color(purple%35) fintensity(10) lpattern(dot)), xlabel(1 "Year 1" 2 "Year 2" 3 "Year 3" 4 "Year 5") ylabel(-1(0.25)1) legend(pos(6) r(1)  order(1 "Satisfaction" 3 "Salary net" 5 "Salary gross" 7 "Skill fit")) xtitle("# of years in current job")
graph export "${figures}/ukhls_tenure_satinc.png", as(png) name("Graph") replace

restore

preserve
keep if tenure<5 & satinc == 0
tw (connected std_jbsat tenure,lc(blue)  msymbol(Oh) mcolor(grey2))(rarea std_jbsat_ci_l std_jbsat_ci_h tenure,color(blue%35) fintensity(10) lpattern(dot)) (connected std_payn_dv tenure,lc(red)  msymbol(Th) mcolor(grey5))(rarea std_payn_dv_ci_l std_payn_dv_ci_h tenure,color(red%35) fintensity(10) lpattern(dot)) (connected std_payg_dv tenure,lc(green)  msymbol(Dh) mcolor(grey3))(rarea std_payg_dv_ci_l std_payg_dv_ci_h tenure,color(green%35) fintensity(10) lpattern(dot))(connected std_skill_fit tenure,lc(purple)  msymbol(Dh) mcolor(grey3))(rarea std_skill_fit_ci_l std_skill_fit_ci_h tenure,color(purple%35) fintensity(10) lpattern(dot)), xlabel(1 "Year 1" 2 "Year 2" 3 "Year 3" 4 "Year 5") ylabel(-1(0.25)1) legend(pos(6) r(1)  order(1 "Satisfaction" 3 "Salary net" 5 "Salary gross" 7 "Skill fit")) xtitle("# of years in current job") 
graph export "${figures}/ukhls_tenure_satdec.png", as(png) name("Graph") replace

restore

-

eststo clear
eststo: reghdfe tenure jbsat payn_dv, absorb(jbsoc10_cc waveno) cluster(pidp)
eststo: reghdfe tenure jbsat payg_dv, absorb(jbiindb_dv waveno) cluster(pidp)
eststo: reghdfe tenure jbsat payg_dv, absorb(age sex jbsoc10_cc waveno) cluster(pidp)
eststo: reghdfe tenure jbsat payg_dv, absorb(age sex jbiindb_dv waveno) cluster(pidp)

eststo clear
eststo: reghdfe tenure jbsat_std payg_dv_std, absorb(jbsoc10_cc waveno) cluster(pidp)
eststo: reghdfe tenure jbsat_std payg_dv_std, absorb(jbiindb_dv waveno) cluster(pidp)
eststo: reghdfe tenure jbsat_std payg_dv_std, absorb(age sex jbsoc10_cc waveno) cluster(pidp)
eststo: reghdfe tenure jbsat_std payg_dv_std, absorb(age sex jbiindb_dv waveno) cluster(pidp)




