***************************************************************************************
***************************************************************************************
** Figures    Generation                                                        	 **
** This version: October 2020 (Michael Weber & Jörg Langbein)     	         		 **
***************************************************************************************
***************************************************************************************


program Figures
version 14.2


dis "", _newline(6)

dis " The figures are being created now. Please wait. "



qui{
set varabbrev off
local date : dis %td_CCYYNNDD date(c(current_date), "DMY")

** Globals
global data "$user\\$y\Data"
global graph "$user\\$y\JDLT_`date'\"
global indicators "$user\\$y\JDLT_`date'\Question 1 - Jobs and workers profile"
global regressions "$user/$y/JDLT_`date'/Question 5 - Worker characteristics and LM outcomes"
global condALL   age>=15 & age<=64
global noCondALL age<15 & age>64	


*** Change the coloring scheme

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

** Each year

use "$data/I2D2_test_$y.dta", clear

levels year
foreach lev in `r(levels)' {

use "$data/I2D2_test_$y.dta", clear

keep if year==`lev'

*** Variable Preparation

bys year: egen nonmissing_reg=count(reg01)
bys year: egen nonmissing_OLF=count(OLF)
bys year: egen nonmissing_urb=count(urb)
bys year: egen nonmissing_empl=count(employed)
bys year: egen nonmissing_unemp=count(unemployed)
bys year: egen nonmissing_edu=count(edulevelSEL)
bys year: egen nonmissing_emptype=count(emptype)
bys year: egen nonmissing_ocusec=count(ocusec)
bys year: egen nonmissing_empstat=count(empstat)
gen d_empstat1=1 if empstat==1
gen d_empstat2=1 if empstat==2
bys year: egen nonmissing_emp1=count(d_empstat1)
bys year: egen nonmissing_emp2=count(d_empstat2)
bys year: egen nonmissing_contract=count(contract)
bys year: egen nonmissing_pcc=count(pcc)
bys year: egen nonmissing_underemp=count(whours)
bys year: egen nonmissing_informal=count(informal)
bys year: egen nonmissing_atsch=count(atschool)
bys year: egen nonmissing_industry=count(industry)
bys year: egen nonmissing_wages=count(wage)
bys year: egen nonzero_wages=count(wage) if wage!=0
bys year: egen nonmissing_occup=count(occup)
bys year: egen nonmissing_whours=count(whours)
bys year: egen nonzero_whours=count(whours) if whours!=0

bys year: egen nonmissing_whours_inf=count(whours) if informal==1
bys year: egen nonmissing_whours_for=count(whours) if informal==0

bys year: egen nonmissing_whours_pub=count(whours) if ocusec==1
bys year: egen nonmissing_whours_pri=count(whours) if ocusec==2




***************************************************************
********************* Employment ******************************
***************************************************************



if nonmissing_empstat!=0 & nonmissing_urb!=0 {

	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(empstat) over(age_5, label(labsize(vsmall) angle(45))) over(gen_urb) ///
	showyvars asyvars stack legend(size(small) colfirst) ytitle("") blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment Types, age 15-64, `lev' ", size (medium)) 
	graph export "$Q31\02_B_3_Empstat_gen_urb_`lev'.png", replace
}
else {
	di "empstat or urban variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the  empstat or urban variable in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q31\99_Empstat_gen_urb_error_`lev'.png", replace
}

if nonmissing_edu!=0 & nonmissing_empstat!=0 & nonmissing_ocusec!=0 {
	
	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(emptype) over(edulevelSEL, label(labsize(vsmall) angle(45))) ///
	showyvars asyvars stack legend(size(small) colfirst) ytitle("")   blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment Types by Education, age 15-64, `lev'", size (medium)) 
	graph export "$Q31\01_B_2_Emp_type_educ_`lev'.png", replace
}
	
else {
	di "Education or empstat or sector variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the education, empstat or sector variable in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q31\99_Emp_type_educ_error_`lev'.png", replace
}


if nonmissing_empstat!=0 & nonmissing_urb!=0  & nonmissing_edu!=0 {

	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(empstat) over(edulevelSEL, label(labsize(vsmall) angle(45))) ///
	showyvars asyvars stack legend(size(small) colfirst) ytitle("")   blabel(bar, position(center) size(vsmall) format(%3.1f))   ///
	graphregion(color(white)) title("Employment Types by Education, age 15-64, `lev'", size (medium)) 
	graph export "$Q31\02_B_2_Empstat_type_educ_`lev'.png", replace
}
else {
	di "empstat or urban variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the  empstat or urban variable in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q31\99_Empstat_type_educ_error_`lev'.png", replace
		}



if nonmissing_pcc!=0 {

	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, over(female, label(labsize(vsmall) angle(45))) over(pcc_d) ///
	showyvars ascategory asyvar legend(off) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment to Population by gender across Consumption deciles, age 15-64, `lev'", size (small)) 
	graph export "$Q43\01_B_2_Emp_to_pop_cons_decile_gender_`lev'.png", replace

	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, over(age_x, label(labsize(vsmall) angle(45))) over(pcc_d) ///
	showyvars ascategory asyvar legend(off) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment to Population by age across Consumption deciles, age 15-64, `lev'", size (small)) 
	graph export "$Q43\01_B_2_Emp_to_pop_cons_decile_age_`lev'.png", replace
		}
		
else {
	di "Consumption Variables missing in Year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the consumption variable in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q43\99_Emp_to_pop_cons_decile_gender`lev'_error.png", replace
	graph export "$Q43\99_Emp_to_pop_cons_decile_age_error_`lev'.png", replace
}


****************************************************************
*************** Underemployment ********************************
****************************************************************



if nonmissing_urb!=0 & nonmissing_underemp!=0 {

	graph bar (sum) counter [pw=wgt] if age_x<3, percentages over(underemployed) over(age_5, label(labsize(vsmall) angle(45))) over(gen_urb) ///
	asyvars stack legend(size(medium) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f)) ///
	graphregion(color(white)) title("Underemployed: Works < 35hours/week, age 15-64, `lev'", size (medium)) 
	graph export "$Q31\09_B_3_Underemp_urban_rural_gender_`lev'.png", replace	
}
	
	
else {
	di "Urban/Rural or underemployed variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the underemployed or urban variable in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q31\99_Underemp_urban_rural_gender_error_`lev'.png", replace
}


if nonmissing_industry!=0 & nonmissing_urb!=0 & nonmissing_underemp!=0 {

/*	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over (underemployed) over(industry_x, label(labsize(vsmall) angle(45))) over(gen_urb, label(labsize(medium))) ///
	asyvars stack legend(size(small) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f)) ///
	graphregion(color(white)) title("Underemployment < 35 hours/week, age 15-64, `lev'", size(medium)) 
	graph export "Underemp_industry_urban_rural1_`lev'.png", replace
	
	graph bar (sum) counter [pw=wgt] if age_x<3 & underemployed==1, percentages over(industry_x) over(gen_urb, label(labsize(medium))) ///
	asyvars stack legend(size(small) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Underemployment < 35 hours/week, age 15-64, `lev'", size(medium)) 
	graph export "Underemp_industry_urban_rural2_`lev'.png", replace
	

}
else {
	di "Industry or urban variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the industry variable in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "99_Underemployment_industry_urban_rural1_error_`lev'.png", replace
	graph export "99_Underemployment_industry_urban_rural2_error_`lev'.png", replace
}
*/


*************************
**** Education **********
*************************

if nonmissing_edu!=0 & nonmissing_reg!=0 {

	graph bar (sum) counter [pw=wgt] if age_x<3 & nonmissing_edu!=0, percentages over(edulevelSEL) over(reg01, label(labsize(vsmall) angle(45))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Highest level of education completed across regions ", size (medium)) 
	graph export "$Q34\01_B_2_Education_regions_`lev'.png", replace
}

else {
	di "Region or Education variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the education or region variable in year `lev' ", ring(0) position(12) color(red) size(small))
	capture	graph export "$Q34\99_Educ_regions_error_`lev'.png", replace
}


if nonmissing_industry!=0 & nonmissing_edu!=0{
	
	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(edulevelSEL) over(industry_x, label(labsize(medium))) ///
	asyvars stack legend(size(small) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment by education across Industries, age 15-64, `lev'", size(medium)) 
	graph export "$Q34\01_B_2_Industry_educ_`lev'.png", replace	
}

else {
	di "Industry or Education variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the education or industry variable in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q34\99_Industry_educ_error_`lev'.png", replace	
}	

if nonmissing_pcc!=0 & nonmissing_edu!=0 {	
		
	graph bar (sum) counter [pw=wgt], percentages over(edulevelSEL) over(pcc_d, label(labsize(vsmall) angle(45)))  ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Sample Distribution over Consumption Deciles by education, `lev'", size (medium)) 
	graph export "$Q43\01_B_2_Consumption_deciles_edu_`lev'.png", replace			
			}
		
else {
	di "Consumption or Education Variables missing in Year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the consumption or education variable in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q43\99_Consumption_deciles_edu_error_`lev'.png", replace			
			}


			
********************************************************************
***************** Sector *******************************************
********************************************************************


if nonmissing_industry!=0{
	
	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(industry_x) ///
	asyvars legend(size(medium) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment across industries, age 15-64, `lev'", size (medium)) 
	graph export "$Q32\01_B_1_Industry_`lev'.png", replace
	
	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(industry,  sort(1) descending label(labsize(vsmall) angle(45))) ///
	asyvars legend(size(medium) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment across industries, age 15-64, `lev'", size (medium)) 
	graph export "$Q32\01_B_1_Industry_detailed_`lev'.png", replace

	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(female) over(industry_x, label(labsize(medium))) ///
	asyvars stack legend(size(small) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment by Gender across Industries, age 15-64, `lev'", size(medium)) 
	graph export "$Q32\01_B_2_Industry_gender_`lev'.png", replace

	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(female) over(industry, label(labsize(vsmall) angle(45))) ///
	asyvars stack legend(size(small) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment by Gender across Industries, age 15-64, `lev'", size(medium)) 
	graph export "$Q32\01_B_2_Industry_gender_detailed_`lev'.png", replace
	
	
	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(industry_x) over(age__x, label(labsize(vsmall) angle(45))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Age structure of employment by Sector, age 15-64, `lev'", size (medium)) 
	graph export "$Q32\01_B_2_Industry_age_cohorts_`lev'.png", replace

}

else {
	di "Industry variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the industry variable in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q32\99_Industry_error_`lev'.png", replace
	graph export "$Q32\99_Industry_detailed_error_`lev'.png", replace	
	graph export "$Q32\99_Industry_gender_error_`lev'.png", replace
	graph export "$Q32\99_Industry_gender_detailed_error_`lev'.png", replace
	graph export "$Q32\99_Industry_age_cohorts_error_`lev'.png", replace

}		
	
	
if nonmissing_industry!=0 & nonmissing_edu!=0{
	

	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(edulevelSEL) over(industry_x, label(labsize(medium))) ///
	asyvars stack legend(size(small) colfirst) ytitle("") blabel(bar, position(center) size(vsmall) format(%3.1f)) ///
	graphregion(color(white)) title("Employment by education across Industries, age 15-64, `lev'", size(medium)) 
	graph export "$Q32\01_B_2_Industry_educ_`lev'.png", replace	
}

else {
	di "Industry or Education variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the education or industry variable in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q34\99_Industry_educ_error_`lev'.png", replace	
}	

if nonmissing_industry!=0 & nonmissing_urb!=0{

	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(urb) over(industry_x, label(labsize(medium))) ///
	asyvars stack legend(size(small) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment across industries by area, age 15-64, `lev'", size(medium)) 
	graph export "$Q32\01_B_2_Industry_urban_rural_`lev'.png", replace

}
else {
	di "Industry or urban variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the industry variable in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q32\99_Industry_urban_rural_error_`lev'.png", replace
}
	
	

if nonmissing_industry!=0 & nonmissing_pcc!=0 {
		
		graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(industry_x) over(pcc_d) ///
		asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
		graphregion(color(white)) title("Employment across sectors by consumption deciles, age 15-64, `lev'", size (small)) 
		graph export "$Q43\01_B_2_Sector_cons_decile_`lev'.png", replace
}
		
else {
		di "Consumption and/or industry Variables missing in Year `lev'"
		graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the consumption or industry variable in year `lev' ", ring(0) position(12) color(red) size(small))
		graph export "$Q43\99_Sector_cons_decile_error_`lev'.png", replace
}
			




***********************************************
************** Occupations ********************
***********************************************


if nonmissing_occup!=0{
		
	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(occup, label(labsize(small) angle(45))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment across Occupations, age 15-64, `lev'", size(small)) 
	graph export "$Q33\01_B_1_Occupation_`lev'.png", replace

	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(female) over(occup, label(labsize(small) angle(45))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment by gender across Occupations, age 15-64, `lev'", size(small)) 
	graph export "$Q33\01_B_2_Occupation_gender_`lev'.png", replace


	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(age_x) over(occup, label(labsize(small) angle(45))) ///
	asyvars stack legend(size(small) colfirst) ytitle("") blabel(bar, position(center) size(vsmall) format(%3.1f)) ///
	graphregion(color(white)) title("Employment by age across Occupations, age 15-64, `lev'", size(medium)) 
	graph export "$Q33\01_B_2_Occupation_age_`lev'.png", replace	
}

else {
	di "Occupation variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the occupation variable in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q33\99_Occupation_age_error_`lev'.png", replace	
	graph export "$Q33\99_Occupation_gender_error_`lev'.png", replace
	graph export "$Q33\99_Occupation_error_`lev'.png", replace

}		
	
if nonmissing_industry!=0 & nonmissing_edu!=0 & nonmissing_occup!=0{
	

	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(edulevelSEL) over(occup, label(labsize(small) angle(45))) ///
	asyvars stack legend(size(small) colfirst) ytitle("")   blabel(bar, position(center) size(vsmall) format(%3.1f)) ///
	graphregion(color(white)) title("Employment by education across Occupations, age 15-64, `lev'", size(medium)) 
	graph export "$Q33\01_B_2_Occupation_educ_`lev'.png", replace	
}

else {
	di "Occupation or Education variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the occupation or education variable in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q33\99_Occupation_educ_error_`lev'.png", replace	
}		

if nonmissing_industry!=0 & nonmissing_urb!=0 & nonmissing_occup!=0{

	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(urb) over(occup, label(labsize(small) angle(45))) ///
	asyvars stack legend(size(small) colfirst) ytitle("")   blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment across Occupations Rural vs Urban, age 15-64, `lev'", size(medium)) 
	graph export "$Q33\01_B_3_Occupation_urban_rural_`lev'.png", replace

}
else {
	di "Occupation or urban variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the occupation variable in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q33\99_Occupation_urban_rural_error_`lev'.png", replace
}	
	


if nonmissing_pcc!=0 & nonmissing_occup!=0 {
	
		graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(occup) over(pcc_d) ///
		asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
		graphregion(color(white)) title("Employment across Occupations by Consumption deciles, age 15-64, `lev'", size (small)) 
		graph export "$Q43\01_B_2_Consumption_decile_occupation_`lev'.png", replace		
}
		
else {
		di "Consumption and/or occupation Variables missing in Year `lev'"
		graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the ocusec or consumption variable in year `lev' ", ring(0) position(12) color(red) size(small))
		graph export "$Q43\99_Consumption_decile_occupation_error_`lev'.png", replace
}






*********** Work hours (Underemployment) Kernel Densities only for wage workers *******************************************

preserve

keep if empstat==1
drop d_empstat1

gen d_empstat1=1 

bys year: egen nonmissing_empstat1=count(d_empstat1)

drop d_empstat1

replace whours=. if nonmissing_empstat1==0







if nonmissing_whours!=0 & nonmissing_empstat1!=0 & nonzero_whours!=0 {

**********************************************************************************************************
** Calculates kernel distributions of monthly whours separately by all/gender/informality.
**********************************************************************************************************

	/* Generate variables for graphing */

	tempname meanvar
	label var whours "Work hours last week"
	su whours [aweight=wgt] if age_x<3
	scalar `meanvar'=`r(mean)'
	
		qui su whours, d
		
		scalar minrg=`r(min)'
		scalar maxrg=`r(max)'
		scalar pct1=`r(p1)'
		scalar pct99=`r(p99)'
		
		gen whours_atv=minrg+((_n-1)*((maxrg-minrg)/100)) if _n <= 101
		label var whours_atv "Work hours/week"

	
		kdensity whours [aweight=wgt], at (whours_atv) gen(whours_f) title("Kernel Densities of Working Hours `lev'", size (small))
		label var whours_f "Work hours (Only Wage Workers Age 15-64)"
		graph export `"$Q42\02_B_1_Kdensity_work_hours_all_`lev'.png"',  replace

	
		********************************     COMPARISONS       ***************************************
		
*		FEMALE vs MALE whours:

		kdensity whours [aweight=wgt] if female==1, nograph at (whours_atv) gen(whours_f_fem)
		label var whours_f_fem "Female work hours/week"
		
		kdensity whours [aweight=wgt] if female==0, nograph at (whours_atv) gen(whours_f_mal)
		label var whours_f_mal "Male work hours/week"

		line whours_f_fem whours_f_mal whours_atv, sort ytitle(Density) legend(size(small)) ////   /* lcolor(black blue red) lwidth(medthick medthick medthick)*/
		title("Kernel Densities of work hours/week (Only Wage Workers Age 15-64)  - `lev'", size (vsmall))
		graph export `"$Q42\02_B_2_Kdensity_work_hours_combined_gender_`lev'.png"',  replace		


*		Youth vs Adult whours:

		kdensity whours [aweight=wgt] if age_x==1, nograph at (whours_atv) gen(whours_f_youth)
		label var whours_f_youth "Youth work hours/week"
		
		kdensity whours [aweight=wgt] if age_x==2, nograph at (whours_atv) gen(whours_f_adult)
		label var whours_f_adult "Adult work hours/week"

		line whours_f_youth whours_f_adult whours_atv, sort ytitle(Density) legend(size(small)) ////   /* lcolor(black blue red) lwidth(medthick medthick medthick)*/
		title("Kernel Densities of work hours/week (Only Wage Workers) - `lev'", size (small))
		graph export `"$Q42\02_B_2_Kdensity_work_hours_combined_age_`lev'.png"',  replace
		
		
		
		
		
		
}

else {
		di "Whours variable or empstat has missing values for all obs. in year `lev'"
		graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the whours or empstat variable in year `lev' ", ring(0) position(12) color(red) size(small))
		graph export `"$Q42\99_Kdensity_work_hours_all_error_`lev'.png"',  replace
		graph export `"$Q42\99_Kdensity_work_hours_combined_gender_error_`lev'.png"',  replace		
		graph export `"$Q42\99_Kdensity_work_hours_combined_age_error_`lev'.png"',  replace		
} 

		
*		FORMAL vs INFORMAL whours:


if nonmissing_whours!=0 & nonzero_whours!=0 & nonzero_whours!=. & nonmissing_empstat!=0 & nonmissing_informal!=0 & nonmissing_whours_for!=0 & nonmissing_whours_inf!=0 {
	
		kdensity whours [aweight=wgt] if informal==0, nograph at (whours_atv) gen(whours_f_formal)
		label var whours_f_formal "Formal work hours/week"
		
		kdensity whours [aweight=wgt] if informal==1, nograph at (whours_atv) gen(whours_f_informal)
		label var whours_f_informal "Informal work hours/week"
				
		line whours_f_formal whours_f_informal whours_atv, sort ytitle(Density) legend(size(small))   //// /* lcolor(black blue red) lwidth(medthick medthick medthick)*/
		title("Kernel Densities of work hours/week (Only Wage Workers Age 15-64) - `lev'", size (vsmall))
		graph export `"$Q42\02_B_2_Kdensity_work_hours_combined_informal_`lev'.png"', replace	
}

else {
		di "Whours variable or related var has missing values for all obs. in year `lev'"
		graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the whours, informal or empstat variable in year `lev' ", ring(0) position(12) color(red) size(small))
		graph export `"$Q42\99_Kdensity_work_hours_combined_informal_error_`lev'.png"', replace	
} 


*		Sector whours:


if nonmissing_whours!=0 & nonzero_whours!=0 & nonzero_whours!=. & nonmissing_empstat!=0 & nonmissing_industry!=0 & nonmissing_whours_for!=0 & nonmissing_whours_inf!=0 {
	
		kdensity whours [aweight=wgt] if industry1==1, nograph at (whours_atv) gen(whours_f_agri)
		label var whours_f_agri "Agriculture work hours/week"
		
		kdensity whours [aweight=wgt] if industry1==2, nograph at (whours_atv) gen(whours_f_indu)
		label var whours_f_indu "Industry work hours/week"
		
		kdensity whours [aweight=wgt] if industry1==3, nograph at (whours_atv) gen(whours_f_serv)
		label var whours_f_serv "Services work hours/week"
				
		line whours_f_agri whours_f_indu whours_f_serv whours_atv, sort ytitle(Density) legend(size(small))   //// /* lcolor(black blue red) lwidth(medthick medthick medthick)*/
		title("Kernel Densities of work hours/week (Only Wage Workers Age 15-64) - `lev'", size (vsmall))
		graph export `"$Q42\02_B_2_Kdensity_work_hours_combined_sector_`lev'.png"', replace	
}

else {
		di "Whours variable or related var has missing values for all obs. in year `lev'"
		graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the whours, industry  or empstat variable in year `lev' ", ring(0) position(12) color(red) size(small))
		graph export `"$Q42\99_Kdensity_work_hours_combined_sector_error_`lev'.png"', replace	
} 
			
*		Public vs Private whours:

if nonmissing_whours!=0 & nonzero_whours!=0 & nonzero_whours!=. & nonmissing_empstat!=0 & nonmissing_ocusec!=0 & nonmissing_whours_pub!=0 & nonmissing_whours_pri!=0 {
	
		kdensity whours [aweight=wgt] if ocusec==1, nograph at (whours_atv) gen(whours_f_public)
		label var whours_f_public "Public Sector work hours/week"
		
		kdensity whours [aweight=wgt] if ocusec==2, nograph at (whours_atv) gen(whours_f_private)
		label var whours_f_private "Private Sector work hours/week"
				
		line whours_f_public whours_f_private whours_atv, sort ytitle(Density) legend(size(small))   //// /* lcolor(black blue red) lwidth(medthick medthick medthick)*/
		title("Kernel Densities of work hours/week (Only Wage Workers Age 15-64) - `lev'", size (vsmall))
		graph export `"$Q42\02_B_2_Kdensity_work_hours_combined_public_priv_`lev'.png"',  replace	
}

else {
		di "Whours variable or empstat has missing values for all obs. in year `lev'"
		graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the whours or empstat variable in year `lev' ", ring(0) position(12) color(red) size(small))
		graph export `"$Q42\99_Kdensity_work_hours_combined_public_priv_error_`lev'.png"',  replace	
} 		


restore

if nonmissing_whours!=0  & nonmissing_edu!=0 & nonmissing_industry!=0 {


*** Suggested graph: same graph as above by gender


	graph hbar (mean) whours [pw=wgt] if age_x<3,  over(age_x,  axis(off) sort(1)) bar(1, color(gs10)) blabel(group, position(base) color(gs0)) over(female)  ///
	legend(size(vsmall) colfirst)    /// 
	ytitle(Mean) ///
	graphregion(color(white)) title("Average weekly working hours by age and gender in `lev'", size (small)) 
	graph export "$Q42\01_B_3_Whours_age_gender_`lev'.png", replace

	graph hbar (mean) whours [pw=wgt] if age_x<3,  over(urb,  axis(off) sort(1)) bar(1, color(gs10)) blabel(group, position(base) color(gs0)) over(female)  ///
	legend(size(vsmall) colfirst)    /// 
	ytitle(Mean) ///
	graphregion(color(white)) title("Average weekly working hours by area and gender in `lev'", size (small)) 
	graph export "$Q42\01_B_3_Whours_area_gender_`lev'.png", replace


	graph hbar (mean) whours [pw=wgt] if age_x<3,  over(industry,  axis(off) sort(1)) bar(1, color(gs10)) blabel(group, position(base) color(gs0)) over(female)  ///
	legend(size(vsmall) colfirst)    /// 
	ytitle(Mean) ///
	graphregion(color(white)) title("Average weekly working hours by sector and gender in `lev'", size (small)) 
	graph export "$Q42\01_B_3_Whours_sector_gender_`lev'.png", replace

	graph hbar (mean) whours [pw=wgt] if age_x<3, bar(1, color(gs10)) over(edulevelSEL,  axis(off) sort(1)) blabel(group, position(base) color(gs0)) over(female)  ///
	legend(size(vsmall) colfirst)  blabel(bar, position(center) size(vsmall) format(%3.1f))  /// 
	ytitle(Mean) ///
	graphregion(color(white)) title("Average weekly working hours by education and gender in `lev'", size (small)) 
	graph export "$Q42\01_B_3_Whours_edu_gender_`lev'.png", replace
}

else {
	di "Whours or industry  has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the wage, industry or empstat in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q42\99_Whours_age_gender_error_`lev'.png", replace
	graph export "$Q42\99_Whours_area_gender_error_`lev'.png", replace
	graph export "$Q42\99_Whours_sector_gender_error_`lev'.png", replace
	graph export "$Q42\99_Whours_edu_gender_error_`lev'.png", replace
}









*********************************************
***************** Earnings ******************
*********************************************


if nonmissing_wages!=0 & nonzero_wages!=0 & nonzero_wages!=. & nonmissing_empstat!=0 & nonmissing_industry!=0 & nonmissing_edu!=0 {



	graph hbar (mean) wage_per_month [pw=wgt] if age_x<3 & empstat!=2, over(age_x,  axis(off) sort(1)) bar(1, color(gs10)) blabel(group, position(base) color(gs0)) over(female)  ///
	legend(size(vsmall) colfirst)   /// 
	ytitle(Mean) ///
	graphregion(color(white)) title("Mean earnings per month by age and gender, Excluding Unpaid Workers `lev'", size (small)) 
	graph export "$Q411\01_B_3_Wage_all_but_unpaid_workers_age_gender_`lev'.png", replace


	graph hbar (mean) wage_per_month [pw=wgt] if age_x<3 & empstat!=2, over(urb,  axis(off) sort(1)) bar(1, color(gs10)) blabel(group, position(base) color(gs0)) over(female)  ///
	legend(size(vsmall) colfirst)   /// 
	ytitle(Mean) ///
	graphregion(color(white)) title("Mean earnings per month by area and gender, Excluding Unpaid Workers `lev'", size (small)) 
	graph export "$Q411\01_B_3_Wage_all_but_unpaid_workers_area_gender_`lev'.png", replace


	graph hbar (mean) wage_per_month [pw=wgt] if age_x<3 & empstat!=2, over(industry,  axis(off) sort(1)) bar(1, color(gs10)) blabel(group, position(base) color(gs0)) over(female)  ///
	legend(size(vsmall) colfirst)   /// 
	ytitle(Mean) ///
	graphregion(color(white)) title("Mean earnings per month by sector and gender, Excluding Unpaid Workers `lev'", size (small)) 
	graph export "$Q411\01_B_3_Wage_all_but_unpaid_workers_sector_gender_`lev'.png", replace

	graph hbar (mean) wage_per_month [pw=wgt] if age_x<3 & empstat!=2,over(edulevelSEL,  axis(off) sort(1)) bar(1, color(gs10))  blabel(group, position(base) color(gs0)) over(female)  ///
	legend(size(vsmall) colfirst)  /// 
	ytitle(Mean) ///
	graphregion(color(white)) title("Mean earnings per month by education and gender, Excluding Unpaid Workers `lev'", size (small)) 
	graph export "$Q411\01_B_3_Wage_all_but_unpaid_workers_edu_gender_`lev'.png", replace
}

else {
	di "Wage variable or empstat or industry  has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the wage, industry or empstat in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q411\99_Wage_all_but_unpaid_workers_age_gender_error_`lev'.png", replace
	graph export "$Q411\99_Wage_all_but_unpaid_workers_area_gender_error_`lev'.png", replace
	graph export "$Q411\99_Wage_all_but_unpaid_workers_sector_gender_error_`lev'.png", replace
	graph export "$Q411\99_Wage_all_but_unpaid_workers_edu_gender_error_`lev'.png", replace
}



if nonmissing_wages!=0 & nonzero_wages!=0 & nonzero_wages!=. & nonmissing_empstat!=0 & nonmissing_industry!=0 & nonmissing_edu!=0 {



	graph hbar (median) wage_per_month [pw=wgt] if age_x<3 & empstat!=2, over(age_x,  axis(off) sort(1)) bar(1, color(gs10)) blabel(group, position(base) color(gs0)) over(female)  ///
	legend(size(vsmall) colfirst)   /// 
	ytitle(Mean) ///
	graphregion(color(white)) title("Median earnings per month by age and gender, Excluding Unpaid Workers `lev'", size (small)) 
	graph export "$Q412\01_B_3_Wage_all_but_unpaid_workers_age_gender_`lev'.png", replace


	graph hbar (median) wage_per_month [pw=wgt] if age_x<3 & empstat!=2, over(urb,  axis(off) sort(1)) bar(1, color(gs10)) blabel(group, position(base) color(gs0)) over(female)  ///
	legend(size(vsmall) colfirst)   /// 
	ytitle(Mean) ///
	graphregion(color(white)) title("Median earnings per month by area and gender, Excluding Unpaid Workers `lev'", size (small)) 
	graph export "$Q412\01_B_3_Wage_all_but_unpaid_workers_area_gender_`lev'.png", replace


	graph hbar (median) wage_per_month [pw=wgt] if age_x<3 & empstat!=2, over(industry,  axis(off) sort(1)) bar(1, color(gs10)) blabel(group, position(base) color(gs0)) over(female)  ///
	legend(size(vsmall) colfirst)   /// 
	ytitle(Mean) ///
	graphregion(color(white)) title("Median earnings per month by sector and gender, Excluding Unpaid Workers `lev'", size (small)) 
	graph export "$Q412\01_B_3_Wage_all_but_unpaid_workers_sector_gender_`lev'.png", replace

	graph hbar (median) wage_per_month [pw=wgt] if age_x<3 & empstat!=2,over(edulevelSEL,  axis(off) sort(1)) bar(1, color(gs10))  blabel(group, position(base) color(gs0)) over(female)  ///
	legend(size(vsmall) colfirst)  /// 
	ytitle(Mean) ///
	graphregion(color(white)) title("Median earnings per month by education and gender, Excluding Unpaid Workers `lev'", size (small)) 
	graph export "$Q412\01_B_3_Wage_all_but_unpaid_workers_edu_gender_`lev'.png", replace
}

else {
	di "Wage variable or empstat or industry  has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the wage, industry or empstat in year `lev' ", ring(0) position(12) color(red) size(small))
	graph export "$Q412\99_Wage_all_but_unpaid_workers_age_gender_error_`lev'.png", replace
	graph export "$Q412\99_Wage_all_but_unpaid_workers_area_gender_error_`lev'.png", replace
	graph export "$Q412\99_Wage_all_but_unpaid_workers_sector_gender_error_`lev'.png", replace
	graph export "$Q412\99_Wage_all_but_unpaid_workers_edu_gender_error_`lev'.png", replace
}

}
}







use "$data/I2D2_test_$y.dta", clear

cap gen byte employed_act 			=0 if age>=15 & age<=64 & lstatus!=.
cap replace employed_act		=1 if lstatus==1 & age>=15 & age<=64
cap gen byte no_employed	=. 
cap replace no_employed=1	if employed==1
cap gen byte sh_unempr_all=0  if lstatus<=2 & age>=15 & age<=64
cap replace sh_unempr_all=1   if lstatus==2 & age>=15 & age<=64
cap gen byte no_lf_numb=1 	if (lstatus==1 | lstatus==2) & age_x<3
cap gen byte sh_lf_ =0  	if lstatus!=. & age_x<3
cap replace sh_lf_=1  	if lstatus<=2 & age_x<3



	 
save "$data/I2D2_test_$y.dta", replace

sum year, d
gen year_dummy=r(sd)

if year_dummy!=0{


** Setup

	sort ccode year
	merge ccode year using  "$user\\$y\Data\wbopendata.dta"
	keep if _merge==3  
	drop _merge	
	
	gen CPI_deflator=fp_cpi_totl/100
	label var CPI_deflator "CPI Deflator"

	
	gen wages_hourly_real=hourly_wages/CPI_deflator
	
	gen wages_monthly_real=wage_monthly/CPI_deflator


	label var wages_hourly_real			"Average Earnings per hour, deflated to 2010 local currency values"
	label var wages_monthly_real		"Average Earnings per month, deflated to 2010 local currency values"

	
*** Variable preparation
preserve


bys sample1: egen nonmissing_OLF=count(OLF)
bys sample1: egen nonmissing_urb=count(urb)
bys sample1: egen nonmissing_empl=count(employed)
bys sample1: egen nonmissing_unemp=count(unemployed)
bys sample1: egen nonmissing_edu=count(edulevelSEL)
bys sample1: egen nonmissing_emptype=count(emptype)
bys sample1: egen nonmissing_ocusec=count(ocusec)
bys sample1: egen nonmissing_empstat=count(empstat)
gen d_empstat1=1 if empstat==1
gen d_empstat2=1 if empstat==2
bys sample1: egen nonmissing_emp1=count(d_empstat1)
bys sample1: egen nonmissing_emp2=count(d_empstat2)
bys sample1: egen nonmissing_contract=count(contract)
bys sample1: egen nonmissing_industry=count(industry)
bys sample1: egen nonmissing_occup=count(occup)
bys sample1: egen nonmissing_wages_real=count(wages_monthly_real)
bys sample1: egen nonmissing_wages_hourly=count(wages_hourly_real)
bys sample1: egen nonmissing_whours=count(whours)

collapse nonmissing_*, by (ccode year sample1)

gen x=_N

egen count_sample=count(x)


foreach var in  nonmissing_OLF nonmissing_urb nonmissing_empl nonmissing_unemp nonmissing_edu nonmissing_emptype nonmissing_ocusec nonmissing_empstat nonmissing_emp1 nonmissing_emp2 nonmissing_contract nonmissing_industry nonmissing_occup nonmissing_wages_real nonmissing_wages_hourly nonmissing_whours{
gen `var'_miss=1 if `var'==0
egen miss_`var'=count(`var'_miss)
gen sum_miss_`var'=miss_`var'/count_sample
}

keep ccode year sample1 sum_miss_* 

sort ccode year sample1
save "$user\\$y\Data\miss", replace

restore

sort ccode year sample1

merge ccode year sample1  using "$user\\$y\Data/miss"
tab _merge
drop _merge




**********************************
************ Urbanization ********
**********************************




if sum_miss_nonmissing_urb!=1{

	graph bar (sum) counter [pw=wgt], percentages over(urb) over(year,  label(labsize(vsmall)))  ///
	asyvars stack legend(size(small) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Urban vs Rural over years", size (medium)) 
	graph export "$Q21\04_A_1_Urban_over_years.png", replace
	
	graph bar (sum) counter [pw=wgt], percentages over(female) over(year,  label(labsize(vsmall))) over(urb, ) ///
	asyvars stack legend(size(small) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Urban vs Rural by gender over years", size (medium)) 
	graph export "$Q21\04_A_2_Urban_gender_over_years.png", replace
	
		graph bar (sum) counter [pw=wgt], percentages over(female) over(year,  label(labsize(vsmall))) over(age_x ) ///
	asyvars stack legend(size(small) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Urban vs Rural by age over years", size (medium)) 
	graph export "$Q21\04_A_2_Urban_age_over_years.png", replace
	
}
else{
di "Urban variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the urban or gender variable", ring(0) position(12) color(red) size(small))
	graph export "$Q21\99_Urban_gender_over_years_error.png", replace
	graph export "$Q21\99_Urban_over_years_error.png", replace
	graph export "$Q21\99_Urban_age_over_years.png", replace

}
	

	
**********************************
************ LFP *****************
**********************************
	

if sum_miss_nonmissing_OLF!=1{
	graph bar (sum) counter [pw=wgt] if age_x<3, percentages over(lstatus) over(year, label(labsize(small))) ///
	showyvars stack ascategory asyvar ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("LFP shares over years, age 15-64", size (medium)) 
	graph export "$Q21\01_A_1_LFP_over_years.png", replace

	graph bar (sum) counter [pw=wgt] if age_x<3 , percentages over(lstatus) over(year, label(labsize(small))) over(female) ///
	showyvars stack ascategory asyvar ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("LFP shares over years and gender, age 15-64", size (medium)) 
	graph export "$Q21\01_A_2_LFP_gender_over_years.png", replace
	
	graph bar (sum) counter [pw=wgt] if age_x<3 , percentages over(lstatus) over(year, label(labsize(small))) over(age_x) ///
	showyvars stack ascategory asyvar ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("LFP shares over years and age, age 15-64", size (medium)) 
	graph export "$Q21\01_A_2_LFP_age_over_years.png", replace
	

}
else {
	di "Inactive variable has missing values for all obs."
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the OLF variable over years ", ring(0) position(12) color(red) size(small))
	graph export "$Q21\99_LFP_over_years_error.png", replace
	graph export "$Q21\99_LFP_gender_over_years_error.png", replace
	graph export "$Q21\99_LFP_age_over_years_error.png", replace
}


if sum_miss_nonmissing_OLF!=1 & sum_miss_nonmissing_urb!=1{

	graph bar (sum) counter [pw=wgt] if age_x<3, percentages over(lstatus) over(year, label(labsize(small))) over(urb) ///
	showyvars stack ascategory asyvar ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("LFP shares over years and area, age 15-64", size (medium)) 
	graph export "$Q21\01_A_2_LFP_urban_over_years.png", replace
}
else {
	di "Urbanisation and Inactive variable has missing values for all obs."
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the OLF and urbanisation variable over years ", ring(0) position(12) color(red) size(small))
	graph export "$Q21\99_LFP_urban_over_years_error.png", replace
}		


if sum_miss_nonmissing_edu!=1 & sum_miss_nonmissing_OLF!=1{	
	graph bar (sum) counter [pw=wgt] if age_x<3, percentages over(lstatus) over(edulevelSEL, label(labsize(vsmall)angle(45))) over(year, label(labsize(small)))  ///
	showyvars stack ascategory asyvar ytitle("") legend(size(vsmall))   blabel(bar, position(center) size(vsmall) format(%3.1f))   ///
	graphregion(color(white)) title("LFP shares over years and education, age 15-64", size (medium)) 
	graph export "$Q21\01_A_2_LFP_edu_over_years.png", replace
}
else {
	di "Employed and education variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the employed variable over all years", ring(0) position(12) color(red) size(small))
	graph export "$Q21\99_LFP_edu_over_years_error.png", replace
}

**************************************
********** Employment ****************
**************************************


if sum_miss_nonmissing_empl!=1{

* Gender
	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(female) over(year, label(labsize(small))) ///
	showyvars stack ascategory asyvar ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment over years by gender, age 15-64", size (medium)) 
	graph export "$Q22\01_A_2_Employment_gender_over_years.png", replace

* Age

	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(age_x) over(year, label(labsize(small))) ///
	showyvars stack ascategory asyvar ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment over years by age, age 15-64", size (medium)) 
	graph export "$Q22\01_A_2_Employment_age_over_years.png", replace
}
else {
di 	"Employed  variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the employed and urbanisation variable over all years", ring(0) position(12) color(red) size(small))
	graph export "$Q22\99_Employment_age_over_years_error.png", replace
	graph export "$Q22\99_Employment_gender_over_years_error.png", replace
}



if 	sum_miss_nonmissing_urb!=1 & sum_miss_nonmissing_empl!=1{
	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(urb) over(year, label(labsize(small)))  ///
	showyvars stack ascategory asyvar ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment over years by area, age 15-64", size (medium)) 
	graph export "$Q22\01_A_2_Employment_urban_over_years.png", replace
}
else {
	di "Employed and urbanisation variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the employed and urbanisation variable over all years", ring(0) position(12) color(red) size(small))
	graph export "$Q22\99_Employment_urban_over_years_error.png", replace
}

if sum_miss_nonmissing_edu!=1 & sum_miss_nonmissing_empl!=1{	
	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(edulevelSEL) over(year, label(labsize(small)))  ///
	showyvars stack ascategory asyvar ytitle("") legend(size(vsmall))   blabel(bar, position(center) size(vsmall) format(%3.1f))   ///
	graphregion(color(white)) title("Employment over years by education, age 15-64", size (medium)) 
	graph export "$Q22\01_A_2_Employment_edu_over_years.png", replace
}
else {
	di "Employed and education variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the employed variable over all years", ring(0) position(12) color(red) size(small))
	graph export "$Q22\99_Employment_edu_over_years_error.png", replace
}





if sum_miss_nonmissing_emptype!=1 & sum_miss_nonmissing_ocusec!=1{
	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(emptype) over(year, label(labsize(small)))  ///
	showyvars stack ascategory asyvar ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment over years, age 15-64", size (medium)) 
	graph export "$Q31\01_A_1_Employment_emptype_over_years.png", replace
}
else{
	di "Employed, emptype and ocusec variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the employed, emptype and ocusec variable over all years", ring(0) position(12) color(red) size(small))
	graph export "$Q31\99_Employment_emptype_over_years_error.png", replace
}



if sum_miss_nonmissing_empstat!=1{		
	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(empstat) over(year, label(labsize(small)))  ///
	showyvars stack ascategory asyvar ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment over years, age 15-64", size (medium)) 
	graph export "$Q31\02_A_1_Employment_empstat_over_years.png", replace
	
	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(empstat) over(age_5, label(labsize(small))) over(year)  ///
	showyvars stack ascategory asyvar ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f)) ///
	graphregion(color(white)) title("Employment over years by age, age 15-64", size (medium)) 
	graph export "$Q31\02_A_2_Employment_empstat_age_over_years.png", replace

	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(empstat) over(female, label(labsize(small))) over(year)  ///
	showyvars stack ascategory asyvar ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f)) ///
	graphregion(color(white)) title("Employment over years by gender, age 15-64", size (medium)) 
	graph export "$Q31\02_A_2_Employment_empstat_female_over_years.png", replace
	
	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(empstat) over(urb, label(labsize(small))) over(year)  ///
	showyvars stack ascategory asyvar ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f)) ///
	graphregion(color(white)) title("Employment over years by area, age 15-64", size (medium)) 
	graph export "$Q31\02_A_2_Employment_empstat_urb_over_years.png", replace
	

	
}

else {
	di "Employed and emptype variable has missing values for all obs. in year `lev'"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the employed, emptype and ocusec variable over all years", ring(0) position(12) color(red) size(small))
	graph export "$Q31\99_Employment_empstat_over_years_error.png", replace
	graph export "$Q31\99_Employment_empstat_age_over_years_error.png", replace
	graph export "$Q31\99_Employment_empstat_female_over_years_error.png", replace
	graph export "$Q31\99_Employment_empstat_urb_over_years_error.png", replace
}


if sum_miss_nonmissing_edu!=1 & sum_miss_nonmissing_empstat!=1{	
		
	graph bar (sum) counter [pw=wgt] if age_x<3 & employed==1, percentages over(empstat) over(edulevelSEL, label(labsize(vsmall)angle(45))) over(year)  ///
	showyvars stack ascategory asyvar ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f)) ///
	graphregion(color(white)) title("Employment over years by education, age 15-64", size (medium)) 
	graph export "$Q31\02_A_2_Employment_empstat_edu_over_years.png", replace
}

else {
	graph export "$Q31\99_Employment_empstat_edu_over_years_error.png", replace
}


*******************************************************************************************************
************** Employment, Unemployment and Labor Force over time in relative and absolute numbers ****
*******************************************************************************************************



if sum_miss_nonmissing_empl!=1 {

preserve
drop  if lstatus==3
keep if age>=15 & age<=64

drop employed


collapse (mean) employed_act  (count) no_employed [pw=wgt], by(year) 


gen employed_round=round(employed_act, 0.01)
drop employed_act


gen employed=employed_round*100
gen no_Mio=no_employed/1000000

label var employed "Employment share"
label var no_Mio   "Number of employed (in million)"

sum year, d
local maxyear = r(max)
local minyear = r(min)

sum no_Mio, d
gen var=r(sd)
gen var_round=round(var, 0.1)

sum no_Mio if year==`minyear'
gen minabs=r(mean)-var_round
gen minabs_round=round(minabs, 0.1)

sum no_Mio if year==`maxyear'
gen maxabs=r(mean)+var_round
gen maxabs_round=round(maxabs, 0.1)

sum var_round
local var_round=r(mean)

sum maxabs_round
local maxabs_round=r(mean)

sum minabs_round
local minabs_round=r(mean)

sum year, d
local maxyear = r(max)
local minyear = r(min)
levelsof year
local information_year=r(levels)

twoway  (bar no_Mio year, yaxis(1) ytitle("Number of employed (in million)", size(medsmall))) ||  ///
			(line employed year, connect(l) yaxis(2) ytitle("Employment share", size(medsmall) axis(2))  ///
			ylabel(0(20)100, axis(2) nogrid) ylabel(`minabs_round'(`var_round')`maxabs_round', axis(1) nogrid) xlabel(`minyear'(2)`maxyear') title("Employment share over time in $y, age 15-64", size(medium)) ///
			note("Note: Employment share is defined as the share of employed individuals at working age (15-64) in the active labor force." "Data points are available in the years `information_year'.", size(vsmall)) graphregion(color(white))) 	
graph export "$Q22\\02_A_1_Employment_share_over_years.png", replace
restore
}


else {
di  "Employed variable has missing values for all obs. in year "
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the employed, emptype and ocusec variable over all years", ring(0) position(12) color(red) size(small))
	graph export "$Q22\99_Employment_share_over_years_error.png", replace
}


if sum_miss_nonmissing_empl!=1 {

preserve

keep if age>=15 & age<=64
cap drop employed

	
collapse (mean) employed_act  (count) no_employed [pw=wgt], by(year) 


gen employed_round=round(employed_act, 0.01)
drop employed_act


gen employed=employed_round*100
gen no_Mio=no_employed/1000000

label var employed "Employment ratio"
label var no_Mio   "Number of employed (in million)"

sum year, d
local maxyear = r(max)
local minyear = r(min)

sum no_Mio, d
gen var=r(sd)
gen var_round=round(var, 0.1)

sum no_Mio if year==`minyear'
gen minabs=r(mean)-var_round
gen minabs_round=round(minabs, 0.1)

sum no_Mio if year==`maxyear'
gen maxabs=r(mean)+var_round
gen maxabs_round=round(maxabs, 0.1)

sum var_round
local var_round=r(mean)

sum maxabs_round
local maxabs_round=r(mean)

sum minabs_round
local minabs_round=r(mean)

sum year, d
local maxyear = r(max)
local minyear = r(min)
levelsof year
local information_year=r(levels)

twoway  (bar no_Mio year, yaxis(1) ytitle("Number of employed (in million)", size(medsmall))) ||  ///
			(line employed year, connect(l) yaxis(2) ytitle("Employment ratio", size(medsmall) axis(2))  ///
			ylabel(0(20)100, axis(2) nogrid) ylabel(`minabs_round'(`var_round')`maxabs_round', axis(1) nogrid) xlabel(`minyear'(2)`maxyear') title("Employment ratio over time in $y, age 15-64", size(medium)) ///
			note("Note: Employment ratio is defined as the ratio of employed individuals to all individuals aged 15-64." "Data points are available in the years `information_year'.", size(vsmall)) graphregion(color(white))) 	
graph export "$Q22\01_A_1_Employment_ratio_over_years.png", replace
restore
}


else {
di  "Employed variable has missing values for all obs. in year "
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the employed, emptype and ocusec variable over all years", ring(0) position(12) color(red) size(small))
	graph export "$Q22\99_Employment_ratio_over_years_error.png", replace
}


if sum_miss_nonmissing_empl!=1 {

preserve
keep if lstatus==1 | lstatus==2

drop employed
keep if age>=15 & age<=24

	
collapse (mean) employed_act  (count) no_employed [pw=wgt], by(year) 


gen employed_round=round(employed_act, 0.01)

drop employed_act

gen employed=employed_round*100
gen no_Mio=no_employed/1000000

label var employed "Employment share"
label var no_Mio   "Number of employed (in million)"

sum year, d
local maxyear = r(max)
local minyear = r(min)

sum no_Mio, d
gen var=r(sd)
gen var_round=round(var, 0.1)

sum no_Mio if year==`minyear'
gen minabs=r(mean)-var_round
gen minabs_round=round(minabs, 0.1)

sum no_Mio if year==`maxyear'
gen maxabs=r(mean)+var_round
gen maxabs_round=round(maxabs, 0.1)

sum var_round
local var_round=r(mean)

sum maxabs_round
local maxabs_round=r(mean)

sum minabs_round
local minabs_round=r(mean)

sum year, d
local maxyear = r(max)
local minyear = r(min)
levelsof year
local information_year=r(levels)

twoway  (bar no_Mio year, yaxis(1) ytitle("Number of employed (in million)", size(medsmall))) ||  ///
			(line employed year, connect(l) yaxis(2) ytitle("Employment share", size(medsmall) axis(2))  ///
			ylabel(0(20)100, axis(2) nogrid) ylabel(`minabs_round'(`var_round')`maxabs_round', axis(1) nogrid) xlabel(`minyear'(2)`maxyear') title("Youth employment share over time in $y, age 15-24", size(medium)) ///
			note("Note: Employment share is defined as the share of employed individuals at working age (15-24) in the active labor force." "Data points are available in the years `information_year'.", size(vsmall)) graphregion(color(white))) 	
graph export "$Q22\02_A_2_Employment_share_over_years_youth.png", replace
restore
}


else {
di  "Employed variable has missing values for all obs. in year "
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the employed, emptype and ocusec variable over all years", ring(0) position(12) color(red) size(small))
	graph export "$Q22\99_Employment_share_over_years_youth_error.png", replace
}




if sum_miss_nonmissing_empl!=1{
preserve


drop employed



keep if age>=15 & age<=24


collapse (mean) employed_act  (count) no_employed [pw=wgt], by(year) 


gen employed_round=round(employed_act, 0.01)
drop employed_act


gen employed=employed_round*100
gen no_Mio=no_employed/1000000

label var employed "Employment ratio"
label var no_Mio   "Number of employed (in million)"

sum year, d
local maxyear = r(max)
local minyear = r(min)

sum no_Mio, d
gen var=r(sd)
gen var_round=round(var, 0.1)

sum no_Mio if year==`minyear'
gen minabs=r(mean)-var_round
gen minabs_round=round(minabs, 0.1)

sum no_Mio if year==`maxyear'
gen maxabs=r(mean)+var_round
gen maxabs_round=round(maxabs, 0.1)

sum var_round
local var_round=r(mean)

sum maxabs_round
local maxabs_round=r(mean)

sum minabs_round
local minabs_round=r(mean)

sum year, d
local maxyear = r(max)
local minyear = r(min)

levelsof year
local information_year=r(levels)

twoway  (bar no_Mio year, yaxis(1) ytitle("Number of employed (in million)", size(medsmall))) ||  ///
			(line employed year, connect(l) yaxis(2) ytitle("Employment to Population ratio", size(medsmall) axis(2))  ///
			ylabel(0(20)100, axis(2) nogrid) ylabel(`minabs_round'(`var_round')`maxabs_round', axis(1) nogrid) xlabel(`minyear'(2)`maxyear') title("Youth employment ratio over time in $y, age 15-24", size(medium)) ///
			note("Note: Youth employment to population ratio is defined as the ratio of employed young individuals at age (15-24) to all young individuals." "Data points are available in the years `information_year'.", size(vsmall)) graphregion(color(white))) 	
		
graph export "$Q22\01_A_2_Employment_ratio_over_years_youth.png", replace
restore
}


else {
di  "Employed variable has missing values for all obs. in year "
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the employed, emptype and ocusec variable over all years", ring(0) position(12) color(red) size(small))
	graph export "$Q22\99_Employment_ratio_over_years_youth_error.png", replace
}








******** Labor force participation rate (do also for females)
preserve 

	
collapse (mean) sh_lf_  (count) no_lf_numb [pw=wgt], by(year) 


gen sh_lf_round=round(sh_lf_, 0.01)
drop sh_lf_


gen sh_lf_=sh_lf_round*100
gen no_Mio=no_lf_numb/1000000

label var sh_lf_   "Labor Force Participation rate"
label var no_Mio   "Labor Force (in million)"

sum year, d
local maxyear = r(max)
local minyear = r(min)

sum no_Mio, d
gen var=r(sd)
gen var_round=round(var, 0.1)

sum no_Mio if year==`minyear'
gen minabs=r(mean)-var_round
gen minabs_round=round(minabs, 0.1)

sum no_Mio if year==`maxyear'
gen maxabs=r(mean)+var_round
gen maxabs_round=round(maxabs, 0.1)

sum var_round
local var_round=r(mean)

sum maxabs_round
local maxabs_round=r(mean)

sum minabs_round
local minabs_round=r(mean)

sum year, d
local maxyear = r(max)
local minyear = r(min)
levelsof year
local information_year=r(levels)

twoway  (bar no_Mio year, yaxis(1) ytitle("Labor Force (in million)", size(medsmall))) ||  ///
			(line sh_lf_ year, connect(l) yaxis(2) ytitle("Labor Force Participation Rate", size(medsmall) axis(2))  ///
			ylabel(0(20)100, axis(2) nogrid) ylabel(`minabs_round'(`var_round')`maxabs_round', axis(1) nogrid) xlabel(`minyear'(2)`maxyear') title("Labor Force development in $y over time, age 15-64", size(medium)) ///
			note("Note: Labor Force is defined as all employed or employment seeking individuals in working age (15-64)." "Data points are available in the years `information_year'.", size(vsmall)) graphregion(color(white)) ///
			legend(size(small))		)

graph export "$Q21\02_A_1_LFP_relabs_over_years.png", replace


restore


		
******** Female Labor force participation rate 
preserve 


	
keep if gender==2

collapse (mean) sh_lf_  (count) no_lf_numb [pw=wgt], by(year) 


gen sh_lf_round=round(sh_lf_, 0.01)
drop sh_lf_


gen sh_lf_=sh_lf_round*100
gen no_Mio=no_lf_numb/1000000

label var sh_lf_   "Female Labor Force Participation rate"
label var no_Mio   "Female Labor Force (in million)"

sum year, d
local maxyear = r(max)
local minyear = r(min)

sum no_Mio, d
gen var=r(sd)
gen var_round=round(var, 0.1)

sum no_Mio if year==`minyear'
gen minabs=r(mean)-var_round
gen minabs_round=round(minabs, 0.1)

sum no_Mio if year==`maxyear'
gen maxabs=r(mean)+var_round
gen maxabs_round=round(maxabs, 0.1)

sum var_round
local var_round=r(mean)

sum maxabs_round
local maxabs_round=r(mean)

sum minabs_round
local minabs_round=r(mean)

sum year, d
local maxyear = r(max)
local minyear = r(min)
levelsof year
local information_year=r(levels)

twoway  (bar no_Mio year, yaxis(1) ytitle("Female Labor Force (in million)", size(small))) ||  ///
			(line sh_lf_ year, connect(l) yaxis(2) ytitle("Female Labor Force Participation Rate", size(small) axis(2))  ///
			ylabel(0(20)100, axis(2) nogrid) ylabel(`minabs_round'(`var_round')`maxabs_round', axis(1) nogrid) xlabel(`minyear'(2)`maxyear') title("Female Labor Force development in $y over time, age 15-64", size(medium)) ///
			note("Note: Labor Force is defined as all employed or employment seeking individuals in working age (15-64)." "Data points are available in the years `information_year'.", size(vsmall)) graphregion(color(white)) ///
			legend(size(vsmall)))

graph export "$Q21\02_A_2_LFP_relabs_over_years_female.png", replace


restore

**************************************************************************
************ Sectors with relative and absolute values *******************
**************************************************************************


preserve
if sum_miss_nonmissing_industry!=1{


	gen ag=0 if industry_x!=. & lstatus==1 
	replace ag=1 if industry_x==1
	
	gen indu=0 if industry_x!=. & lstatus==1 
	replace indu=1 if industry_x==2

	gen serv=0 if industry_x!=. & lstatus==1
	replace serv=1 if industry_x==3
	
	gen no_ag=1 if industry_x==1
	
	gen no_indu=1 if industry_x==2
	
	gen no_serv=1 if industry_x==3
	
	
	keep if age_x<3
	
	collapse (mean) ag indu serv (count) no_ag no_indu no_serv [pw=wgt], by(year) 

	
	
	foreach var in ag indu serv{
	gen `var'_round=round(`var', 0.01)
	drop `var'
	}
	
	foreach var in ag indu serv{
	gen `var'=`var'_round * 100
	drop `var'_round
	gen `var'_Mio=no_`var'/1000000
	drop no_`var'
	}
	
	label var ag    	"Share of agriculture workers"
	label var indu		"Share of industry workers"
	label var serv		"Share of service workers"
	
	label var ag_Mio 	"Number of ag workers"
	label var indu_Mio 	"Number of industry workers"
	label var serv_Mio 	"Number of service worker"
	
	sum year, d
	local maxyear = r(max)
	local minyear = r(min)

	sum ag_Mio, d
	gen var=r(sd)
	gen var_round_ag=round(var, 0.1)
	drop var

	sum indu_Mio, d
	gen var=r(sd)
	gen var_round_indu=round(var, 0.1)
	drop var

	sum serv_Mio, d
	gen var=r(sd)
	gen var_round_serv=round(var, 0.1)
	drop var
	
	
	
	sum ag_Mio if year==`minyear'
	gen minabs=r(mean)-var_round_ag
	gen minabs_round_ag=round(minabs, 0.1)
	drop minabs
	
	sum ag_Mio if year==`maxyear'
	gen maxabs=r(mean)+var_round_ag
	gen maxabs_round_ag=round(maxabs, 0.1)
	drop maxabs
	
	sum indu_Mio if year==`minyear'
	gen minabs=r(mean)-var_round_indu
	gen minabs_round_indu=round(minabs, 0.1)
	drop minabs
	
	sum indu_Mio if year==`maxyear'
	gen maxabs=r(mean)+var_round_indu
	gen maxabs_round_indu=round(maxabs, 0.1)
	drop maxabs
	
	sum serv_Mio if year==`minyear'
	gen minabs=r(mean)-var_round_serv
	gen minabs_round_serv=round(minabs, 0.1)
	drop minabs
	
	sum serv_Mio if year==`maxyear'
	gen maxabs=r(mean)+var_round_serv
	gen maxabs_round_serv=round(maxabs, 0.1)
	drop maxabs
	
	
	replace minabs_round_serv=0 if minabs_round_serv<0
	replace minabs_round_indu=0 if minabs_round_indu<0
	replace minabs_round_ag=0   if minabs_round_ag<0
	
	
	** AG
	sum var_round_ag
	local var_round=r(mean)

	sum maxabs_round_ag
	local maxabs_round=r(mean)

	sum minabs_round_ag
	local minabs_round=r(mean)

	sum year, d
	local maxyear = r(max)
	local minyear = r(min)
	levelsof year
	local information_year=r(levels)
	
	
	twoway  (bar ag_Mio year, yaxis(1) ytitle("Number of AG workers (in million)", size(medsmall))) ||  ///
			(line ag year, connect(l) yaxis(2) ytitle("Share of AG workers", size(medsmall) axis(2))  ///
			ylabel(0(20)100, axis(2) nogrid) ylabel(`minabs_round'(`var_round')`maxabs_round', axis(1) nogrid) xlabel(`minyear'(2)`maxyear') title("Workers in agriculture over time in $y, age 15-64", size(medium)) ///
			note("Note: Data points are available in the years `information_year'.", size(vsmall)) graphregion(color(white)) ///
			legend(size(vsmall)))	
graph export "$Q32\02_A_1_AG_sector_relabs_over_years.png", replace

	
	** Industry
	sum var_round_indu
	local var_round=r(mean)

	sum maxabs_round_indu
	local maxabs_round=r(mean)

	sum minabs_round_indu
	local minabs_round=r(mean)

	sum year, d
	local maxyear = r(max)
	local minyear = r(min)
	levelsof year
	local information_year=r(levels)
	
	
	twoway  (bar indu_Mio year, yaxis(1) ytitle("Number of industry workers (in million)", size(medsmall))) ||  ///
			(line indu year, connect(l) yaxis(2) ytitle("Share of industry workers", size(medsmall) axis(2))  ///
			ylabel(0(20)100, axis(2) nogrid) ylabel(`minabs_round'(`var_round')`maxabs_round', axis(1) nogrid) xlabel(`minyear'(2)`maxyear') title("Workers in industry sector over time in $y, age 15-64", size(medium)) ///
			note("Note: Data points are available in the years `information_year'.", size(vsmall)) graphregion(color(white)) ///
			legend(size(vsmall)))
	
graph export "$Q32\02_A_1_Industry_sector_relabs_over_years.png", replace

	
	** Services
	sum var_round_serv
	local var_round=r(mean)

	sum maxabs_round_serv
	local maxabs_round=r(mean)

	sum minabs_round_serv
	local minabs_round=r(mean)

	sum year, d
	local maxyear = r(max)
	local minyear = r(min)
	levelsof year
	local information_year=r(levels)
	
	
	twoway  (bar serv_Mio year, yaxis(1) ytitle("Number of service workers (in million)", size(medsmall))) ||  ///
			(line serv year, connect(l) yaxis(2) ytitle("Share of service workers", size(medsmall) axis(2))  ///
			ylabel(0(20)100, axis(2) nogrid) ylabel(`minabs_round'(`var_round')`maxabs_round', axis(1) nogrid) xlabel(`minyear'(2)`maxyear') title("Workers in service sector over time in $y, age 15-64", size(medium)) ///
			note("Note: Data points are available in the years `information_year'.", size(vsmall)) graphregion(color(white)) ///
			legend(size(vsmall))) 	
	graph export "$Q32\02_A_1_Service_sector_relabs_over_years.png", replace
}

else {
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the industry variable  ", ring(0) position(12) color(red) size(small))
	graph export "$Q32\99_Service_sector_error_over_years.png", replace
	graph export "$Q32\99_AG_sector_error_over_years.png", replace
	graph export "$Q32\99_Industry_sector_error_over_years.png", replace
}
	
	
restore

*************************************
********* Emp Stat ******************
*************************************


if sum_miss_nonmissing_industry!=1{
preserve

	gen paid_emp=1 if empstat==1 & employed==1 
	
	gen SE_empl=1  if empstat==4 | empstat==3 & employed==1
	
	gen unpaid=1   if empstat==2 & employed==1	
	
	
	keep if age_x<3
	
	collapse (count) paid_emp SE_empl unpaid [pw=wgt], by(year) 


	
	foreach var in paid_emp SE_empl unpaid {
	gen `var'_Mio=`var'/1000000
	drop `var'
	}
	

	label var paid_emp_Mio	"Number of wage workers"
	label var SE_empl_Mio 	"Number of SE or employers"
	label var unpaid_Mio 	"Number of unpaid worker"
			
	twoway  (line paid_emp_Mio year, connect(l))  || ///
			(line SE_empl_Mio  year, connect(l))  || ///
			(line unpaid_Mio   year, connect(l)),  ///
			ytitle("Number of workers (in Mio.)") title("Number of workers by employment type (in Mio.), age 15-64", size(medium)) graphregion(color(white)) ylabel(,nogrid) legend(size(small))
			
graph export "$Q31\02_A_1_Employment_types_over_years.png", replace



restore
}

else {
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the industry variable  ", ring(0) position(12) color(red) size(small))
	graph export "$Q31\99_Employment_types_error_over_years.png", replace
}
	

	


*************************************
********* Industry and wage type ****
*************************************


if sum_miss_nonmissing_industry!=1{

preserve

	gen paid_emp_no_ag=1 if empstat==1 & employed==1 & (industry_x==2 | industry_x==3)
	
	gen paid_emp_ag=1 if empstat==1 & employed==1 & (industry_x==1)
	
	gen SE_no_ag=1  if empstat==4 & employed==1 & (industry_x==2 | industry_x==3)
	
	gen SE_ag=1  if empstat==4 & employed==1 & (industry_x==1)

	keep if age_x<3
	
	gen emp_sec=.
	replace emp_sec=1 if paid_emp_no_ag==1
	replace emp_sec=2 if paid_emp_ag==1
	replace emp_sec=3 if SE_no_ag==1
	replace emp_sec=4 if SE_ag==1
	
	label def emp_sec 1 "Wage No AG" 2 "Wage AG" 3 "SE No AG" 4 "SE AG"
	label val emp_sec emp_sec
	
	graph bar (sum) counter [pw=wgt] if age_x<3, percentages ///
	over(emp_sec) over(year, label(labsize(small))) ///
	asyvars stack legend(size(small) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Employment by sector, age 15-64", size (medium))
	graph export "$Q31\04_A_2_Employment_sector_over_years.png", replace
	
	
	
	
	collapse (count) paid_emp_no_ag paid_emp_ag SE_no_ag SE_ag [pw=wgt], by(year) 


	
	foreach var in paid_emp_no_ag paid_emp_ag SE_no_ag SE_ag {
	gen `var'_Mio=`var'/1000000
	drop `var'
	}
	

	label var paid_emp_no_ag_Mio	"Wage No AG"
	label var paid_emp_ag_Mio		"Wage AG"
	label var SE_no_ag_Mio			"SE No AG"
	label var SE_ag_Mio				"SE AG"

			
	twoway  (line paid_emp_no_ag_Mio year, connect(l))  || ///
			(line paid_emp_ag_Mio  year, connect(l))  || ///
			(line SE_ag_Mio	  year, connect(l))  || ///
			(line SE_no_ag_Mio  year, connect(l)),  ///
			ytitle("Number of workers (in Mio.)") title("Number of workers by employment type and sector (in Mio.), age 15-64", size(medium)) graphregion(color(white)) ylabel(,nogrid) legend(size(small))
			
graph export "$Q31\04_A_3_Employment_sector_absolute_over_years.png", replace



restore
}

else {
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the industry variable  ", ring(0) position(12) color(red) size(small))
	graph export "$Q31\99_Employment_sector_error_over_years.png", replace
	graph export "$Q31\99_Employment_sector_absolute_over_years.png", replace
}
	
	
	

	
	
	
	
	
	

***************************************
************** Unemployment ***********
***************************************


if sum_miss_nonmissing_unemp!=1{

	graph bar (sum) counter [pw=wgt] if age_x<3 & unemployed==1, percentages ///
	over(female) over(year, label(labsize(small))) ///
	asyvars stack legend(size(small) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Share of Unemployed over years by gender, age 15-64", size (medium))
	graph export "$Q22\04_A_2_Unemployment_gender_over_years.png", replace

	graph bar (sum) counter [pw=wgt] if age_x<3 & unemployed==1, percentages ///
	over(age_x) over(year, label(labsize(small)))  ///
	asyvars stack legend(size(small) colfirst) ytitle("") blabel(bar, position(center) size(vsmall) format(%3.1f))   ///
	graphregion(color(white)) title("Share of Unemployed over years by age groups, age 15-64", size (medium))
	graph export "$Q22\04_A_2_Unemployment_age_over_years.png", replace
}
else {
	di "Unemployment variable has missing values for all obs. in year `lev' or no unemployment in wka pop."
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the unemployment or urbanisation variable  ", ring(0) position(12) color(red) size(small))
	graph export "$Q22\99_Unemployment_gender_error_over_years.png", replace
	graph export "$Q22\99_Unemployment_age_error_over_years.png", replace
}
	

if sum_miss_nonmissing_unemp!=1 & sum_miss_nonmissing_urb!=1{
	graph bar (sum) counter [pw=wgt] if age_x<3  & unemployed==1, percentages ///
	over(urb) over(year, label(labsize(small))) ///
	asyvars stack legend(size(small) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Share of Unemployed over years by area, age 15-64", size (medium))
	graph export "$Q22\04_A_2_Unemployment_urban_over_years.png", replace
}
else{
	di "Urbanisation or unemployment variable has missing values for all obs. in year `lev' "
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the unemployment or urbanisation variable  ", ring(0) position(12) color(red) size(small))
	graph export "$Q22\99_Unemployment_urban_error_over_years.png", replace
}


if sum_miss_nonmissing_edu!=1 & sum_miss_nonmissing_unemp!=1{
	 graph bar (sum) counter [pw=wgt] if age_x<3 &  unemployed==1, percentages ///
	 over(edulevelSEL) over(year, label(labsize(small))) ///
	 asyvars stack legend(size(vsmall)) ytitle("")  ///
	 blabel(bar, position(center) size(vsmall) format(%3.2f))  ///
	 graphregion(color(white)) title("Share of Unemployed over years by highest education level, age 15-64", size (medium))
	 graph export "$Q22\04_A_2_Unemployment_edu_over_years.png", replace
}
else{
	di "Education variable has missing values for all obs. in year `lev' or no unemployment"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the unemployment or education variable  ", ring(0) position(12) color(red) size(small))
	graph export "$Q22\99_Unemployment_edu_over_years_error.png", replace
}




***************************************
************** Inactive ***************
***************************************

label def non_LFP 0 "In Labor Force" 1 "Out of Labor Force", modify
label val non_LFP non_LFP

if sum_miss_nonmissing_OLF!=1{

	graph bar (sum) counter [pw=wgt] if age_x<3 , percentages  over(non_LFP) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Out of Labor Force, age 15-64", size (medium)) 
	graph export "$Q23\03_A_1_OLF_years.png", replace
	
	
	
	
	graph bar (sum) counter [pw=wgt] if age_x<3  & non_LFP==1, percentages over(female) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Out of Labor Force by gender, age 15-64", size (medium)) 
	graph export "$Q23\03_A_2_OLF_gender_years.png", replace

	graph bar (sum) counter [pw=wgt] if age_x<3 & non_LFP==1, percentages over(age_5) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Out of LF by age, age 15-64", size (medium)) 
	graph export "$Q23\03_A_2_OLF_age_years.png", replace
}
else {
	di "Inactive Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the inactive variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q23\99_OLF_gender_years_error.png", replace
	graph export "$Q23\99_OLF_age_years_error.png", replace
}

if sum_miss_nonmissing_urb!=1 & sum_miss_nonmissing_OLF!=1{
	
	graph bar (sum) counter [pw=wgt] if age_x<3  & non_LFP==1, percentages over(urb) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Out of LF by area, age 15-64", size (medium)) 
	graph export "$Q23\03_A_2_OLF_urban_years.png", replace
}

else {
	di "Urban Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the urban variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q23\99_OLF_urban_years_error.png", replace
}	
	
if sum_miss_nonmissing_edu!=1 & sum_miss_nonmissing_OLF!=1{
	graph bar (sum) counter [pw=wgt] if age_x<3 & non_LFP==1, percentages over(edulevelSEL) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall)) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Out of LF by education, age 15-64", size (medium)) 
	graph export "$Q23\03_A_2_OLF_education_years.png", replace
}

else {
	di "Education or Inactive variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the education or inactive variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q23\99_OLF_education_years_error.png", replace
}
	

	
	


***************************************
************** Sector ***************
***************************************

if sum_miss_nonmissing_industry!=1{

	graph bar (sum) counter [pw=wgt] if age_x<3  & lstatus==1, percentages  over(industry_x) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Industry over time, age 15-64", size (medium)) 
	graph export "$Q32\01_A_1_industry_years.png", replace
	
	
	
	
	graph bar (sum) counter [pw=wgt] if age_x<3  & lstatus==1, percentages over(industry_x) over(female) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Industry by gender, age 15-64", size (medium)) 
	graph export "$Q32\01_A_2_industry_gender_years.png", replace

	graph bar (sum) counter [pw=wgt] if age_x<3 & lstatus==1, percentages over(industry_x) over(age_5) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Industry by age, age 15-64", size (medium)) 
	graph export "$Q32\01_A_2_industry_age_years.png", replace
}
else {
	di "Inactive Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the inactive variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q32\99_industry_gender_years_error.png", replace
	graph export "$Q32\99_industry_age_years_error.png", replace
}

if sum_miss_nonmissing_urb!=1 & sum_miss_nonmissing_industry!=1{
	
	graph bar (sum) counter [pw=wgt] if age_x<3  & lstatus==1, percentages over(industry_x)  over(urb) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Industry by area, age 15-64", size (medium)) 
	graph export "$Q32\01_A_2_industry_urban_years.png", replace
}

else {
	di "Urban Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the urban variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q32\99_industry_urban_years_error.png", replace
}	
	
if sum_miss_nonmissing_edu!=1 & sum_miss_nonmissing_industry!=1{
	graph bar (sum) counter [pw=wgt] if age_x<3 & lstatus==1, percentages over(industry_x)  over(edulevelSEL,label(labsize(vsmall)angle(45))) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall)) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Industry by education, age 15-64", size (medium)) 
	graph export "$Q32\01_A_2_industry_education_years.png", replace
}

else {
	di "Education or Inactive variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the education or inactive variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q32\99_industry_education_years_error.png", replace
}
	
	
***************************************
************** Occupation**************
***************************************

if sum_miss_nonmissing_occup!=1{

	graph bar (sum) counter [pw=wgt] if age_x<3  & lstatus==1, percentages  over(occup) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Occupation over time, age 15-64", size (medium)) 
	graph export "$Q33\01_A_1_occup_years.png", replace
	
	
	
	
	graph bar (sum) counter [pw=wgt] if age_x<3  & lstatus==1, percentages over(occup) over(female) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Occupation by gender, age 15-64", size (medium)) 
	graph export "$Q33\01_A_2_occup_gender_years.png", replace

	graph bar (sum) counter [pw=wgt] if age_x<3 & lstatus==1, percentages over(occup) over(age_5) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Occupation by age, age 15-64", size (medium)) 
	graph export "$Q33\01_A_2_occup_age_years.png", replace
}
else {
	di "Inactive Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the inactive variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q33\99_occup_gender_years_error.png", replace
	graph export "$Q33\99_occup_age_years_error.png", replace
}

if sum_miss_nonmissing_urb!=1 & sum_miss_nonmissing_occup!=1{
	
	graph bar (sum) counter [pw=wgt] if age_x<3  & lstatus==1, percentages over(occup)  over(urb) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall) colfirst) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Occupation by area, age 15-64", size (medium)) 
	graph export "$Q33\01_A_2_occup_urban_years.png", replace
}

else {
	di "Urban Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the urban variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q33\99_occup_urban_years_error.png", replace
}	
	
if sum_miss_nonmissing_edu!=1 & sum_miss_nonmissing_occup!=1{
	graph bar (sum) counter [pw=wgt] if age_x<3 & lstatus==1, percentages over(occup)  over(edulevelSEL, label(labsize(vsmall)angle(45))) over(year, label(labsize(small))) ///
	asyvars stack legend(size(vsmall)) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Occupation by education, age 15-64", size (medium)) 
	graph export "$Q33\01_A_2_occup_education_years.png", replace
}

else {
	di "Education or Inactive variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the education or inactive variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q33\99_occup_education_years_error.png", replace
}
	
	
		
***************************************
************** Working hours**************
***************************************

if sum_miss_nonmissing_whours!=1{

	graph hbar (mean) whours [pw=wgt] if age_x<3 & lstatus==1, bar(1, color(gs10)) over(year) blabel(group, position(base) color(gs0))  ///
	legend(size(vsmall) colfirst)  blabel(bar, position(center) size(vsmall) format(%3.1f))  /// 
	ytitle(Mean) ///
	graphregion(color(white))  title("Working hours over time, age 15-64", size (medium))
	graph export "$Q42\01_A_1_whours_years.png", replace

	
	graph hbar (mean) whours [pw=wgt] if age_x<3 & lstatus==1, bar(1, color(gs10)) over(year) over(female) blabel(group, position(base) color(gs0))  ///
	legend(size(vsmall) colfirst)  blabel(bar, position(center) size(vsmall) format(%3.1f))  /// 
	ytitle(Mean) ///
	graphregion(color(white))  title("Working hours over time and gender, age 15-64", size (medium))
	graph export "$Q42\01_A_2_whours_gender_years.png", replace

	graph hbar (mean) whours [pw=wgt] if age_x<3 & lstatus==1, bar(1, color(gs10)) over(year) over(age_x) blabel(group, position(base) color(gs0))  ///
	legend(size(vsmall) colfirst)  blabel(bar, position(center) size(vsmall) format(%3.1f))  /// 
	ytitle(Mean) ///
	graphregion(color(white))  title("Working hours over time and age, age 15-64", size (medium))
	graph export "$Q42\01_A_2_whours_age_years.png", replace
	
	
	
}
else {
	di "Inactive Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the inactive variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q42\99_whours_gender_years_error.png", replace
	graph export "$Q42\99_whours_age_years_error.png", replace
}

if sum_miss_nonmissing_whours!=1 {
	
	graph hbar (mean) whours [pw=wgt] if age_x<3 & lstatus==1, bar(1, color(gs10)) over(year) over(urb) blabel(group, position(base) color(gs0))  ///
	legend(size(vsmall) colfirst)  blabel(bar, position(center) size(vsmall) format(%3.1f))  /// 
	ytitle(Mean) ///
	graphregion(color(white))  title("Working hours over time and area, age 15-64", size (medium))
	graph export "$Q42\01_A_2_whours_urban_years.png", replace
}

else {
	di "Urban Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the urban variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q42\99_whours_urban_years_error.png", replace
}	
	
if sum_miss_nonmissing_edu!=1 & sum_miss_nonmissing_whours!=1{
	graph hbar (mean) whours [pw=wgt] if age_x<3 & lstatus==1, bar(1, color(gs10)) over(year) over(edulevelSEL) blabel(group, position(base) color(gs0))  ///
	legend(size(vsmall) colfirst)  blabel(bar, position(center) size(vsmall) format(%3.1f))  /// 
	ytitle(Mean) ///
	graphregion(color(white))  title("Working hours over time and education, age 15-64", size (medium))
	graph export "$Q42\01_A_2_whours_education_years.png", replace
}

else {
	di "Education or Inactive variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the education or inactive variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q42\99_whours_education_years_error.png", replace
}
	
		
	
	
	
****************************************************************
******************** Earnings Mean******************************
****************************************************************
	
	

	
if sum_miss_nonmissing_wages_real!=1{

	graph bar wages_monthly_real [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white)) title("Mean monthly earnings in local currency, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\01_A_1_Mean_Earnings_monthly_years.png", replace


	graph bar wages_monthly_real  [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean monthly earnings in local currency by gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\01_A_2_Mean_Earnings_monthly_gender_years.png", replace

	graph bar wages_monthly_real  [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean monthly earnings in local currency by age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\01_A_2_Mean_Earnings_monthly_age_years.png", replace
	
	graph bar wages_monthly_real  [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean monthly earnings in local currency by area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\01_A_2_Mean_Earnings_monthly_urban_years.png", replace
	
	graph bar wages_monthly_real  [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) over(industry1) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean monthly earnings in local currency by industry sector, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\01_A_2_Mean_Earnings_monthly_sector_years.png", replace
	
	graph hbar wages_monthly_real  [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) over(industry1) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean monthly earnings in local currency by industry sector and gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\01_A_3_Mean_Earnings_monthly_sector_gender_years.png", replace

	graph hbar wages_monthly_real  [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) over(industry1) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean monthly earnings in local currency by industry sector and area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\01_A_3_Mean_Earnings_monthly_sector_urb_years.png", replace
	
	graph hbar wages_monthly_real  [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) over(industry1) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean monthly earnings in local currency by industry sector and age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\01_A_3_Mean_Earnings_monthly_sector_age_years.png", replace
	
}
else {
	di "Earnings Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the inactive variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q411\99_Mean_Earnings_monthly_years_error.png", replace
	graph export "$Q411\99_Mean_Earnings_monthly_gender_years_error.png", replace
	graph export "$Q411\99_Mean_Earnings_monthly_age_years_error.png", replace
	graph export "$Q411\99_Mean_Earnings_monthly_urban_years_error.png", replace
	graph export "$Q411\99_Mean_Earnings_monthly_sector_years_error.png", replace
	graph export "$Q411\99_Mean_Earnings_monthly_sector_gender_years.png", replace
	graph export "$Q411\99_Mean_Earnings_monthly_sector_urb_years.png", replace
	graph export "$Q411\99_Mean_Earnings_monthly_sector_age_years.png", replace

}	
	
	
	
if sum_miss_nonmissing_wages_real!=1{

	graph bar wages_monthly_real [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white)) title("Mean monthly wages for workers in local currency, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\02_A_1_Mean_Wage_monthly_years.png", replace


	graph bar wages_monthly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean monthly wages for workers in local currency by gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\02_A_2_Mean_Wage_monthly_gender_years.png", replace

	graph bar wages_monthly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean monthly wages for workers in local currency by age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\02_A_2_Mean_Wage_monthly_age_years.png", replace
	
	graph bar wages_monthly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean monthly wages for workers in local currency by area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\02_A_2_Mean_Wage_monthly_urban_years.png", replace
	
	graph bar wages_monthly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean monthly wages for workers in local currency by industry sector, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\02_A_2_Mean_Wage_monthly_sector_years.png", replace
	
	graph hbar wages_monthly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean monthly wages for workers in local currency by industry sector and gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\02_A_3_Mean_Wage_monthly_sector_gender_years.png", replace
	
	graph hbar wages_monthly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean monthly wages for workers in local currency by industry sector and area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\02_A_3_Mean_Wage_monthly_sector_urban_years.png", replace
	
	graph hbar wages_monthly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean monthly wages for workers in local currency by industry sector and age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\02_A_3_Mean_Wage_monthly_sector_age_years.png", replace
}
else {
	di "Earnings Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the inactive variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q411\99_Mean_wage_monthly_years_error.png", replace
	graph export "$Q411\99_Mean_wage_monthly_gender_years_error.png", replace
	graph export "$Q411\99_Mean_wage_monthly_age_years_error.png", replace
	graph export "$Q411\99_Mean_wage_monthly_urban_years_error.png", replace
	graph export "$Q411\99_Mean_wage_monthly_sector_years_error.png", replace
	graph export "$Q411\99_Mean_wage_monthly_sector_gender_years_error.png", replace
	graph export "$Q411\99_Mean_wage_monthly_sector_urb_years_error.png", replace
	graph export "$Q411\99_Mean_wage_monthly_sector_age_years_error.png", replace

}	
	
		
if sum_miss_nonmissing_wages_hourly!=1{

	graph bar wages_hourly_real [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white)) title("Mean hourly earnings in local currency, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\03_A_1_Mean_Earnings_hourly_years.png", replace


	graph bar wages_hourly_real  [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean hourly earnings in local currency by gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\03_A_2_Mean_Earnings_hourly_gender_years.png", replace

	graph bar wages_hourly_real  [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean hourly earnings in local currency by age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\03_A_2_Mean_Earnings_hourly_age_years.png", replace
	
	graph bar wages_hourly_real  [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean hourly earnings in local currency by area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\03_A_2_Mean_Earnings_hourly_urban_years.png", replace
	
	graph bar wages_hourly_real  [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) over(industry1) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean hourly earnings in local currency by industry sector, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\03_A_2_Mean_Earnings_hourly_sector_years.png", replace
	
	graph hbar wages_hourly_real  [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) over(industry1) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean hourly earnings in local currency by industry sector and gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\03_A_3_Mean_Earnings_hourly_sector_gender_years.png", replace
	
	graph hbar wages_hourly_real  [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) over(industry1) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean hourly earnings in local currency by industry sector and area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\03_A_3_Mean_Earnings_hourly_sector_area_years.png", replace
	
	graph hbar wages_hourly_real  [pw=wgt] if age_x<3 & lstatus==1, over(year, label(labsize(small))) over(industry1) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean hourly earnings in local currency by industry sector and age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\03_A_3_Mean_Earnings_hourly_sector_age_years.png", replace
}
else {
	di "Earnings Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the earnings or working hours variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q411\99_Mean_Earnings_hourly_years_error.png", replace
	graph export "$Q411\99_Mean_Earnings_hourly_gender_years_error.png", replace
	graph export "$Q411\99_Mean_Earnings_hourly_age_years_error.png", replace
	graph export "$Q411\99_Mean_Earnings_hourly_urban_years_error.png", replace
	graph export "$Q411\99_Mean_Earnings_hourly_sector_years_error.png", replace
	graph export "$Q411\99_Mean_Earnings_hourly_sector_gender_years_error.png", replace
}	
	
	
if sum_miss_nonmissing_wages_real!=1{

	graph bar wages_hourly_real [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white)) title("Mean hourly wages for workers in local currency, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\04_A_1_Mean_Wage_hourly_years.png", replace


	graph bar wages_hourly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean hourly wages for workers in local currency by gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\04_A_2_Mean_Wage_hourly_gender_years.png", replace

	graph bar wages_hourly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean hourly wages for workers in local currency by age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\04_A_2_Mean_Wage_hourly_age_years.png", replace
	
	graph bar wages_hourly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean hourly wages for wage workers in local currency by area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\04_A_2_Mean_Wage_hourly_urban_years.png", replace
	
	graph bar wages_hourly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean hourly wages for wage workers in local currency by industry sector, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\04_A_2_Mean_Wage_hourly_sector_years.png", replace
	
	graph hbar wages_hourly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean hourly wages for wage workers in local currency by industry sector and gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\04_A_3_Mean_Wage_hourly_sector_gender_years.png", replace

	graph hbar wages_hourly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean hourly wages for wage workers in local currency by industry sector and area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\04_A_3_Mean_Wage_hourly_sector_area_years.png", replace
	
	graph hbar wages_hourly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Mean")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Mean hourly wages for wage workers in local currency by industry sector and age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q411\04_A_3_Mean_Wage_hourly_sector_age_years.png", replace
}
else {
	di "Earnings Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the earnings or working hours variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q411\99_Mean_Wage_hourly_years_error.png", replace
	graph export "$Q411\99_Mean_Wage_hourly_gender_years_error.png", replace
	graph export "$Q411\99_Mean_Wage_hourly_age_years_error.png", replace
	graph export "$Q411\99_Mean_Wage_hourly_urban_years_error.png", replace
	graph export "$Q411\99_Mean_Wage_hourly_sector_years.png", replace
	graph export "$Q411\99_Mean_Wage_hourly_sector_gender_years.png", replace
	graph export "$Q411\99_Mean_Wage_hourly_sector_age_years.png", replace
	graph export "$Q411\99_Mean_Wage_hourly_sector_urb_years.png", replace

}	



****************************************************************
******************** Earnings Median******************************
****************************************************************
	
	

	
if sum_miss_nonmissing_wages_real!=1{

	graph bar (median)    wages_monthly_real [pw=wgt] if age_x<3, over(year, label(labsize(small))) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white)) title("Median monthly earnings in local currency, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\01_A_1_Median_Earnings_monthly_years.png", replace


	graph bar (median)   wages_monthly_real  [pw=wgt] if age_x<3, over(year, label(labsize(small))) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median monthly earnings in local currency by gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\01_A_2_Median_Earnings_monthly_gender_years.png", replace

	graph bar (median)    wages_monthly_real  [pw=wgt] if age_x<3, over(year, label(labsize(small))) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median monthly earnings in local currency by age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\01_A_2_Median_Earnings_monthly_age_years.png", replace
	
	graph bar (median)  wages_monthly_real  [pw=wgt] if age_x<3, over(year, label(labsize(small))) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median monthly earnings in local currency by area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\01_A_2_Median_Earnings_monthly_urban_years.png", replace
	
	graph bar (median)  wages_monthly_real  [pw=wgt] if age_x<3, over(year, label(labsize(small))) over(industry1) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median monthly earnings in local currency by industry sector, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\01_A_2_Median_Earnings_monthly_sector_years.png", replace
	
	graph hbar (median) wages_monthly_real  [pw=wgt] if age_x<3, over(year, label(labsize(small))) over(industry1) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median monthly earnings in local currency by industry sector and gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\01_A_3_Median_Earnings_monthly_sector_gender_years.png", replace

	graph hbar (median) wages_monthly_real  [pw=wgt] if age_x<3, over(year, label(labsize(small))) over(industry1) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median monthly earnings in local currency by industry sector and area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\01_A_3_Median_Earnings_monthly_sector_urb_years.png", replace
	
	graph hbar (median) wages_monthly_real  [pw=wgt] if age_x<3, over(year, label(labsize(small))) over(industry1) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median monthly earnings in local currency by industry sector and age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\01_A_3_Median_Earnings_monthly_sector_age_years.png", replace
	
}
else {
	di "Earnings Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the inactive variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q412\99_Median_Earnings_years_error.png", replace
	graph export "$Q412\99_Median_Earnings_gender_years_error.png", replace
	graph export "$Q412\99_Median_Earnings_age_years_error.png", replace
	graph export "$Q412\99_Median_Earnings_urban_years_error.png", replace
	graph export "$Q412\99_Median_Earnings_sector_years_error.png", replace
	graph export "$Q412\99_Median_Earnings_sector_gender_years.png", replace
	graph export "$Q412\99_Median_Earnings_sector_urb_years.png", replace
	graph export "$Q412\99_Median_Earnings_sector_age_years.png", replace

}	
	
	
	
if sum_miss_nonmissing_wages_real!=1{

	graph bar (median)  wages_monthly_real [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white)) title("Median monthly wages for workers in local currency, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\02_A_1_Median_Wage_monthly_years.png", replace


	graph bar (median)  wages_monthly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median monthly wages for workers in local currency by gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\02_A_2_Median_Wage_monthly_gender_years.png", replace

	graph bar (median)  wages_monthly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median monthly wages for workers in local currency by age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\02_A_2_Median_Wage_monthly_age_years.png", replace
	
	graph bar (median)  wages_monthly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median monthly wages for workers in local currency by area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\02_A_2_Median_Wage_monthly_urban_years.png", replace
	
	graph bar (median)  wages_monthly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median monthly wages for workers in local currency by industry sector, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\02_A_2_Median_Wage_monthly_sector_years.png", replace
	
	graph hbar (median) wages_monthly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median monthly wages for workers in local currency by industry sector and gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\02_A_3_Median_Wage_monthly_sector_gender_years.png", replace
	
	graph hbar (median) wages_monthly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median monthly wages for workers in local currency by industry sector and area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\02_A_3_Median_Wage_monthly_sector_urban_years.png", replace
	
	graph hbar (median) wages_monthly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median monthly wages for workers in local currency by industry sector and age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\02_A_3_Median_Wage_monthly_sector_age_years.png", replace
}
else {
	di "Earnings Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the inactive variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q412\99_Median_wage_monthly_years_error.png", replace
	graph export "$Q412\99_Median_wage_monthly_gender_years_error.png", replace
	graph export "$Q412\99_Median_wage_monthly_age_years_error.png", replace
	graph export "$Q412\99_Median_wage_monthly_urban_years_error.png", replace
	graph export "$Q412\99_Median_wage_monthly_sector_years_error.png", replace
	graph export "$Q412\99_Median_wage_monthly_sector_gender_years_error.png", replace
	graph export "$Q412\99_Median_wage_monthly_sector_urb_years_error.png", replace
	graph export "$Q412\99_Median_wage_monthly_sector_age_years_error.png", replace

}	
	
		
if sum_miss_nonmissing_wages_hourly!=1{

	graph bar (median)  wages_hourly_real [pw=wgt] if age_x<3, over(year, label(labsize(small))) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white)) title("Median hourly earnings in local currency, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\03_A_1_Median_Earnings_hourly_years.png", replace


	graph bar (median)  wages_hourly_real  [pw=wgt] if age_x<3, over(year, label(labsize(small))) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median hourly earnings in local currency by gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\03_A_2_Median_Earnings_hourly_gender_years.png", replace

	graph bar (median)  wages_hourly_real  [pw=wgt] if age_x<3, over(year, label(labsize(small))) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median hourly earnings in local currency by age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\03_A_2_Median_Earnings_hourly_age_years.png", replace
	
	graph bar (median)  wages_hourly_real  [pw=wgt] if age_x<3, over(year, label(labsize(small))) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median hourly earnings in local currency by area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\03_A_2_Median_Earnings_hourly_urban_years.png", replace
	
	graph bar (median)  wages_hourly_real  [pw=wgt] if age_x<3, over(year, label(labsize(small))) over(industry1) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median hourly earnings in local currency by industry sector, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\03_A_2_Median_Earnings_hourly_sector_years.png", replace
	
	graph hbar (median) wages_hourly_real  [pw=wgt] if age_x<3, over(year, label(labsize(small))) over(industry1) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median hourly earnings in local currency by industry sector and gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\03_A_3_Median_Earnings_hourly_sector_gender_years.png", replace
	
	graph hbar (median) wages_hourly_real  [pw=wgt] if age_x<3, over(year, label(labsize(small))) over(industry1) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median hourly earnings in local currency by industry sector and area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\03_A_3_Median_Earnings_hourly_sector_area_years.png", replace
	
	graph hbar (median) wages_hourly_real  [pw=wgt] if age_x<3, over(year, label(labsize(small))) over(industry1) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median hourly earnings in local currency by industry sector and age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\03_A_3_Median_Earnings_hourly_sector_age_years.png", replace
}
else {
	di "Earnings Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the earnings or working hours variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q412\99_Median_Earnings_hourly_years_error.png", replace
	graph export "$Q412\99_Median_Earnings_hourly_gender_years_error.png", replace
	graph export "$Q412\99_Median_Earnings_hourly_age_years_error.png", replace
	graph export "$Q412\99_Median_Earnings_hourly_urban_years_error.png", replace
	graph export "$Q412\99_Median_Earnings_hourly_sector_years_error.png", replace
	graph export "$Q412\99_Median_Earnings_hourly_sector_gender_years_error.png", replace
}	
	
	
if sum_miss_nonmissing_wages_real!=1{

	graph bar (median)  wages_hourly_real [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white)) title("Median hourly wages for workers in local currency, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\04_A_1_Median_Wage_hourly_years.png", replace


	graph bar (median)  wages_hourly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median hourly wages for workers in local currency by gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\04_A_2_Median_Wage_hourly_gender_years.png", replace

	graph bar (median)  wages_hourly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median hourly wages for workers in local currency by age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\04_A_2_Median_Wage_hourly_age_years.png", replace
	
	graph bar (median)  wages_hourly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median hourly wages for wage workers in local currency by area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\04_A_2_Median_Wage_hourly_urban_years.png", replace
	
	graph bar (median)  wages_hourly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median hourly wages for wage workers in local currency by industry sector, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\04_A_2_Median_Wage_hourly_sector_years.png", replace
	
	graph hbar (median) wages_hourly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) over(gender) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median hourly wages for wage workers in local currency by industry sector and gender, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\04_A_3_Median_Wage_hourly_sector_gender_years.png", replace

	graph hbar (median) wages_hourly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) over(urb) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median hourly wages for wage workers in local currency by industry sector and area, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\04_A_3_Median_Wage_hourly_sector_area_years.png", replace
	
	graph hbar (median) wages_hourly_real  [pw=wgt] if age_x<3 & empstat==1, over(year, label(labsize(small))) over(industry1) over(age_x) ///
	legend(size(vsmall) colfirst) ytitle("Median")  blabel(bar, position(center) size(vsmall) format(%3.0f))  ///
	graphregion(color(white))  title("Median hourly wages for wage workers in local currency by industry sector and age, age 15-64 (2010 values)", size (vsmall)) 
	graph export "$Q412\04_A_3_Median_Wage_hourly_sector_age_years.png", replace
}
else {
	di "Earnings Variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the earnings or working hours variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q412\99_Median_hourly_wage_years_error.png", replace
	graph export "$Q412\99_Median_hourly_wage_gender_years_error.png", replace
	graph export "$Q412\99_Median_hourly_wage_age_years_error.png", replace
	graph export "$Q412\99_Median_hourly_wage_urban_years_error.png", replace
	graph export "$Q412\99_Median_hourly_wage_sector_years.png", replace
	graph export "$Q412\99_Median_hourly_wage_sector_gender_years.png", replace
	graph export "$Q412\99_Median_hourly_wage_sector_age_years.png", replace
	graph export "$Q412\99_Median_hourly_wage_sector_urb_years.png", replace

}	


	

****************************************************************
**************** Education *************************************
****************************************************************


* Distribution by highest level of education completed and age group over years

if sum_miss_nonmissing_edu!=1{


	graph bar (sum) counter [pw=wgt] if age_x<3, percentages over(edulevelSEL) over(year,  label(labsize(vsmall))) ///
	asyvars stack legend(size(vsmall)) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Highest level of education completed over years, age 15-64", size (medium)) 
	graph export "$Q34\01_A_1_Education_over_years.png", replace

	graph bar (sum) counter [pw=wgt] if age_x<3, percentages over(edulevelSEL) over(year,  label(labsize(vsmall))) over(female) ///
	asyvars stack legend(size(vsmall)) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Highest level of education completed over years by gender , age 15-64", size (medium)) 
	graph export "$Q34\01_A_2_Education_gender_over_years.png", replace


	graph bar (sum) counter [pw=wgt] if age_x<3, percentages over(edulevelSEL) over(year,  label(labsize(vsmall))) over(urb) ///
	asyvars stack legend(size(vsmall)) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Highest level of education completed over years by area, age 15-64", size (medium)) 
	graph export "$Q34\01_A_2_Education_urb_over_years.png", replace

	graph bar (sum) counter [pw=wgt] if age_x<3, percentages over(edulevelSEL) over(age_x) over(year,  label(labsize(vsmall))) ///
	asyvars stack legend(size(vsmall)) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Highest level of education completed over years by age, age 15-64", size (medium)) 
	graph export "$Q34\01_A_2_Education_age_over_years.png", replace

	graph bar (sum) counter [pw=wgt] if  age_x==1, percentages over(edulevelSEL) over(year,  label(labsize(vsmall))) over(female) ///
	asyvars stack legend(size(vsmall)) ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Highest level of education completed over years by gender, age 15-24", size (medium)) 
	graph export "$Q34\01_A_3_Education_gender_youth_over_years.png", replace
}

else {
	di "Education variable has missing values"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in the education variable ", ring(0) position(12) color(red) size(small))
	graph export "$Q34\99_Education_over_years_error.png", replace
	graph export "$Q34\99_Education_gender_over_years_error.png", replace
	graph export "$Q34\99_Education_urb_over_years_error.png", replace
	graph export "$Q34\99_Education_gender_youth_over_years_error.png", replace
	graph export "$Q34\99_Education_age_over_years_error.png", replace

}

****************************************************************
**************** Informal **************************************
****************************************************************


replace informal=. if informal==2

***** Only wage workers

preserve



g d_empstat1=1 if empstat==1
g d_empstat2=1 if empstat==2


bys year: egen nonmissing_emp1=count(d_empstat1)
bys year: egen nonmissing_emp2=count(d_empstat2)
	
bys year empstat: egen nonmissing_informal_emp=count(informal)
replace informal=. if nonmissing_emp1==0

bys year: egen nonmissing_informal=count(informal)

levels year if nonmissing_informal!=0
local nyears : word count `r(levels)'
di `nyears'

if `nyears' > 1 {


* keep only wage workers (paid)


keep if empstat==1

	
	*Figure: No Social Security Workers Among Wage Workers over years, population aged 15-64. 


	graph bar (sum) counter [pw=wgt] if age_x<3 & nonmissing_emp1!=0 & nonmissing_emp2!=0 & nonmissing_informal!=0, ///
	percentages over(informal) over(year,  label(labsize(vsmall))) ///
	showyvars ascategory asyvar stack ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f)) ///
	graphregion(color(white)) title("Informal Workers Among Wage Workers over years, age 15-64", size (small)) 
	 graph export "$Q31\06_A_01_Informal_over_years.png", replace

* Gender
	 
	graph bar (sum) counter [pw=wgt] if age_x<3 & nonmissing_emp1!=0 & nonmissing_emp2!=0 & nonmissing_informal!=0, ///
	percentages over(informal) over(year,  label(labsize(vsmall))) over(female, ) ///
	showyvars ascategory asyvar stack ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Informal workers among wage workers over years by gender, age 15-64", size (small)) 
	 graph export "$Q31\06_A_02_Informal_gender_over_years.png", replace

* Age

	graph bar (sum) counter [pw=wgt] if age_x<3 & nonmissing_emp1!=0 & nonmissing_emp2!=0 & nonmissing_informal!=0, ///
	percentages over(informal) over(year,  label(labsize(vsmall))) over(age_x, ) ///
	showyvars ascategory asyvar stack ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Informal workers among wage workers over years by age, age 15-64", size (small)) 
	graph export "$Q31\06_A_02_Informal_age_over_years.png", replace

* Age

	graph bar (sum) counter [pw=wgt] if age_x<3 & nonmissing_emp1!=0 & nonmissing_emp2!=0 & nonmissing_informal!=0, ///
	percentages over(informal) over(year,  label(labsize(vsmall))) over(urb, ) ///
	showyvars ascategory asyvar stack ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Informal workers among wage workers over years by area, age 15-64", size (small)) 
	graph export "$Q31\06_A_02_Informal_urb_over_years.png", replace	
}

else { 
	di "There is only one or less years where contract variable is available"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in contract variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q31\99_Informal_over_years_error.png", replace
	graph export "$Q31\99_Informal_over_years_gender_error.png", replace
	graph export "$Q31\99_Informal_over_years_age_error.png", replace
	graph export "$Q31\99_Informal_over_years_urb_error.png", replace

}	
	
	
	
	levels year if nonmissing_informal!=0 & sum_miss_nonmissing_edu!=0
	
local nyears : word count `r(levels)'
di `nyears'

if `nyears' > 1 {

* Education

* education is missing for some years

tab edulevelSEL year

 	
	graph bar (sum) counter [pw=wgt] if age_x<3 & nonmissing_edu!=0 & nonmissing_emp1!=0 & nonmissing_emp2!=0 & nonmissing_informal!=0, ///
	percentages over(informal) over(year,  label(labsize(vsmall))) over(edulevelSEL, label(labsize(vsmall))) ///
	showyvars ascategory asyvar stack ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Informal workers among wage workers over years by education, age 15-64", size (small)) 
	graph export "$Q31\06_A_02_Informal_edu_over_years.png", replace	

}

else { 
	di "There is only one or less years where informal and educations variables are both available"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in informal and education variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q31\99_Informal_edu_over_years_error.png", replace	
}

restore






************ All workers

preserve

g d_empstat1=1 if empstat==1
g d_empstat2=1 if empstat==2


bys year: egen nonmissing_emp1=count(d_empstat1)
bys year: egen nonmissing_emp2=count(d_empstat2)

bys year empstat: egen nonmissing_informal_emp=count(informal)
*replace informal=. if nonmissing_emp1==0

bys year: egen nonmissing_informal=count(informal)








levels year if nonmissing_informal!=0
local nyears : word count `r(levels)'
di `nyears'

if `nyears' > 1 {
	
	*Figure: No Social Security Workers (All Workers) over years, population aged 15-64. 

	

	graph bar (sum) counter [pw=wgt] if age_x<3 & nonmissing_emp1!=0 & nonmissing_emp2!=0 & nonmissing_informal!=0, ///
	percentages over(informal) over(year,  label(labsize(vsmall))) ///
	showyvars ascategory asyvar stack ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Informal workers over years, age 15-64", size (medium)) 
	 graph export "$Q31\07_A_01_Informal_all_over_years.png", replace

* Gender
	 
	graph bar (sum) counter [pw=wgt] if age_x<3 & nonmissing_emp1!=0 & nonmissing_emp2!=0 & nonmissing_informal!=0, ///
	percentages over(informal) over(year,  label(labsize(vsmall))) over(female, ) ///
	showyvars ascategory asyvar stack ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Informal workers over years by gender, age 15-64", size (medium)) 
	 graph export "$Q31\07_A_02_Informal_gender_all_over_years.png", replace

* Age

	graph bar (sum) counter [pw=wgt] if age_x<3 & nonmissing_emp1!=0 & nonmissing_emp2!=0 & nonmissing_informal!=0, ///
	percentages over(informal) over(year,  label(labsize(vsmall))) over(age_x, ) ///
	showyvars ascategory asyvar stack ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Informal workers over years by age, age 15-64", size (medium)) 
	graph export "$Q31\07_A_02_Informal_age_all_over_years.png", replace
	
	

* Urb

	graph bar (sum) counter [pw=wgt] if age_x<3 & nonmissing_emp1!=0 & nonmissing_emp2!=0 & nonmissing_informal!=0, ///
	percentages over(informal) over(year,  label(labsize(vsmall))) over(urb, ) ///
	showyvars ascategory asyvar stack ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Informal workers over years by area, age 15-64", size (medium)) 
	graph export "$Q31\07_A_02_Informal_urb_all_over_years.png", replace	
}

else { 
	di "There is only one or less years where informal variable is available"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in informal variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q31\99_Informal_all_over_years_error.png", replace
	graph export "$Q31\99_Informal_gender_all_over_years_error.png", replace
	graph export "$Q31\99_Informal_age_all_over_years_error.png", replace
	graph export "$Q31\99_Informal_urb_all_over_years_error.png", replace	

}	
	
	
	
levels year if nonmissing_informal!=0 & sum_miss_nonmissing_edu!=1
	
local nyears : word count `r(levels)'
di `nyears'

if `nyears' > 1 {

* Education

* education is missing for some years

 	
 graph bar (sum) counter [pw=wgt] if age_x<3 & nonmissing_emp1!=0 & nonmissing_emp2!=0 & nonmissing_informal!=0, ///
	percentages over(informal) over(year,  label(labsize(vsmall))) over(edulevelSEL, label(labsize(vsmall))) ///
	showyvars ascategory asyvar stack ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Informal workers over years by education, age 15-64", size (medium)) 
	graph export "$Q31\07_A_02_Informal_edu_all_over_years.png", replace	

}

else { 
	di "There is only one or less years where informal and educations variables are both available"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in informal or education variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q31\99_Informal_edu_all_over_years_error.png", replace	
}



restore


************************************************************************************************************************
*  var used: contract
************************************************************************************************************************



preserve


g d_empstat1=1 if empstat==1
g d_empstat2=1 if empstat==2


bys year: egen nonmissing_emp1=count(d_empstat1)
bys year: egen nonmissing_emp2=count(d_empstat2)

replace contract=. if nonmissing_emp1==0


levels year if sum_miss_nonmissing_contract!=1
local nyears : word count `r(levels)'
di `nyears'

if `nyears' > 1 {


	*Figure:	No Contract Workers (All Workers) over years, population aged 15-64. 


	graph bar (sum) counter [pw=wgt] if age_x<3 & nonmissing_emp1!=0 & nonmissing_emp2!=0 , ///
	percentages over(no_contract) over(year,  label(labsize(vsmall))) ///
	showyvars ascategory asyvar stack ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Workers without contract over years, age 15-64", size (medium)) 
	graph export "$Q31\08_A_1_Nocontract_all_over_years.png", replace

* Gender	
	graph bar (sum) counter [pw=wgt] if age_x<3 & nonmissing_emp1!=0 & nonmissing_emp2!=0 , ///
	percentages over(no_contract) over(year,  label(labsize(vsmall))) over(female, ) ///
	showyvars ascategory asyvar stack ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Workers without contract over years by gender, age 15-64", size (medium)) 
	graph export "$Q31\08_A_2_Nocontract_gender_all_over_years.png", replace

* Age

	graph bar (sum) counter [pw=wgt] if age_x<3 & nonmissing_emp1!=0 & nonmissing_emp2!=0 , ///
	percentages over(no_contract) over(year,  label(labsize(vsmall))) over(age_x, ) ///
	showyvars ascategory asyvar stack ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
	graphregion(color(white)) title("Workers without contract over years by age, age 15-64", size (medium)) 
	graph export "$Q31\08_A_2_Nocontract_age_all_over_years.png", replace
}
else { 
	di "There is only one or less years where contract variable is available"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in contract variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q31\99_Nocontract_all_over_years_error.png", replace
	graph export "$Q31\99_Nocontract_gender_all_over_years_error.png", replace
	graph export "$Q31\99_Nocontract_age_all_over_years_error.png", replace
}
		



levels year if sum_miss_nonmissing_contract!=0 & sum_miss_nonmissing_edu!=1
local nyears : word count `r(levels)'
di `nyears'

if `nyears' > 1 {
	
	graph bar (sum) counter [pw=wgt] if age_x<3  & nonmissing_emp1!=0 & nonmissing_emp2!=0 , ///
	percentages over(no_contract) over(year,  label(labsize(vsmall))) over(edulevelSEL, label(labsize(vsmall))) ///
	showyvars ascategory asyvar stack ytitle("")  blabel(bar, position(center) size(vsmall) format(%3.1f)) ///
	graphregion(color(white)) title("Workers without contract over years by education, age 15-64", size (medium)) 
	graph export "$Q31\08_A_2_Nocontract_edu_all_over_years.png", replace	

}
else { 
	di "There is only one or less years where contract and education variables are both available"
	graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in contract and education variable in in one of the years ", ring(0) position(12) color(red) size(small))
	graph export "$Q31\99_Nocontract_edu_all_over_years_error.png", replace	
}



levels year if sum_miss_nonmissing_contract!=0 & sum_miss_nonmissing_urb!=1
local nyears : word count `r(levels)'
di `nyears'

if `nyears' > 1 {
	
		graph bar (sum) counter [pw=wgt] if age_x<3  & nonmissing_emp1!=0 & nonmissing_emp2!=0 , ///
		percentages over(no_contract,  label(labsize(vsmall))) over(year,  label(labsize(vsmall))) over(urb) ///
		showyvars ascategory asyvar stack ytitle("") ylabel(,angle(45))  blabel(bar, position(center) size(vsmall) format(%3.1f))  ///
		graphregion(color(white)) title("Workers without contract  by gender over years by area, age 15-64", size (medium)) 
		graph export "$Q31\08_A_2_Nocontract_urb_all_over_years.png", replace
		

}
else { 
		di "There is only one or less years where contract and urban variables are both available"
		graph pie error, pie(1, explode color(black)) title ("This graph could not be produced due to missing values in contract and urban variable in in one of the years ", ring(0) position(12) color(red) size(small))
		graph export "$Q31\99_Nocontract_urb_all_over_years_error.png", replace	
}

restore
}

else{
cd "$ado"
}

cap drop year_dummy

cd "$ado"

}

dis "", _newline(8)
dis as result `" All figures have now been created and can be found in the "Question 2/3/4 folder" "'
dis as result `" You can continue creating the Indicators or Regressions by typing Indicator or Regressions, respectively"'



end
