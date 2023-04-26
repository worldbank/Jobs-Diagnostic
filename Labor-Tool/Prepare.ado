program Prepare


dis "", _newline(10)





*--------------------------------*--------------------------------*---------------------------------------
*-----THIS PROGRAM CREATES TABS and GRAPHS for Jobs Diagnostics Supply Side using I2D2 (Standardized Data)

* Authors: Michael Weber, Jörg Langbein
* For any questions, please contact: mweber1@worldbank.org

*------------------------------*--------------------------------*----------------------------------------


dis "The data is currently being prepared, please wait"

quietly {

* Check folder structure and package availability or install


foreach package in datacheck winsor2 confirmdir filelist excelcol mdesc sencode grstyle coefplot estout outreg2 wbopendata oaxaca{
 capture which `package'
 if _rc==111 ssc install `package'
}
	

version 14.2


set more off
set varabbrev off

local date : dis %td_CCYYNNDD date(c(current_date), "DMY")


confirmdir "$user\\$y"
if _rc != 0 {
                mkdir "$user\\$y"
                di "Country folder created"
				}
else {
                di "Country folder already exists"
                }
cd "$user\\$y"


*Defining Globals for Each Country Folders:

*Defining Globals for Each Country Folders:
global raw_data "$user\"
global data "$user\\$y\Data"
global graph "$user\\$y\JDLT_`date'\"
global logs "$user\\$y\logs"
global indicators "$user\\$y\JDLT_`date'\Question 1 - Jobs and workers profile"
global regressions "$user/$y/JDLT_`date'/Question 5 - Worker characteristics and LM outcomes"



confirmdir "$data"
if _rc != 0 {
                mkdir "$user\\$y\Data"
                di "Data folder created"
				}
else {
                di "Data folder already exists"
                }

confirmdir "$user\\$y\JDLT_`date'"
if _rc != 0 {
                mkdir "$user\\$y\JDLT_`date'"
                di "Output folder created"
				}
else {
                di "Output folder already exists"
                }


	
confirmdir "$graph\Question 2 - Labor supply and demography"

if _rc != 0 {
                mkdir "$graph\Question 2 - Labor supply and demography"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }


	
confirmdir "$graph\Question 2 - Labor supply and demography\2.1.Labor Force Participation"

if _rc != 0 {
                mkdir  "$graph\Question 2 - Labor supply and demography\2.1.Labor Force Participation"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }			
				
				
confirmdir "$graph\Question 2 - Labor supply and demography\2.2.Active Labor Force"

if _rc != 0 {
                mkdir  "$graph\Question 2 - Labor supply and demography\2.2.Active Labor Force"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }						
		
confirmdir "$graph\Question 2 - Labor supply and demography\2.3.Out of Labor Force"

if _rc != 0 {
                mkdir  "$graph\Question 2 - Labor supply and demography\2.3.Out of Labor Force"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }		
		

confirmdir "$graph\Question 3 - Employment and education"

if _rc != 0 {
                mkdir "$graph\Question 3 - Employment and education"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }
				

confirmdir "$graph\Question 3 - Employment and education\3.1.Employment Types"

if _rc != 0 {
                mkdir "$graph\Question 3 - Employment and education\3.1.Employment Types"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }				
								
				
				
confirmdir "$graph\Question 3 - Employment and education\3.2.Industry sectors"

if _rc != 0 {
                mkdir "$graph\Question 3 - Employment and education\3.2.Industry sectors"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }				
				
				
confirmdir "$graph\Question 3 - Employment and education\3.3.Occupation"

if _rc != 0 {
                mkdir "$graph\Question 3 - Employment and education\3.3.Occupation"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }				
				
					
confirmdir "$graph\Question 3 - Employment and education\3.4.Education"

if _rc != 0 {
                mkdir "$graph\Question 3 - Employment and education\3.4.Education"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }				
				
					
							
				
				
confirmdir "$graph\Question 4 - Earnings"

if _rc != 0 {
                mkdir "$graph\Question 4 - Earnings"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }

				
confirmdir "$graph\Question 4 - Earnings\4.1.Earnings and wages"

if _rc != 0 {
                mkdir "$graph\Question 4 - Earnings\4.1.Earnings and wages"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }				
				

confirmdir "$graph\Question 4 - Earnings\4.1.Earnings and wages\Median"

if _rc != 0 {
                mkdir "$graph\Question 4 - Earnings\4.1.Earnings and wages\Median"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }				
				
confirmdir "$graph\Question 4 - Earnings\4.1.Earnings and wages\Mean"

if _rc != 0 {
                mkdir "$graph\Question 4 - Earnings\4.1.Earnings and wages\Mean"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }				
				
				
				
				
				
				
				
				
				
confirmdir "$graph\Question 4 - Earnings\4.2.Working hours"

if _rc != 0 {
                mkdir "$graph\Question 4 - Earnings\4.2.Working hours"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }					
				
				
confirmdir "$graph\Question 4 - Earnings\4.3.Consumption and Income Deciles"

if _rc != 0 {
                mkdir "$graph\Question 4 - Earnings\4.3.Consumption and Income Deciles"
                di "Graph folder created"
				}
else {
                di "Graph folder already exists"
                }			

				
confirmdir "$indicators"

if _rc != 0 {
                mkdir "$indicators"
                di "Indicators folder created"
				}
else {
                di "Indicators folder already exists"
                }

confirmdir "$logs"

if _rc != 0 {
                mkdir "$logs"
                di "Logs folder created"
				}
else {
                di "Logs folder already exists"
                }

				
				
confirmdir "$regressions"

if _rc != 0 {
                mkdir "$regressions"
                di "Labor Status folder created"
				}
else {
                di "Labor Status folder already exists"
                }
		 

confirmdir "$regressions\Labor Status"

if _rc != 0 {
                mkdir "$regressions\Labor Status"
                di "Labor Status folder created"
				}
else {
                di "Labor Status folder already exists"
                }
		 

	
confirmdir "$regressions\Probit"

if _rc != 0 {
                mkdir "$regressions\Probit"
                di "Probit folder created"
				}
else {
                di "Probit folder already exists"
                }
				
				
		 
				 
				 
confirmdir "$regressions\Probit\Wage vs NonWage"

if _rc != 0 {
                mkdir "$regressions\Probit\Wage vs NonWage"
                di "Wage vs NonWage folder created"
				}
else {
                di "Wage vs NonWage folder already exists"
                }

	
confirmdir "$regressions\Probit\Public vs Private"

if _rc != 0 {
                mkdir "$regressions\Probit\Public vs Private"
                di "Public vs Private folder created"
				}
else {
                di "Public vs Private folder already exists"
                }
		 		 		 
	
confirmdir "$regressions\Probit\Formal vs Informal"

if _rc != 0 {
                mkdir "$regressions\Probit\Formal vs Informal"
                di "Formal vs Informal folder created"
				}
else {
                di "Formal vs Informal folder already exists"
                }
		 		 		 
		 	
		 
	
confirmdir "$regressions\Wages"

if _rc != 0 {
                mkdir "$regressions\Wages"
                di "Wages folder created"
				}
else {
                di "Wages folder already exists"
                }
		 		 		 
					 

global Q2   "$graph\Question 2 - Labor supply and demography"
global Q21  "$graph\Question 2 - Labor supply and demography\2.1.Labor Force Participation"
global Q22  "$graph\Question 2 - Labor supply and demography\2.2.Active Labor Force"
global Q23  "$graph\Question 2 - Labor supply and demography\2.3.Out of Labor Force"
global Q3   "$graph\Question 3 - Employment and education"					 
global Q31  "$graph\Question 3 - Employment and education\3.1.Employment Types"		
global Q32  "$graph\Question 3 - Employment and education\3.2.Industry sectors"
global Q33  "$graph\Question 3 - Employment and education\3.3.Occupation"			 
global Q34  "$graph\Question 3 - Employment and education\3.4.Education"	
global Q4   "$graph\Question 4 - Earnings"
global Q41  "$graph\Question 4 - Earnings\4.1.Earnings and wages"
global Q411 "$graph\Question 4 - Earnings\4.1.Earnings and wages\Mean"
global Q412 "$graph\Question 4 - Earnings\4.1.Earnings and wages\Median"
global Q42  "$graph\Question 4 - Earnings\4.2.Working hours"
global Q43  "$graph\Question 4 - Earnings\4.3.Consumption and Income Deciles"			 
		 
		 
		 
				 

cd "$raw_data"






*** Combine all files that are in the main user directory


capture erase "$sub_search/filelist.dta"
global sub_search "$raw_data"



filelist, dir("$raw_data") pat(*.dta) save("filelist.dta") // gives the variable dirname that specifies the directory with files that have .gph format in it

use "$sub_search/filelist.dta", clear
drop if dirname!="$user\"
save, replace

levels filename
foreach var in `r(levels)'{
cd "$sub_search"
use "`var'", clear
capture drop sample1 
capture drop employed
capture gen str sample1=""
capture drop  educat_orig 
capture drop industry_orig 
capture drop occup_orig 
capture drop industry_orig_2 
capture drop occup_orig_2 
capture drop occup_orig_year 
capture drop occup_orig_year_2 
capture drop industry_orig_year_2 
capture drop industry_orig_year_2 
save, replace
}

cd "$raw_data"
erase filelist.dta





* Append all data files in the directory: and generate variable sample as data file name

! dir *.dta /a-d /b >filelist.txt

file open myfile using filelist.txt, read

file read myfile line
use `line'
capture replace sample1="`line'"
save tst_data, replace

file read myfile line
while r(eof)==0 { /* while you're not at the end of the file */
	append using `line', force
	capture replace sample1="`line'" if sample1==""
	file read myfile line
}
file close myfile
save tst_data, replace

tab year sample1, m
cap drop sample
gen str sample=sample1

* check if there is any I2D2 var that is not available. if so, generate the variable with missing values. 
cap gen str harmonization="" 

replace harmonization = "I2D2" if strpos(sample, "I2D2")>0
replace harmonization = "GMD"  if strpos(sample, "GMD")>0
replace harmonization = "GLD"  if strpos(sample, "GLD")>0


		
** Recode in case of GMD or GLD surveys		
		
if harmonization=="GMD" | harmonization=="GLD" {

* Rename variables 
cap rename weight wgt
cap rename weight_h wgt
cap rename male gender
cap recode gender 0=2
label define gender 1 "Male" 2 "Female"
cap label val gender gender
cap rename urban urb
cap recode urb 0=2
label define urb 1 "Urban" 2 "Rural"
cap label val urb urb

** Generate Country Code
gen str ccode=countrycode
label var ccode "Country Code"


** Generate Household ID
gen idh=hhid
label var idh "Household ID"

** Household size
cap rename hsize hhsize

** Education Level 1

	cap gen byte edulevel1=educat7
	cap label var edulevel1 "Level of education 1"
	la de lbledulevel1 1 "No education" 2 "Primary incomplete" 3 "Primary complete" 4 "Secondary incomplete" 5 "Secondary complete" 6 "Higher than secondary but not university" 7 "University incomplete or complete" 8 "Other" 9 "Unstated"
	cap label values edulevel1 lbledulevel1
	
*EDUCATION LEVEL 2
	cap gen byte edulevel2=edulevel1
	cap recode edulevel2 4=3 5=4 6 7=5 8 9=.
	cap replace edulevel2=. if age<ed_mod_age & age!=.
	cap label var edulevel2 "Level of education 2"
	la de lbledulevel2 1 "No education" 2 "Primary incomplete"  3 "Primary complete but secondary incomplete" 4 "Secondary complete" 5 "Some tertiary/post-secondary"
	cap label values edulevel2 lbledulevel2
	
* EDUCATION LEVEL 3
	cap gen byte edulevel3=edulevel1
	cap recode edulevel3 2 3=2 4 5=3 6 7=4 8 9=.
	cap label var edulevel3 "Level of education 3"
	cap la de lbledulevel3 1 "No education" 2 "Primary" 3 "Secondary" 4 "Post-secondary"
	cap label values edulevel3 lbledulevel3	
	
* Industry

	cap gen industry=industrycat10
    	cap label var industry "1 digit industry classification"
	cap la de lblindustry 1 "Agriculture" 2 "Mining" 3 "Manufacturing" 4 "Public utilities" 5 "Construction"  6 "Commerce" 7 "Transport and Comnunications" 8 "Financial and Business Services" 9 "Public Administration" 10 "Other Services, Unspecified"
	cap label values industry lblindustry
	
* INDUSTRY 1
	cap gen byte industry1=industry
	cap recode industry1 (1=1)(2 3 4 5 =2)(6 7 8 9=3)(10=4)
	cap replace industry1=. if lstatus!=1
	cap label var industry1 "1 digit industry classification (Broad Economic Activities)"
	cap la de lblindustry1 1 "Agriculture" 2 "Industry" 3 "Services" 4 "Other"
	cap label values industry1 lblindustry1	
	
* Wages

   cap rename wage_no_compen wage

* Regional code
   capture drop subnatid3 	
   cap sencode subnatid1, replace
   cap sencode subnatid2, replace
   cap rename subnatid1 reg01
	
}


else {
                di "I2D2 dataset"
                }
		

local I2D2_varlist "hhsize atschool lstatus ocusec pci_d firmsize_u sample1 year reg01 head literacy empstat occup pcc contract socialsec healthins soc idh reg02 educy nlfreason wage pcc_d internet unempldur idp ownhouse age edulevel1 edulevel2 edulevel3 unempldur_l unitwage njobs internet2 union water marital edulevel2 unempldur_u landphone cellphone pcw_d welfare strata electricity ed_mod_age sample harmonization industry computer psu toilet everattend lb_mod_age whours pci firmsize_l restriction" 

foreach v of local I2D2_varlist {
                capture confirm variable `v'
                if _rc==0 {
                        di "Variable `v' exist"
                }
                else {
                        gen `v'=.
                }
        }				

** Reduce to key variables		
keep ccode year idh idp wgt strata psu urb gender harmonization hhsize atschool lstatus ocusec pci_d firmsize_u sample1 reg01 head literacy empstat occup pcc contract socialsec healthins soc idh reg02 educy nlfreason wage pcc_d internet unempldur ownhouse age edulevel1 edulevel2 edulevel3 unempldur_l unitwage njobs internet2 union water marital unempldur_u landphone cellphone pcw_d welfare electricity ed_mod_age sample industry computer toilet everattend lb_mod_age whours pci firmsize_l restriction			


		
save "$data\I2D2_test_$y.dta", replace
*****

capture erase tst_data.dta 
capture erase filelist.dta
capture erase filelist.txt


****************************************************************************
*** Create survey structure, consistency and quality checks ****************
****************************************************************************


split sample, p(_) gen(geo)
drop geo1 geo3
split geo4, parse(.) gen(survey)
capture drop survey2

replace survey1 = upper(survey1)

gen year_s = geo2 + " " + survey1
tab year_s


log using "$logs/JD_SS_data_check_$y", replace

local working_age_cond "age>14 | age<65"
local no_working_age_cond "age<15 | age>64"


				*Step 0: Data Availability and Sources

tab year	
	
tab year sample

		
				*Step 1: Range Checks 

* Check min/max: any min or max value that is not reasonable?

bys year sample: sum

***************************************************************************************************************************************************

				*Step 2: Duplicates and Missingness in the Sample

*check for duplicate ids and mark the duplicates
duplicates tag ccode year idh idp wgt strata psu, generate(dup)
tab dup


***************************************************************************************************************************************************

			*Step 3: QUALITY CHECK: Missingness

		***Step 3.1: MISSINGNESS for Demographics:

		**** Missing weight
bysort year sample: mdesc idp idh wgt age gender marital atschool edulevel1 edulevel2 edulevel3

*** Details of Missingness:

datacheck wgt < ., by(year sample) varshow(age gender edulevel1) message(Missing Weights) nolist

datacheck age < ., by(year sample) varshow(age gender edulevel1) message(Missing age) nolist

datacheck gender < ., by(year sample) varshow(year sample age gender edulevel1) message(Missing gender) nolist

datacheck marital < . if age>14, by(year sample) message(Missing marital status) flag nolist
replace _contra = . if age<15
rename _contra marital_missing


datacheck urb < ., by(year sample) varshow(age gender edulevel1 sample) message(Missing Urban) flag nolist
rename _contra urb_missing

datacheck !missing(reg01), by(year sample) varshow(age gender edulevel1 sample) message(Missing Region 1) flag nolist
rename _contra reg01_missing

datacheck !missing(reg02), by(year sample) varshow(age gender edulevel1 sample) message(Missing Region 2) flag nolist
rename _contra reg02_missing


*** MANY MISSING: atschool and edulevel1, edulevel2
datacheck atschool < . if age>6 & age<30, by(year sample) varshow(age gender edulevel1 edulevel2  lstatus sample) message(Missing atschool) flag nolist
replace _contra = . if age<7 | age>29
rename _contra atsch_missing

datacheck edulevel1 < . if age>6, by(year sample) varshow(age gender edulevel1 edulevel2  lstatus sample) message(Missing education level 1) flag nolist
replace _contra = . if age<7
rename _contra edu1_missing

datacheck edulevel2 < . if age>6, by(year sample) varshow(age gender edulevel1 edulevel2  lstatus sample) message(Missing education level 2) flag nolist
replace _contra = . if age<7
rename _contra edu2_missing

datacheck edulevel3 < . if age>6, by(year sample) varshow(age gender edulevel1 edulevel2  lstatus sample) message(Missing education level 3) flag nolist
replace _contra = . if age<7
rename _contra edu3_missing


*education 
datacheck edulevel2 < . if `working_age_cond', by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing education var2) flag nolist
replace _contra = . if `no_working_age_cond'
rename _contra edu2_wka_missing

datacheck edulevel3 < . if `working_age_cond', by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing education var3) flag nolist
replace _contra = . if `no_working_age_cond'
rename _contra edu3_wka_missing

		***Step 3.2: MISSINGNESS for Labor Vars:

* Missingness of LFP
bysort year sample: mdesc lstatus if `working_age_cond'

* Missingness of Job related Vars for Employed Individuals
bysort year sample: mdesc empstat industry occup ocusec njobs wage whours if lstatus==1 & `working_age_cond'


*** Details of Missingness:

*LFP
datacheck lstatus < . if `working_age_cond', by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing LFP) flag nolist


replace _contra = . if `no_working_age_cond'
rename _contra lstat_missing


*Job Related Vars

datacheck empstat < . if `working_age_cond' & lstatus==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Employment Status) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1
rename _contra empstat_missing

	gen empstat1=1 if empstat==1
	gen empstat2=1 if empstat==2
	gen empstat3=1 if empstat==3
	gen empstat4=1 if empstat==4

datacheck empstat1 < . if `working_age_cond' & lstatus==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Wage Worker) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1
rename _contra empstat1_missing

datacheck empstat2 < . if `working_age_cond' & lstatus==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Unpaid Workers) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1
rename _contra empstat2_missing

datacheck empstat3 < . if `working_age_cond' & lstatus==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Employer) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1
rename _contra empstat3_missing

datacheck empstat4 < . if `working_age_cond' & lstatus==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Self Employed) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1
rename _contra empstat4_missing

datacheck industry < . if `working_age_cond' & lstatus==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Industry) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1
rename _contra indus_missing

datacheck occup < . if `working_age_cond' & lstatus==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Occupation) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1
rename _contra occup_missing

datacheck ocusec < . if `working_age_cond' & lstatus==1 & empstat==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Public ve Private) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1 | empstat!=1
rename _contra ocusec_missing

datacheck njobs < . if `working_age_cond' & lstatus==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing if Additional Jobs) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1 
rename _contra njob_missing

datacheck wage < . if `working_age_cond' & lstatus==1 & empstat!=1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Wage) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1 | empstat==1
rename _contra wage_othemp_missing

datacheck wage < . if `working_age_cond' & lstatus==1 & empstat==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Wage) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1 | empstat!=1
rename _contra wage_wagewrkr_missing

datacheck whours < . if `working_age_cond' & lstatus==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Working Hours) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1
rename _contra whours_missing

datacheck whours < . if `working_age_cond' & lstatus==1 & empstat==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Working Hours for Wage Workers) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1  | empstat!=1
rename _contra whours_wagewrk

datacheck whours < . if `working_age_cond' & lstatus==1 & empstat==2, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Working Hours for Unpaid) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1  | empstat!=2
rename _contra whours_unpaid

datacheck whours < . if `working_age_cond' & lstatus==1 & empstat==3, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Working Hours for Employes) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1  | empstat!=3
rename _contra whours_emplyr

datacheck whours < . if `working_age_cond' & lstatus==1 & empstat==4, by(year sample) varshow(age gender edulevel1 lstatus) message(Missing Working Hours for Self Employed) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1  | empstat!=4
rename _contra whours_self


datacheck contract < . if `working_age_cond' & lstatus==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Contract) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1
rename _contra contract_missing

datacheck contract < . if `working_age_cond' & lstatus==1 & empstat==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Contract for Wage Workers) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1  | empstat!=1
rename _contra contract_wagewrk

datacheck contract < . if `working_age_cond' & lstatus==1 & empstat==2, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Contract for Unpaid) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1  | empstat!=2
rename _contra contract_unpaid

datacheck contract < . if `working_age_cond' & lstatus==1 & empstat==3, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Contract for Employes) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1 | empstat!=3
rename _contra contract_emplyr

datacheck contract < . if `working_age_cond' & lstatus==1 & empstat==4, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Contract for Self Employed) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1 | empstat!=4
rename _contra contract_self

datacheck socialsec < . if `working_age_cond' & lstatus==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Social Sec.) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1
rename _contra socialsec_missing

datacheck socialsec < . if `working_age_cond' & lstatus==1 & empstat==1, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Social Sec. for Wage Workers) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1 | empstat!=1
rename _contra socialsec_wagewrk

datacheck socialsec < . if `working_age_cond' & lstatus==1 & empstat==2, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Social Sec. for Unpaid) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1 | empstat!=2
rename _contra socialsec_unpaid

datacheck socialsec < . if `working_age_cond' & lstatus==1 & empstat==3, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Social Sec. for Employes) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1 | empstat!=3
rename _contra socialsec_emplyr

datacheck socialsec < . if `working_age_cond' & lstatus==1 & empstat==4, by(year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Social Sec. for Self Employed) flag nolist
replace _contra = . if `no_working_age_cond' | lstatus!=1 | empstat!=4
rename _contra socialsec_self


***************************************************************************************************************** **********************************

				***Step 4: Quality Check: Categorical Variables and Labeling

* Values/categories might not be the same across years due to different sources, therefore not standard across countries

* There is no if conditions on age in this section because it focuses on the labeling of categories rather than missingness.

* Demographics
bys year sample: tab marital sample, missing
bys year sample: tab edulevel1 sample, missing
bys year sample: tab edulevel2 sample, missing
bys year sample: tab edulevel3 sample, missing
bys year: tab atschool sample, missing

* Consumption & Welfare
bys year sample: tab pcc_d sample, missing
bys year sample: tab pcw_d sample, missing

*Regional
bys year sample: tab reg01 sample, missing
bys year sample: tab reg02 sample, missing
bys year sample: tab urb sample, missing

* Work
bys year sample: tab lstatus sample if `working_age_cond', missing
bys year sample: tab nlfreason sample if lstatus==3, missing

bys year sample: tab empstat sample if lstatus==1, missing
bys year sample: tab industry sample if lstatus==1, missing
bys year sample: tab occup sample if lstatus==1, missing
bys year sample: tab ocusec sample if lstatus==1 & empstat==1, missing
bys year sample: tab njobs sample if lstatus==1, missing

bys year sample empstat: sum wage

*Formality
bys year sample: tab socialsec sample if lstatus==1, missing
bys year sample: tab healthins sample if lstatus==1, missing
bys year sample: tab contract sample if lstatus==1, missing
bys year sample: tab union sample if lstatus==1, missing



saveold "$data/I2D2_test_$y.dta", replace



**************************************************************************
*************** Data cleaning ********************************************
**************************************************************************


*** Drop if weights are missing

drop if wgt==.

*** Drop if weights has no variation

bys year sample: egen sd_wgt=sd(wgt)
drop if sd_wgt==0


*drop if idh==""
*drop if idp==""

*** Drop if essential vars are missing

drop if age==.
drop if gender==.


* if the education variable is only collected for those being at school then set education var missing - threshold 0.8 (!)
* not working if e.g. atschool is not available or all missing (and of course if the respective edulevel var is not available or largely missing)
capture confirm variable atschool
if !_rc {
			*di in red "atschool exists"
			if atsch_missing==0 {
				* at school should be fully available (here over all samples/survey years
				* assert miss_atsch_missing==0
				* problem with multiple samples with and without atschool
				* assert miss_edu1_missing==
				if !edu2_missing==1 {
					* edulevel2 must not be completely missing - and should be available
					* (does edulevel2 exist (or is it all missing?)
					gen no_atsch_edu2_miss=(edulevel2==. & atschool!=1)
					* tbd if atschool==0 is better
					bys year sample: egen edu2_no_sc_miss=mean(no_atsch_edu2_miss) if atschool!=1
					bys year sample: gen edu2_replace=1 if edu2_no_sc_miss > 0.8 & ~missing(edu2_no_sc_miss)
					replace edulevel2=. if edu2_replace==1
					drop no_atsch_edu2_miss edu2_no_sc_miss edu2_replace
				}
				if !edu3_missing==1  {
					* edulevel3 must not be completely missing - and should be available
					* (does edulevel3 exist (or is it all missing?)
					gen no_atsch_edu3_miss=(edulevel3==. & atschool!=1)
					* tbd if atschool==0 is better
					bys year sample: egen edu3_no_sc_miss=mean(no_atsch_edu3_miss) if atschool!=1
					bys year sample: gen edu3_replace=1 if edu3_no_sc_miss > 0.8 & ~missing(edu3_no_sc_miss)
					replace edulevel2=. if edu3_replace==1
					drop no_atsch_edu3_miss edu3_no_sc_miss edu3_replace
				}
				* !!!! nothing for edulevel1?
			}
			* if atschool is partially or fully missing - no action at this point
   }
   else {
		   di in red "atschool does not exist"
	}
 


* drop lstatus if lstatus is missing for more than 20% of wka pop.
bys year sample: egen lstat_missing_=mean(lstat_missing)
tab year sample if lstat_missing_ > 0.2

bys year sample: gen drop_lstat=1 if lstat_missing_ > 0.2 

drop if drop_lstat==1




******Replace as missing if one category is missing for some/all years



* if empstat does not have any wage workers or less than 0.5% in employed
bys year sample: egen empstat1_missing_ = mean(empstat1_missing)
tab year sample if empstat1_missing_ > 0.998

bys year sample: gen drop_empstat1=1 if empstat1_missing_ > 0.998 

drop if drop_empstat1==1


* if empstat does not have any self employed or less than 0.5% in employed
bys year sample: egen empstat4_missing_=mean(empstat4_missing)
tab year sample if empstat4_missing_ > 0.998

bys year sample: gen drop_empstat4=1 if empstat4_missing_ > 0.998 
*not necessary see above: & ~missing(empstat4_missing_)

drop if drop_empstat4==1






log c


drop *_missing
drop *_missing_


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


	g married=(marital!=2) if ~missing(marital)
	label def married 0"Single" 1"Ever Married",modify
	label val married married

*** Gen age range

*** All population 

	gen age_4=.
	replace age_4=1 if age <15
	replace age_4=2 if age >=15 & age <=24
	replace age_4=3 if age >=25 & age <=64
	replace age_4=4 if age >=65
*	label def age_4 1"0-15" 2"15-24" 3"25-64" 4"64-Above"
	label def age_4 1"Children" 2"Youth" 3"Adult" 4"Elderly"
	label val age_4 age_4
	tab age_4,m


	gen age_5=.
	replace age_5=1 if age <15
	replace age_5=2 if age >=15 & age <=24
	replace age_5=3 if age >=25 & age <=34
	replace age_5=4 if age >=35 & age <=64
	replace age_5=5 if age >=65

	label def age_5 1"0-15" 2"15-24" 3"25-34" 4"35-64" 5"64-Above"
	label val age_5 age_5
	tab age_5,m
	
	
	gen age_3=.
	replace age_3=1 if age <25
	replace age_3=2 if age >=25 & age <=64
	replace age_3=3 if age >=65
	label def age_3 1"0-24" 2"25-64" 3"64- "
	label val age_3 age_3
	tab age_3,m
	
	
	gen age_x=.
	replace age_x=1 if age >=15 & age <=24
	replace age_x=2 if age >=25 & age <=64
	label def age_x 1"15-24" 2"25-64"
	label val age_x age_x
	tab age_x,m

** Gen more detailed age range
	gen age__x=.
	replace age__x=1 if age >=6 & age <=9
	replace age__x=2 if age >=10 & age <=14
	replace age__x=3 if age >=15 & age <=19
	replace age__x=4 if age >=20 & age <=24
	replace age__x=5 if age >=25 & age <=29
	replace age__x=6 if age >=30 & age <=34
	replace age__x=7 if age >=35 & age <=39
	replace age__x=8 if age >=40 & age <=44
	replace age__x=9 if age >=45 & age <=49
	replace age__x=10 if age >=50 & age <=54
	replace age__x=10 if age >=55 & age <=59
	replace age__x=10 if age >=60 & age <=64

	label def age__x 1"6-9" 2"10-14" 3"15-19" 4"20-24" 5"25-29" 6"30-34" 7"35-39" 8"40-44" 9"45-49" 10"50-54" 11"55-59" 12"60-64", modify
	label val age__x age__x
	tab age__x,m
	
	* Age groups
recode age (0/14=0 "Children") (15/24=1 "15-24") (25/59 =2 "25-59") (60/max=3 "Elderly"), gen(agegr)	
label var agegr "Age group"

la de lbl_agegr 0 "OUT" 1 "you" 2 "wrk" 3 "eld", replace
la val agegr lbl_agegr
decode agegr, gen(agegrSTR)
la val agegr agegr

*Age group binary indicators (alternative xi type on "agegr"
gen byte child = (age < 15) if ~missing(age)
gen byte youth = (age >= 15 & age < 25) if ~missing(age)
gen byte workingage = (age >= 25 & age < 65) if ~missing(age)
gen byte elderly = (age >= 65) if ~missing(age)
* removed the condition & age < 120 (why 120?) the definition is 60+ (and non-missing)

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

*Household Types (hhtype)
sort ccode year_s idh 

preserve
	collapse (sum) child youth workingage elderly, by(ccode year_s idh)
	sort ccode year_s idh 
	gen hhtype_gen =. 
	replace hhtype_gen = 1 if elderly >=1 & (workingage ==0 & youth ==0 & child==0)
	replace hhtype_gen = 2 if elderly ==0 
	replace hhtype_gen = 3 if elderly >=1 & (workingage >=1 | youth >=1 | child >=1)  
	
	la de hhtype_gen 1 "Elderly-Only Households" 2 "Non-Elderly Households" 3 "Some Elderly Households", replace
	label var hhtype_gen "Living Arrangements - Basic"
	la val hhtype_gen hhtype_gen

	save "_test.dta", replace
restore

*sort ccode year_s idh
merge m:1 ccode year_s idh using "_test.dta", keepusing (hhtype_gen)
tab _merge
capture erase "_test.dta"
drop _merge


*** IF Out-of-LF atschool==0
gen atschool_NON_LF_zero = atschool
replace atschool_NON_LF_zero = 0 if missing(atschool) & lstatus==3

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
		gen less_primary=(edulevelSEL==1 | edulevelSEL==2 | edulevelSEL==3) if ~missing(edulevelSEL)
		label def edulevelSEL 1 "No education" 2 "Primary incomplete" 3 "Secondary incomplete" 4 "Secondary complete" 5 "Some tertiary/post-secondary"
		label val edulevelSEL edulevelSEL
	}
	else {
		gen edulevelSEL = edulevel3
		gen less_primary=(edulevelSEL==1 | edulevelSEL==2) if ~missing(edulevelSEL)
		label val edulevelSEL lbledulevel3 
	}
	label var edulevelSEL "Level of Education"
	
	drop miss_bin_edulevel1 miss_mean_edulevel1
	drop miss_bin_edulevel2 miss_mean_edulevel2 
	drop miss_bin_edulevel3 miss_mean_edulevel3

*** Gen primary or less than primary education
	*moved above: gen less_primary=(edulevel1==1 | edulevel1==2 | edulevel1==3) if ~missing(edulevel1)
	label define less_primary 0"Primary and Above" 1"Less than Primary",modify
	label val less_primary less_primary
	tab less_primary
	label var less_primary "Primary or less than primary education"
	
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
	

*what if ocusec and or industry all missing?????
	
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
	 


	 label define lblemptype 1 "Wage public" 2 "Wage private" 3 "Self-employed Agriculture" 4 "Self-employed Non-Agriculture"  5 "Other"
     label values emptype lblemptype	
	
		
*** Gen categories for graphs

	gen sector_x6=1 if lstatus==1 & industry__x==1
    replace sector_x6=2 if lstatus==1 & (empstat==4 | empstat==2) & industry__x==2
 	replace sector_x6=3 if lstatus==1 & (empstat==4 | empstat==2) & industry__x==3 
 	replace sector_x6=4 if lstatus==1 & empstat==1 & ocusec==2
   	replace sector_x6=5 if lstatus==1 & empstat==1 & ocusec==2 & industry__x==2
    replace sector_x6=6 if lstatus==1 & empstat==1 & ocusec==2 & industry__x==3
	label define sector_x6 1"agr" 2"HHE, industry" 3"HHE, services" 4"Private wage" 5 "industry Private wage" 6 "services Private wage"
	label values sector_x6 sector_x6

	    gen sector_x4=1 if lstatus==1 & industry__x==1
        replace sector_x4=2 if lstatus==1 & (empstat==4 | empstat==2)
   		replace sector_x4=3 if lstatus==1 & empstat==1 & industry__x==2
    	replace sector_x4=4 if lstatus==1 & empstat==1 & industry__x==3
		label define sector_x4 1"agr" 2"HHE" 3"Wage Industry" 4"Wage Services"
		label values sector_x4 sector_x4
		
	    gen sector_x3=1 if lstatus==1 & industry__x==1
        replace sector_x3=2 if lstatus==1 & (empstat==4 | empstat==2)
 		replace sector_x3=3 if lstatus==1 & empstat==1
		label define sector_x3 1"agr" 2"HHE" 3"Wage"
		label values sector_x3 sector_x3


* Farm vs Non-farm income

	gen income_diverse=.
	replace income_diverse=1 if lstatus==1 & njobs==. & industry_x==1
    replace income_diverse=2 if lstatus==1 & njobs==. & industry_x!=1
 	replace income_diverse=3 if lstatus==1 & njobs!=.
	label define income_diverse 1"Farm Only" 2"Non-Farm Only" 3"Both", modify
	label values income_diverse income_diverse
				
* Having a second job (or additional jobs?)

	gen second_job=(njobs==1 | njobs==2)
	label def second_job 0"No Second Job" 1"Second Job",modify
	label val second_job second_job
	tab second_job


* Monthly Wage 

	
** Setup

* Generate weekly wages
gen daily_work=whours/8
label var daily_work "Number of days worked per week for daily labourer"
	
gen wage_daily=daily_work*wage if unitwage==1

gen 	weekly_wage=wage 						if unitwage==2 	& 	wage >=0 & wage!=.
replace weekly_wage=daily_work*wage 			if unitwage==1 & 	wage >=0 & wage!=.
replace weekly_wage=wage/2  					if unitwage==3  &   wage >=0 & wage!=.
replace weekly_wage=wage/8.4					if unitwage==4  &   wage >=0 & wage!=.
replace weekly_wage=wage/4.2 					if unitwage==5 	& 	wage >=0 & wage!=.
replace weekly_wage=wage/12.6 					if unitwage==6  &   wage >=0 & wage!=.
replace weekly_wage=wage/52 					if unitwage==8 	&   wage >=0 & wage!=.
replace weekly_wage=wage*whours					if unitwage==9  &   wage >=0 & wage!=.

gen hourly_wages=.
replace hourly_wages=weekly_wage/whours   if whours!=. & whours!=0
replace hourly_wages=wage if unitwage==9 
*replace hourly_wages=weekly_wage/40       if whours==. & weekly_wage!=.  // For those where working hours are not reported we assume 40 hours of work per week.
replace hourly_wages=. if hourly_wages<0 | hourly_wages==0

gen wage_monthly=wage 						if unitwage==5  &   wage>=0 & wage!=.
replace wage_monthly=weekly_wage*4.2 		if unitwage!=5  &   wage>=0 & wage!=. 


winsor2 hourly_wages, cuts(1 99) by(sample1) replace
winsor2 wage_monthly, cuts(1 99) by(sample1) replace

* Upscale to monthly wages

gen wage_per_month= wage_monthly

*  if wage unit is missing it could be assumed to be monthly but we set as missing here
replace wage_per_month=. if unitwage==.

* Monthly wage is missing if zero
replace wage_per_month=. if wage==0
la var wage_per_month "Monthly Wage"


* PER CAPITA INCOME AND CONSUMPTION
recode pci_d (1/2=1 "1 Quintile") (3/4=2 "2 Quintile") (5/6=3 "3 Quintile") (7/8=4 "4 Quintile") (9/10=5 "5 Quintile"), gen(pci_q)	
label var pci_q "Income per Capita Quintiles"
	
recode pcc_d (1/2=1 "1 Quintile") (3/4=2 "2 Quintile") (5/6=3 "3 Quintile") (7/8=4 "4 Quintile") (9/10=5 "5 Quintile"), gen(pcc_q)	
label var pcc_q "Consumption per Capita Quintiles"

recode pcw_d (1/2=1 "1 Quintile") (3/4=2 "2 Q uintile") (5/6=3 "3 Quintile") (7/8=4 "4 Quintile") (9/10=5 "5 Quintile"), gen(pcw_q)	
label var pcw_q "Welfare Quintiles"

gen bottom_40_welfare=(pcw_d<5)
la var bottom_40_welfare "Bottom 40 in Consumption"

gen bottom_40_cons=(pcc_d<5)
la var bottom_40_cons "Bottom 40 in Consumption"

*** Urban vs Rural




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


*** Informal Workers Definition

* Available Variables:

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



*** Informality: Basic Definition with Social Security  
gen informal=(empstat==2 | (empstat==1 & socialsec==0) | (empstat==3 & socialsec==0) | (empstat==4 & socialsec==0)) if ~missing(socialsec)

replace informal=. if empstat==.
replace informal=. if empstat!=2 & socialsec==.
replace informal=2 if informal==. & lstatus==1


label define informal 2 "informality unknown" 1 "informal" 0 "formal", replace
label values informal informal
label var informal "Informality status"	
	
	

g em=1 if lstatus==1
g unem=1 if lstatus==2
g OLF=1 if lstatus==3
bys year_s: egen nonmissing_em=count(em)
bys year_s: egen nonmissing_unem=count(unem)
bys year_s: egen nonmissing_OLF=count(OLF)


g em_wka=1 if lstatus==1 & age_x<3
g unem_wka=1 if lstatus==2 & age_x<3
g OLF_wka=1 if lstatus==3 & age_x<3
bys year_s: egen nonmissing_em_wka=count(em_wka)
bys year_s: egen nonmissing_unem_wka=count(unem_wka)
bys year_s: egen nonmissing_OLF_wka=count(OLF_wka)

drop em_wka unem_wka OLF_wka
drop if nonmissing_em==0 | nonmissing_unem==0 | nonmissing_OLF==0 | nonmissing_em_wka==0 | nonmissing_unem_wka==0 | nonmissing_OLF_wka==0


* urb
gen urban=1 if urb==1
gen rural=1 if urb==2

bys year_s: egen nonmissing_urban=count(urban)
bys year_s: egen nonmissing_rural=count(rural)

replace urb=. if nonmissing_urban==0
replace urb=. if nonmissing_rural==0

* contract
gen with_contract=1 if contract==1
gen without_contract=1 if contract==0

bys year_s: egen nonmissing_with_contract=count(with_contract)
bys year_s: egen nonmissing_without_contract=count(without_contract)

replace contract=. if nonmissing_with_contract==0
replace contract=. if nonmissing_without_contract==0

* healthins
gen with_healthins=1 if healthins==1
gen without_healthins=1 if healthins==0

bys year_s: egen nonmissing_with_healthins=count(with_healthins)
bys year_s: egen nonmissing_without_healthins=count(without_healthins)

replace healthins=. if nonmissing_with_healthins==0
replace healthins=. if nonmissing_without_healthins==0

* socialsec
gen with_socialsec=1 if socialsec==1
gen without_socialsec=1 if socialsec==0

bys year_s: egen nonmissing_with_socialsec=count(with_socialsec)
bys year_s: egen nonmissing_without_socialsec=count(without_socialsec)

replace socialsec=. if nonmissing_with_socialsec==0
replace socialsec=. if nonmissing_without_socialsec==0

drop with* urban rural nonmissing_*


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




*********************************************************************************************
*********************************************************************************************
*********************************************************************************************

*REGIONS in size order (largest to smallest):

* first pick the region variable to use. sometime reg01 has missing. sometime reg02
* we choose the one that is available in more years

	bys year_s: egen nonmissing_reg1=count(reg01)
	bys year_s: egen nonmissing_reg2=count(reg02)
	
levels year_s if nonmissing_reg1==0
local nyears_reg1 : word count `r(levels)'
di `nyears_reg1'

levels year_s if nonmissing_reg2==0
local nyears_reg2 : word count `r(levels)'
di `nyears_reg2'

		
if `nyears_reg1' > `nyears_reg2' {
	rename reg01 reg01_orig 
rename reg02 reg01
}

else {
di "reg01 variable don't have missing values"
}

drop nonmissing_reg*

* Deal with reg01 if numeric, labelled
cap confirm numeric variable reg01
if _rc == 0 { // it is indeed numeric
	
	capture decode reg01, g(region)
	capture bys region: egen region_size = count(wgt)
	capture sencode region, g(regionn) label(regionval) gsort(-region_size)
	capture rename reg01 reg01_original
	capture rename regionn reg01
	
}
else { // it is string
	
	* Extract region name from code
	capture gen region = regexs(2) if regexm(reg01, "(^[0-9]+[ ]*-[ ]*)([a-zA-Z ]+)")
	capture bys region: egen region_size = count(wgt)
	capture sencode region, g(regionn) label(regionval) gsort(-region_size)
	capture rename reg01 reg01_original
	capture rename regionn reg01
	
}


**

* underemployment: if works less than 35 hours per week

gen underemployed=(whours<35) if employed==1 & whours!=.
la var underemployed "Underemployed < 35 hours/week"

label define underemployed 1 "underemployed" 0 "not underemployed", replace
label values underemployed underemployed

* Error code for graphs

gen error=1

* Counter for graphs

gen counter=1

capture gen countryname="$y"
label var countryname "Countryname"


gen low_edu=0 if edulevel1!=.
replace low_edu=1 if edulevel1==1 | edulevel1==2 | edulevel1==3
cap numlabel, remove 

compress

saveold "$data/I2D2_test_$y.dta", replace


** Reduced version
gen no=1

keep countryname year year_s sample1  no ccode

label var sample1 "Survey Data Source"

gen sample_type=substr(sample1,15,19)
replace sample_type="lsms" if sample_type=="dta"
replace sample_type=subinstr(sample_type,".dta","",.)
replace sample_type=subinstr(sample_type,".dt","",.)
replace sample_type=subinstr(sample_type,".d","",.)
replace sample_type=substr(sample_type, 1,5) if sample_type!="eurosilc"
replace sample_type=subinstr(sample_type,"_v","",.)
replace sample_type=subinstr(sample_type,"_","",.)

bys countryname year sample1:     gen sample_size=_N
label var sample_size "Sample Size"

collapse no, by(countryname ccode year_s year sample1 sample_type sample_size)
drop no year_s
gen sample2=sample1
compress

save "$data/I2D2_test_${y}_red.dta", replace

**************************************************************************************
********* Download Data from WBopendata and, if second run, check if replace wanted
*************************************************************************************


capture confirm file `"$user\\$y\Data\wbopendata.dta"'
if _rc != 0 {

wbopendata, indicator(fp.cpi.totl; pa.nus.prvt.pp) clear long

*Prepare dataset
rename countrycode ccode
rename region regioncode
rename regionname region 
keep countryname ccode  region regioncode year fp_cpi_totl pa_nus_prvt_pp 
drop if region=="Aggregates"

drop if fp_cpi_totl==.
bys ccode year: gen ppp2=pa_nus_prvt_pp if year==2010
egen ppp = mean(ppp2), by(ccode) 

drop ppp2
replace ppp=. if pa_nus_prvt_pp==.
sort ccode year
save "$user\\$y\Data\wbopendata"
}


else {
                di "Dataset already downloaded"
                }




}
*********************************************************************************************
*********************************************************************************************
*********************************************************************************************




dis "",  _newline(10)


dis as result "The data is now prepared. To continue you have the following options:"
dis as text  `"1. Labor Market indicators. Please type  Indicator "'
dis as text  `"2. Labor Market Figures. Please type  Figures "'
dis as text  `"3. Labor Market Regressions. Please type Regressions "'

end



