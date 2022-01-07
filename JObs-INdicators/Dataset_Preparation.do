

foreach var in  SSA SA MNA NA  ECA EAP LAC_NO_BRAZIL LAC_BRAZIL    {

use  "$source\`var'_2.0.dta", clear


foreach dummy in ccode sample year atschool everattend gender urb marital age industry njobs ocusec empstat lstatus edulevel1 edulevel2 edulevel3 educy wage unitwage whours contract wgt healthins literacy socialsec occup{
	cap gen `dummy'=.
} 
keep ccode sample year atschool everattend gender urb marital age industry njobs ocusec empstat lstatus edulevel1 edulevel2 edulevel3 educy wage unitwage whours contract wgt healthins socialsec occup literacy

		
global condALL age_x <3

****************************************************************************

split sample, p(_) gen(geo)
drop geo1 geo3
split geo4, parse(.) gen(survey)
capture drop survey2

replace survey1 = upper(survey1)

*egen survey_year=concat(geo2 survey1)
gen year_s = geo2 + " " + survey1
tab year_s



capture drop sample1

capture confirm string variable sample
                if !_rc {
                        gen sample1=sample
                }
                else {
                        encode sample, gen(sample1)
                }

label var sample1 "Survey Data Source"


*********************************************************************
****************** Variable Generation and Renames ******************
*********************************************************************

***	Create and Rename Variables	for tables and graphs

*** Gen gender and marital status 
	gen male = (gender==1)
	label def male 0"Female" 1"Male",modify
	label val male male
	tab male

	gen female = (gender==2)
	label def female 0"Male" 1"Female",modify
	label val female female
	tab female
	
label list lblgender
label define lblgenderSTR 1 "mal" 2 "fem"
label values gender lblgenderSTR 
decode gender, gen(genderSTR) 
label values gender lblgender

	g married=(marital!=2) if ~missing(marital)
	label def married 0"Single" 1"Ever Married",modify
	label val married married

*** Gen age range

	gen age_x=.
	replace age_x=1 if age >=15 & age <=24
	replace age_x=2 if age >=25 & age <=64
	label def age_x 1"15-24" 2"25-64"
	label val age_x age_x
	tab age_x,m



*Age group binary indicators 
gen byte child = (age < 15) if ~missing(age)
gen byte youth = (age >= 15 & age < 25) if ~missing(age)
gen byte workingage = (age >= 25 & age < 65) if ~missing(age)
gen byte elderly = (age >= 65) if ~missing(age)

label var child "Child (0-14)"
la de child 1 "Child (0-14)" 0 "Non-Child (15+)", replace
lab val child child

label var youth "Youth (15-24)"
la de youth 1 "Youth (15-24)" 0 "Non-Youth (0-14, 25+)", replace
lab val youth youth

la de workingage 1 "Working Age (25-64)" 0 "Non-Working Age (0-24 or 65+)", replace
label var workingage "Working Age (25-64)"
lab val workingage workingage

label var elderly "Elderly (65+)"
la de elderly  0 "Not elderly (0-64)" 1 "Elderly (65+)", replace
lab val elderly elderly

*** Gen variable (narrow) industry	
	gen industry__x=.
	replace industry__x=1 if industry==1
	replace industry__x=2 if industry==3
	replace industry__x=3 if industry==2 | industry==5
	replace industry__x=4 if industry==4 | (industry>=6 & industry<=10)
	label def industry__x 1"agriculture" 2"manufacturing" 3"mining and construction" 4"services",modify
	label val industry__x industry__x
	tab industry__x
		
	gen industry_x=industry__x
	replace industry_x=2 if industry_x==3
	replace industry_x=3 if industry_x==4
	label def industry_x 1"agriculture" 2"industry" 3"services",modify
	label val industry_x industry_x
	tab industry_x

*** Relabel public sector
	label def ocusec 1"Public" 2"Private", modify
	label val ocusec ocusec
	
	
	
*** Gen employed unemployed
	g employed=(lstatus==1)
	label define employed 0"Not Employed" 1"Employed",modify
	label val employed employed

	g unemployed=(lstatus==2)
	label define unemployed 0"Not Unemployed" 1"Unemployed",modify
	label val unemployed unemployed

	g non_LFP=(lstatus==3)
	label define non_LFP 0"In LF" 1"Non LF",modify
	label val non_LFP non_LFP 

*** Label empstat taking value 5 as others

label de lblocu 5 "Others", modify
	

*** Gen emp categories for graphs

gen byte emptype = .

					/*wage public*/
			
	replace emptype=1 if empstat==1 & ocusec==1
	
					/*wage private*/
	
	replace emptype=2 if empstat==1 & ocusec==2

				/*Self-employed Agriculture*/
	
	replace emptype=3 if empstat==4 & industry==1
			
			/*Self-employed Non-Agriculture*/
	
	replace emptype=4 if empstat==4 & industry!=1                      												

    			  	   /*Other*/

	replace emptype=5 if empstat==2 | empstat==3  | empstat==5 | (empstat==1 & ocusec==.)  | (empstat==4 & industry==.)  
	 

*	 label define lblemptype 1 "wage formal public" 2 "wage formal private" 3 "wage informal" 4 "Self-employed Agriculture" 5 "Self-employed Non-Agriculture"  6 "Other"

	 label define lblemptype 1 "Wage public" 2 "Wage private" 3 "Self-employed Agriculture" 4 "Self-employed Non-Agriculture"  5 "Other"
     label values emptype lblemptype	
	

	
**************************************************************************************************************
******************************** Wages ***********************************************************************	
**************************************************************************************************************	
	

*-- Hourly Wages
	gen hourly_wages =.
		replace hourly_wages = 5*wage/whours 		     if unitwage == 1 & $condALL & wage >=0 & wage!=.
		replace hourly_wages = wage/whours              if unitwage == 2 & $condALL & wage >=0 & wage!=.
		replace hourly_wages = (wage/2)/whours          if unitwage == 3 & $condALL & wage >=0 & wage!=.
		replace hourly_wages = (wage/2)/(4.345*whours)  if unitwage == 4 & $condALL & wage >=0 & wage!=.
		replace hourly_wages = wage/(4.345*whours)      if unitwage == 5 & $condALL & wage >=0 & wage!=.
		replace hourly_wages = (wage/3)/(4.345*whours)  if unitwage == 6 & $condALL & wage >=0 & wage!=.
		replace hourly_wages = wage/(4.345*12*whours)   if unitwage == 8 & $condALL & wage >=0 & wage!=.
		replace hourly_wages = wage                     if unitwage == 9 & $condALL & wage >=0 & wage!=.

* Monthly Wages		
gen wage_monthly = whours*4.345*hourly_wages



winsor2 hourly_wages, cuts(1 99) by(sample1) replace
winsor2 wage_monthly, cuts(1 99) by(sample1) replace
	



** Variables in local nominal currency for wage workers
gen wages_hourly_def=hourly_wages  if empstat==1  & $condALL
gen wages_monthly_def=wage_monthly if empstat==1 & $condALL
gen wages_monthly_def_agri=wages_monthly_def	if industry==1 & industry!=.
gen wages_monthly_def_indu=wages_monthly_def	if (industry==3 | industry==4 |  industry==5 | industry==2) & industry!=.
gen wages_monthly_def_serv=wages_monthly_def	if ((industry>=6 & industry<=10))  & industry!=.

label var wages_hourly_def 				"Median Earnings for wage workers per hour, local nominal currency"
label var wages_monthly_def 			"Median Earnings for wage workers per month, local nominal currency"
label var wages_monthly_def_agri		"Median Earnings for wage workers per month in agriculture, local nominal currency"
label var wages_monthly_def_indu		"Median Earnings for wage workers per month in industry, local nominal currency"
label var wages_monthly_def_serv		"Median Earnings for wage workers per month in service, local nominal currency"

compress
*** Real wages

	sort ccode year
	merge ccode year using   "$data\CPI_PPP_adjusted"  // Note that this has all PPP values adjusted to 2011 in the merged database. This would need to be redone in case of change or update! It also means this works only when values are first deflated and then ppp adjusted.
	
	
	
	keep if _merge==3  
	drop _merge	
	compress
	gen CPI_deflator=cpi2011
	label var CPI_deflator "CPI Deflator"
	
drop geo2 geo4 geo5 geo6 geo7 geo8 geo9 lendingtype lendingtypename pa_nus_prvt_pp fp_cpi_totl year_cpi_2011 
*	gen wage_real=wage/CPI_deflator if wage>0 & wage!=.  & age>=15 & age<=64
*	label var wage_real "Wage earnings, constant 2010 values" 

	gen wages_hourly_def_real=wages_hourly_def/CPI_deflator 			if wage>0 & wage!=.  & age>=15 & age<=64 & empstat==1	
	gen wages_monthly_def_real=wages_monthly_def /CPI_deflator 			if wage>0 & wage!=.  & age>=15 & age<=64 & empstat==1	
	gen earnings_monthly_def_real=wage_monthly/CPI_deflator 			if wage>0 & wage!=.  & age>=15 & age<=64	
	gen earnings_hourly_def_real=hourly_wages /CPI_deflator 			if wage>0 & wage!=.  & age>=15 & age<=64	
	
	label var wages_hourly_def_real 		"Median Earnings for wage workers per hour,  deflated to 2010 local currency values"
	label var wages_monthly_def_real 		"Median Earnings for wage workers per month, deflated to 2010 local currency values"
	
		
*** Generate PPP

	gen 	wages_hourly_usd=wages_hourly_def_real/ppp			 	  		if  empstat==1						 				
	gen 	wages_monthly_usd=wages_monthly_def_real/ppp					if  empstat==1
	gen 	earnings_hourly_usd=earnings_monthly_def_real/ppp	
	gen 	earnings_monthly_usd=earnings_hourly_def_real/ppp
		    

	label var wages_hourly_usd 		 "Real Median Hourly  Wages in USD (base 2010), PPP adjusted"
	label var wages_monthly_usd 	 "Real Median Monthly Wages in USD (base 2010), PPP adjusted"
	label var earnings_monthly_usd   "Real Median Monthly Earnings in USD (base 2010), PPP adjusted"
	label var earnings_hourly_usd    "Real Median Hourly  Earnings in USD (base 2010), PPP adjusted"
	


*** Urban vs Rural

label list lblurb
label define lblurbSTR 1 "urb" 2 "rur"
label values urb lblurbSTR 
decode urb, gen(urbSTR) 
label values urb lblurb


   		g gen_urb=.
		replace gen_urb=1 if urb==2 & gender==1 
		replace gen_urb=2 if urb==2 & gender==2
		replace gen_urb=3 if urb==1 & gender==1 
		replace gen_urb=4 if urb==1 & gender==2 	

la var gen_urb "Urban-Sex"
la def gen_urb 1"Rural-Male" 2"Rural-Female" 3"Urban-Male" 4"Urban-Female"
la val gen_urb gen_urb



   		g gen_age=.
		replace gen_age=1 if age_x==1 & gender==1 
		replace gen_age=2 if age_x==1 & gender==2
		replace gen_age=3 if age_x==2 & gender==1 
		replace gen_age=4 if age_x==2 & gender==2 	

la var gen_age "Age-Gender"
la def gen_age 1"Male(15-24) " 2"Female(15-24) " 3"Male(25-64)" 4"Female(25-64)"
la val gen_age gen_age

compress
*** Informal Workers Definition

* Available Variables:
capture gen contract=.
capture gen healthins=.
capture gen socialsec=.
g no_contract=(contract==0) if ~missing(contract)
replace no_contract=2 if contract==.
la var no_contract "No contract"
	label def no_contract 0"With Contract" 1"Without Contract" 2"Contract unknown",modify
	label val no_contract no_contract

g no_healthins=(healthins==0) if ~missing(healthins)
replace no_healthins=2 if healthins==.
la var no_healthins "No Health Insurance"
	label def no_healthins 0"With Insurance" 1"Without Insurance" 2"Insurance Unknown",modify
	label val no_healthins no_healthins
	
g no_socialsec=(socialsec==0) if ~missing(socialsec)
replace no_socialsec=2 if socialsec==.
la var no_socialsec "No Social Security"
	label def no_socialsec 0"With Social Sec." 1"Without Social Sec." 2"Social Sec. Unknown",modify
	label val no_socialsec no_socialsec


/*Old code
*** Informality: Basic Definition with Social Security and empstat 
gen informal= (empstat==2 | (empstat==1 & socialsec==0) | (empstat==3 & socialsec==0) | (empstat==4 & socialsec==0)) if ~missing(socialsec)
replace informal=. if empstat==.
replace informal=. if empstat!=2 & socialsec==.
replace informal=2 if informal==. & lstatus==1
label define informal 2 "informality unknown" 1 "informal" 0 "formal", replace

*/

*New code

gen informal=0 if empstat==1 & (contract<=1 | socialsec<=1)
replace informal=1 if empstat==1 & (socialsec==0 | contract==0)

label define informal  1 "informal" 0 "formal", replace
label values informal informal
label var informal "Informality status"	


*** Informality: Wide definition with social security, contract or health insurance

gen informal_ext=0		 if contract!=. | healthins!=. | socialsec!=.
replace informal_ext=1 	 if contract==0 | healthins==0 | socialsec==0	

label val informal_ext informal	
label var informal_ext "Wide informality definition"


*** Informality: Narrow definition with social security, contract and health insurance

gen informal_narrow=0 		if contract!=. & healthins!=. & socialsec!=.
replace informal_narrow=1 	if contract==0 & healthins==0 & socialsec==0	

label val informal_narrow informal	
label var informal_narrow "Narrow informality definition"


** Industry variable
capture drop industry1

gen industry1=1 if industry==1
replace industry1=2 if industry==2 | industry==3 | industry==4 | industry==5
replace industry1=3 if industry==6 | industry==7 | industry==8 | industry==9 
replace industry1=4 if industry==10

label def add_indu 1 "Agriculture" 2 "Industry" 3 "Services" 4 "Other"
label val industry1 add_indu
	
replace industry1=3 if industry1==4
label def indu_1 1 "Agriculture" 2 "Industry" 3 "Services and Other"
label val industry1 indu_1




* underemployment: if works less than 35 hours per week

gen underemployed=(whours<35) if employed==1 & whours!=.
la var underemployed "Underemployed < 35 hours/week"

label define underemployed 1 "underemployed" 0 "not underemployed", replace
label values underemployed underemployed


capture gen countryname="$y"
label var countryname "Countryname"


compress


*** Introduce edulevel variable of choice
	gen miss_bin_edulevel1=(edulevel1==.)
	bys sample: egen miss_mean_edulevel1=mean(miss_bin_edulevel1)

	gen miss_bin_edulevel2=(edulevel2==.)
	bys sample: egen miss_mean_edulevel2=mean(miss_bin_edulevel2)
	
	gen miss_bin_edulevel3=(edulevel3==.)
	bys sample: egen miss_mean_edulevel3=mean(miss_bin_edulevel3)
	
	quietly: summarize miss_mean_edulevel1
	local average_miss_edulevel1 = r(mean)
	
	quietly: summarize miss_mean_edulevel2
	local average_miss_edulevel2 = r(mean)
	
	quietly: summarize miss_mean_edulevel3
	local average_miss_edulevel3 = r(mean)

	*ignoring edulevel1 for now:
	if `average_miss_edulevel2'<=`average_miss_edulevel3' {
		gen edulevelSEL = edulevel2
		label def edulevelSEL 1 "No education" 2 "Primary incomplete" 3 "Secondary incomplete" 4 "Secondary complete" 5 "Some tertiary/post-secondary"
		label val edulevelSEL edulevelSEL
	}
	else {
		gen edulevelSEL = edulevel3
		label val edulevelSEL lbledulevel3 
	}
	label var edulevelSEL "Level of Education"
	
	drop miss_bin_edulevel1 miss_mean_edulevel1
	drop miss_bin_edulevel2 miss_mean_edulevel2 
	drop miss_bin_edulevel3 miss_mean_edulevel3


gen low_edu=0 		if edulevelSEL==3 | edulevelSEL==4
replace low_edu=1 	if edulevelSEL==1 | edulevelSEL==2 

compress


save "$data\`var'_prepared.dta", replace
}
