* Author: Jörg Langbein


* Generate  dataset

* Set folder
global Data "This is the folder where all datasets, including the WDI, EU etc. datasets are stored. You can also store your input data there"
global Pivot "This is the folder where JOIN_Benchmarking_Data.csv is stored" 

global condALL age_x <3



** Load input data
use  year ccode sample sample1 gender urb age_x industry empstat edulevelSEL lstatus ocusec informal occup educy wages_monthly_usd whours age wgt countryname wages_hourly_usd earnings_hourly_usd earnings_monthly_usd  low_edu industry industry1 sh_underemp sh_excemp using "This is your input data you want to add", clear


compress 

cap replace wgt=wgt*1000 if sample_type=="eulfs" // Change weights for population etc. for EULFS surveys

keep year ccode sample sample1 gender urb age_x industry empstat edulevelSEL lstatus ocusec informal occup educy wages_monthly_usd whours age wgt countryname wages_hourly_usd earnings_hourly_usd earnings_monthly_usd  low_edu industry industry1 sh_underemp sh_excemp



compress 

** Prepare the data


* Create totals for population (including unknowns), working age and employed
gen  pop=1
gen  pop_gender=1    if gender==.
gen  pop_area=1  	if urb==.
gen  pop_age=1   	if age==.
gen  pop_child=1  	if age>=0 & age<=14
gen  pop_old=1		if age>=65 & age!=. 
gen  wka=1 			if $condALL
gen  emp=1 			if lstatus==1 & $condALL

label var pop "Population"
label var wka "Working age (15-64)"
label var emp "Employed"
label var pop_gen "Population (unknown gender)"
label var pop_area "Population (unknown area)"
label var pop_age  "Population (unknown age)"
label var pop_child "Children (<15)"
label var pop_old	"Old Age (65+)"



* Create age groups
gen age_group=1 if age>=0 & age<=14
replace age_group=2 if age>=15 & age<=24
replace age_group=3 if age>=25 & age<=64
replace age_group=4 if age>=65 & age!=.
replace age_group=5 if age==.
label def age_group 1 "1. Children (0-14)" 2 "2. Youth (15-24)" 3 "3. Adult (25-64)"  4 "4. Elderly (65+)" 5 "5. Unknown"
label val age_group age_group
label var age_group "Age group"




* Change to unknwon for gender and urban as important disaggregations
replace gender=3 if gender>2

label def gender2 1 "Male" 2 "Female" 3 "Unknown"
label val gender gender2

replace urb=3 if urb>2
label def urban2 1 "Urban" 2 "Rural" 3 "Unknown"
label val urb urban2
label var urb "Area"


*Recoding variables
replace lstatus=. 					 if age_group==1 | age_group==4  |  age_group==5
replace empstat=. 					 if age_group==1 | age_group==4  |  age_group==5 | lstatus!=1 | empstat>4 | empstat==-1
replace informal=. 				     if age_group==1 | age_group==4  |  age_group==5 | lstatus!=1 | informal>1
replace industry=. 				 	 if age_group==1 | age_group==4  |  age_group==5 | lstatus!=1 | industry>10
replace ocusec=.   					 if age_group==1 | age_group==4  |  age_group==5 | lstatus!=1 
replace occup=.    					 if age_group==1 | age_group==4  |  age_group==5 | lstatus!=1 | occup>10 | occup==0
replace wages_monthly_usd=.			 if age_group==1 | age_group==4  |  age_group==5 | lstatus!=1 | empstat!=1
replace industry1=. 				 if age_group==1 | age_group==4  |  age_group==5 | lstatus!=1 | industry1>10
replace wages_hourly_usd=.  		 if age_group==1 | age_group==4  |  age_group==5 | lstatus!=1 | empstat!=1 | whours==. | whours==0
replace earnings_hourly_usd=.  		 if age_group==1 | age_group==4  |  age_group==5 | lstatus!=1 | whours==. | whours==0
replace earnings_monthly_usd=.  	 if age_group==1 | age_group==4  |  age_group==5 | lstatus!=1
replace sh_underemp=.				 if age_group==1 | age_group==4  |  age_group==5 | lstatus!=1
replace sh_excemp=.					 if age_group==1 | age_group==4  |  age_group==5 | lstatus!=1
replace edulevelSEL=. 				 if edulevelSEL>4  
replace ocusec=.					 if ocusec>2 | age_group==1 | age_group==4  | lstatus!=1
replace whours=.					 if lstatus!=1  | age_group==1 | age_group==4 |  age_group==5

compress

label var industry1 "Sector broad"
label var industry "Sector detailed"
label var lstatus "Labor Force composition"
label var edulevelSEL "Education level"
label var ocusec "Private vs Public Sector"
label var occup "Occupation detailed"
label var age "Sum of age"
label var educy "Years of education"
label var wages_monthly_usd "Month Wage USD ppp adjusted"
label var wages_hourly_usd  "Hour Wage USD ppp adjusted"
label var earnings_monthly_usd "Real Monthly Earnings (USD base 2010) ppp adjusted"
label var earnings_hourly_usd  " Real Hourly  Earnings (USD base 2010) ppp adjusted"
label var whours "Hours of work in last week"
label var countryname "Country Name"
label var edulevelSEL "Education level"
label var sh_underemp "Underemp less 35 hr per week" 
label var sh_excemp   "Excessive work above 48 hr per wk" 
label var informal "Informality status"
label var empstat "Employment status"

replace industry1=3 if industry1==4
label def industry_add 1 "Agriculture" 2 "Industry" 3 "Services and other"
label val industry1 industry_add

gen  unem_people=1   if lstatus==2	& $condALL
label var unem_people    "Unemployed"

replace low_edu=. if edulevelSEL==.
label def low_edu 0 "High Education" 1 "Low Education"
label val low_edu low_edu
label var low_edu "Education Low High"

gen  whours_people=1 if whours!=. & $condALL
label var whours_people "Hours of work in last week Resp"

gen  age_people=1 	if age!=.
label var age_people "Sum of age Resp"

gen  educy_people=1  if educy!=.
label var educy_people 	 "Years of education Resp"


gen  underemployed_people=1 if sh_underemp!=.
label var underemployed_people "Underemp less 35 hr per week Resp"

gen  wages_people_monthly=1 	if wages_monthly_usd!=. 
label var wages_people_monthly "Month Wage USD ppp adj Resp"

gen  wages_people_hourly=1 if wages_hourly_usd!=. 
label var wages_people_hourly "Hour wage USD ppp adj Resp"

gen  earnings_people_hourly=1 if earnings_hourly_usd!=. 
label var earnings_people_hourly "Sum of number of respondents used for hourly earnings calculation, age 15-64"

gen  earnings_people_monthly=1 if earnings_monthly_usd!=. 
label var earnings_people_monthly "Sum of number of respondents used for monthly earnings calculation, age 15-64"

** - Process for country_sample --*
* Create country sample variable, clean it to have only survey info, no file or other info
gen country_sample = sample1

* Now differentiate between I2D2 and GLD / GMD cases
gen cs_type = .
replace cs_type = 1 if regexm(country_sample, "_GLD|_GMD")
replace cs_type = 2 if regexm(country_sample, "_i2d2|_I2D2")

* Drop dta at the end (once as it should be in there only once)
replace country_sample = subinstr(country_sample, ".dta", "", 1)

* Find in CCC_YYYY_SURV_V0#_M_V0#_A_[GLD/GMD]_...
* the string where "_A_" begins, keep anything before
gen cs_glmd_pos = strpos(country_sample, "_A_") if cs_type == 1
replace country_sample = substr(country_sample, 1, cs_glmd_pos + 1) if cs_type == 1

* Use process as was for I2D2, expand it
replace country_sample = subinstr(country_sample, "_i2d2", "", .) if cs_type == 2
replace country_sample = subinstr(country_sample, "_i2d2_", "_", 1) if cs_type == 2
replace country_sample = subinstr(country_sample, "_I2D2_", "_", 1) if cs_type == 2

drop cs_type cs_glmd_pos
* End process for country_sample

label var country_sample "Sample Description"


local label "pop pop_gender pop_area pop_age pop_child pop_old wka emp age age_people educy educy_people whours whours_people wages_monthly_usd wages_people_monthly  wages_hourly_usd wages_people_hourly unem_people sh_underemp sh_excemp"


foreach x in `label'{
local l`x' : variable label `x' 
}

collapse (sum) `label' [pw=wgt], by (countryname ccode year country_sample gender urb age_group industry1 industry empstat edulevelSEL lstatus ocusec informal occup low_edu)


foreach x in `label'{
label var `x' "`l`x''" 
}

** Add standard indicators like fragility etc. Needs to be updated each year!


drop countryname 

merge m:m ccode year using "$Data\WDI.dta"
drop if _merge==2
drop _merge
drop  region_iso2 adminregion_iso2 incomelevel_iso2 lendingtype_iso2 capital latitude longitude
drop ny_gdp_totl_rt_zs
drop incomelevel incomelevelname
drop adminregion adminregionname

compress
* Add Demographics, EU, Resource, FCS 

merge m:m ccode using "$Data\Summary.dta"
drop if _merge==2
drop _merge
compress

rename EuropeanUnion EU
label var Resource "Resource Rich"
rename FCS fragile
label var fragile "Fragile and conflict affected"
replace fragile="Not FCS" if fragile==""
replace fragile="FCS" if fragile=="Fragile and conflict affected situations"


* Add GDP_Deciles

merge m:m ccode year using "$Data\GDP_deciles.dta"
drop if _merge==2
drop _merge
label var decile "Income Decile"

* Add incomelevel
merge m:m ccode year using "$Data\Income.dta"
drop if _merge==2
drop _merge
compress

gen Income_Level=Income
replace Income_Level="High income" if Income_Level=="H"
replace Income_Level="Upper middle income" if Income_Level=="UM"
replace Income_Level="Lower middle income" if Income_Level=="LM"
replace Income_Level="Low income" 		   if Income_Level=="L"


label var Income "Income Level Code Over Time"
label var Income_Level "Income Level Over Time"

replace region="XXX" /// This is your region. It varies between MNA, SA, SSA, LAC, ECA, EAP, NA 

cap replace urb=2 if urb==0 & country_sample=="lbr_2016_hies"


foreach x in pop pop_gender pop_area pop_age pop_child pop_old wka emp unem_people age age_people educy educy_people wages_monthly_usd wages_people_monthly wages_hourly_usd wages_people_hourly sh_underemp sh_excemp whours whours_people{ 
replace `x'=round(`x', 0.0000001) 
}


keep countryname country_sample year ccode decile Income_Level Income regionname region lendingtypename fragile EU Demographic Resource gender urb age_group lstatus empstat industry1 industry occup low_edu edulevelSEL ocusec informal pop pop_gender pop_area pop_age pop_child pop_old wka emp unem_people age age_people educy educy_people wages_monthly_usd wages_people_monthly wages_hourly_usd wages_people_hourly sh_underemp sh_excemp whours whours_people

order countryname  year country_sample ccode decile Income_Level Income regionname region lendingtypename fragile EU Demographic Resource gender urb age_group lstatus empstat industry1 industry occup low_edu edulevelSEL ocusec informal pop pop_gender pop_area pop_age pop_child pop_old wka emp unem_people age age_people educy educy_people wages_monthly_usd wages_people_monthly wages_hourly_usd wages_people_hourly sh_underemp sh_excemp whours whours_people

export delimited using "$Pivot\YOUR FILE'", replace 

save "$Pivot\YOUR FILE.dta", replace


clear

import delimited using "Pivot\CSV\JOIN_Benchmarking_Data.csv"
append using "$Pivot\YOUR FILE'.csv"	
