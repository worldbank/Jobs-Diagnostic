***************************************************************************************
** Basic Indicator Generation                                                        **
** This version: May 2018 (Michael Weber & Jörg Langbein)     	            		 **
***************************************************************************************
***************************************************************************************


program Regressions
version 14.2


dis "",  _newline(8)


dis "The Regressions are being created now. Please wait."





qui{




*****************************************************
************* Settings ******************************
*****************************************************

*** Setting the figure coloring to Jobs group colours

grstyle init
grstyle color p1  "0 85 184"
grstyle color p2  "0 173 228"
grstyle color p3  "0 96 104"
grstyle color p4  "27 117 184"
grstyle color p5  "0 100 80"
grstyle color p6  "109 110 112"
grstyle color p7  "0 128 255"
grstyle color p8  "0 42 255"
grstyle color p9   "0 35 69"
grstyle color p10  "85 107 47"
grstyle color p11 "0 34 204"
grstyle color p12 "153 170 255"



*** Globbals and Locals
local date : dis %td_CCYYNNDD date(c(current_date), "DMY")

global data "$user\\$y\Data"
global graph "$user\\$y\JDLT_`date'\"
global indicators  "$user\\$y\JDLT_`date'\Question 1 - Jobs and workers profile"
global regressions "$user\\$y\JDLT_`date'\Question 5 - Worker characteristics and LM outcomes"
global condALL   age>=15 & age<=64
global noCondALL age<15 & age>64	



use "$data/I2D2_test_$y.dta", clear







***********************************************
********* Multinomial Logit for Lstatus *******
***********************************************

levels year_s
foreach lev in `r(levels)' {

use "$data/I2D2_test_$y.dta", clear


** Data preparation

keep if year_s=="`lev'"
gen age2 = age^2
la var age2 "Age Squared"
la var hhsize "Size of Household" 

gen base_reg=region if reg01==1
gsort reg01
bys year_s: replace base_reg=base_reg[_n-1] if base_reg==""
tab base_reg, m
local base_r=base_reg


** Regressions

eststo clear
local varlist "lstatus age gender married urb edulevelSEL hhsize reg01"

foreach var in `varlist'{

bys year: egen nonmissing_`var'=count(`var')
}

if nonmissing_lstatus!=0 & nonmissing_age!=0 & nonmissing_gender!=0 & nonmissing_married!=0 & nonmissing_urb!=0 & nonmissing_edulevelSEL!=0 & nonmissing_hhsize!=0  & nonmissing_reg01!=0 {
 
 
mlogit lstatus age age2 i.gender i.married i.urb i.edulevelSEL hhsize  i.reg01 if $condALL [aweight=wgt], baseoutcome(3) nolog
        est store mlogit_lstatus_all

	forval i = 1/3 {
margins, dydx(*) predict(outcome(`i')) post
est store mlogit_lstatus_AME`i'
est res mlogit_lstatus_all
}


mlogit lstatus age age2 i.married i.urb i.edulevelSEL hhsize i.reg01 if $condALL & gender==2 [aweight=wgt], baseoutcome(3) nolog
        est store mlogit_lstatus_fem

	forval i = 1/3 {
margins, dydx(*) predict(outcome(`i')) post
est store mlogit_lstatus_AME_fem`i'
est res mlogit_lstatus_fem
}


mlogit lstatus age age2 i.married i.urb i.edulevelSEL hhsize i.reg01 if $condALL & gender==1 [aweight=wgt], baseoutcome(3) nolog
        est store mlogit_lstatus_mal

	forval i = 1/3 {
margins, dydx(*) predict(outcome(`i')) post
est store mlogit_lstatus_AME_mal`i'
est res mlogit_lstatus_mal
}

cd "$regressions\Labor Status"

local lstatus_logodds "mlogit_lstatus_all mlogit_lstatus_fem mlogit_lstatus_mal"

local lstatus_AME "mlogit_lstatus_AME1 mlogit_lstatus_AME2 mlogit_lstatus_AME3"

local lstatus_AME_mal "mlogit_lstatus_AME_mal1 mlogit_lstatus_AME_mal2 mlogit_lstatus_AME_mal3"

local lstatus_AME_fem "mlogit_lstatus_AME_fem1 mlogit_lstatus_AME_fem2 mlogit_lstatus_AME_fem3"



esttab `lstatus_logodds' using "mlogit_00_lstatus_logodds_`lev'.csv", replace compress nonumbers unstack nogap label mtitles(`lstatus_logodds') b(%6.3f) /// 
		                 scalars(N ll) star(* 0.1 ** 0.05 *** 0.01) title("Multinomial Logit of Labor Status: Log Odds, $y `lev'") 
		
esttab `lstatus_AME' using "mlogit_00_lstatus_AME_`lev'.csv", replace compress nonumbers unstack nogap label mtitles(`lstatus_AME') b(%6.3f) /// 
		                 scalars(N ll) star(* 0.1 ** 0.05 *** 0.01) title("Multinomial Logit of Labor Status: Average Marginal Effects, $y `lev'") 



esttab `lstatus_AME_mal' using "mlogit_00_lstatus_AME_`lev'_mal.csv", replace compress nonumbers unstack nogap label mtitles(`lstatus_AME_mal') b(%6.3f) /// 
		                 scalars(N ll) star(* 0.1 ** 0.05 *** 0.01) title("Multinomial Logit of Labor Status: Average Marginal Effects for Male, $y `lev'") 


esttab `lstatus_AME_fem' using "mlogit_00_lstatus_AME_`lev'_fem.csv", replace compress nonumbers unstack nogap label mtitles(`lstatus_AME_fem') b(%6.3f) /// 
		                 scalars(N ll) star(* 0.1 ** 0.05 *** 0.01) title("Multinomial Logit of Labor Status: Average Marginal Effects for Female, $y `lev'") 
		
						 

* Plotting the main marginal effects estimation 
coefplot (mlogit_lstatus_AME1, aseq(1) \ mlogit_lstatus_AME2, aseq(2) \ mlogit_lstatus_AME3, aseq(3)), keep(*: age *.gender *.edulevelSEL) drop(_cons) omitted ///
 bylabel(AME) ||, xline(0) byopts(xrescale)	xtitle("Av. Marginal Effects") mlabel format(%9.2g) mlabposition(12) mlabgap(*2) ///
 title("Multinomial Logit: Marginal Effects, $y `lev'", size (small)) eqlabels("{bf:Employed}" "{bf:Unemployed}" "{bf:Out of LF}", asheadings)
	graph export "mlogit_00_lstatus_AME_demographics_`lev'.png", replace

coefplot (mlogit_lstatus_AME1, aseq(1) \ mlogit_lstatus_AME2, aseq(2) \ mlogit_lstatus_AME3, aseq(3)), keep(*: *married hhsize) drop(_cons) omitted ///
 bylabel(AME) ||, xline(0) byopts(xrescale)	xtitle("Av. Marginal Effects") mlabel format(%9.2g) mlabposition(12) mlabgap(*2) ///
 title("Multinomial Logit: Marginal Effects, $y `lev'", size (small)) eqlabels("{bf:Employed}" "{bf:Unemployed}" "{bf:Out of LF}", asheadings)
	graph export "mlogit_00_lstatus_AME_household_`lev'.png", replace	
		
coefplot (mlogit_lstatus_AME1, aseq(1) \ mlogit_lstatus_AME2, aseq(2) \ mlogit_lstatus_AME3, aseq(3)), keep(*: *.urb *.reg01) drop(_cons) omitted ///
 bylabel(AME) ||, xline(0) byopts(xrescale) xtitle("Av. Marginal Effects") mlabel format(%9.2g) mlabposition(12) mlabgap(*2)  ////
 title("Multinomial Logit: Marginal Effects, $y `lev'", size (small)) eqlabels("{bf:Employed}" "{bf:Unemployed}" "{bf:Out of LF}", asheadings) ///
 	note("Note: Base region is `base_r'.", size(small))
	graph export "mlogit_00_lstatus_AME_loc_`lev'.png", replace

}

else {
di "Labor Status or other relevant variable are missing in `lev'"
}
}


eststo clear



use "$data/I2D2_test_$y.dta", clear

levels year_s
foreach lev in `r(levels)' {

use "$data/I2D2_test_$y.dta", clear


keep if year_s=="`lev'"

		local n=year

      

 gen age2 = age^2
 la var age2 "Age Squared"

 la var hhsize "Size of Household" 

 
 
 global condALL age_x <3

 
 
 keep if lstatus==1

 keep if empstat==1 
 
 
eststo clear

gen base_reg=region if reg01==1
gsort reg01
bys year_s: replace base_reg=base_reg[_n-1] if base_reg==""
tab base_reg, m
local base_r=base_reg

di "`base_r'"


g form_vs_inform=.   
replace form_vs_inform=1 if informal==0
replace form_vs_inform=0 if informal==1

gen form_work=1 if informal==0
gen non_form_work=1 if informal==1



bys year_s: egen nonmissing_form_work=count(form_work)
bys year_s: egen nonmissing_non_form_work=count(non_form_work)


local varlist "empstat industry age gender married urb edulevelSEL  hhsize reg01"

foreach var in `varlist'{
bys year: egen nonmissing_`var'=count(`var')
}

if nonmissing_form_work!=0 & nonmissing_non_form_work!=0 & nonmissing_age!=0 & nonmissing_gender!=0 & nonmissing_married!=0 & nonmissing_urb!=0 & nonmissing_edulevelSEL!=0 & nonmissing_hhsize!=0 & nonmissing_reg01!=0 {
  

table edulevelSEL age_x urb [pw=wgt], by(gender) format(%9.3f) sc col row

table edulevelSEL age_x urb [pw=wgt], by(gender) c(mean form_vs_inform) format(%9.3f) sc col row

table form_vs_inform edulevelSEL [pw=wgt], format(%9.2f) center row col
 
 eststo clear
 
probit form_vs_inform age age2 i.gender i.married i.urb i.edulevelSEL i.industry_x hhsize i.reg01 if $condALL [iweight=wgt], vce(robust)
est sto coe_form_vs_inform`n'
margins, dydx(*) post
est sto mar_form_vs_inform`n'


cd "$regressions\Probit\Formal vs Informal"



global form_vs_inform_COEcsv = "b(3) se(2) pr2 star(* 0.1 ** 0.05 *** 0.01) nogap label mtitles(All-Sample) replace"
global form_vs_inform_AMEcsv = "b(3) se(2) star(* 0.1 ** 0.05 *** 0.01) nogap label mtitles(All-Sample) replace"

esttab coe_form_vs_inform`n' using "form_vs_inform_COE_`lev'.csv", $form_vs_inform_COEcsv
esttab mar_form_vs_inform`n' using "form_vs_inform_MAR_`lev'.csv", $form_vs_inform_AMEcsv

 
coefplot (mar_form_vs_inform`n'), ///
keep(*: age *.gender *.edulevelSEL *.industry_x) drop(_cons) omitted  ///
 bylabel(AME) ||, xline(0) byopts(xrescale)	xtitle("Av. Marginal Effects") ///
 mlabel format(%9.2g) mlabposition(12) mlabgap(*2) ///  
 title("Probit: Formal vs Non-Formal Employment, only wage worker $y `lev'", size (small)) ///
	note("Note: Dependent variable is 1 if the worker is in formal employment and 0 otherwise.", size(vsmall)) ///
 ylab( ,nogrid ang(hor)labsize(small)labcol(black)) xlab(, labcol(black))  
	graph export "probit_form_vs_inform_AME_demographics_`lev'.png", replace

	
coefplot (mar_form_vs_inform`n'), ///
keep(*: *married hhsize) drop(_cons) omitted ///
 bylabel(AME) ||, xline(0) byopts(xrescale)	xtitle("Av. Marginal Effects") ///
 mlabel format(%9.2g) mlabposition(12) mlabgap(*2) ///  
 title("Probit: Formal vs Non-Formal Employment, only wage worker $y `lev'", size (small)) ///
 	note("Note: Dependent variable is 1 if the worker is in formal employment and 0 otherwise.", size(vsmall)) ///
 ylab( ,nogrid ang(hor)labsize(small)labcol(black)) xlab(, labcol(black))  
	graph export "probit_form_vs_inform_AME_household_`lev'.png", replace


coefplot (mar_form_vs_inform`n'), ///
keep(*: *.urb *.reg01) drop(_cons) omitted ///
 bylabel(AME) ||, xline(0) byopts(xrescale)	xtitle("Av. Marginal Effects") ///
 mlabel format(%9.2g) mlabposition(12) mlabgap(*2) ///  
 title("Probit: Formal vs Non-Formal Employment, only wage worker $y `lev'", size (small)) ///
 	note("Note: Dependent variable is 1 if the worker is in formal employment and 0 otherwise. Base region is `base_r'.", size(vsmall)) ///
 ylab( ,nogrid ang(hor)labsize(small)labcol(black)) xlab(, labcol(black))  
	graph export "probit_form_vs_inform_AME_loc_`lev'.png", replace	
	
		

}

else {
di "Relevant variable has missing values for all obs. in year `lev'"
}

}

 

eststo clear



use "$data/I2D2_test_$y.dta", clear

levels year_s
foreach lev in `r(levels)' {

use "$data/I2D2_test_$y.dta", clear



keep if year_s=="`lev'"

		local n=year


 gen age2 = age^2
 la var age2 "Age Squared"

 la var hhsize "Size of Household" 

 
 
 global condALL age_x <3

 
 
 keep if lstatus==1

 keep if empstat==1 
 
 
eststo clear

gen base_reg=region if reg01==1
gsort reg01
bys year_s: replace base_reg=base_reg[_n-1] if base_reg==""
tab base_reg, m
local base_r=base_reg

di "`base_r'"


g pub_vs_nonpub=.
replace pub_vs_nonpub=1 if ocusec==1
replace pub_vs_nonpub=0 if ocusec==2

gen pub_work=1 if ocusec==1
gen non_pub_work=1 if ocusec==2



bys year_s: egen nonmissing_pub_work=count(pub_work)
bys year_s: egen nonmissing_non_pub_work=count(non_pub_work)


local varlist "empstat age gender married urb edulevelSEL hhsize reg01"

foreach var in `varlist'{
bys year: egen nonmissing_`var'=count(`var')
}

if nonmissing_pub_work!=0 & nonmissing_non_pub_work!=0  & nonmissing_age!=0 & nonmissing_gender!=0 & nonmissing_married!=0 & nonmissing_urb!=0 & nonmissing_edulevelSEL!=0 & nonmissing_hhsize!=0 & nonmissing_reg01!=0 {
  

table edulevelSEL age_x urb [pw=wgt], by(gender) format(%9.3f) sc col row

table edulevelSEL age_x urb [pw=wgt], by(gender) c(mean pub_vs_nonpub) format(%9.3f) sc col row

table pub_vs_nonpub edulevelSEL [pw=wgt], format(%9.2f) center row col
 
 eststo clear
 
probit pub_vs_nonpub age age2 i.gender i.married i.urb i.edulevelSEL hhsize i.reg01 if $condALL [iweight=wgt], vce(robust)
est sto coe_pub_vs_nonpub`n'
margins, dydx(*) post
est sto mar_pub_vs_nonpub`n'


cd "$regressions\Probit\Public vs Private"



global pub_vs_nonpub_COEcsv = "b(3) se(2) pr2 star(* 0.1 ** 0.05 *** 0.01) nogap label mtitles(All-Sample) replace"
global pub_vs_nonpub_AMEcsv = "b(3) se(2) star(* 0.1 ** 0.05 *** 0.01) nogap label mtitles(All-Sample) replace"

esttab coe_pub_vs_nonpub`n' using "pub_vs_nonpub_COE_`lev'.csv", $pub_vs_nonpub_COEcsv
esttab mar_pub_vs_nonpub`n' using "pub_vs_nonpub_MAR_`lev'.csv", $pub_vs_nonpub_AMEcsv



 
coefplot (mar_pub_vs_nonpub`n'), ///
keep(*: age *.gender *.edulevelSEL) drop(_cons) omitted  ///
 bylabel(AME) ||, xline(0) byopts(xrescale)	xtitle("Av. Marginal Effects") ///
 mlabel format(%9.2g) mlabposition(12) mlabgap(*2) ///  
 title("Probit: Public vs Non-Public Employment, only wage worker $y `lev'", size (small)) ///
	note("Note: Dependent variable is 1 if the worker is employed in the public sector and 0 otherwise.", size(vsmall)) ///
 ylab( ,nogrid ang(hor)labsize(small)labcol(black)) xlab(, labcol(black))  
	graph export "probit_pub_vs_nonpub_AME_demographics_`lev'.png", replace

	
coefplot (mar_pub_vs_nonpub`n'), ///
keep(*: *married hhsize) drop(_cons) omitted ///
 bylabel(AME) ||, xline(0) byopts(xrescale)	xtitle("Av. Marginal Effects") ///
 mlabel format(%9.2g) mlabposition(12) mlabgap(*2) ///  
 title("Probit: Public vs Non-Public Employment, only wage worker $y `lev'", size (small)) ///
 	note("Note: Dependent variable is 1 if the worker is employed in the public sector and 0 otherwise.", size(vsmall)) ///
 ylab( ,nogrid ang(hor)labsize(small)labcol(black)) xlab(, labcol(black))  
	graph export "probit_pub_vs_nonpub_AME_household_`lev'.png", replace


coefplot (mar_pub_vs_nonpub`n'), ///
keep(*: *.urb *.reg01) drop(_cons) omitted ///
 bylabel(AME) ||, xline(0) byopts(xrescale)	xtitle("Av. Marginal Effects") ///
 mlabel format(%9.2g) mlabposition(12) mlabgap(*2) ///  
 title("Probit: Public vs Non-Public Employment, only wage worker $y `lev'", size (small)) ///
 	note("Note: Dependent variable is 1 if the worker is employed in the public sector and 0 otherwise. Base region is `base_r'.", size(vsmall)) ///
 ylab( ,nogrid ang(hor)labsize(small)labcol(black)) xlab(, labcol(black))  
	graph export "probit_pub_vs_nonpub_AME_loc_`lev'.png", replace	
	
		

}

else {
di "Relevant variable has missing values for all obs. in year `lev'"
}

}



 
eststo clear


use "$data/I2D2_test_$y.dta", clear

levels year_s
foreach lev in `r(levels)' {

use "$data/I2D2_test_$y.dta", clear


keep if year
keep if year_s=="`lev'"

		local n=year

 
      

 gen age2 = age^2
 la var age2 "Age Squared"

 la var hhsize "Size of Household" 

 
 
 global condALL age_x <3

 
 keep if lstatus==1

eststo clear

gen base_reg=region if reg01==1
gsort reg01
bys year_s: replace base_reg=base_reg[_n-1] if base_reg==""
tab base_reg, m
local base_r=base_reg

di "`base_r'"



g wagewrk=1 if empstat==1 
g nonwagewrk=1 if empstat==2 | empstat==3 | empstat==4

g wage_vs_nonwage=(wagewrk==1)


replace wage_vs_nonwage=. if empstat==.
tab empstat wage_vs_nonwage, m


bys year_s: egen nonmissing_wagewrk=count(wagewrk)
bys year_s: egen nonmissing_nonwagewrk=count(nonwagewrk)


local varlist "empstat  age gender married urb edulevelSEL hhsize reg01 industry"

foreach var in `varlist'{
bys year: egen nonmissing_`var'=count(`var')
}

if nonmissing_wagewrk!=0 & nonmissing_nonwagewrk!=0 & nonmissing_empstat!=0  & nonmissing_age!=0 & nonmissing_gender!=0 & nonmissing_married!=0 & nonmissing_urb!=0 & nonmissing_edulevelSEL!=0 & nonmissing_hhsize!=0 & nonmissing_reg01!=0  & nonmissing_industry!=0{
  


table edulevelSEL age_x urb [pw=wgt], by(gender) format(%9.3f) sc col row

table edulevelSEL age_x urb [pw=wgt], by(gender) c(mean wage_vs_nonwage) format(%9.3f) sc col row

table wage_vs_nonwage edulevelSEL [pw=wgt], format(%9.2f) center row col
 
 eststo clear
 
probit wage_vs_nonwage age age2 i.gender i.married i.urb i.edulevelSEL i.industry hhsize i.reg01 if $condALL [iweight=wgt], vce(robust)
est sto coe_wage_nonwage`n'
margins, dydx(*) post
est sto mar_wage_nonwage`n'


cd "$regressions\Probit\Wage vs NonWage"


global wage_nonwage_COEcsv = "b(3) se(2) pr2 star(* 0.1 ** 0.05 *** 0.01) nogap label mtitles(All-Sample) replace"
global wage_nonwage_AMEcsv = "b(3) se(2) star(* 0.1 ** 0.05 *** 0.01) nogap label mtitles(All-Sample) replace"

esttab coe_wage_nonwage`n' using "wage_nonwage_COE_`lev'.csv", $wage_nonwage_COEcsv
esttab mar_wage_nonwage`n' using "wage_nonwage_MAR_`lev'.csv", $wage_nonwage_AMEcsv




 
coefplot (mar_wage_nonwage`n'), ///
keep(*: age *.gender *.edulevelSEL *.industry_x) drop(_cons) omitted  ///
 bylabel(AME) ||, xline(0) byopts(xrescale)	xtitle("Av. Marginal Effects") ///
 mlabel format(%9.2g) mlabposition(12) mlabgap(*2) ///  
 title("Probit: Wage vs Non-Wage Employment, $y `lev'", size (small)) ///
	note("Note: Dependent variable is 1 if the worker is a wage worker and 0 otherwise.", size(vsmall)) ///
 ylab( ,nogrid ang(hor)labsize(small)labcol(black)) xlab(, labcol(black))  
	graph export "probit_wage_nonwage_AME_demographics_`lev'.png", replace

	
coefplot (mar_wage_nonwage`n'), ///
keep(*: *married hhsize) drop(_cons) omitted ///
 bylabel(AME) ||, xline(0) byopts(xrescale)	xtitle("Av. Marginal Effects") ///
 mlabel format(%9.2g) mlabposition(12) mlabgap(*2) ///  
 title("Probit: Wage vs Non-Wage Employment, $y `lev'", size (small)) ///
	note("Note: Dependent variable is 1 if the worker is a wage worker and 0 otherwise.", size(vsmall)) ///
 ylab( ,nogrid ang(hor)labsize(small)labcol(black)) xlab(, labcol(black))  
	graph export "probit_wage_nonwage_AME_household_`lev'.png", replace


coefplot (mar_wage_nonwage`n'), ///
keep(*: *.urb *.reg01) drop(_cons) omitted ///
 bylabel(AME) ||, xline(0) byopts(xrescale)	xtitle("Av. Marginal Effects") ///
 mlabel format(%9.2g) mlabposition(12) mlabgap(*2) ///  
 title("Probit: Wage vs Non-Wage Employment, $y `lev'", size (small)) ///
	note("Note: Dependent variable is 1 if the worker is a wage worker and 0 otherwise. Base region is `base_r'.", size(vsmall)) ///
 ylab( ,nogrid ang(hor)labsize(small)labcol(black)) xlab(, labcol(black))  
	graph export "probit_wage_nonwage_AME_loc_`lev'.png", replace	
	
		

}

else {
di "Employment Type or other relevant variable has missing values for all obs. in year `lev'"
}

}




eststo clear




cd "$regressions\Wages"

use "$data/I2D2_test_$y.dta", clear


		levels year_s
		foreach lev in `r(levels)' {

		use "$data/I2D2_test_$y.dta", clear


		keep if year_s=="`lev'"

		local n=year
		
		di `n'
		
		bys year: egen nonmissing_wages=count(wage_per_month)
		bys year: egen nonmissing_occup=count(occup)
		bys year: egen max_wages=max(wage)
		bys year: egen mean_wages=mean(wage)
		bys year: egen nonmissing_industry=count(industry)

		bys year: egen nonmissing_ocusec=count(ocusec)
		bys year: egen nonmissing_informal=count(informal)
		bys year: egen nonmissing_contract=count(contract)


local varlist "emptype age gender married urb edulevelSEL reg01 hhsize"

foreach var in `varlist'{

bys year: egen nonmissing_`var'=count(`var')
}

if nonmissing_wages!=0 & mean_wages!=0 & max_wages!=1 & nonmissing_emptype!=0 & nonmissing_age!=0 & nonmissing_gender!=0 & nonmissing_married!=0 & nonmissing_urb!=0 & nonmissing_edulevelSEL!=0 & nonmissing_hhsize!=0 & nonmissing_reg01!=0 {
    

 gen age2 = age^2
 la var age2 "Age Squared"




	gen lwage=log(wage_per_month)
	label var lwage "Log(Monthly Wage)"
	
	
	g wage_hourly=hourly_wages
	gen lwage_hourly=log(wage_hourly)
	label var lwage_hourly "Log(Hourly Wage)"


	
	




g select=(employed==1)
replace select=. if lstatus==.

local fix_reg "i.gender age age2 i.edulevelSEL i.urb i.reg01"
local fix_reg_sx "age age2 i.edulevelSEL i.urb i.reg01"

eststo clear

	

reg lwage `fix_reg' if $condALL [weight = wgt] , robust cluster(idh)
est store OLS1_all`n', nocopy

	
		foreach sex in 1 2 {
		reg lwage `fix_reg_sx' if $condALL & gender==`sex' [weight = wgt] , robust cluster(idh)
		est store OLS1_sex`sex'`n', nocopy
		}
	
	
		if nonmissing_industry!=0{

reg lwage `fix_reg' i.industry_x if $condALL [weight = wgt] , robust cluster(idh)
est store OLS2_all`n', nocopy

		foreach sex in 1 2 {
		reg lwage `fix_reg_sx' i.industry_x if $condALL & gender==`sex' [weight = wgt] , robust cluster(idh)
		est store OLS2_sex`sex'`n', nocopy
		}	
	}
else {
di "industry is missing in year `lev'"
}	
	
	
		if nonmissing_occup!=0 & nonmissing_industry!=0{

reg lwage `fix_reg' i.industry_x b6.occup if $condALL [weight = wgt] , robust cluster(idh)
est store OLS3_all`n', nocopy

		foreach sex in 1 2 {
		reg lwage `fix_reg_sx' i.industry_x b6.occup if $condALL & gender==`sex' [weight = wgt] , robust cluster(idh)
		est store OLS3_sex`sex'`n', nocopy
		}	
	}
else {
di "industry and/or occup is missing in year `lev'"
}
		
	
		if nonmissing_industry!=0{

reg lwage `fix_reg' i.industry if $condALL [weight = wgt] , robust cluster(idh)
est store OLS4_all`n', nocopy
		
		foreach sex in 1 2 {
		reg lwage `fix_reg_sx' i.industry if $condALL & gender==`sex' [weight = wgt] , robust cluster(idh)
		est store OLS4_sex`sex'`n', nocopy
		}	
	}
else {
di "industry is missing in year `lev'"
}
		
		
	if nonmissing_ocusec!=0 {
reg lwage `fix_reg' i.ocusec if $condALL [weight = wgt] , robust cluster(idh)
est store OLS5_all`n', nocopy
}
else {
di "ocusec is missing in year `lev'"
}

	if nonmissing_informal!=0 {
reg lwage `fix_reg' i.informal if $condALL [weight = wgt] , robust cluster(idh)
est store OLS6_all`n', nocopy
}
else {
di "informal is missing in year `lev'"
}

if nonmissing_contract!=0 {
reg lwage `fix_reg' i.no_contract if $condALL [weight = wgt] , robust cluster(idh)
est store OLS7_all`n', nocopy
}
else {
di "contract is missing in year `lev'"
}
	
	
esttab OLS*`n' using "00_logwage_estimation_`lev'.csv", replace compress nogap label nonumbers  ////
mtitle("Model 1 - All Sample" "Model 1 - Male" "Model 1 - Female" "Model 2 - All Sample" "Model 2 - Male" "Model 2 - Female" "Model 3 - All Sample" "Model 3 - Male" "Model 3 - Female"	"Model 4 - All Sample" "Model 4 - Male" "Model 4 - Female" "Model 5 - All Sample" "Model 6 - All Sample" "Model 7 - All Sample") ////
		                 scalars(N ll) star(* 0.1 ** 0.05 *** 0.01) title("Wage Estimation with Log Wages as Outcome Variable, $y `lev'") 
}

else {
di "Wage and/or Industry variables have missing values for all obs. in year `lev'"
}

eststo clear


}


use "$data/I2D2_test_$y.dta", clear

eststo clear

		levels year_s
		foreach lev in `r(levels)' {

		use "$data/I2D2_test_$y.dta", clear


		keep if year_s=="`lev'"

		local n=year
		
		di `n'
		
		bys year: egen nonmissing_wages=count(wage_per_month)
		bys year: egen nonmissing_occup=count(occup)
		bys year: egen max_wages=max(wage)
		bys year: egen mean_wages=mean(wage)
		bys year: egen nonmissing_industry=count(industry)

		bys year: egen nonmissing_ocusec=count(ocusec)
		bys year: egen nonmissing_informal=count(informal)
		bys year: egen nonmissing_contract=count(contract)


local varlist "emptype age gender married urb edulevelSEL reg01 hhsize"

foreach var in `varlist'{

bys year: egen nonmissing_`var'=count(`var')
}

if nonmissing_wages!=0 & mean_wages!=0 & max_wages!=1 & nonmissing_emptype!=0 & nonmissing_age!=0 & nonmissing_gender!=0 & nonmissing_married!=0 & nonmissing_urb!=0 & nonmissing_edulevelSEL!=0 & nonmissing_hhsize!=0 & nonmissing_reg01!=0 {
    

 gen age2 = age^2
 la var age2 "Age Squared"

	gen lwage=log(wage_per_month)
	label var lwage "Log(Monthly Wage)"
	
	
	g wage_hourly=hourly_wages
	gen lwage_hourly=log(wage_hourly)
	label var lwage_hourly "Log(Hourly Wage)"


g select=(employed==1)
replace select=. if lstatus==.

local fix_reg "i.gender age age2 i.edulevelSEL i.urb i.reg01"
local fix_reg_sx "age age2 i.edulevelSEL i.urb i.reg01"

eststo clear

	

sqreg lwage `fix_reg' if $condALL, q(.25 .5 .75)
est store QOLS1_all`n', nocopy

	
		if nonmissing_industry!=0{

sqreg lwage `fix_reg' i.industry_x if $condALL, q(.25 .5 .75)
est store QOLS2_all`n', nocopy

	}
else {
di "industry is missing in year `lev'"
}	
	
	
		if nonmissing_occup!=0 & nonmissing_industry!=0{

sqreg lwage `fix_reg' i.industry_x b6.occup if $condALL, q(.25 .5 .75)
est store QOLS3_all`n', nocopy		
	}
	
else {
di "industry and/or occup is missing in year `lev'"
}
		
	
		if nonmissing_industry!=0{

sqreg lwage `fix_reg' i.industry if $condALL, q(.25 .5 .75)
est store QOLS4_all`n', nocopy
		
	}
else {
di "industry is missing in year `lev'"
}
		
		
	if nonmissing_ocusec!=0 {
sqreg lwage `fix_reg' i.ocusec if $condALL, q(.25 .5 .75)
est store QOLS5_all`n', nocopy
}
else {
di "ocusec is missing in year `lev'"
}

	if nonmissing_informal!=0 {
sqreg lwage `fix_reg' i.informal if $condALL, q(.25 .5 .75)
est store QOLS6_all`n', nocopy
}
else {
di "informal is missing in year `lev'"
}

if nonmissing_contract!=0 {
sqreg lwage `fix_reg' i.no_contract if $condALL, q(.25 .5 .75)
est store QOLS7_all`n', nocopy
}
else {
di "contract is missing in year `lev'"
}
	
	
esttab QOLS*`n' using "Quantile_estimation_`lev'.csv", replace compress nogap label nonumbers  ////
mtitle("Model 1"  "Model 2" "Model 3" "Model 4 - All Sample" "Model 5 - All Sample" "Model 6 - All Sample" "Model 7 - All Sample") ////
		                 scalars(N ll) star(* 0.1 ** 0.05 *** 0.01) title("Quantile Estimation on 25 50 and 75 percentile with Log Wages as Outcome Variable, $y `lev'") 
}

else {
di "Wage and/or Industry variables have missing values for all obs. in year `lev'"
}

eststo clear


}


cd "$regressions\Wages"

use "$data/I2D2_test_$y.dta", clear

levels year_s
foreach lev in `r(levels)' {
use "$data/I2D2_test_$y.dta", clear

keep if year_s=="`lev'"		


bys year: egen nonmissing_wages=count(wage_monthly)
bys year: egen nonmissing_occup=count(occup)
bys year: egen nonmissing_industry=count(industry)
bys year: egen nonmissing_empstat=count(empstat)
bys year: egen nonmissing_age=count(age)
bys year: egen nonmissing_urb=count(urb)
bys year: egen nonmissing_edulevelSEL=count(edulevelSEL)
bys year: egen nonmissing_gender=count(gender)


gen lnwage=ln(wage_monthly)
gen sex="Female" if gender==2
replace sex="Male" if gender==1

if nonmissing_wages!=0 &  nonmissing_empstat!=0 & nonmissing_age!=0 & nonmissing_gender!=0  & nonmissing_urb!=0 & nonmissing_edulevelSEL!=0 & nonmissing_occup!=0 & nonmissing_industry!=0 {
    
oaxaca lnwage empstat age urb edulevelSEL  [aweight=wgt], by(sex) 
outreg2 using "Blinder_Decomposition_`lev'.xls",  replace ctitle(Model 1) addnote(The decomposition uses the Oaxaca package by Ben Jann. An interpretation of the threefold decomposition is given on page 468-469 in the related Stata journal article., The first column for each model reports the differential and the second column the decomposition., The first model uses employment status age residency area and education level as input variables. The second model adds industry sector. The third model adds occupations to model 2.)

oaxaca lnwage empstat age urb edulevelSEL industry [aweight=wgt], by(sex) 
outreg2 using "Blinder_Decomposition_`lev'.xls",  append ctitle(Model 2) 

oaxaca lnwage empstat age urb edulevelSEL industry occup [aweight=wgt], by(sex) 
outreg2 using "Blinder_Decomposition_`lev'.xls",  append ctitle(Model 3)
}

else {

di " Data missings"
}	
}










}
dis "", _newline(8)



dis as result `" The Regression outputs have now been created and stored in "$regressions" "'
dis as result `" You can continue creating the Indicators or Figures by typing Indicator or Figures, respectivey"'



end
