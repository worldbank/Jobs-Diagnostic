program Indicator
version 14.2


dis "",  _newline(8)



dis as result `" The indicator file is now being prepared. Please wait until a message tells you that the process is completed. "'


local date : dis %td_CCYYNNDD date(c(current_date), "DMY")



quietly {

set varabbrev off

use "$data/I2D2_test_$y.dta", clear
count
local full_sample `r(N)'

*Defining Globals for Each Country Folders:

global data "$user\\$y\Data"
global graph "$user\\$y\JDLT_`date'\"
global indicators "$user\\$y\JDLT_`date'\Question 1 - Jobs and workers profile"
global regressions "$user/$y/JDLT_`date'/Question 5 - Worker characteristics and LM outcomes"
global condALL   age>=15 & age<=64
global noCondALL age<15 & age>64	

set more off
	 

********************************************************
**************** Create the Worksplit Sheet ************
********************************************************
***************************************************************************************************************************************************************************		
		
		
*** Basics LM indicators


	gen byte sh_wap_	 = (age>=15 & age<=64) if age!=.

	label var sh_wap_ " Working Age Population"
	la de sh_wap_  0 "Not working age (0-14 or 65+)" 1 "Working age (15-64)"
	la val sh_wap_ sh_wap_

	drop if sh_wap_==.


** Sector 
	gen byte sh_agr_ = (industry==1) 												if lstatus==1 & $condALL 	& industry!=.
	label var sh_agr_ " Agriculture (15-64)"




	gen byte sh_non_wap_	 = 0 if sh_wap_==1 
	replace sh_non_wap_		 = 1 if sh_wap_==0 

	label var sh_non_wap_ " Non-Working Age Population"
	la de sh_non_wap_  0 "Working age (15-64)" 1 "Not working age (0-14 or 65+)"
	la val sh_non_wap_ sh_non_wap_


	gen byte sh_empr_all			= (lstatus==1)  if $condALL & lstatus!=.
	gen byte sh_unempr_all			= (lstatus==2)  if $condALL & lstatus!=.
	gen byte sh_inact_all 			= (lstatus==3)  if $condALL & lstatus!=.
	gen byte sh_no_agr				= (sh_agr_==0)  if $condALL & industry!=.

	gen byte sh_wage_agri 			= (empstat==1)  if lstatus==1 & $condALL & empstat<=4 & industry==1 & industry!=. & lstatus!=.
	gen byte sh_wage_non_agri 		= (empstat==1)  if lstatus==1 & $condALL & empstat<=4 & industry!=1 & industry!=. & lstatus!=.
	gen byte sh_unpaid_agri			= (empstat==2)  if lstatus==1 & $condALL & empstat<=4 & industry==1 & industry!=. & lstatus!=.
	gen byte sh_unpaid_non_agri		= (empstat==2)  if lstatus==1 & $condALL & empstat<=4 & industry!=1 & industry!=. & lstatus!=.
	gen byte sh_emps_agri	    	= (empstat==3)  if lstatus==1 & $condALL & empstat<=4 & industry==1 & industry!=. & lstatus!=.
	gen byte sh_emps_non_agri   	= (empstat==3)  if lstatus==1 & $condALL & empstat<=4 & industry!=1 & industry!=. & lstatus!=.
	gen byte sh_self_agri	    	= (empstat==4)  if lstatus==1 & $condALL & empstat<=4 & industry==1 & industry!=. & lstatus!=.
	gen byte sh_self_non_agri		= (empstat==4)  if lstatus==1 & $condALL & empstat<=4 & industry!=1 & industry!=. & lstatus!=.
	gen byte sh_formal_wage_nonag	= (informal==0) if lstatus==1 & $condALL & sh_wage_non_agri==1 & empstat<=4 & informal<=1 & lstatus!=.
	gen byte sh_informal_wage_nonag = (informal==1) if lstatus==1 & $condALL & sh_wage_non_agri==1 & empstat<=4 & informal<=1 & lstatus!=.
	gen byte sh_public_wage_nonag	= (ocusec==1)	if lstatus==1 & $condALL & sh_formal_wage_nonag==1 & empstat<=4 & informal<=1 & lstatus!=. & ocusec<=2
	gen byte sh_private_wage_nonag	= (ocusec==2)	if lstatus==1 & $condALL & sh_formal_wage_nonag==1 & empstat<=4 & informal<=1 & lstatus!=. & ocusec<=2

	
	
	label var sh_empr_all				"Employed (15-64)"
	label var sh_unempr_all				"Unemployed (15-64)"
	label var sh_inact_all				"Inactive (15-64)"
	label var sh_no_agr					"Non-agriculture (15-64)"
	label var sh_wage_agri 				"Agricultural wage employees (15-64)"
	label var sh_unpaid_agri 			"Agricultural unpaid (15-64)"
	label var sh_emps_agri				"Agricultural employers (15-64)" 
	label var sh_self_agri 				"Agricultural self-employed (15-64)"
	label var sh_wage_non_agri 			"Non-agricultural wage employees (15-64)"
	label var sh_unpaid_non_agri 		"Non-agricultural unpaid (15-64)"
	label var sh_emps_non_agri			"Non-agricultural employers (15-64)" 
	label var sh_self_non_agri 			"Non-agricultural self-employed (15-64)"
	label var sh_formal_wage_nonag  	"Non-agricultural wage employees in formal work"
	label var sh_informal_wage_nonag 	"Non-agricultural wage employees in informal work"
	label var sh_public_wage_nonag 		"Non-agricultural wage employees in formal and public  sector work"
	label var sh_private_wage_nonag		"Non-agricultural wage employees in formal and private sector work"
	
	gen no_pop_=1
	label var no_pop_ "Total population"
	

	
keep countryname year  sample1 no_pop_  sh_wap_ sh_non_wap_ sh_empr_all sh_unempr_all sh_inact_all sh_agr_ sh_no_agr sh_wage_agri sh_wage_non_agri sh_unpaid_agri sh_unpaid_non_agri sh_emps_agri sh_emps_non_agri sh_self_agri sh_self_non_agri sh_formal_wage_nonag sh_informal_wage_nonag sh_public_wage_nonag sh_private_wage_nonag wgt


gen sample_type=.
label var sample_type "Sample type"

gen sample_size=.
label var sample_size "Sample size"



local shares1 "countryname  year sample1 sample_type sample_size no_pop_ sh_wap_ sh_non_wap_ sh_empr_all sh_unempr_all sh_inact_all sh_agr_ sh_no_agr sh_wage_agri sh_unpaid_agri sh_emps_agri sh_self_agri sh_wage_non_agri   sh_unpaid_non_agri sh_emps_non_agri  sh_self_non_agri sh_formal_wage_nonag sh_informal_wage_nonag sh_public_wage_nonag sh_private_wage_nonag"
foreach x in `shares1'{
local l`x' : variable label `x' 
}


collapse (count) no_pop_ (mean) sh_* [pw=wgt], by (countryname year sample1)

gen sample_type=.
label var sample_type "Sample type"

gen sample_size=.
label var sample_size "Sample size"





foreach x in `shares1'{
label var `x' "`l`x''" 
}	
	order `shares1'
	


putexcel set "$indicators\Indicators_`date'",  sheet(0_Worksplit) replace
putexcel describe	
	
putexcel A1="Meta-Data"
putexcel A1:E1, merge hcenter vcenter txtwrap border(all) fpattern(solid, lightyellow )

putexcel F1="Population size", hcenter vcenter txtwrap border(all) fpattern(solid, yellow)

putexcel G1="Labor Force and Employment"
putexcel G1:K1, merge hcenter vcenter txtwrap border(all) fpattern(solid, green)
	
putexcel L1="Sectors"
putexcel L1:M1, merge hcenter vcenter txtwrap border(all) fpattern(solid, blue)

putexcel N1="Employment Types"
putexcel N1:U1, merge hcenter vcenter txtwrap border(all) fpattern(solid, orange)		
	
putexcel V1="Informal work"
putexcel V1:W1, merge hcenter vcenter txtwrap border(all) fpattern(solid, red)		

putexcel X1="Public sector"
putexcel X1:Y1, merge hcenter vcenter txtwrap border(all) fpattern(solid, purple)	

label var sample1 "Survey Data Source"
	
local excel=1

foreach var in `shares1'{
excelcol `excel' 
local colname `r(column)'
local p : variable label `var'
putexcel `colname'2="`p'", txtwrap overwrite
local ++excel
}
	

count
local y=r(N)
local row=3			  

tabstat  no_pop_, by(year) save
forval z=1/`y'	{ 
matrix define pop_no`z'=r(Stat`z')
}

tabstat sh_wap_ sh_non_wap_ sh_empr_all sh_unempr_all sh_inact_all sh_agr_ sh_no_agr sh_wage_agri sh_unpaid_agri sh_emps_agri sh_self_agri sh_wage_non_agri   sh_unpaid_non_agri sh_emps_non_agri  sh_self_non_agri sh_formal_wage_nonag sh_informal_wage_nonag sh_public_wage_nonag sh_private_wage_nonag, by(sample1) save


forval z=1/`y'	{ 
matrix define pop`z'=r(Stat`z')
}
	

forval z=1/`y'	{
putexcel F`row'=matrix(pop_no`z'), nformat(number_sep)
putexcel G`row'=matrix(pop`z'), nformat(percent_d2)
local ++row
}	

local row=3		  


levels sample1
foreach lev in `r(levels)'{
use "$data/I2D2_test_${y}_red.dta", clear
keep if sample1=="`lev'"
putexcel A`row'=countryname
putexcel B`row'=year    
putexcel C`row'=sample1 
putexcel D`row'=sample_type
putexcel E`row'=sample_size
local ++row
}	
	
	
	
	
	
	
	
	
	
	
	
	
	

*****************************************************************************
************* Creation of the Indicator Sheet for all and subgroups**********
***************************************************************************** 

use "$data/I2D2_test_$y.dta", clear



** NLFE
gen NLFE=lstatus  if age_x==1
replace NLFE=4 if lstatus==3 & atschool!=1 & age_x==1
		
label de NLFE 1 "Employed" 2 "Unemployed" 3 "Inactive but in Education" 4 "Inactive and not in Education (or unknown)", replace
lab val NLFE NLFE
label var NLFE "Not in Labor Force or Education"
		
*** Basics LM indicators

* Socio-Demographics
	gen no_pop_=1
	label var no_pop_ "Total population"

	gen byte sh_child_   = (age < 15) if age!=.
	gen byte sh_youth_   = (age >= 15 & age < 25) if age!=.
	gen byte sh_adult_ 	 = (age >= 25 & age < 65) if age!=.
	gen byte sh_elderly_ = (age >= 65) if age!=.
	gen byte sh_urb_	 = (urb==1)   
	gen byte sh_wap_	 = (age>=15 & age<=64) if age!=.

	label var sh_child_ "Children, aged 0-14"
	la de sh_child_ 1 "Child (0-14)" 0 "Non-Child (15+)", replace
	lab val sh_child_ sh_child_

	label var sh_youth_ "Youth, aged 15-24"
	la de sh_youth_ 1 "Youth (15-24)" 0 "Non-Youth (0-14, 25+)", replace
	lab val sh_youth_ sh_youth_

	la de sh_adult_ 1 "Adult (25-64)" 0 "Non-Adult (15-24)", replace
	label var sh_adult_ "Adult, aged 25-64"
	lab val sh_adult_ sh_adult_

	label var sh_elderly_ "Elderly, aged 65+"
	la de sh_elderly_  0 "Not elderly (0-59)" 1 "Elderly (60+)", replace
	lab val sh_elderly_ sh_elderly_

	label var sh_urb_ "Urban Population (% of total Population)"
	la de sh_urb_ 0 "Rural area" 1 "Urban area"
	la val sh_urb_ sh_urb_

	label var sh_wap_ " Working Age Population, aged 15-64 (% of total Pop.)"
	la de sh_wap_  0 "Not working age (0-14 or 65+)" 1 "Working age (15-64)"
	la val sh_wap_ sh_wap_



* Labor

** Labor Force
* Absolute numbers
	gen no_lf_numb=1 if (lstatus==1 | lstatus==2) & age_x<3

* Shares
	gen byte sh_lf_ 			= (lstatus==1 | lstatus==2) if lstatus!=. & $condALL
	egen agemin= total(age<=14) if age !=., 			by(ccode year sample1) 
	egen agemax= total(age >=65) if age !=., 			by(ccode year sample1) 
	egen ageint= total(age>=15 | age<=64) if age !=., 	by(ccode year sample1) 
	gen sh_dependency=((agemin+agemax)/ageint)
	gen sh_dependency_youth=(agemin/ageint)
	gen sh_dependency_old  =(agemax/ageint)
	gen byte sh_lf_fem 	 		= (lstatus<=2) if lstatus!=. & $condALL & gender==2
	gen byte sh_empl_ 			= (lstatus == 1) if lstatus!=. & $condALL
	gen byte sh_empr_all 			= (lstatus==1) if lstatus<=2 & $condALL
	gen byte sh_empr_young 		= (lstatus==1) if lstatus<=2 & $condALL & age_x==1
	gen byte sh_unempr_all 		= (lstatus==2) if lstatus<=2 & $condALL
	gen byte sh_unempr_young 	= (lstatus==2) if lstatus<=2 & $condALL  & age_x==1
	gen byte sh_nlfe_young		= (NLFE==4)    if $condALL   & lstatus!=. & age_x==1
	
	

	la var no_lf_numb			"Labor Force, aged 15-64"
	la var sh_dependency		"Dependency Rate, all compared to 15-64"
	la var sh_dependency_youth 	"Youth Dependency Rate, younger than 15 compared to 15-64"
	la var sh_dependency_old	"Old Age Dependency Rate, older than 64 compared to 15-64"
	label var sh_lf_ 			"Labor Force Participation Rate, aged 15-64"
	label var sh_lf_fem 		"Female Labor Force Participation Rate, aged 15-64"
	label var sh_empr_young 	"Youth Employment Rate, aged 15-24"
	label var sh_empl_ 			"Employment to Population Ratio, aged 15-64"
	label var sh_empr_all 		"Employment Rate, aged 15-64 "
	label var sh_unempr_all 	"Unemployment Rate, aged 15-64"
	label var sh_unempr_young 	"Youth Unemployment Rate, aged 15-24"
	label var sh_nlfe_young		"Not in labor force or education rate among youth, aged 15-24"
	

	
** Employment Type
	gen byte sh_wage_ =1  					if lstatus==1 	 	& $condALL & empstat!=. & empstat==1 		
	replace sh_wage_  =0  					if lstatus==1 	 	& $condALL & empstat!=. & empstat!=1 
	gen byte sh_unpaid_ =1 					if lstatus==1 	 	& $condALL & empstat!=. & empstat==2 		
	replace sh_unpaid_  =0 					if lstatus==1 	 	& $condALL & empstat!=. & empstat!=2 
	gen byte sh_emps_ =1  					if lstatus==1 	 	& $condALL & empstat!=. & empstat==3 		
	replace sh_emps_  =0  					if lstatus==1 	 	& $condALL & empstat!=. & empstat!=3 
	gen byte sh_self_ =1  					if lstatus==1 	 	& $condALL & empstat!=. & empstat==4 		
	replace sh_self_  =0  					if lstatus==1 	 	& $condALL & empstat!=. & empstat!=4 
	gen byte sh_missing__ = .			 	if lstatus==1  		& $condALL & empstat==. 
	gen byte sh_pub_ = 1  					if lstatus==1 		& $condALL & ocusec<3 & ocusec==1 
	replace sh_pub_ = 0  					if lstatus==1 		& $condALL & ocusec<3 & ocusec!=1 
	gen byte sh_notclass_ = .  

	gen byte sh_informal_ = (informal==1) if lstatus==1 & $condALL 	
	gen byte sh_formal_ = (informal==0) if lstatus==1  	& $condALL 		
	gen byte sh_formal_miss_ = 0		if lstatus==1 	& $condALL
	replace  sh_formal_miss_ = 1 		if lstatus==1	& $condALL 	& informal>1
	
	gen byte sh_secondary=njobs			if lstatus==1	& $condALL 	
	
	label var sh_wage_ 		"Wage employees, aged 15-64 "
	label var sh_unpaid_ 	"Unpaid, aged 15-64"
	label var sh_emps_		"Employers, aged 15-64" 
	label var sh_self_ 		"Self-employed, aged 15-64"
	label var sh_notclass_  " Other workers, aged 15-64"
	label var sh_missing__  " missing - employment status-"
	label var sh_pub_ 			"Public sector employment, aged 15-64"
	label var sh_informal_ 	 	"Informal jobs, aged 15-64"
	label var sh_formal_ 		"Formal jobs, aged 15-64"
	label var sh_formal_miss_ 	"Employed with missing formality information, aged 15-64"
	label var sh_secondary		"Share of workers (aged 15-64) with more than one jobs in last week"

	

	
** Sector 
	gen byte sh_agr_ = (industry==1) 													if lstatus==1 & $condALL 	& industry!=.
	gen byte sh_ind_ = (industry==3 | industry==4 |  industry==5 | industry==2) 		if lstatus==1 & $condALL 	& industry!=.
	gen byte sh_serv_ = ((industry>=6 & industry<=10)) 									if lstatus==1 & $condALL 	& industry!=.
	gen byte sh_ind_miss_ = (industry==.) 												if lstatus==1 & $condALL 	
	gen byte sh_nonagr_women= (industry!=1) 											if lstatus==1 & $condALL 	& industry!=. & gender==2
	gen byte sh_nonagr_youth= (industry!=1) 											if lstatus==1 & $condALL 	& industry!=. & age_x==1


	
	label var sh_agr_ " Agriculture, aged 15-64"
	label var sh_nonagr_women " Female in non-agricultural employment, aged 15-64"	
	label var sh_nonagr_youth "Youth in non-agricultural employment, aged 15-64"
	label var sh_ind_ " Industry, aged 15-64"
	label var sh_serv_ " Services, aged 15-64"
	label var sh_ind_miss_ "Missing industry, aged 15-64"
	


** Sector, detail
	gen byte sh_agr_det     = (industry==1) 											  if lstatus==1 & $condALL & industry!=.
	gen byte sh_ind_min 	= (industry==2)				 							 	  if lstatus==1 & $condALL & industry!=.
	gen byte sh_ind_manu    = (industry==3) 											  if lstatus==1 & $condALL & industry!=.
	gen byte sh_ind_pub 	= (industry==4) 							 				  if lstatus==1 & $condALL & industry!=.
	gen byte sh_ind_cons    = (industry==5) 											  if lstatus==1 & $condALL & industry!=.
	gen byte sh_serv_com    = (industry==6) 											  if lstatus==1 & $condALL & industry!=.
	gen byte sh_serv_trans  = (industry==7) 											  if lstatus==1 & $condALL & industry!=.
	gen byte sh_serv_fbs    = (industry==8)												  if lstatus==1 & $condALL & industry!=.
	gen byte sh_serv_pa     = (industry==9)												  if lstatus==1 & $condALL & industry!=.
	gen byte sh_serv_rest   = (industry==10)				  							  if lstatus==1 & $condALL & industry!=.

	
	
	label var sh_agr_det    " Agriculture, aged 15-64"
	label var sh_ind_min    " Mining and Public Utilities, aged 15-64"
	label var sh_ind_manu   " Manufacturing, aged 15-64"
	label var sh_ind_pub	" Public utilities, aged 15-64"
	label var sh_ind_cons   " Construction, aged 15-64"
	label var sh_serv_com   " Commerce, aged 15-64"
	label var sh_serv_trans "Transport & Communication, aged 15-64"
	label var sh_serv_fbs 	"Financial and Business Services, aged 15-64"
	label var sh_serv_pa 	"Public Administration, aged 15-64"
	label var sh_serv_rest  " Other services, aged 15-64"


** Occupation

		
gen byte sh_occup_senior_ =1 		if lstatus==1  & $condALL  & occup!=. & occup==1
replace sh_occup_senior_  =0  		if lstatus==1  & $condALL  & occup!=. & occup!=1
gen byte sh_occup_prof_	  =1  		if lstatus==1  & $condALL  & occup!=. & occup==2
replace sh_occup_prof_	  =0  		if lstatus==1  & $condALL  & occup!=. & occup!=2
gen byte sh_occup_techn_  =1  		if lstatus==1  & $condALL  & occup!=. & occup==3
replace sh_occup_techn_	  =0  		if lstatus==1  & $condALL  & occup!=. & occup!=3		
gen byte sh_occup_clerk_  =1  		if lstatus==1  & $condALL  & occup!=. & occup==4
replace sh_occup_clerk_	  =0  		if lstatus==1  & $condALL  & occup!=. & occup!=4
gen byte sh_occup_servi_  =1  		if lstatus==1  & $condALL  & occup!=. & occup==5
replace sh_occup_servi_	  =0  		if lstatus==1  & $condALL  & occup!=. & occup!=5	
gen byte sh_occup_skillagr_	 =1  	if lstatus==1  & $condALL  & occup!=. & occup==6
replace sh_occup_skillagr_	 =0  	if lstatus==1  & $condALL  & occup!=. & occup!=6		
gen byte sh_occup_craft_	 =1  	if lstatus==1  & $condALL  & occup!=. & occup==7
replace sh_occup_craft_	     =0		if lstatus==1  & $condALL  & occup!=. & occup!=7
gen byte sh_occup_machi_	 =1  	if lstatus==1  & $condALL  & occup!=. & occup==8
replace sh_occup_machi_	     =0		if lstatus==1  & $condALL  & occup!=. & occup!=8
gen byte sh_occup_eleme_	 =1  	if lstatus==1  & $condALL  & occup!=. & occup==9
replace sh_occup_eleme_	     =0 	if lstatus==1  & $condALL  & occup!=. & occup!=9	
gen byte sh_occup_armed_	 =1  	if lstatus==1  & $condALL  & occup!=. & occup==10
replace sh_occup_armed_	     =0		if lstatus==1  & $condALL  & occup!=. & occup!=10	
		

	label var sh_occup_senior_		" Senior Officials, aged 15-64" 
	label var sh_occup_prof_		" Professionals, aged 15-64"
	label var sh_occup_techn_		" Technicians, aged 15-64"
	label var sh_occup_clerk_		" Clerks, aged 15-64"
	label var sh_occup_servi_		" Service and Market Sales, aged 15-64"
	label var sh_occup_skillagr_	" Skilled Agriculture, aged 15-64"
	label var sh_occup_craft_		" Craft Workers, aged 15-64"
	label var sh_occup_machi_		" Machine Operators, aged 15-64"
	label var sh_occup_eleme_		" Elementary Occupations, aged 15-64"
	label var sh_occup_armed_		" Armed Forces"




* Working hours

	bys ccode year sample1: egen byte mean_hours_=mean(whours) if whours!=. & whours !=0 & lstatus==1 & $condALL
	gen sh_excemp=0 			if whours!=.  & whours !=0 & lstatus==1 & $condALL
	replace sh_excemp=1 		if whours>48 & whours!=. & whours !=0 & lstatus==1 & $condALL
		
	gen 	sh_underemp=0  		if whours!=.  & whours !=0 & lstatus==1 & $condALL
	replace sh_underemp=1  		if whours<35  & whours !=0 & lstatus==1 & $condALL
	
	
	label var mean_hours_ 		"Average weekly working hours"
	label var sh_excemp   		"Excessive working hours,>48 hours per week"
	label var sh_underemp 		"Underemployment, <35 hours per week"

	
* Earnings
		
** Setup
	
	gen 	wages_hourly_def=hourly_wages					if empstat==1 & age>=15 & age<=64
	gen 	wages_monthly_def=wage_monthly		 			if empstat==1 & age>=15 & age<=64

	sort ccode year
	merge ccode year using   "$user\\$y\Data\wbopendata.dta"  // Note that this has all PPP values adjusted to 2010 in the merged database. This would need to be redone in case of change!
	keep if _merge==3  
	drop _merge	
	
	gen CPI_deflator=fp_cpi_totl/100
	label var CPI_deflator "CPI Deflator"

	gen wage_real=wage/CPI_deflator if wage>0 & wage!=.  & age>=15 & age<=64
	label var wage_real "Wage earnings, constant 2010 values" 

	
** Setup real wage
	gen 	weekly_wage_real=wage_real 		if unitwage==2 	& 	wage_real >=0 & wage_real!=.
	replace weekly_wage_real=wage_real/2  	if unitwage==3  &   wage_real >=0 & wage_real!=.
	replace weekly_wage_real=wage_real/9	if unitwage==4  &   wage_real >=0 & wage_real!=.
	replace weekly_wage_real=wage_real/4.2 	if unitwage==5 	& 	wage_real >=0 & wage_real!=.
	replace weekly_wage_real=wage_real/12 	if unitwage==6  &   wage_real >=0 & wage_real!=.
	replace weekly_wage_real=wage_real/52 	if unitwage==8 	&   wage_real >=0 & wage_real!=.
	replace weekly_wage_real=wage_real*40 	if unitwage==9  &   wage_real >=0 & wage_real!=.

	gen hourly_wages_real=.
	replace hourly_wages_real=weekly_wage_real/whours   if whours!=. & whours!=0
	replace hourly_wages_real=wage_real if unitwage==9 
	replace hourly_wages_real=. if hourly_wages_real<0 | hourly_wages_real==0

	gen wage_monthly_real=weekly_wage_real * 4.2
	
	gen 	wages_hourly_def_real=hourly_wages_real			if empstat==1 & $condALL
	gen 	wages_monthly_def_real=wage_monthly_real		if empstat==1 & $condALL

		
	winsor2 wages_hourly_def_real, cuts(1 99) by(sample1) replace
	winsor2 wages_monthly_def_real, cuts(1 99) by(sample1) replace
	
		
	gen wages_monthly_def_agri=wages_monthly_def	if industry==1 & industry!=.
	gen wages_monthly_def_indu=wages_monthly_def	if (industry==3 | industry==4 |  industry==5 | industry==2) & industry!=.
	gen wages_monthly_def_serv=wages_monthly_def	if ((industry>=6 & industry<=10))  & industry!=.
	
	label var wages_hourly_def 				"Median Earnings for wage workers per hour, local nominal currency"
	label var wages_monthly_def 			"Median Earnings for wage workers per month, local nominal currency"
	label var wages_hourly_def_real 		"Median Earnings for wage workers per hour,  deflated to 2010  local currency values"
	label var wages_monthly_def_real 		"Median Earnings for wage workers per month, deflated to 2010 local currency values"
	label var wages_monthly_def_agri		"Median Earnings for wage workers per month in agriculture, local nominal currency"
	label var wages_monthly_def_indu		"Median Earnings for wage workers per month in industry, local nominal currency"
	label var wages_monthly_def_serv		"Median Earnings for wage workers per month in service, local nominal currency"

	
	* Generate PPP
	gen 	wages_hourly_usd=.						 				
	gen 	wages_monthly_usd=.
	

	levelsof ccode 
	foreach x in `r(levels)'{	
	replace wages_hourly_usd=wages_hourly_def_real/ppp	 	if ccode=="`x'" & empstat==1
	replace wages_monthly_usd=wages_monthly_def_real/ppp		if ccode=="`x'" & empstat==1 
	}
	
	label var wages_hourly_usd  "Real Median Hourly  Wages in USD (base 2010), PPP adjusted"
	label var wages_monthly_usd "Real Median Monthly Wages in USD (base 2010), PPP adjusted"
	
	
	
	
* Skills	
** Education	

	gen byte sh_no_educ = (edulevelSEL==1) 		if edulevel2<5 & $condALL
	gen byte sh_prim_educ = (edulevelSEL==2) 	if edulevel2<5 & $condALL
	gen byte sh_sec_educ = (edulevelSEL==3) 		if edulevel2<5 & $condALL
	gen byte sh_postsec_educ = (edulevelSEL==4) 	if edulevel2<5 & $condALL

	label var sh_no_educ " No Education"
	label var sh_prim_educ " Primary Education" 
	label var sh_sec_educ " Secondary Education"
	label var sh_postsec_educ " Post Secondary Education"	
	

	capture replace countryname="Mozambique" if ccode=="MOZ"
	capture replace countryname="Uganda" 	 if ccode=="UGA"
	capture replace countryname="South Africa" if ccode=="ZAF"
	capture replace ="Low income" if ccode=="MOZ" | ccode=="UGA"
	capture replace ="Upper middle income" if ccode=="ZAF"

label var countryname "Countryname"

label var sample1 "Survey Data Source"


* Additional
	gen byte sh_UnSe_=	(empstat==2 | empstat==4) if lstatus==1  	& $condALL & empstat!=.
	label var sh_UnSe_ "Unpaid or Self-employed, age 15-64"
	
** Formality
    gen byte sh_formal_con_ = (contract==1) if contract!=. & $condALL
	label var sh_formal_con_ "Share of work contract"
	

	gen byte sh_formal_health_= (healthins==1) if healthins!=. & $condALL
	label var sh_formal_health_ "Share of health insurance"
	
	gen byte sh_formal_socialsec_= (socialsec==1) if socialsec!=. & $condALL
	label var sh_formal_socialsec_ "Share of social security"
	
* Wage gaps

	by ccode year sample1, sort: egen wages_male=median(wages_monthly_def )    if gender==1 & empstat==1
	by ccode year sample1, sort: egen wages_female=median(wages_monthly_def )  if gender==2 & empstat==1
	by ccode year sample1, sort: egen wages_public=median(wages_monthly_def )  if ocusec==1 & empstat==1
	by ccode year sample1, sort: egen wages_private=median(wages_monthly_def ) if ocusec==2 & empstat==1
	
keep no_* sh_* wages_* mean_hours_ countryname ccode year_s year sample1 gender age_x urb wgt age low_edu

compress

*********************************************
************** ALL ************************
*********************************************

preserve

gen sample_type=.
label var sample_type "Survey Type"

gen sample_size=.
label var sample_size "Sample Size"


local shares "countryname  year sample1 sample_type sample_size no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ sh_formal_con_ sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd"
foreach x in `shares'{
local l`x' : variable label `x' 
}

collapse (count) no_* (mean) sh_*  mean_hours_ (median) wages_* [pw=wgt], by(countryname year sample1)

gen sample_type=.
label var sample_type "Survey Type"

gen sample_size=.
label var sample_size "Sample Size"


foreach x in `shares' {
label var `x' "`l`x''" 
local varlabel: var label `x'
}	

gen ratio_gender_gap=wages_female/wages_male
label var ratio_gender_gap "Female to Male gender wage gap"

gen ratio_sector_gap=wages_public/wages_private
label var ratio_sector_gap "Public to Private wage gap"


putexcel set "$indicators\Indicators_`date'",  sheet(1_Indicators_ALL) modify


putexcel A1="Meta-Data"
putexcel A1:E2, merge hcenter vcenter txtwrap border(all) 

qui putexcel F1="Socio-Demographics"
qui putexcel F1:O1, merge hcenter vcenter txtwrap border(all) fpattern(solid, yellow)


putexcel P1="Labor Force and Employment"
putexcel P1:AK1, merge hcenter vcenter txtwrap border(all) fpattern(solid, green)

putexcel AL1="Employment composition by sector and occupation"
putexcel AL1:BI1, merge hcenter vcenter txtwrap border(all) fpattern(solid, orange)


putexcel BJ1="Labor Market Outcomes"
putexcel BJ1:BW1, merge hcenter vcenter txtwrap border(all) fpattern(solid, blue)

putexcel BX1="Education"
putexcel BX1:CA1, merge hcenter vcenter txtwrap border(all) fpattern(solid, purple)



putexcel F2="Population"
putexcel F2:K2, merge hcenter vcenter txtwrap border(all) fpattern(solid, gold)


putexcel L2="Working Age"
putexcel L2:O2, merge hcenter vcenter txtwrap border(all) fpattern(solid, lightyellow )


putexcel P2="Labor Force"
putexcel P2:Y2, merge hcenter vcenter txtwrap border(all) fpattern(solid, lime)


putexcel Z2="Employment Type"
putexcel Z2:AK2, merge hcenter vcenter txtwrap border(all) fpattern(solid, darkgreen)

putexcel AL2="Sector"
putexcel AL2:AP2, merge hcenter vcenter txtwrap border(all) fpattern(solid, lightsalmon )

putexcel AQ2="Sector, detail"
putexcel AQ2:AY2, merge hcenter vcenter txtwrap border(all) fpattern(solid, sandybrown)

putexcel AZ2="Occupation"
putexcel AZ2:BI2, merge hcenter vcenter txtwrap border(all) fpattern(solid, khaki)

putexcel BJ2="Working Hours"
putexcel BJ2:BL2, merge hcenter vcenter txtwrap border(all) fpattern(solid, turquoise)

putexcel BM2="Earnings"
putexcel BM2:BW2, merge hcenter vcenter txtwrap border(all) fpattern(solid, aliceblue)

putexcel BX2="Education attainment"
putexcel BX2:CA2, merge hcenter vcenter txtwrap border(all) fpattern(solid, pink)


** 3rd Row Description
putexcel G3="Share of total Population"
putexcel G3:J3, merge hcenter  txtwrap bold shrink border(all) fpattern(solid, gold)

putexcel V3="Share of all Labor Force Participants, aged 15-64"
putexcel V3:W3, merge hcenter  txtwrap bold shrink border(all) fpattern(solid, lime)

putexcel X3="Share of all Labor Force Participants, aged 15-24"
putexcel X3:Y3, merge hcenter  txtwrap bold shrink border(all) fpattern(solid, lime)

putexcel Z3="Share of all employment types"
putexcel Z3:AD3, merge hcenter  txtwrap bold shrink border(all) fpattern(solid, mediumspringgreen)

putexcel AE3="Share of formal employment"
putexcel AE3:AK3, merge hcenter  txtwrap bold shrink border(all) fpattern(solid, mediumspringgreen)

putexcel AL3="Share of all employed by sectors"
putexcel AL3:AN3, merge hcenter  txtwrap bold shrink border(all) fpattern(solid, lightsalmon)

putexcel AQ3="Share of all employed by detailed sectors, excluding agriculture"
putexcel AQ3:AY3, merge hcenter  txtwrap bold shrink  border(all) fpattern(solid, sandybrown)

putexcel AZ3="Share of all employed by occupations"
putexcel AZ3:BI3, merge hcenter  txtwrap bold shrink  border(all) fpattern(solid, khaki)

putexcel BJ3="Share of all employed by working hours"
putexcel BJ3:BL3, merge hcenter  txtwrap bold shrink  border(all) fpattern(solid, turquoise)

putexcel BX3="Share of working age population"
putexcel BX3:CA3, merge hcenter  txtwrap bold shrink border(all) fpattern(solid, pink)




local shares "countryname year sample1 sample_type sample_size no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ "

local excel=1

foreach var in `shares'{
excelcol `excel' 
local colname `r(column)'
local p : variable label `var'
putexcel `colname'4="`p'", txtwrap overwrite
local ++excel
}



count
local y=r(N)
local row=5			  

	

tabstat sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old, by(sample1) save


forval z=1/`y'	{ 
matrix define pop`z'=r(Stat`z')
}

tabstat  no_pop_, by(sample1) save
forval z=1/`y'	{ 
matrix define pop_no`z'=r(Stat`z')
}

tabstat no_lf_numb, by(sample1) save
forval z=1/`y'	{ 
matrix define lf_no`z'=r(Stat`z')
}

tabstat sh_lf_ sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_, by(sample1) save

tabstat sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ ///
		sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ ///
		sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs ///
		sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ ///
		sh_occup_eleme_ sh_occup_armed_, by(sample1) save
forval z=1/`y'	{ 
matrix define lf_`z'=r(Stat`z')
}

tabstat mean_hours_, by(sample1) save
forval z=1/`y'	{ 
matrix define wo_no`z'=r(Stat`z')
}

tabstat sh_underemp sh_excemp, by(sample1) save
forval z=1/`y'	{ 
matrix define wo_`z'=r(Stat`z')
}

tabstat wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd, by(sample1) save
forval z=1/`y'	{ 
matrix define wages`z'=r(Stat`z')
}

tabstat  ratio_gender_gap ratio_sector_gap , by(sample1) save
forval z=1/`y'	{ 
matrix define ratio_`z'=r(Stat`z')
}


tabstat  sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ, by(sample1) save
forval z=1/`y'	{ 
matrix define edu_`z'=r(Stat`z')
}



forval z=1/`y'	{
putexcel F`row'=matrix(pop_no`z'), nformat(number_sep)
putexcel G`row'=matrix(pop`z'), nformat(percent_d2)
putexcel P`row'=matrix(lf_no`z'), nformat(number_sep)
putexcel Q`row'=matrix(lf_`z'), nformat(percent_d2)
putexcel BJ`row'=matrix(wo_no`z'), nformat (number_sep) 
putexcel BK`row'=matrix(wo_`z'), nformat(percent_d2) 
putexcel BM`row'=matrix(wages`z'), nformat (number_sep) 
putexcel BV`row'=matrix(ratio_`z'), nformat(percent_d2) 
putexcel BX`row'=matrix(edu_`z'), nformat(percent_d2)  
local ++row
}	

local row=5			  


levels sample1
foreach lev in `r(levels)'{
use "$data/I2D2_test_${y}_red.dta", clear
keep if sample1=="`lev'"
putexcel A`row'=countryname
putexcel B`row'=year    
putexcel C`row'=sample1 
putexcel D`row'=sample_type
putexcel E`row'=sample_size
local ++row
}	
	
	
restore


preserve
drop no_contract no_healthins no_socialsec sh_notclass_ sh_missing__  sh_ind_miss_ sh_agr_det 

*********************************************
************** Urban ************************
*********************************************

* First check if var in data *and* not all missing. If pass: do
cap count if missing(urb)
if _rc == 0 & (`r(N)' < `full_sample') {
	
	keep if urb==1

	gen sample_type=.
	label var sample_type "Survey Type"

	gen sample_size=.
	label var sample_size "Sample Size"

	gen category=.
	label var category "Category"


	local shares "countryname  year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ sh_formal_con_ sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd"
	foreach x in `shares'{
	local l`x' : variable label `x' 
	}


	collapse (count) no_* (mean) sh_*  mean_hours_ (median) wages_* [pw=wgt], by(countryname year sample1)

	gen sample_type=.
	label var sample_type "Survey Type"

	gen category=.
	label var category "Category"



	foreach x in `shares' {
	label var `x' "`l`x''" 
	local varlabel: var label `x'
	}	

	gen ratio_gender_gap=wages_female/wages_male
	label var ratio_gender_gap "Female to Male gender wage gap"

	gen ratio_sector_gap=wages_public/wages_private
	label var ratio_sector_gap "Public to Private wage gap"


	putexcel set "$indicators\Indicators_`date'",  sheet(2_Indicators_Disaggregation) modify


	putexcel A1="Meta-Data"
	putexcel A1:E2, merge hcenter vcenter txtwrap border(all) 

	qui putexcel F1="Socio-Demographics"
	qui putexcel F1:O1, merge hcenter vcenter txtwrap border(all) fpattern(solid, yellow)


	putexcel P1="Labor Force and Employment"
	putexcel P1:AK1, merge hcenter vcenter txtwrap border(all) fpattern(solid, green)

	putexcel AL1="Employment composition by sector and occupation"
	putexcel AL1:BI1, merge hcenter vcenter txtwrap border(all) fpattern(solid, orange)


	putexcel BJ1="Labor Market Outcomes"
	putexcel BJ1:BW1, merge hcenter vcenter txtwrap border(all) fpattern(solid, blue)

	putexcel BX1="Education"
	putexcel BX1:CA1, merge hcenter vcenter txtwrap border(all) fpattern(solid, purple)



	putexcel F2="Population"
	putexcel F2:K2, merge hcenter vcenter txtwrap border(all) fpattern(solid, gold)


	putexcel L2="Working Age"
	putexcel L2:O2, merge hcenter vcenter txtwrap border(all) fpattern(solid, lightyellow )


	putexcel P2="Labor Force"
	putexcel P2:Y2, merge hcenter vcenter txtwrap border(all) fpattern(solid, lime)


	putexcel Z2="Employment Type"
	putexcel Z2:AK2, merge hcenter vcenter txtwrap border(all) fpattern(solid, darkgreen)

	putexcel AL2="Sector"
	putexcel AL2:AP2, merge hcenter vcenter txtwrap border(all) fpattern(solid, lightsalmon )

	putexcel AQ2="Sector, detail"
	putexcel AQ2:AY2, merge hcenter vcenter txtwrap border(all) fpattern(solid, sandybrown)

	putexcel AZ2="Occupation"
	putexcel AZ2:BI2, merge hcenter vcenter txtwrap border(all) fpattern(solid, khaki)

	putexcel BJ2="Working Hours"
	putexcel BJ2:BL2, merge hcenter vcenter txtwrap border(all) fpattern(solid, turquoise)

	putexcel BM2="Earnings"
	putexcel BM2:BW2, merge hcenter vcenter txtwrap border(all) fpattern(solid, aliceblue)

	putexcel BX2="Education attainment"
	putexcel BX2:CA2, merge hcenter vcenter txtwrap border(all) fpattern(solid, pink)


	** 3rd Row Description
	putexcel G3="Share of total Population"
	putexcel G3:J3, merge hcenter  txtwrap bold shrink border(all) fpattern(solid, gold)

	putexcel V3="Share of all Labor Force Participants, aged 15-64"
	putexcel V3:W3, merge hcenter  txtwrap bold shrink border(all) fpattern(solid, lime)

	putexcel X3="Share of all Labor Force Participants, aged 15-24"
	putexcel X3:Y3, merge hcenter  txtwrap bold shrink border(all) fpattern(solid, lime)

	putexcel Z3="Share of all employment types"
	putexcel Z3:AD3, merge hcenter  txtwrap bold shrink border(all) fpattern(solid, mediumspringgreen)

	putexcel AE3="Share of formal employment"
	putexcel AE3:AK3, merge hcenter  txtwrap bold shrink border(all) fpattern(solid, mediumspringgreen)

	putexcel AL3="Share of all employed by sectors"
	putexcel AL3:AN3, merge hcenter  txtwrap bold shrink border(all) fpattern(solid, lightsalmon)

	putexcel AQ3="Share of all employed by detailed sectors, excluding agriculture"
	putexcel AQ3:AY3, merge hcenter  txtwrap bold shrink  border(all) fpattern(solid, sandybrown)

	putexcel AZ3="Share of all employed by occupations"
	putexcel AZ3:BI3, merge hcenter  txtwrap bold shrink  border(all) fpattern(solid, khaki)

	putexcel BJ3="Share of all employed by working hours"
	putexcel BJ3:BL3, merge hcenter  txtwrap bold shrink  border(all) fpattern(solid, turquoise)

	putexcel BX3="Share of working age population"
	putexcel BX3:CA3, merge hcenter  txtwrap bold shrink border(all) fpattern(solid, pink)

	local shares "countryname year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ "

	local excel=1

	foreach var in `shares'{
	excelcol `excel' 
	local colname `r(column)'
	local p : variable label `var'
	putexcel `colname'4="`p'", txtwrap overwrite
	local ++excel
	}


	count
	local y=r(N)
	local row=5			  

		

	tabstat sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old, by(sample1) save


	forval z=1/`y'	{ 
	matrix define pop`z'=r(Stat`z')
	}

	tabstat  no_pop_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define pop_no`z'=r(Stat`z')
	}

	tabstat no_lf_numb, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_no`z'=r(Stat`z')
	}


	tabstat sh_lf_ sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_, by(sample1) save

	tabstat sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ ///
			sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ ///
			sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs ///
			sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ ///
			sh_occup_eleme_ sh_occup_armed_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_`z'=r(Stat`z')
	}

	tabstat mean_hours_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_no`z'=r(Stat`z')
	}

	tabstat sh_underemp sh_excemp, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_`z'=r(Stat`z')
	}

	tabstat wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wages`z'=r(Stat`z')
	}

	tabstat  ratio_gender_gap ratio_sector_gap , by(sample1) save
	forval z=1/`y'	{ 
	matrix define ratio_`z'=r(Stat`z')
	}


	tabstat  sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ, by(sample1) save
	forval z=1/`y'	{ 
	matrix define edu_`z'=r(Stat`z')
	}



	forval z=1/`y'	{
	putexcel F`row'=matrix(pop_no`z'), nformat(number_sep)
	putexcel G`row'=matrix(pop`z'), nformat(percent_d2)
	putexcel P`row'=matrix(lf_no`z'), nformat(number_sep)
	putexcel Q`row'=matrix(lf_`z'), nformat(percent_d2)
	putexcel BJ`row'=matrix(wo_no`z'), nformat (number_sep) 
	putexcel BK`row'=matrix(wo_`z'), nformat(percent_d2) 
	putexcel BM`row'=matrix(wages`z'), nformat (number_sep) 
	putexcel BV`row'=matrix(ratio_`z'), nformat(percent_d2) 
	putexcel BX`row'=matrix(edu_`z'), nformat(percent_d2)  
	local ++row
	}	

	local row=5			  


	levels sample1
	foreach lev in `r(levels)'{
	use "$data/I2D2_test_${y}_red.dta", clear
	keep if sample1=="`lev'"
	putexcel A`row'=countryname
	putexcel B`row'=year    
	putexcel C`row'=sample1 
	putexcel D`row'=sample_type
	putexcel E`row'="Urban"
	local ++row
	}	
	
}


restore


*********************************************
************** Rural ************************
*********************************************

cap count if missing(urb)
if _rc == 0 & (`r(N)' < `full_sample') {

	preserve


	keep if urb==2


	gen sample_type=.
	label var sample_type "Survey Type"

	gen category=.
	label var category "Category"


	local shares "countryname  year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ sh_formal_con_ sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd"
	foreach x in `shares'{
	local l`x' : variable label `x' 
	}

	collapse (count) no_* (mean) sh_*  mean_hours_ (median) wages_* [pw=wgt], by(countryname year sample1)


	gen sub_sample=.
	label var sub_sample "Sub-Sample"

	gen sample_type=.
	label var sample_type "Survey Type"

	gen ratio_gender_gap=wages_female/wages_male
	label var ratio_gender_gap "Female to Male gender wage gap"

	gen ratio_sector_gap=wages_public/wages_private
	label var ratio_sector_gap "Public to Private wage gap"

	gen category=.
	label var category "Category"

	local shares "countryname year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ "

	local excel=1



	count
	local y=r(N)
	local row=5	+ `y'		  

		

	tabstat sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old, by(sample1) save


	forval z=1/`y'	{ 
	matrix define pop`z'=r(Stat`z')
	}

	tabstat  no_pop_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define pop_no`z'=r(Stat`z')
	}

	tabstat no_lf_numb, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_no`z'=r(Stat`z')
	}


	tabstat sh_lf_ sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_, by(sample1) save


	tabstat sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ ///
			sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ ///
			sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs ///
			sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ ///
			sh_occup_eleme_ sh_occup_armed_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_`z'=r(Stat`z')
	}

	tabstat mean_hours_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_no`z'=r(Stat`z')
	}

	tabstat sh_underemp sh_excemp, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_`z'=r(Stat`z')
	}

	tabstat wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wages`z'=r(Stat`z')
	}

	tabstat  ratio_gender_gap ratio_sector_gap , by(sample1) save
	forval z=1/`y'	{ 
	matrix define ratio_`z'=r(Stat`z')
	}


	tabstat  sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ, by(sample1) save
	forval z=1/`y'	{ 
	matrix define edu_`z'=r(Stat`z')
	}



	forval z=1/`y'	{
	putexcel F`row'=matrix(pop_no`z'), nformat(number_sep)
	putexcel G`row'=matrix(pop`z'), nformat(percent_d2)
	putexcel P`row'=matrix(lf_no`z'), nformat(number_sep)
	putexcel Q`row'=matrix(lf_`z'), nformat(percent_d2)
	putexcel BJ`row'=matrix(wo_no`z'), nformat (number_sep) 
	putexcel BK`row'=matrix(wo_`z'), nformat(percent_d2) 
	putexcel BM`row'=matrix(wages`z'), nformat (number_sep) 
	putexcel BV`row'=matrix(ratio_`z'), nformat(percent_d2) 
	putexcel BX`row'=matrix(edu_`z'), nformat(percent_d2)  
	local ++row
	}	

	local row=5	+ `y'		  


	levels sample1
	foreach lev in `r(levels)'{
	use "$data/I2D2_test_${y}_red.dta", clear
	keep if sample1=="`lev'"
	putexcel A`row'=countryname
	putexcel B`row'=year    
	putexcel C`row'=sample1 
	putexcel D`row'=sample_type
	putexcel E`row'="Rural"
	local ++row
	}	

	restore

}





*********************************************
************** Male ************************
*********************************************


cap count if missing(gender)
if _rc == 0 & (`r(N)' < `full_sample') {
	
	preserve


	keep if gender==1


	gen sample_type=.
	label var sample_type "Survey Type"

	gen category=.
	label var category "Category"


	local shares "countryname  year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ sh_formal_con_ sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd"
	foreach x in `shares'{
	local l`x' : variable label `x' 
	}

	collapse (count) no_* (mean) sh_*  mean_hours_ (median) wages_* [pw=wgt], by(countryname year sample1)


	gen sub_sample=.
	label var sub_sample "Sub-Sample"

	gen sample_type=.
	label var sample_type "Survey Type"



	gen category=.
	label var category "Category"

	gen ratio_gender_gap=wages_female/wages_male
	label var ratio_gender_gap "Female to Male gender wage gap"

	gen ratio_sector_gap=wages_public/wages_private
	label var ratio_sector_gap "Public to Private wage gap"


	local shares "countryname year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ "

	local excel=1



	count
	local y=r(N)
	local row=5	+ 2*`y'		  

		

	tabstat sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old, by(sample1) save


	forval z=1/`y'	{ 
	matrix define pop`z'=r(Stat`z')
	}

	tabstat  no_pop_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define pop_no`z'=r(Stat`z')
	}

	tabstat no_lf_numb, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_no`z'=r(Stat`z')
	}


	tabstat sh_lf_ sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_, by(sample1) save


	tabstat sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ ///
			sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ ///
			sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs ///
			sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ ///
			sh_occup_eleme_ sh_occup_armed_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_`z'=r(Stat`z')
	}

	tabstat mean_hours_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_no`z'=r(Stat`z')
	}

	tabstat sh_underemp sh_excemp, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_`z'=r(Stat`z')
	}

	tabstat wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wages`z'=r(Stat`z')
	}

	tabstat  ratio_gender_gap ratio_sector_gap , by(sample1) save
	forval z=1/`y'	{ 
	matrix define ratio_`z'=r(Stat`z')
	}


	tabstat  sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ, by(sample1) save
	forval z=1/`y'	{ 
	matrix define edu_`z'=r(Stat`z')
	}



	forval z=1/`y'	{
	putexcel F`row'=matrix(pop_no`z'), nformat(number_sep)
	putexcel G`row'=matrix(pop`z'), nformat(percent_d2)
	putexcel P`row'=matrix(lf_no`z'), nformat(number_sep)
	putexcel Q`row'=matrix(lf_`z'), nformat(percent_d2)
	putexcel BJ`row'=matrix(wo_no`z'), nformat (number_sep) 
	putexcel BK`row'=matrix(wo_`z'), nformat(percent_d2) 
	putexcel BM`row'=matrix(wages`z'), nformat (number_sep) 
	putexcel BV`row'=matrix(ratio_`z'), nformat(percent_d2) 
	putexcel BX`row'=matrix(edu_`z'), nformat(percent_d2)  
	local ++row
	}	

	local row=5	+ 2*`y'		  


	levels sample1
	foreach lev in `r(levels)'{
	use "$data/I2D2_test_${y}_red.dta", clear
	keep if sample1=="`lev'"
	putexcel A`row'=countryname
	putexcel B`row'=year    
	putexcel C`row'=sample1 
	putexcel D`row'=sample_type
	putexcel E`row'="Male"
	local ++row
	}	

	restore
}






*********************************************
************** Female ************************
*********************************************

cap count if missing(gender)
if _rc == 0 & (`r(N)' < `full_sample') {
	
	preserve

	keep if gender==2


	gen sample_type=.
	label var sample_type "Survey Type"

	gen category=.
	label var category "Category"


	local shares "countryname  year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ sh_formal_con_ sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd"
	foreach x in `shares'{
	local l`x' : variable label `x' 
	}

	collapse (count) no_* (mean) sh_*  mean_hours_ (median) wages_* [pw=wgt], by(countryname year sample1)


	gen sub_sample=.
	label var sub_sample "Sub-Sample"

	gen sample_type=.
	label var sample_type "Survey Type"

	gen ratio_gender_gap=wages_female/wages_male
	label var ratio_gender_gap "Female to Male gender wage gap"

	gen ratio_sector_gap=wages_public/wages_private
	label var ratio_sector_gap "Public to Private wage gap"

	gen category=.
	label var category "Category"

	local shares "countryname year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ "

	local excel=1



	count
	local y=r(N)
	local row=5	+ 3*`y'		  

		

	tabstat sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old, by(sample1) save

	forval z=1/`y'	{ 
	matrix define pop`z'=r(Stat`z')
	}

	tabstat  no_pop_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define pop_no`z'=r(Stat`z')
	}

	tabstat no_lf_numb, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_no`z'=r(Stat`z')
	}


	tabstat sh_lf_ sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_, by(sample1) save

	tabstat sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ ///
			sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ ///
			sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs ///
			sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ ///
			sh_occup_eleme_ sh_occup_armed_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_`z'=r(Stat`z')
	}

	tabstat mean_hours_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_no`z'=r(Stat`z')
	}

	tabstat sh_underemp sh_excemp, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_`z'=r(Stat`z')
	}

	tabstat wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wages`z'=r(Stat`z')
	}

	tabstat  ratio_gender_gap ratio_sector_gap , by(sample1) save
	forval z=1/`y'	{ 
	matrix define ratio_`z'=r(Stat`z')
	}


	tabstat  sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ, by(sample1) save
	forval z=1/`y'	{ 
	matrix define edu_`z'=r(Stat`z')
	}



	forval z=1/`y'	{
	putexcel F`row'=matrix(pop_no`z'), nformat(number_sep)
	putexcel G`row'=matrix(pop`z'), nformat(percent_d2)
	putexcel P`row'=matrix(lf_no`z'), nformat(number_sep)
	putexcel Q`row'=matrix(lf_`z'), nformat(percent_d2)
	putexcel BJ`row'=matrix(wo_no`z'), nformat (number_sep) 
	putexcel BK`row'=matrix(wo_`z'), nformat(percent_d2) 
	putexcel BM`row'=matrix(wages`z'), nformat (number_sep) 
	putexcel BV`row'=matrix(ratio_`z'), nformat(percent_d2) 
	putexcel BX`row'=matrix(edu_`z'), nformat(percent_d2)  
	local ++row
	}	

	local row=5	+ 3*`y'		  


	levels sample1
	foreach lev in `r(levels)'{
	use "$data/I2D2_test_${y}_red.dta", clear
	keep if sample1=="`lev'"
	putexcel A`row'=countryname
	putexcel B`row'=year    
	putexcel C`row'=sample1 
	putexcel D`row'=sample_type
	putexcel E`row'="Female"
	local ++row
	}	

	restore

}






*********************************************
************** Young Worker *****************
*********************************************


cap count if missing(age_x)
if _rc == 0 & (`r(N)' < `full_sample') {

	preserve


	keep if age_x==1


	gen sample_type=.
	label var sample_type "Survey Type"

	gen category=.
	label var category "Category"


	local shares "countryname  year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ sh_formal_con_ sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd"
	foreach x in `shares'{
	local l`x' : variable label `x' 
	}

	collapse (count) no_* (mean) sh_*  mean_hours_ (median) wages_* [pw=wgt], by(countryname year sample1)


	gen sub_sample=.
	label var sub_sample "Sub-Sample"

	gen sample_type=.
	label var sample_type "Survey Type"

	gen ratio_gender_gap=wages_female/wages_male
	label var ratio_gender_gap "Female to Male gender wage gap"

	gen ratio_sector_gap=wages_public/wages_private
	label var ratio_sector_gap "Public to Private wage gap"

	gen category=.
	label var category "Category"


	local shares "countryname year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ "

	local excel=1



	count
	local y=r(N)
	local row=5	+ 4*`y'		  

		

	tabstat sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old, by(sample1) save


	forval z=1/`y'	{ 
	matrix define pop`z'=r(Stat`z')
	}

	tabstat  no_pop_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define pop_no`z'=r(Stat`z')
	}

	tabstat no_lf_numb, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_no`z'=r(Stat`z')
	}


	tabstat sh_lf_ sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_, by(sample1) save

	tabstat sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ ///
			sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ ///
			sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs ///
			sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ ///
			sh_occup_eleme_ sh_occup_armed_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_`z'=r(Stat`z')
	}

	tabstat mean_hours_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_no`z'=r(Stat`z')
	}

	tabstat sh_underemp sh_excemp, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_`z'=r(Stat`z')
	}

	tabstat wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wages`z'=r(Stat`z')
	}

	tabstat  ratio_gender_gap ratio_sector_gap , by(sample1) save
	forval z=1/`y'	{ 
	matrix define ratio_`z'=r(Stat`z')
	}


	tabstat  sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ, by(sample1) save
	forval z=1/`y'	{ 
	matrix define edu_`z'=r(Stat`z')
	}



	forval z=1/`y'	{
	putexcel F`row'=matrix(pop_no`z'), nformat(number_sep)
	putexcel G`row'=matrix(pop`z'), nformat(percent_d2)
	putexcel P`row'=matrix(lf_no`z'), nformat(number_sep)
	putexcel Q`row'=matrix(lf_`z'), nformat(percent_d2)
	putexcel BJ`row'=matrix(wo_no`z'), nformat (number_sep) 
	putexcel BK`row'=matrix(wo_`z'), nformat(percent_d2) 
	putexcel BM`row'=matrix(wages`z'), nformat (number_sep) 
	putexcel BV`row'=matrix(ratio_`z'), nformat(percent_d2) 
	putexcel BX`row'=matrix(edu_`z'), nformat(percent_d2)  
	local ++row
	}	

	local row=5	+ 4*`y'		  


	levels sample1
	foreach lev in `r(levels)'{
	use "$data/I2D2_test_${y}_red.dta", clear
	keep if sample1=="`lev'"
	putexcel A`row'=countryname
	putexcel B`row'=year    
	putexcel C`row'=sample1 
	putexcel D`row'=sample_type
	putexcel E`row'="Young Worker"
	local ++row
	}	

	restore
}




*********************************************
************** Old Worker *****************
*********************************************

cap count if missing(age_x)
if _rc == 0 & (`r(N)' < `full_sample') {
	
	preserve


	keep if age_x==2


	gen sample_type=.
	label var sample_type "Survey Type"

	gen category=.
	label var category "Category"


	local shares "countryname  year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ sh_formal_con_ sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd"
	foreach x in `shares'{
	local l`x' : variable label `x' 
	}

	collapse (count) no_* (mean) sh_*  mean_hours_ (median) wages_* [pw=wgt], by(countryname year sample1)


	gen sub_sample=.
	label var sub_sample "Sub-Sample"

	gen sample_type=.
	label var sample_type "Survey Type"

	gen ratio_gender_gap=wages_female/wages_male
	label var ratio_gender_gap "Female to Male gender wage gap"

	gen ratio_sector_gap=wages_public/wages_private
	label var ratio_sector_gap "Public to Private wage gap"

	gen category=.
	label var category "Category"


	local shares "countryname year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ "

	local excel=1




	count
	local y=r(N)
	local row=5	+ 5*`y'		  

		

	tabstat sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old, by(sample1) save


	forval z=1/`y'	{ 
	matrix define pop`z'=r(Stat`z')
	}

	tabstat  no_pop_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define pop_no`z'=r(Stat`z')
	}

	tabstat no_lf_numb, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_no`z'=r(Stat`z')
	}


	tabstat sh_lf_ sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_, by(sample1) save

	tabstat sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ ///
			sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ ///
			sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs ///
			sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ ///
			sh_occup_eleme_ sh_occup_armed_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_`z'=r(Stat`z')
	}

	tabstat mean_hours_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_no`z'=r(Stat`z')
	}

	tabstat sh_underemp sh_excemp, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_`z'=r(Stat`z')
	}

	tabstat wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd, by(sample1) save

	forval z=1/`y'	{ 
	matrix define wages`z'=r(Stat`z')
	}

	tabstat  ratio_gender_gap ratio_sector_gap , by(sample1) save
	forval z=1/`y'	{ 
	matrix define ratio_`z'=r(Stat`z')
	}


	tabstat  sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ, by(sample1) save
	forval z=1/`y'	{ 
	matrix define edu_`z'=r(Stat`z')
	}



	forval z=1/`y'	{
	putexcel F`row'=matrix(pop_no`z'), nformat(number_sep)
	putexcel G`row'=matrix(pop`z'), nformat(percent_d2)
	putexcel P`row'=matrix(lf_no`z'), nformat(number_sep)
	putexcel Q`row'=matrix(lf_`z'), nformat(percent_d2)
	putexcel BJ`row'=matrix(wo_no`z'), nformat (number_sep) 
	putexcel BK`row'=matrix(wo_`z'), nformat(percent_d2) 
	putexcel BM`row'=matrix(wages`z'), nformat (number_sep) 
	putexcel BV`row'=matrix(ratio_`z'), nformat(percent_d2) 
	putexcel BX`row'=matrix(edu_`z'), nformat(percent_d2)  
	local ++row
	}	

	local row=5	+ 5*`y'		  


	levels sample1
	foreach lev in `r(levels)'{
	use "$data/I2D2_test_${y}_red.dta", clear
	keep if sample1=="`lev'"
	putexcel A`row'=countryname
	putexcel B`row'=year    
	putexcel C`row'=sample1 
	putexcel D`row'=sample_type
	putexcel E`row'="Old worker"
	local ++row
	}	

	restore
}






*********************************************
************** Less educated*****************
*********************************************

cap count if missing(low_edu)
if _rc == 0 & (`r(N)' < `full_sample') {
	
	preserve


	keep if low_edu==1


	gen sample_type=.
	label var sample_type "Survey Type"

	gen category=.
	label var category "Category"


	local shares "countryname  year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ sh_formal_con_ sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd"
	foreach x in `shares'{
	local l`x' : variable label `x' 
	}

	collapse (count) no_* (mean) sh_*  mean_hours_ (median) wages_* [pw=wgt], by(countryname year sample1)


	gen sub_sample=.
	label var sub_sample "Sub-Sample"

	gen sample_type=.
	label var sample_type "Survey Type"

	gen ratio_gender_gap=wages_female/wages_male
	label var ratio_gender_gap "Female to Male gender wage gap"

	gen ratio_sector_gap=wages_public/wages_private
	label var ratio_sector_gap "Public to Private wage gap"

	gen category=.
	label var category "Category"


	local shares "countryname year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ "

	local excel=1


	count
	local y=r(N)
	local row=5	+ 6*`y'		  

		

	tabstat sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old, by(sample1) save


	forval z=1/`y'	{ 
	matrix define pop`z'=r(Stat`z')
	}

	tabstat  no_pop_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define pop_no`z'=r(Stat`z')
	}

	tabstat no_lf_numb, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_no`z'=r(Stat`z')
	}


	tabstat sh_lf_ sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_, by(sample1) save

	tabstat sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ ///
			sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ ///
			sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs ///
			sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ ///
			sh_occup_eleme_ sh_occup_armed_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_`z'=r(Stat`z')
	}

	tabstat mean_hours_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_no`z'=r(Stat`z')
	}

	tabstat sh_underemp sh_excemp, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_`z'=r(Stat`z')
	}

	tabstat wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd, by(sample1) save

	forval z=1/`y'	{ 
	matrix define wages`z'=r(Stat`z')
	}

	tabstat  ratio_gender_gap ratio_sector_gap , by(sample1) save
	forval z=1/`y'	{ 
	matrix define ratio_`z'=r(Stat`z')
	}


	tabstat  sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ, by(sample1) save
	forval z=1/`y'	{ 
	matrix define edu_`z'=r(Stat`z')
	}



	forval z=1/`y'	{
	putexcel F`row'=matrix(pop_no`z'), nformat(number_sep)
	putexcel G`row'=matrix(pop`z'), nformat(percent_d2)
	putexcel P`row'=matrix(lf_no`z'), nformat(number_sep)
	putexcel Q`row'=matrix(lf_`z'), nformat(percent_d2)
	putexcel BJ`row'=matrix(wo_no`z'), nformat (number_sep) 
	putexcel BK`row'=matrix(wo_`z'), nformat(percent_d2) 
	putexcel BM`row'=matrix(wages`z'), nformat (number_sep) 
	putexcel BV`row'=matrix(ratio_`z'), nformat(percent_d2) 
	putexcel BX`row'=matrix(edu_`z'), nformat(percent_d2)  
	local ++row
	}	

	local row=5	+ 6*`y'		  


	levels sample1
	foreach lev in `r(levels)'{
	use "$data/I2D2_test_${y}_red.dta", clear
	keep if sample1=="`lev'"
	putexcel A`row'=countryname
	putexcel B`row'=year    
	putexcel C`row'=sample1 
	putexcel D`row'=sample_type
	putexcel E`row'="Lower education"
	local ++row
	}	

	restore
}



*********************************************
************** High educated*****************
*********************************************

cap count if missing(low_edu)
if _rc == 0 & (`r(N)' < `full_sample') {
	
	preserve


	keep if low_edu==0


	gen sample_type=.
	label var sample_type "Survey Type"

	gen category=.
	label var category "Category"


	local shares "countryname  year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ sh_formal_con_ sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd"
	foreach x in `shares'{
	local l`x' : variable label `x' 
	}

	collapse (count) no_* (mean) sh_*  mean_hours_ (median) wages_* [pw=wgt], by(countryname year sample1)


	gen sub_sample=.
	label var sub_sample "Sub-Sample"

	gen sample_type=.
	label var sample_type "Survey Type"

	gen ratio_gender_gap=wages_female/wages_male
	label var ratio_gender_gap "Female to Male gender wage gap"

	gen ratio_sector_gap=wages_public/wages_private
	label var ratio_sector_gap "Public to Private wage gap"


	gen category=.
	label var category "Category"



	local shares "countryname year sample1 sample_type category no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ "

	local excel=1

	count
	local y=r(N)
	local row=5	+ 7*`y'		  

		

	tabstat sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb_ sh_wap_ sh_dependency sh_dependency_youth sh_dependency_old, by(sample1) save


	forval z=1/`y'	{ 
	matrix define pop`z'=r(Stat`z')
	}

	tabstat  no_pop_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define pop_no`z'=r(Stat`z')
	}

	tabstat no_lf_numb, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_no`z'=r(Stat`z')
	}


	tabstat sh_lf_ sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_, by(sample1) save

	tabstat sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ ///
			sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con_ sh_formal_health_ sh_formal_socialsec_ sh_pub_ ///
			sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs ///
			sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ ///
			sh_occup_eleme_ sh_occup_armed_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define lf_`z'=r(Stat`z')
	}

	tabstat mean_hours_, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_no`z'=r(Stat`z')
	}

	tabstat sh_underemp sh_excemp, by(sample1) save
	forval z=1/`y'	{ 
	matrix define wo_`z'=r(Stat`z')
	}

	tabstat wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd, by(sample1) save

	forval z=1/`y'	{ 
	matrix define wages`z'=r(Stat`z')
	}

	tabstat  ratio_gender_gap ratio_sector_gap , by(sample1) save
	forval z=1/`y'	{ 
	matrix define ratio_`z'=r(Stat`z')
	}


	tabstat  sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_educ, by(sample1) save
	forval z=1/`y'	{ 
	matrix define edu_`z'=r(Stat`z')
	}



	forval z=1/`y'	{
	putexcel F`row'=matrix(pop_no`z'), nformat(number_sep)
	putexcel G`row'=matrix(pop`z'), nformat(percent_d2)
	putexcel P`row'=matrix(lf_no`z'), nformat(number_sep)
	putexcel Q`row'=matrix(lf_`z'), nformat(percent_d2)
	putexcel BJ`row'=matrix(wo_no`z'), nformat (number_sep) 
	putexcel BK`row'=matrix(wo_`z'), nformat(percent_d2) 
	putexcel BM`row'=matrix(wages`z'), nformat (number_sep) 
	putexcel BV`row'=matrix(ratio_`z'), nformat(percent_d2) 
	putexcel BX`row'=matrix(edu_`z'), nformat(percent_d2)  
	local ++row
	}	

	local row=5	+ 7*`y'		  


	levels sample1
	foreach lev in `r(levels)'{
	use "$data/I2D2_test_${y}_red.dta", clear
	keep if sample1=="`lev'"
	putexcel A`row'=countryname
	putexcel B`row'=year    
	putexcel C`row'=sample1 
	putexcel D`row'=sample_type
	putexcel E`row'="Higher education"
	local ++row
	}	

	restore
	 
}	 
	 
	 
	 
	 
	 
******************************************************************
***************** Create the Pivot *******************************
******************************************************************


use "$data/I2D2_test_$y.dta", clear

capture gen countryname="$y"
label var countryname "Countryname"

gen pop=1
gen wka=1 if age_x==1 | age_x==2
gen emp=1 if lstatus==1 & age_x==1 | age_x==2
	
	
label def age_group 1 "Young worker (15-24)" 2 "Older worker (25-64)"
label val age_x age_group
label var pop "Population"
label var wka "Working age (15-64)"
label var emp "Employment"
label var age_x "Age group"
label var countryname "Country Name"
label var urb "Area"
label var industry "Sector, detailed"
label var lstatus "Labor Force composition"
label var edulevel2 "Education"
label var ocusec "Private vs. Public Sector"



local label "pop wka emp"
foreach x in `label'{
local l`x' : variable label `x' 
}


replace informal=. if informal==2 // Unknown informality coded as missing

collapse (sum) pop wka emp [pw=wgt], by (countryname year sample1 gender urb age_x industry empstat edulevel2 lstatus ocusec informal)

foreach x in `label'{
label var `x' "`l`x''" 
}

order countryname year sample1 gender urb age_x lstatus empstat industry edulevel2

export excel using "$indicators\Indicators_`date'.xlsx", sheet("3_Pivot_Data") firstrow(varlabels) sheetmodify








*******************************************************************************
************************* Create the Missing Sheet ****************************
*******************************************************************************


use "$data/I2D2_test_$y.dta", clear


				*Step 3: QUALITY CHECK: Missingness

		***Step 3.1: MISSINGNESS for Demographics:

		**** Missing weight
sort ccode year sample1

*** Details of Missingness:

datacheck wgt < ., by(ccode year sample1)  message(Missing Weights) flag nolist
rename _contra wgt_missing
la var wgt_missing "Weight variable missing - all"

datacheck age < ., by(ccode year sample1)  message(Missing age) flag nolist
rename _contra age_missing
la var age_missing "Age variable missing - all"

datacheck gender < ., by(ccode year sample1)  message(Missing gender) flag nolist
rename _contra gender_missing
la var gender_missing "Gender variable missing - all"

datacheck urb < ., by(ccode year sample1) varshow(age gender edulevel1 sample1) message(Missing Urban) flag nolist
rename _contra urb_missing
la var urb_missing "Urban/rural variable missing - all"

sort ccode year sample1

*** Education
datacheck atschool < . if age>6 & age<30, by(ccode year sample1) varshow(age gender edulevel1 edulevel2  lstatus sample1) message(Missing atschool) flag nolist
replace _contra = . if age<7 | age>29
rename _contra atschool_missing
la var atschool_missing "Atschool variable missing - age 7-29"


datacheck edulevel2 < . if $condALL, by(ccode year sample1) varshow(age gender edulevel1 edulevel2  lstatus sample1) message(Missing education level 2) flag nolist
replace _contra = . if $noCondALL
rename _contra edu_missing
la var edu_missing "Education variable missing for working age 15-64"


***MISSINGNESS for Labor Vars:

* Missingness of LFP


*** Details of Missingness:
*LFP
datacheck lstatus < . if $condALL, by(ccode year sample1) varshow(age gender edulevel1 lstatus sample1) message(Missing LFP) flag nolist
replace _contra = . if $noCondALL
rename _contra lstat_missing
la var lstat_missing "Labor Status Missing for working age 15-64"



* Missingness of Job related Vars for Employed Individuals

*Job Related Vars

datacheck empstat < . if $condALL & lstatus==1, by(ccode year sample1) varshow(age gender edulevel1 lstatus sample1) message(Missing Employment Status) flag nolist
replace _contra = . if $noCondALL | lstatus!=1
rename _contra empstat_missing
la var empstat_missing "Employment Status Missing for employed working age 15-64"

datacheck industry < . if $condALL & lstatus==1, by(ccode year sample1) varshow(age gender edulevel1 lstatus sample1) message(Missing Industry) flag nolist
replace _contra = .    if $noCondALL | lstatus!=1
rename _contra indus_missing_detailed
la var indus_missing_detailed "Detailed Industry Missing for employed working age 15-64"


datacheck industry1 < . if $condALL & lstatus==1, by(ccode year sample1) varshow(age gender edulevel1 lstatus sample1) message(Missing Industry) flag nolist
replace _contra = .    if $noCondALL | lstatus!=1
rename _contra indus_missing_broad
la var indus_missing_broad "Broad Industry Missing for employed working age 15-64"


datacheck occup < . if $condALL & lstatus==1, by(ccode year sample1) varshow(age gender edulevel1 lstatus sample1) message(Missing Occupation) flag nolist
replace _contra = . if $noCondALL | lstatus!=1
rename _contra occup_missing
la var occup_missing "Occupation Missing for employed working age 15-64"

datacheck ocusec < . if $condALL & lstatus==1 & empstat==1, by(ccode year sample1) varshow(age gender edulevel1 lstatus sample1) message(Missing Public ve Private) flag nolist
replace _contra = .  if $noCondALL | lstatus!=1 | empstat!=1
rename _contra ocusec_missing
la var ocusec_missing "Public vs Private Missing for wage workers working age 15-64"

datacheck njobs < . if $condALL & lstatus==1, by(ccode year sample1) varshow(age gender edulevel1 lstatus sample1) message(Missing if Additional Jobs) flag nolist
replace _contra = . if $noCondALL | lstatus!=1 
rename _contra njob_missing
la var njob_missing "Secondary Job Missing for employed working age 15-64"

datacheck wage < .  if $condALL & lstatus==1 , by(ccode year sample1) varshow(age gender edulevel1 lstatus sample1) message(Missing Wage for All) flag nolist
replace _contra = . if $noCondALL | lstatus!=1 
rename _contra wage_emp_missing
la var wage_emp_missing "Wage Missing for all workers working age 15-64"

datacheck wage < .  if $condALL & lstatus==1 & empstat==1, by(ccode year sample1) varshow(age gender edulevel1 lstatus sample1) message(Missing Wage for Wage Worker) flag nolist
replace _contra = . if $noCondALL | lstatus!=1 | empstat!=1
rename _contra wage_wagewrkr_missing
la var wage_wagewrkr_missing "Wage Missing for wage workers working age 15-64"

datacheck whours < . if $condALL & lstatus==1, by(ccode year sample1) varshow(age gender edulevel1 lstatus sample1) message(Missing Working Hours) flag nolist
replace _contra = .  if $noCondALL | lstatus!=1
rename _contra whours_missing
la var whours_missing "Work hours missing for those that are employed age 15-64"


* informal
datacheck informal < . if $condALL & lstatus==1, by(ccode year sample1) varshow(age gender edulevel1 lstatus sample1) message(Missing Informality) flag nolist
replace _contra = . if $noCondALL | lstatus!=1
rename _contra informal_missing
la var informal_missing "Informal missing for employed age 15-64"  

* contract
datacheck contract < . if $condALL & lstatus==1, by(ccode year sample1) varshow(age gender edulevel1 lstatus sample1) message(Missing Contract) flag nolist
replace _contra = . if $noCondALL | lstatus!=1
rename _contra contract_missing
la var contract_missing "Contract missing for employed working age 15-64"


* healthins
datacheck healthins < . if $condALL & lstatus==1, by(ccode year sample1) varshow(age gender edulevel1 lstatus sample1) message(Missing Contract) flag nolist
replace _contra = . if $noCondALL | lstatus!=1
rename _contra healthins_missing
la var healthins_missing "Health insurance missing for employed working age 15-64"


* contract
datacheck socialsec < . if $condALL & lstatus==1, by(ccode year sample1) varshow(age gender edulevel1 lstatus sample1) message(Missing Contract) flag nolist
replace _contra = . if $noCondALL | lstatus!=1
rename _contra socialsec_missing
la var socialsec_missing "Social security missing for employed working age 15-64"


** Missingness Measure

foreach x in wgt_missing age_missing gender_missing urb_missing atschool_missing  edu_missing lstat_missing empstat_missing indus_missing_broad indus_missing_detailed occup_missing ocusec_missing njob_missing wage_emp_missing wage_wagewrkr_missing whours_missing informal_missing contract_missing  healthins_missing socialsec_missing{
gen miss_`x'=`x'
}


collapse miss_*, by(ccode year sample1)



la var miss_wgt_missing "Weight variable missing - all"

la var miss_age_missing "Age variable missing - all"

la var miss_gender_missing "Gender variable missing - all"

la var miss_urb_missing "Urban/rural variable missing - all"

la var miss_atschool_missing "Atschool variable missing - age 7-29"

la var miss_edu_missing "Education variable missing for working age 15-64"

la var miss_lstat_missing "Labor Status Missing for working age 15-64"

la var miss_empstat_missing "Employment Status Missing for employed working age 15-64"

la var miss_indus_missing_detailed "Detailed Industry Missing for employed working age 15-64"

la var miss_indus_missing_broad "Broad Industry Missing for employed working age 15-64"

la var miss_occup_missing "Occupation Missing for employed working age 15-64"

la var miss_ocusec_missing "Public vs Private Missing for wage workers working age 15-64"

la var miss_njob_missing "Secondary Job Missing for employed working age 15-64"

la var miss_wage_wagewrkr_missing "Wage Missing for wage workers working age 15-64"

la var miss_wage_emp_missing "Wage Missing for all workers working age 15-64"

la var miss_whours_missing "Work hours missing for those that are employed working age 15-64"

la var miss_informal_missing "Informal missing for employed working age 15-64"  

la var miss_contract_missing "Contract missing for employed working age 15-64"

la var miss_healthins_missing "Health insurance missing for employed working age 15-64"

la var miss_socialsec_missing "Social security missing for employed working age 15-64"


putexcel set "$indicators\Indicators_`date'",  sheet(4_Data Quality) modify


putexcel A1="Meta-Data"
putexcel A1:D1, merge hcenter vcenter txtwrap border(all) 

putexcel E1="Socio-Demographics"
putexcel E1:H1, merge hcenter vcenter txtwrap border(all) fpattern(solid, yellow)

putexcel I1="Labor Force and Employment"
putexcel I1:N1, merge hcenter vcenter txtwrap border(all) fpattern(solid, green)

putexcel O1="Employment composition by sector and occupation"
putexcel O1:Q1, merge hcenter vcenter txtwrap border(all) fpattern(solid, orange)

putexcel R1="Labor Market Outcomes"
putexcel R1:V1, merge hcenter vcenter txtwrap border(all) fpattern(solid, blue)

putexcel W1="Education"
putexcel W1:X1, merge hcenter vcenter txtwrap border(all) fpattern(solid, purple)

gen sample_type=.
label var sample_type "Sample type"

local shares "ccode year sample1 sample_type miss_wgt_missing miss_age_missing miss_gender_missing miss_urb_missing  miss_lstat_missing miss_empstat_missing  miss_informal_missing miss_contract_missing  miss_socialsec_missing  miss_healthins_missing miss_indus_missing_broad miss_indus_missing_detailed miss_occup_missing miss_ocusec_missing miss_njob_missing miss_wage_emp_missing miss_wage_wagewrkr_missing miss_whours_missing miss_atschool_missing  miss_edu_missing"

local excel=1

foreach var in `shares'{
excelcol `excel' 
local colname `r(column)'
local p : variable label `var'
putexcel `colname'2="`p'", txtwrap overwrite
local ++excel
}

count
local y=r(N)
local row=3			  

	
tabstat  miss_wgt_missing miss_age_missing miss_gender_missing miss_urb_missing  miss_lstat_missing miss_empstat_missing  miss_informal_missing miss_contract_missing  miss_socialsec_missing  miss_healthins_missing miss_indus_missing_broad miss_indus_missing_detailed miss_occup_missing miss_ocusec_missing miss_njob_missing miss_wage_emp_missing miss_wage_wagewrkr_missing miss_whours_missing miss_atschool_missing  miss_edu_missing, by(sample1) save

forval z=1/`y'	{ 
matrix define miss`z'=r(Stat`z')
}



forval z=1/`y'	{
putexcel E`row'=matrix(miss`z'), nformat(percent_d2)
local ++row
}	

local row=3			  

levels sample1
foreach lev in `r(levels)'{
use "$data/I2D2_test_$y", clear
keep if sample1=="`lev'"
putexcel A`row'=countryname
putexcel B`row'=year    
putexcel C`row'=sample1
putexcel D`row'="All"
local ++row
}






************************************************************************************
******************************** Definitions ***************************************
************************************************************************************



putexcel set "$indicators\Indicators_`date'",  sheet(6_Definitions) modify


putexcel A1="Definitions File for Indicators", bold font([14pt])
putexcel A1:Z1, merge hcenter vcenter txtwrap 



*******************************************************************
******************** General Definitions **************************
*******************************************************************




putexcel A3="General definition of terms", font(italic[13pt]) fpattern(solid, yellow)
putexcel A3:H3, merge hcenter vcenter txtwrap 

putexcel A4="Age dependency", bold
putexcel C4="Following World Development Indicators (WDI) Age dependency ratio is the ratio of dependents, e.g. people younger than 15 or older than 64, to the working-age population aged 15-64. Note that Dependency ratios capture variations in the proportions of children, elderly people, and working-age people in the population that imply the dependency burden that the working-age population bears in relation to children and the elderly. But dependency ratios show only the age composition of a population, not economic dependency. Some children and elderly people are part of the labor force, and many working-age people are not."
putexcel C4:Z6, merge left txtwrap

putexcel A7="Weights", bold
putexcel C7="All results are reported using weights and thus representative for the whole country. The included weights are country specific." 
putexcel C7:Z7, merge left txtwrap

putexcel A9="Labor force definitions",  font(italic[13pt]) fpattern(solid, blue)
putexcel A9:H9, merge hcenter vcenter txtwrap

putexcel A11="Labor Force", bold
putexcel C11="All persons are considered active in the labor force if they presently have a job (formal or informal, i.e. are employed) or do not have a job but are actively seeking work (i.e. unemployed). See below for a definition of employement and unemployment."
putexcel C11:Z11, merge left txtwrap


putexcel A12="Employed", bold
putexcel C12="Employed is defined as anyone who worked during the last 7 days or reference week, regardless of whether the employment was formal or informal, paid or unpaid, for a minimum of 1 hour. Individuals who had a job, but for any reason did not work in the last 7 days are considered employed."
putexcel C12:Z13, merge left txtwrap


putexcel A14="Unemployed", bold
putexcel C14="A person is defined as unemployed if he or she is presently not working but were available for a job in the previous week and is seeking a job. The formal ILO definition of unemployed includes in addition to availability and seeking a job the factor to be able to accept a job.  This question was asked in a minority of surveys and is, thus, not incorporated in the present definition. In line with ILO, a person presently not working but waiting the start of a new job is considered to be unemployed."
putexcel C14:Z15, merge left txtwrap


putexcel A17="Employment status",  font(italic[13pt]) fpattern(solid, darkgreen)
putexcel A17:H17, merge hcenter vcenter txtwrap 


putexcel A19="Wage employment", bold
putexcel C19="Following ICSE-93 paid employee includes anyone whose basic remuneration is not directly dependent on the revenue of the unit they work for, typically remunerated by wages and salaries but may be paid for piece work or in-kind. Contrary to ICSE-93 continuous employment not used as additional criteria since data are often absent and due to country specificity." 	
putexcel C19:Z20, merge left txtwrap

putexcel A21="Unpaid", bold
putexcel C21="Following ICSE-93 unpaid workers include family workers and hold a self-employment job in a market-oriented establishment. The establishment is operated by a related person living in the same households who cannot be regarded as a partner because of their degree of commitment to the operation of the establishment, in terms of working time or other factors, is not at a level comparable to that of the head of the establishment."
putexcel C21:Z22, merge left txtwrap

putexcel A23="Employer", bold
putexcel C23="Following ICSE-93 an Employer is a business owner (whether alone or in partnership) with employees on a continous basis. If the only people working in the business are the owner and contributing family workers, the person is not considered an employer (as has no employees) and is, instead classified as self-employed." 	
putexcel C23:Z24, merge left txtwrap

putexcel A25="Self-employment", bold
putexcel C25="Following ICSE-93 own account or self-employment includes jobs where remuneration is directly dependent from the goods and service produced (where home consumption is considered to be part of the profits) and have not engaged any permanent employees to work for them on a continuous basis during the reference period. Contrary to ICSE-93 members of producers' cooperatives are not a category of their own but regarded as self-employed."   
putexcel C25:Z27, merge left txtwrap


putexcel A28="Informal employment", bold
putexcel C28="Informal employment is defined either as any unpaid employment or any other form of employment without social security. Since particularly the social security variable is often times missing, we report the share of missing formality indicator explicitly."
putexcel C28:Z29, merge left txtwrap


putexcel A31="Sector and Occupations", font(italic[13pt]) fpattern(solid, lightsalmon )
putexcel A31:H31, merge hcenter vcenter txtwrap 



putexcel A32="Sectors [reduced sectors]", bold
putexcel C32="The codes for the main job are given here based on the UN International Standard Industrial Classification (revision 3.1). In the case of different classifications (former Soviet Union republics, for example), recoding has been done to best match the ISIC-31 codes. Values in square brackets indicate the composed categories Agriculture, Industry, and Services. The main categories subsume the following codes:"
putexcel C32:Z33, merge left txtwrap
putexcel C34="Agriculture, Hunting, Fishing (ISIC 01-05) [Agriculture]"
putexcel C35="Mining (ISIC 10-14) [Industry]"
putexcel C36="Manufacturing (ISIC 15-37) [Industry]"
putexcel C37="Electricity and Utilities (ISIC 40-41) [Industry]"
putexcel C38="Construction (ISIC 45) [Industry]"
putexcel C39="Commerce (ISIC 50-55) [Services]"
putexcel C40="Transportation, Storage and Communication (ISIC 60-64) [Services]"
putexcel C41="Financial, Insurance and Real Estate (ISIC 65-74) [Services]"
putexcel C42="Services: Public Administration (ISIC 75) [Services]"
putexcel C43="Other Services (ISIC  80 -99) and unspecified categories or items [Services]" 



putexcel A44="Occupation", bold
putexcel C44="Classifies the main job of any individual with a job and is missing otherwise.  As most surveys collected detailed information and then coded it, and the original data is not in the data bases, no attempt has been made to correct or check the original coding. The classification is based on the International Standard Classification of Occupations (ISCO) 88. In the case of different classifications re-coding has been done to best match the ISCO-88."
putexcel C44:Z45, merge left txtwrap


 
putexcel A47="Working hours and Earnings", font(italic[13pt]) fpattern(solid, khaki)
putexcel A47:H47, merge hcenter vcenter txtwrap 


putexcel A49="Underemployment", bold
putexcel C49="Underemployment is defined as a situation when the hours of work of a person are insufficient in relation to an alternative employment situation in which the person is willing and available to engage and work less than 35 hours per week. Due to data restriction it is not always clear if the person wants to engage in additional work, so we take 35 hours of work per week as criterium." 
putexcel C49:Z50, merge left txtwrap

putexcel A51="Excessive working hours", bold
putexcel C51="We follow ILO that states that: Most countries have statutory limits of weekly working hours of 48 hours or less, and the hours actually worked per week in most countries are less than the 48-hour standard established in ILO conventions. These limits serve to promote higher productivity while safeguarding workers' physical and mental health."
putexcel C51:Z52, merge left txtwrap

putexcel A53="Earnings", bold
putexcel C53="Earnings are reported for wage workers only. The standard output reports median earnings, although all figures give additionally mean earnings and earnings for all workers. Disaggregations for the earnings are on the sectoral level and we report nominal earnings, deflated earnings as well as deflated and PPP adjusted earnings using the consumer price index for deflation and the PPP conversion factor, private consumption as reported in the World Development Indicators. Earnings are winsorized from the 0 to the 1 and 100 to 99 percentile."
putexcel C53:Z55, merge left txtwrap

putexcel A56="Female to Male gender wage gaps", bold
putexcel C56="The female to male gender wage gaps provides the ratio of female median wages on male median wages. It is conducted for the group of wage worker only."
putexcel C56:Z56, merge left txtwrap

putexcel A57="Public to private wage gap", bold
putexcel C57="The public to private wage gap provides the ratio of public median wages on private median wages. It is conducted for the group of wage worker only."
putexcel C57:Z57, merge left txtwrap



putexcel A59="Education", font(italic[13pt]) fpattern(solid, pink)
putexcel A59:H59, merge hcenter vcenter txtwrap 


putexcel A61="Education", bold
putexcel C61="The variable is country specific as not all countries require the same number of school years to complete a given level. Primary completed implies that one completed the stipulated primary education by undertaking an exam or test, where this exists. Otherwise, refers to having completed the highest grade in this level of education. Post secondary  complete refers to teachers' colleges, one or two-year programs of technical nature and include university educational level. University education level refers to any higher education after successfully completing secondary level of education regardless of whether this was completed.  This includes university, and graduate studies." 
putexcel C61:Z63, merge left txtwrap




putexcel A65="Detailed Variable definition", font(italic[13pt]) fpattern(solid, red)
putexcel A65:H65, merge hcenter vcenter txtwrap


putexcel A67= "Section Code", hcenter vcenter txtwrap bold
putexcel B67= "Variable Name", hcenter vcenter txtwrap bold
putexcel C67= "Short Definition", hcenter vcenter txtwrap bold

putexcel A68= "Overall", hcenter vcenter txtwrap  
putexcel B68= "Countryname", hcenter vcenter txtwrap  
putexcel C68= "Name of the respective country"
putexcel C68:Z68, merge left txtwrap

putexcel A69= "Overall", hcenter vcenter txtwrap  
putexcel B69= "Year of Survey", hcenter vcenter txtwrap  
putexcel C69= "Start year of survey"
putexcel C69:Z69, merge left txtwrap

putexcel A70= "Overall", hcenter vcenter txtwrap  
putexcel B70= "Survey Data Source" , hcenter vcenter txtwrap  
putexcel C70= "Identifies the sample from which the results are drawn"
putexcel C70:Z70, merge left txtwrap

putexcel A71= "Overall", hcenter vcenter txtwrap  
putexcel B71= "Survey Type" , hcenter vcenter txtwrap  
putexcel C71= "Identifies the survey type, for example a Labor Force Survey (LFS). This can give some indication on the quality of the survey. "
putexcel C71:Z71, merge left txtwrap


putexcel A72= "Overall", hcenter vcenter txtwrap  
putexcel B72= "Sample Size" , hcenter vcenter txtwrap  
putexcel C72= "Gives the survey sample size. The information is only reported in the Worksplit and Indicator_All file since the whole sample is used to generate those numbers."
putexcel C72:Z72, merge left txtwrap


putexcel A73= "Overall", hcenter vcenter txtwrap  
putexcel B73= "Sub-sample", hcenter vcenter txtwrap  
putexcel C73= "Determines the sub-group used for the analysis. The following sub-groups exist: Urban shows the results for only the urban population, rural shows the results for the rural population, youth shows the results for the young population between 15 to 24 years, old shows the results for the adults aged betwee 25 to 64 years, male shows the results for the male population and female shows the results for the female population."
putexcel C73:Z74, merge left txtwrap


putexcel A75= "Population", hcenter vcenter txtwrap  
putexcel B75= "Total Population", hcenter vcenter txtwrap  
putexcel C75= "Total number of inhabitants in the country"
putexcel C75:Z75, merge left txtwrap


putexcel A76= "Population", hcenter vcenter txtwrap  
putexcel B76= "Children, aged 0-14" , hcenter vcenter txtwrap  
putexcel C76= "Share of children within the population that are aged between 0 to 14 years. The shares of children, youth, adult and elderly must add up to 100 percent." 
putexcel C76:Z76, merge left txtwrap


putexcel A77= "Population", hcenter vcenter txtwrap  
putexcel B77= "Youth, aged 15-24", hcenter vcenter txtwrap  
putexcel C77= "Share of youth within the population that are aged between 15 to 24 years. The shares of children, youth, adult and elderly must add up to 100 percent." 
putexcel C77:Z77, merge left txtwrap


putexcel A78= "Population", hcenter vcenter txtwrap  
putexcel B78= "Adult, aged 25-64", hcenter vcenter txtwrap  
putexcel C78= "Share of adults within the population that are aged between 15 to 24 years. The shares of children, youth, adult and elderly must add up to 100 percent." 
putexcel C78:Z78, merge left txtwrap


putexcel A79= "Population", hcenter vcenter txtwrap  
putexcel B79= "Elderly, aged 65+", hcenter vcenter txtwrap  
putexcel C79= "Share of elderly within the population that are older than 65 years. The shares of children, youth, adult and elderly must add up to 100 percent." 
putexcel C79:Z79, merge left txtwrap




putexcel A80= "Population", hcenter vcenter txtwrap  
putexcel B80= "Urban Population", hcenter vcenter txtwrap  
putexcel C80= "Share of individuals within the population that are living in urban areas" 
putexcel C80:Z80, merge left txtwrap



putexcel A81= "Working Age", hcenter vcenter txtwrap  
putexcel B81= "Working age population, aged 15-64", hcenter vcenter txtwrap  
putexcel C81= "Share of indidivuals within the population that are in working age, defined as aged between 15 to 64 years"
putexcel C81:Z81, merge left txtwrap


putexcel A82= "Working Age", hcenter vcenter txtwrap  
putexcel B82= "Dependency rate, all compared to 15-64", hcenter vcenter txtwrap  
putexcel C82= "Share of indidivuals younger than 15 years or older than 64 years compared to  indivuals in working age (15-64 years)"
putexcel C82:Z82, merge left txtwrap



putexcel A83= "Working Age", hcenter vcenter txtwrap  
putexcel B83= "Youth Dependency Rate, younger than 15 compared to 15-64", hcenter vcenter txtwrap  
putexcel C83= "Share of indidivuals younger than 15 years compared to indivuals in working age (15-64 years)"
putexcel C83:Z83, merge left txtwrap

putexcel A84= "Working Age" , hcenter vcenter txtwrap  
putexcel B84= "Old Age Dependency Rate, older than 64 compared to 15-64", hcenter vcenter txtwrap  
putexcel C84= "Share of indidivuals older than 64 years compared to indivuals in working age (15-64 years)"
putexcel C84:Z84, merge left txtwrap


putexcel A85= "Labor Force", hcenter vcenter txtwrap  
putexcel B85= "Labor Force, aged 15-64", hcenter vcenter txtwrap  
putexcel C85= "Number of individuals that are in the labor force and in working age (15-64 years)"
putexcel C85:Z85, merge left txtwrap


putexcel A86= "Labor Force", hcenter vcenter txtwrap  
putexcel B86= "Labor Force Participation Rate, aged 15-64", hcenter vcenter txtwrap  
putexcel C86= "Share of individuals within all individuals in working age that participate in the labor force"
putexcel C86:Z86, merge left txtwrap

putexcel A87= "Labor Force", hcenter vcenter txtwrap  
putexcel B87= "Female Labor Force Participation Rate, aged 15-64", hcenter vcenter txtwrap  
putexcel C87= "Share of female individuals within all female individuals in working age that participate in the labor force"
putexcel C87:Z87, merge left txtwrap



putexcel A88= "Labor Force", hcenter vcenter txtwrap  
putexcel B88= "Not in labor force or education rate among youth, aged 15-24", hcenter vcenter txtwrap  
putexcel C88= "Share of young individuals within young individuals aged 15 to 24 that are neither parcitipating in the labor force nor are in education" 
putexcel C88:Z88, merge left txtwrap


putexcel A89= "Labor Force" , hcenter vcenter txtwrap  
putexcel B89= "Employment to Population Ratio, aged 15-64", hcenter vcenter txtwrap  
putexcel C89= "Share of employed individuals within working age (15-64)"
putexcel C89:Z89, merge left txtwrap



putexcel A90= "Labor Force", hcenter vcenter txtwrap
putexcel B90= "Share of workers (aged 15-64) with more than one jobs in last week", hcenter vcenter txtwrap
putexcel C90= "Share of workers in employment within working age that had more than one job in the last week"
putexcel C90:Z90, merge left txtwrap



putexcel A91= "Labor Force", hcenter vcenter txtwrap  
putexcel B91= "Employment rate, aged 15-64", hcenter vcenter txtwrap  
putexcel C91= "Share of employed individuals participating in the active labor force in working age (15-64). Must add to 100 percent with share of unemployed individuals participating in the active labor force in working age (15-64)"
putexcel C91:Z91, merge left txtwrap


putexcel A92= "Labor Force", hcenter vcenter txtwrap  
putexcel B92= "Unemployment rate, aged 15-64", hcenter vcenter txtwrap  
putexcel C92= "Share of unemployed individuals participating in the active labor force in working age (15-64).  Must add to 100 percent with share of employed individuals participating in the active labor force in working age (15-64)"
putexcel C92:Z92, merge left txtwrap


putexcel A93= "Labor Force", hcenter vcenter txtwrap  
putexcel B93= "Youth employment rate, aged 15-24", hcenter vcenter txtwrap  
putexcel C93= "Share of employed young individuals participating in the active labor force aged 15-24. Must add to 100 percent with share of employed young individuals participating in the active labor force aged 15-24"
putexcel C93:Z93, merge left txtwrap


putexcel A94= "Labor Force", hcenter vcenter txtwrap  
putexcel B94= "Youth unemployment rate, aged 15-24", hcenter vcenter txtwrap  
putexcel C94= "Share of unemployed young individuals participating in the active labor force aged 15-24. Must add to 100 percent with share of employed young individuals participating in the active labor force aged 15-24"
putexcel C94:Z94, merge left txtwrap

putexcel A95= "Employment Type", hcenter vcenter txtwrap  
putexcel B95= "Wage employees, aged 15-64", hcenter vcenter txtwrap  
putexcel C95= "Share of wage employed within employed individuals in working age (15-64). Must add to 100 percent with self-employed, unpaid and employers."
putexcel C95:Z95, merge left txtwrap

putexcel A96= "Employment Type", hcenter vcenter txtwrap  
putexcel B96= "Self-employed, aged 15-64", hcenter vcenter txtwrap  
putexcel C96= "Share of self-employed within employed individuals in working age (15-64). Must add to 100 percent with wage employees, unpaid and employers."
putexcel C96:Z96, merge left txtwrap

putexcel A97= "Employment Type", hcenter vcenter txtwrap  
putexcel B97= "Unpaid, aged 15-64", hcenter vcenter txtwrap  
putexcel C97= "Share of unpaid individuals within employed individuals in working age (15-64). Must add to 100 percent with wage employees, self-employed and employers."
putexcel C97:Z97, merge left txtwrap

putexcel A98= "Employment Type", hcenter vcenter txtwrap  
putexcel B98= "Employers, aged 15-64", hcenter vcenter txtwrap  
putexcel C98= "Share of employers within employed individuals in working age (15-64). Must add to 100 percent with wage employees, self-employed and unpaid."
putexcel C98:Z98, merge left txtwrap




putexcel A99= "Employment Type", hcenter vcenter txtwrap  
putexcel B99= "Informal jobs, aged 15-64", hcenter vcenter txtwrap  
putexcel C99= "Share of employed individuals working in an informal job in working age"
putexcel C99:Z99, merge left txtwrap



putexcel A100= "Employment Type", hcenter vcenter txtwrap  
putexcel B100= "Formal jobs, aged 15-64", hcenter vcenter txtwrap  
putexcel C100= "Share of employed individuals working in a formal job in working age"
putexcel C100:Z100, merge left txtwrap



putexcel A101= "Employment Type", hcenter vcenter txtwrap  
putexcel B101= "Employed with missing formality information, aged 15-64", hcenter vcenter txtwrap  
putexcel C101= "Share of employed individuals without information on the formality of the job in working age"
putexcel C101:Z101, merge left txtwrap


putexcel A102= "Employment Type", hcenter vcenter txtwrap  
putexcel B102= "Share of work contract, aged 15-64", hcenter vcenter txtwrap  
putexcel C102= "Share of employed individuals with a work contract in working age"
putexcel C102:Z102, merge left txtwrap


putexcel A103= "Employment Type", hcenter vcenter txtwrap  
putexcel B103= "Share of health insurance, aged 15-64", hcenter vcenter txtwrap  
putexcel C103= "Share of employed individuals with a health insurance in working age"
putexcel C103:Z103, merge left txtwrap

putexcel A104= "Employment Type", hcenter vcenter txtwrap  
putexcel B104= "Share of social security, aged 15-64", hcenter vcenter txtwrap  
putexcel C104= "Share of employed individuals with social security in working age"
putexcel C104:Z104, merge left txtwrap

putexcel A105= "Employment Type", hcenter vcenter txtwrap  
putexcel B105= "Public sector employment, aged 15-64", hcenter vcenter txtwrap  
putexcel C105= "Share of employed individuals that work in the public sector in working age"
putexcel C105:Z105, merge left txtwrap

putexcel A106= "Sector", hcenter vcenter txtwrap  
putexcel B106= "Agriculture, aged 15-64", hcenter vcenter txtwrap  
putexcel C106= "Share of employed individuals working in agriculture aged 15-64"
putexcel C106:Z106, merge left txtwrap



putexcel A107= "Sector", hcenter vcenter txtwrap  
putexcel B107= "Industry, aged 15-64", hcenter vcenter txtwrap  
putexcel C107= "Share of employed individuals working in industry sector aged 15-64"
putexcel C107:Z107, merge left txtwrap

putexcel A108= "Sector", hcenter vcenter txtwrap  
putexcel B108= "Services, aged 15-64", hcenter vcenter txtwrap  
putexcel C108= "Share of employed individuals working in service sector aged 15-64"
putexcel C108:Z108, merge left txtwrap

putexcel A109= "Sector", hcenter vcenter txtwrap  
putexcel B109= "Female in non-agricultural employment, aged 15-64", hcenter vcenter txtwrap  
putexcel C109= "Within the group of employed women in working age (15-64) the share working in non-agricultural employment"
putexcel C109:Z109, merge left txtwrap

putexcel A110= "Sector", hcenter vcenter txtwrap  
putexcel B110= "Youth in non-agricultural employment, aged 15-64", hcenter vcenter txtwrap  
putexcel C110= "Within the group of employed youth aged 15-24 the share working in non-agricultural employment"
putexcel C110:Z110, merge left txtwrap


putexcel A111= "Sector, detail", hcenter vcenter txtwrap  
putexcel B111= "Mining, aged 15-64", hcenter vcenter txtwrap  
putexcel C111= "Share of employed individuals working in the mining  sector, aged 15-64"
putexcel C111:Z111, merge left txtwrap

putexcel A112= "Sector, detail", hcenter vcenter txtwrap  
putexcel B112= "Manufacturing, aged 15-64", hcenter vcenter txtwrap  
putexcel C112= "Share of employed individuals working in the manufacturing sector, aged 15-64"
putexcel C112:Z112, merge left txtwrap


putexcel A113= "Sector, detail", hcenter vcenter txtwrap  
putexcel B113= "Public utilities, aged 15-64", hcenter vcenter txtwrap  
putexcel C113= "Share of employed individuals working in public utilities sector, aged 15-64"
putexcel C113:Z113, merge left txtwrap


putexcel A114= "Sector, detail", hcenter vcenter txtwrap  
putexcel B114= "Construction, aged 15-64", hcenter vcenter txtwrap  
putexcel C114= "Share of employed individuals working in the construction sector, aged 15-64"
putexcel C114:Z114, merge left txtwrap




putexcel A115= "Sector, detail", hcenter vcenter txtwrap  
putexcel B115= "Commerce, aged 15-64", hcenter vcenter txtwrap  
putexcel C115= "Share of employed individuals working in the commerce sector, aged 15-64"
putexcel C115:Z115, merge left txtwrap

putexcel A116= "Sector, detail", hcenter vcenter txtwrap  
putexcel B116= "Transport & Communication, aged 15-64", hcenter vcenter txtwrap  
putexcel C116= "Share of employed individuals working in the Transport & Communication sector, aged 15-64"
putexcel C116:Z116, merge left txtwrap

putexcel A117= "Sector, detail", hcenter vcenter txtwrap  
putexcel B117= "Financial and Business Services, aged 15-64", hcenter vcenter txtwrap  
putexcel C117= "Share of employed individuals working in the Financial and Business Services sector, aged 15-64"
putexcel C117:Z117, merge left txtwrap

putexcel A118= "Sector, detail", hcenter vcenter txtwrap  
putexcel B118= "Public Administration, aged 15-64", hcenter vcenter txtwrap  
putexcel C118= "Share of employed individuals working in the Public Administration sector, aged 15-64"
putexcel C118:Z118, merge left txtwrap

putexcel A119= "Sector, detail", hcenter vcenter txtwrap  
putexcel B119= "Other services, aged 15-64", hcenter vcenter txtwrap  
putexcel C119= "Share of employed individuals working in the Other services sector, aged 15-64"
putexcel C119:Z119, merge left txtwrap

putexcel A120= "Occupation", hcenter vcenter txtwrap  
putexcel B120= "Senior Officials, aged 15-64", hcenter vcenter txtwrap  
putexcel C120= "Share of employed individuals working in the  Senior Officials occupation group, aged 15-64"
putexcel C120:Z120, merge left txtwrap

putexcel A121= "Occupation", hcenter vcenter txtwrap  
putexcel B121= "Professionals, aged 15-64", hcenter vcenter txtwrap  
putexcel C121= "Share of employed individuals working in the  Professionals occupation group, aged 15-64"
putexcel C121:Z121, merge left txtwrap

putexcel A122= "Occupation", hcenter vcenter txtwrap  
putexcel B122= "Technicians, aged 15-64", hcenter vcenter txtwrap  
putexcel C122= "Share of employed individuals working in the  Technicians occupation group, aged 15-64"
putexcel C122:Z122, merge left txtwrap

putexcel A123= "Occupation", hcenter vcenter txtwrap  
putexcel B123= "Clerks, aged 15-64", hcenter vcenter txtwrap  
putexcel C123= "Share of employed individuals working in the Clerks occupation group, aged 15-64"
putexcel C123:Z123, merge left txtwrap

putexcel A124= "Occupation", hcenter vcenter txtwrap  
putexcel B124= "Service and Market Sales, aged 15-64", hcenter vcenter txtwrap  
putexcel C124= "Share of employed individuals working in the  Service and Market Sales occupation group, aged 15-64"
putexcel C124:Z124, merge left txtwrap


putexcel A125= "Occupation", hcenter vcenter txtwrap  
putexcel B125= "Skilled Agriculture, aged 15-64", hcenter vcenter txtwrap  
putexcel C125= "Share of employed individuals working in the Skilled Agriculture occupation group, aged 15-64"
putexcel C125:Z125, merge left txtwrap


putexcel A126= "Occupation", hcenter vcenter txtwrap  
putexcel B126= "Craft workers, aged 15-64", hcenter vcenter txtwrap  
putexcel C126= "Share of employed individuals working in the craft workers occupation group, aged 15-64"
putexcel C126:Z126, merge left txtwrap


putexcel A127= "Occupation", hcenter vcenter txtwrap  
putexcel B127= "Machine Operators, aged 15-64", hcenter vcenter txtwrap  
putexcel C127= "Share of employed individuals working in the  Machine Operators occupation group, aged 15-64"
putexcel C127:Z127, merge left txtwrap


putexcel A128= "Occupation", hcenter vcenter txtwrap  
putexcel B128= "Elementary occupations, aged 15-64", hcenter vcenter txtwrap  
putexcel C128= "Share of employed individuals working in the Elementary Occupations occupation group, aged 15-64"
putexcel C128:Z128, merge left txtwrap


putexcel A129= "Occupation", hcenter vcenter txtwrap  
putexcel B129= "Armed Forces, aged 15-64", hcenter vcenter txtwrap  
putexcel C129= "Share of employed individuals working in the  Armed Forces occupation group, aged 15-64"
putexcel C129:Z129, merge left txtwrap

putexcel A130= "Working Hours", hcenter vcenter txtwrap  
putexcel B130= "Average weekly working hours", hcenter vcenter txtwrap  
putexcel C130= "Mean of working hours for employed individuals aged 15-64"
putexcel C130:Z130, merge left txtwrap

putexcel A131= "Working Hours", hcenter vcenter txtwrap  
putexcel B131= "Underemployment, <35 hours per week", hcenter vcenter txtwrap  
putexcel C131= "Share of employed individuals aged 15-64 with working hours less than 35 hours per week"
putexcel C131:Z131, merge left txtwrap

putexcel A132= "Working Hours", hcenter vcenter txtwrap  
putexcel B132= "Excessive working hours,>48 hours per week", hcenter vcenter txtwrap  
putexcel C132= "Share of employed individuals aged 15-64 with working hours higher than 48 hours per week"
putexcel C132:Z132, merge left txtwrap


putexcel A133= "Working Hours", hcenter vcenter txtwrap  
putexcel B133= "Excessive working hours,>48 hours per week", hcenter vcenter txtwrap  
putexcel C133= "Share of employed individuals aged 15-64 with working hours higher than 48 hours per week"
putexcel C133:Z133, merge left txtwrap


putexcel A134= "Earnings", hcenter vcenter txtwrap  
putexcel B134= "Median earnings for wage workers per hour, local currency", hcenter vcenter txtwrap  
putexcel C134= "Median earnings for wage workers per hour aged 15-64 reported in local currency values. Currency values are typically reported for the year when the survey was conducted"
putexcel C134:Z134, merge left txtwrap

putexcel A135= "Earnings", hcenter vcenter txtwrap  
putexcel B135= "Median earnings for wage workers per month, local currency", hcenter vcenter txtwrap  
putexcel C135= "Median earnings for wage workers per month aged 15-64 reported in local currency values. Currency values are typically reported for the year when the survey was conducted"
putexcel C135:Z135, merge left txtwrap

putexcel A136= "Earnings", hcenter vcenter txtwrap  
putexcel B136= "Median earnings for wage workers per month in agriculture, local currency", hcenter vcenter txtwrap  
putexcel C136= "Median earnings in the agricultural sector for wage workers per month aged 15-64 reported in local currency values. Currency values are typically reported for the year when the survey was conducted"
putexcel C136:Z136, merge left txtwrap

putexcel A137= "Earnings", hcenter vcenter txtwrap  
putexcel B137= "Median earnings for wage workers per month in industry, local currency", hcenter vcenter txtwrap  
putexcel C137= "Median earnings in the industry sector for wage workers per month aged 15-64 reported in local currency values. Currency values are typically reported for the year when the survey was conducted"
putexcel C137:Z137, merge left txtwrap

putexcel A138= "Earnings", hcenter vcenter txtwrap  
putexcel B138= "Median earnings for wage workers per month in service, local currency", hcenter vcenter txtwrap  
putexcel C138= "Median earnings in the service sector for wage workers per month aged 15-64 reported in local currency values. Currency values are typically reported for the year when the survey was conducted"
putexcel C138:Z138, merge left txtwrap

putexcel A139= "Earnings", hcenter vcenter txtwrap  
putexcel B139= "Median earnings for wage workers per hour, deflated to 2010", hcenter vcenter txtwrap  
putexcel C139= "Median earnings for wage workers per hour aged 15-64, inflation corrected to 2010 values."
putexcel C139:Z139, merge left txtwrap


putexcel A140= "Earnings", hcenter vcenter txtwrap  
putexcel B140= "Median earnings for wage workers per hour, deflated to 2010 and PPP adjusted ", hcenter vcenter txtwrap  
putexcel C140= "Median earnings for wage workers per hour aged 15-64, inflation corrected to 2010 values and adjusted for purchasing power parity using WDI provided exchange values."
putexcel C140:Z140, merge left txtwrap

putexcel A141= "Earnings", hcenter vcenter txtwrap  
putexcel B141= "Median earnings for wage workers per month, deflated to 2010", hcenter vcenter txtwrap  
putexcel C141= "Median earnings for wage workers per month aged 15-64, inflation corrected to 2010 values."
putexcel C141:Z141, merge left txtwrap


putexcel A142= "Earnings", hcenter vcenter txtwrap  
putexcel B142= "Median earnings for wage workers per month, deflated to 2010 and PPP adjusted ", hcenter vcenter txtwrap  
putexcel C142= "Median earnings for wage workers per month aged 15-64, inflation corrected to 2010 values and adjusted for purchasing power parity using WDI provided exchange values."
putexcel C142:Z142, merge left txtwrap


putexcel A143= "Earnings", hcenter vcenter txtwrap  
putexcel B143= "Female to Male gender wage gap", hcenter vcenter txtwrap  
putexcel C143= "Female to Male gender wage gap for wage workers aged 15-64. Reports the ratio of female wage workers earnings to male wage workers earnings."
putexcel C143:Z143, merge left txtwrap


putexcel A144= "Earnings", hcenter vcenter txtwrap  
putexcel B144= "Public to Private wage gap", hcenter vcenter txtwrap  
putexcel C144= "Public to Private wage gap for wage workers aged 15-64. Reports the ratio of public wage workers earnings to private wage workers earnings."
putexcel C144:Z144, merge left txtwrap



putexcel A145= "Education attainment", hcenter vcenter txtwrap  
putexcel B145= "No education", hcenter vcenter txtwrap  
putexcel C145= "Share of individuals that have no education"
putexcel C145:Z145, merge left txtwrap

putexcel A146= "Education attainment", hcenter vcenter txtwrap  
putexcel B146= "Primary education", hcenter vcenter txtwrap  
putexcel C146= "Share of individuals that have passed primary education levels but no higher education levels"
putexcel C146:Z146, merge left txtwrap

putexcel A147= "Education attainment", hcenter vcenter txtwrap  
putexcel B147= "Secondary education", hcenter vcenter txtwrap  
putexcel C147= "Share of individuals that have passed secondary education levels but no higher education levels"
putexcel C147:Z147, merge left txtwrap

putexcel A148= "Education attainment", hcenter vcenter txtwrap  
putexcel B148= "Post-secondary education", hcenter vcenter txtwrap  
putexcel C148= "Share of individuals that have passed post-secondary education levels but no higher education levels"
putexcel C148:Z148, merge left txtwrap

putexcel A149="Pivot Data", font(italic[13pt]) fpattern(solid, red)
putexcel A149:H149, merge left txtwrap

putexcel A151= "Variable Name", hcenter vcenter txtwrap  
putexcel C151= "Short Definition", hcenter vcenter txtwrap 

putexcel A152="Gender", bold
putexcel C152="Gender of individual. Is either male or female and should be always given."

putexcel A153="Area", bold
putexcel C153="Location where the individual is living. Is either urban area or rural area."

putexcel A154="Age group", bold
putexcel C154="Reports the age group for each respective individual. There are three categories: 1. Young worker, which is everyone aged 15-24 years; 2. Older workers, which is everyone aged 25-64 years; 3. Missing, which is every younger than 15 or older than 64."
putexcel C154:Z154, merge left txtwrap

putexcel A155="Labor Force composition", bold
putexcel C15="Potential outcomes are: Employed, Unemployed, Non-LF and missing. Employed and unemployed are defined as above. Non-LF is defined as someone in working age but currently not actively participating in the labor force. One reason could be that the person is going to school. Missing inforamtion on this variable is due to missing information in the source data."
putexcel C155:Z155, merge left txtwrap

putexcel A156="Employment status", bold
putexcel C156="Employment status is either paid employee, self-employed, unpaid or employee. Definitions for the different status are given above. In case of no information or if the individual is not employed the respective cell is empty."

putexcel A157="Sector, detailed", bold
putexcel C157="Sector, detailes is defined according to ISIC norms specified above. In case of missing information on the variable or if the individual is not employed, the cell is empty."

putexcel A158="Education", bold
putexcel C158="Education is defined as above. Missing cells are either due to missing information or in case the person is below primary schooling age."

putexcel A159="Private vs. Public", bold
putexcel C159="Indicates whether the individual is working in a public or private job. Missing cells are either due to missing information or if the individual is not in employment."

putexcel A160="Informality status", bold
putexcel C160="Presents the informality status as defined above. Missing cells are either due to missing information or if the individual is not in employment."

putexcel A161="Population", bold
putexcel C161="Weighted sum of the population for the individual with the indicated characteristics."

putexcel A162="Working Age", bold
putexcel C162="Weighted sum of the working age population for individual with the indicated characteristics."


putexcel A163="Employment", bold
putexcel C163="Weighted sum of the employed population for individual with the indicated characteristics."


}


dis "", _newline(8)

dis as result `" The indicator file has now been created and stored in "$indicators" "'




end
