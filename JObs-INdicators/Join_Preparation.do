*********************************************************************
*** Indicators / Join ***********************************************
*********************************************************************
foreach var in   SSA LAC_NO_BRAZIL EAP {

use "$data\`var'_prepared", clear

global condALL age_x <3

	
** NLFE
gen NLFE=lstatus  if age_x==1
replace NLFE=4 if lstatus==3 & atschool!=1 & age_x==1

	la de NLFE 1 "Employed" 2 "Unemployed" 3 "Inactive but in Education" 4 "Inactive and not in Education (or unknown)", replace
	lab val NLFE NLFE
	label var NLFE "Not in Labor Force or Education"

		

		
***************************************************************************************************************************************************************************		
		
		
*** Basics LM indicators

* Socio-Demographics
	gen no_pop_=1
	label var no_pop_ "Total population"

	gen byte sh_child_   = (age < 15) if age!=.
	gen byte sh_youth_   = (age >= 15 & age < 25) if age!=.
	gen byte sh_adult_ 	 = (age >= 25 & age < 65) if age!=.
	gen byte sh_elderly_ = (age >= 65) if age!=.
	gen byte sh_urb_	 = (urb==1)   if urb!=.
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
	gen no_lf_numb=1 if (lstatus==1 | lstatus==2) & $condALL

* Shares
	gen byte sh_lf_ =  1 if (lstatus==1 | lstatus==2)   & $condALL
	replace sh_lf_	=  0 if lstatus==3 & lstatus!=. 	& $condALL
	
	gen byte sh_lf_fem 	 		= 1 if (lstatus<=2)  & $condALL    & gender==2
	replace sh_lf_fem			=0 if lstatus==3 & lstatus!=. & $condALL & gender==2

	
	gen agemin= 1 if age<=14
	gen agemax= 1 if age>=65 & age!=.
	gen ageint= 1 if age>=15 & age<=64
	gen byte sh_empl_ 			= (lstatus == 1) if lstatus!=.   & $condALL
	gen byte sh_empr_all 		= (lstatus==1)   if lstatus<=2   & $condALL
	gen byte sh_empr_young 		= (lstatus==1)   if lstatus<=2   & $condALL   & age_x==1
	gen byte sh_unempr_all 		= (lstatus==2)   if lstatus<=2   & $condALL
	gen byte sh_unempr_young 	= (lstatus==2)   if lstatus<=2   & $condALL   & age_x==1
	gen byte sh_nlfe_young		= (NLFE==4)      if $condALL     & lstatus!=. & age_x==1
	
	

	la var no_lf_numb			"Labor Force, aged 15-64"
	label var sh_lf_ 			"Labor Force Participation Rate, aged 15-64"
	label var sh_lf_fem 		"Female Labor Force Participation Rate, aged 15-64"
	label var sh_empr_young 	"Youth Employment Rate, aged 15-24"
	label var sh_empl_ 			"Employment to Population Ratio, aged 15-64"
	label var sh_empr_all 		"Employment Rate, aged 15-64 "
	label var sh_unempr_all 	"Unemployment Rate, aged 15-64"
	label var sh_unempr_young 	"Youth Unemployment Rate, aged 15-24"
	label var sh_nlfe_young		"Not in labor force or education rate among youth, aged 15-24"
	

	
** Employment Type
replace empstat=. if (empstat>4 | empstat<1)
gen byte sh_wage_ =1  if lstatus==1 	 	& $condALL & empstat!=. & empstat==1 	
replace sh_wage_  =0  if lstatus==1 	 	& $condALL & empstat!=. & empstat!=1 
gen byte sh_unpaid_ =1  if lstatus==1 	 	& $condALL & empstat!=. & empstat==2 		
replace sh_unpaid_  =0  if lstatus==1 	 	& $condALL & empstat!=. & empstat!=2 
gen byte sh_emps_ =1  if lstatus==1 	 	& $condALL & empstat!=. & empstat==3 		
replace sh_emps_  =0  if lstatus==1 	 	& $condALL & empstat!=. & empstat!=3 
gen byte sh_self_ =1  if lstatus==1 	 	& $condALL & empstat!=. & empstat==4 		
replace sh_self_  =0  if lstatus==1 	 	& $condALL & empstat!=. & empstat!=4 
gen byte sh_missing__ = . if lstatus==1 	 & $condALL & empstat==. 


replace ocusec=. if ocusec>2 
gen byte sh_pub_ = 1  if lstatus==1 		& $condALL & ocusec!=. & ocusec==1 
replace sh_pub_ = 0  if lstatus==1 			& $condALL & ocusec!=. & ocusec==2



	gen byte sh_informal_ = 0 				if lstatus==1 & $condALL & informal==0
	replace sh_informal_  = 1				if lstatus==1 & $condALL & informal==1
	gen byte sh_formal_   = 1				if sh_informal==0
	replace  sh_formal_   = 0 				if sh_informal==1
	gen byte sh_formal_miss_ = 0		  	if lstatus==1 & $condALL & empstat==1
	replace  sh_formal_miss_ = 1 		  	if lstatus==1 & $condALL & informal>1 & empstat==1
	
	gen byte sh_informal_ext =0 if lstatus==1 & $condALL & (contract!=. | socialsec!=.) 
	replace  sh_informal_ext =1 if lstatus==1 & $condALL & (contract==1 | socialsec==1)
	label var sh_informal_ext "Wide informality definition"
	
	
	gen byte sh_informal_narrow =0 if lstatus==1 & $condALL & (contract!=. & socialsec!=.) 
	replace informal_narrow     =1 if lstatus==1 & $condALL & (contract==1 & socialsec==1)
	label var sh_informal_narrow "Narrow informality definition"
	
	
	
	gen byte sh_informal_non_ag=0 if lstatus==1 & industry>1 & industry!=. &  informal==0 & $condALL
	replace sh_informal_non_ag=1  if lstatus==1 & industry>1 & industry!=. &  informal==1 & $condALL   
	
	label var sh_informal_non_ag "Non-Ag Informalitye (old definition)"
	
	
	gen byte sh_informal_non_ag_wide=0  if lstatus==1 & industry>1 & industry!=. & $condALL & informal_ext==0
	replace  sh_informal_non_ag_wide=1  if lstatus==1 & industry>1 & industry!=. &  informal_ext==1 & $condALL  
	
	label var sh_informal_non_ag_wide "Non-Ag Informality (wide definition)"
	
	
	
	gen byte sh_secondary=njobs			if lstatus==1	& $condALL 	
	
	
	
	label var sh_wage_ 		"Wage employees, aged 15-64 "
	label var sh_unpaid_ 	"Unpaid, aged 15-64"
	label var sh_emps_		"Employers, aged 15-64" 
	label var sh_self_ 		"Self-employed, aged 15-64"
	label var sh_missing__  " missing - employment status-"
	label var sh_pub_ 			"Public sector employment, aged 15-64"
	label var sh_informal_ 	 	"Informal jobs, aged 15-64"
	label var sh_formal_ 		"Formal jobs, aged 15-64"
	label var sh_formal_miss_ 	"Employed with missing formality information, aged 15-64"
	label var sh_secondary		"Share of workers (aged 15-64) with more than one jobs in last week"

	

	
** Sector 
	replace industry=. if industry>10
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

** Age and non-ag wage work

	gen byte sh_non_ag_wage = 0 if lstatus==1 & empstat!=. & $condALL
	replace sh_non_ag_wage  = 1 if lstatus==1 & ((industry>=2 & industry<=10)) & empstat==1	& $condALL
	
	
	gen byte sh_non_ag_unpaid = 0 if lstatus==1 & empstat!=. & $condALL
	replace sh_non_ag_unpaid  = 1 if lstatus==1 & ((industry>=2 & industry<=10)) & empstat==2	& $condALL
	
	
	gen byte sh_non_ag_empl = 0 if lstatus==1  &  empstat!=. & $condALL
	replace sh_non_ag_empl  = 1 if lstatus==1  & ((industry>=2 & industry<=10)) & empstat==3	& $condALL
	
	
	gen byte sh_non_ag_se = 0 if lstatus==1  & empstat!=. & $condALL
	replace sh_non_ag_se  = 1 if lstatus==1  & ((industry>=2 & industry<=10)) & empstat==4	& $condALL

	gen byte sh_non_ag_wage_young = 0 if lstatus==1 & industry==1 & empstat!=. & age_x==1
	replace sh_non_ag_wage_young  = 1 if lstatus==1 & ((industry>=2 & industry<=10)) & empstat==1 & age_x==1

** wage work by sector	
	gen byte sh_ag_wage = 0 if lstatus==1 & industry==1 & empstat!=1 & empstat!=. & $condALL
	replace sh_ag_wage  = 1 if lstatus==1 & industry==1 & empstat==1	& $condALL
	
	gen byte sh_indu_wage = 0 if lstatus==1 & (industry==3 | industry==4 |  industry==5 | industry==2) & empstat!=1 & empstat!=. & $condALL
	replace sh_indu_wage  = 1 if lstatus==1 & (industry==3 | industry==4 |  industry==5 | industry==2) & empstat==1	& $condALL
	
	gen byte sh_serv_wage = 0 if lstatus==1 & ((industry>=6 & industry<=10))  & empstat!=1 & empstat!=. & $condALL
	replace sh_serv_wage  = 1 if lstatus==1 & ((industry>=6 & industry<=10))  & empstat==1	& $condALL
	
	
	label var sh_agr_det    	"Agriculture, aged 15-64"
	label var sh_ind_min    	"Mining, aged 15-64"
	label var sh_ind_manu		"Manufacturing, aged 15-64"
	label var sh_ind_pub		"Electricity and utilities, aged 15-64"
	label var sh_ind_cons   	"Construction, aged 15-64"
	label var sh_serv_com   	"Commerce, aged 15-64"
	label var sh_serv_trans 	"Transport & Communication, aged 15-64"
	label var sh_serv_fbs 		"Financial and Business Services, aged 15-64"
	label var sh_serv_pa 		"Public Administration, aged 15-64"
	label var sh_serv_rest  	"Other services, aged 15-64"
	label var sh_non_ag_wage 	"Non-Agricultural wage employment, aged 15-64"
	label var sh_non_ag_unpaid  "Non-Agricultural unpaid employment, aged 15-64"
	label var sh_non_ag_empl		"Non-Agricultural employer, aged 15-64"
	label var sh_non_ag_se			"Non-Agricultural self-employed, aged 15-64"
	label var sh_non_ag_wage_young "Youth Non-Agricultural wage employment, aged 15-24"
	label var sh_ag_wage			"Wage employment in agriculture, aged 15-64"
	label var sh_indu_wage			"Wage employment in industry, aged 15-64"
	label var sh_serv_wage			"Wage employment in services, aged 15-64"

** Occupation

replace occup=. if occup>10 | occup==0

gen byte sh_occup_senior_ =1  	 if lstatus==1  & $condALL  & occup!=. & occup==1
replace sh_occup_senior_	 =0  if lstatus==1  & $condALL  & occup!=. & occup!=1
gen byte sh_occup_prof_	 =1  if lstatus==1  & $condALL  & occup!=. & occup==2
replace sh_occup_prof_	 =0  if lstatus==1  & $condALL  & occup!=. & occup!=2
gen byte sh_occup_techn_	 =1  if lstatus==1  & $condALL  & occup!=. & occup==3
replace sh_occup_techn_	 =0  if lstatus==1  & $condALL  & occup!=. & occup!=3	
gen byte sh_occup_clerk_	 =1  if lstatus==1  & $condALL  & occup!=. & occup==4
replace sh_occup_clerk_	 =0  if lstatus==1  & $condALL  & occup!=. & occup!=4
gen byte sh_occup_servi_	 =1  if lstatus==1  & $condALL  & occup!=. & occup==5
replace sh_occup_servi_	 =0  if lstatus==1  & $condALL  & occup!=. & occup!=5		
gen byte sh_occup_skillagr_	 =1  if lstatus==1  & $condALL  & occup!=. & occup==6
replace sh_occup_skillagr_	 =0  if lstatus==1  & $condALL  & occup!=. & occup!=6			
gen byte sh_occup_craft_	 =1  if lstatus==1  & $condALL  & occup!=. & occup==7
replace sh_occup_craft_	 =0  if lstatus==1  & $condALL  & occup!=. & occup!=7		
gen byte sh_occup_machi_	 =1  if lstatus==1  & $condALL  & occup!=. & occup==8
replace sh_occup_machi_	 =0  if lstatus==1  & $condALL  & occup!=. & occup!=8		
gen byte sh_occup_eleme_	 =1  if lstatus==1  & $condALL  & occup!=. & occup==9
replace sh_occup_eleme_	 =0  if lstatus==1  & $condALL  & occup!=. & occup!=9			
gen byte sh_occup_armed_	 =1  if lstatus==1  & $condALL  & occup!=. & occup==10
replace sh_occup_armed_	 =0  if lstatus==1  & $condALL  & occup!=. & occup!=10	


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

*	bys ccode year sample1: egen byte mean_hours_=mean(whours) if whours!=. & whours !=0 & lstatus==1 & $condALL
	gen sh_excemp=0 			if whours!=.  & whours !=0 & lstatus==1 & $condALL
	replace sh_excemp=1 		if whours>48 & whours!=. & whours !=0 & lstatus==1 & $condALL
		
	gen 	sh_underemp=0  		if whours!=.  & whours !=0 & lstatus==1 & $condALL
	replace sh_underemp=1  		if whours<35  & whours !=0 & lstatus==1 & $condALL
	
	gen whours_used=whours		if whours!=.  & whours !=0 & lstatus==1 & $condALL
*	label var mean_hours_ 		"Average weekly working hours"
	label var sh_excemp   		"Excessive working hours,>48 hours per week"
	label var sh_underemp 		"Underemployment, <35 hours per week"


* Skills	
** Education	
replace edulevelSEL=. if edulevelSEL>4
	gen byte sh_no_educ_ 		= (edulevelSEL==1) 					if edulevelSEL!=. & $condALL
	gen byte sh_prim_educ_ 		= (edulevelSEL==2) 					if edulevelSEL!=. & $condALL
	gen byte sh_sec_educ_		= (edulevelSEL==3) 					if edulevelSEL!=. & $condALL
	gen byte sh_postsec_educ_ 	= (edulevelSEL==4) 					if edulevelSEL!=. & $condALL

	label var sh_no_educ_ " No Education"
	label var sh_prim_educ_ " Primary Education" 
	label var sh_sec_educ_ " Secondary Education"
	label var sh_postsec_educ_ " Post Secondary Education"	
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

** Create mean wage variables	
	clonevar mean_wages_hourly_def=wages_hourly_def 
	label var mean_wages_hourly_def "Mean Earnings for wage workers per hour, local nominal currency"
	
	clonevar mean_wages_monthly_def=wages_monthly_def  
	label var mean_wages_monthly_def "Mean Earnings for wage workers per month, local nominal currency"
	
	clonevar mean_wages_monthly_def_agri=wages_monthly_def_agri
	label var mean_wages_monthly_def_agri "Mean Earnings for wage workers per month in agriculture, local nominal currency"
	
	clonevar mean_wages_monthly_def_indu=wages_monthly_def_indu
	label var mean_wages_monthly_def_indu "Mean Earnings for wage workers per month in industry, local nominal currency"
	
	clonevar mean_wages_monthly_def_serv=wages_monthly_def_serv
	label var mean_wages_monthly_def_serv "Mean Earnings for wage workers per month in service, local nominal currency"
	
	clonevar mean_wages_hourly_def_real=wages_hourly_def_real
	label var mean_wages_hourly_def_real "Mean Earnings for wage workers per hour,  deflated to 2010  local currency values"
	
	clonevar mean_wages_monthly_def_real=wages_monthly_def_real
	label var mean_wages_monthly_def_real "Mean Earnings for wage workers per month, deflated to 2010 local currency values"
	
	clonevar mean_wages_hourly_usd=wages_hourly_usd
	label var mean_wages_hourly_usd "Real Mean Hourly  Wages in USD (base 2010), PPP adjusted"
	
	clonevar mean_wages_monthly_usd=wages_monthly_usd
	label var mean_wages_monthly_usd "Real Mean Monthly Wages in USD (base 2010), PPP adjusted"

	
** Create Age disaggregation by sector and employment type
	gen age_worker=age if lstatus==1 & $condALL 
	label var age_worker "Mean age of worker between 15-64"
	
	gen age_worker_agriculture=age if lstatus==1 & industry==1 & $condALL 
	label var age_worker_agriculture "Mean age of worker in agriculture, between 15-64"
	
	gen age_worker_industry=age if lstatus==1 & (industry==3 | industry==4 |  industry==5 | industry==2) & $condALL
	label var age_worker_industry "Mean age of worker in industry, between 15-64"
	
	gen age_worker_services=age if lstatus==1 &  ((industry>=6 & industry<=10)) & $condALL 
	label var age_worker_services "Mean age of worker in services, between 15-64"
	
	
	gen age_worker_wage=age if lstatus==1 & empstat==1 &  $condALL 
	label var age_worker_wage "Mean age of wage worker, between 15-64"
	
	gen age_worker_se_unpaid=age if lstatus==1 & (empstat==2 | empstat==4) &   $condALL 
	label var age_worker_se_unpaid "Mean age of self-employed or unpaid worker, between 15-64"
	
	gen age_worker_employer=age if lstatus==1 & empstat==3 & $condALL
	label var age_worker_employer "Mean age of employer, between 15-64"
	
** Literacy rate
capture gen literacy=.

gen sh_literacy=0 if age>=15 & literacy==0
replace sh_literacy=1 if age>=15 & literacy==1
	
label var sh_literacy "Literacy rate, aged 15 and older"	
	
** Labelling education years
gen sh_educy=educy if age>=17
label var sh_educy "Mean number of years of education completed, aged 17 and older"

** Enrollment rate
gen sh_enrolled=0 if age>=6 & age<=16 & atschool==0
replace sh_enrolled=1 if age>=6 & age<=16 & atschool==1	
label var sh_enrolled "Enrollment rate for individuals aged 6-16"
	
** Data information	
			
gen sample2=sample1				

gen sample_type=substr(sample2,15,19)
replace sample_type="lsms" if sample_type=="dta"
replace sample_type=subinstr(sample_type,".dta","",.)
replace sample_type=subinstr(sample_type,".dt","",.)
replace sample_type=subinstr(sample_type,".d","",.)
replace sample_type=substr(sample_type, 1,5) if sample_type!="eurosilc"
replace sample_type=subinstr(sample_type,"_v","",.)
replace sample_type=subinstr(sample_type,"_","",.)

bys countryname year sample2:     gen sample_size=_N
label var sample_size "Sample Size"	


compress 


erase "$data\`var'_prepared.dta"
save "$data\`var'_test.dta", replace

}
