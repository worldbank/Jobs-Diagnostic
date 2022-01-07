
foreach var in   ECA_v2 ECA_v1 {

use "$data\`var'_test", clear

	
global condALL age>=15 & age<=64
global noCondALL age<15 & age>64	
***************************************************************************************************************************************************

				*Step 3: QUALITY CHECK: Missingness

		***Step 3.1: MISSINGNESS for Demographics:

		**** Missing weight
sort ccode year sample

*** Details of Missingness:

datacheck wgt < ., by(ccode year sample)  message(Missing Weights) flag nolist
rename _contra wgt_missing
la var wgt_missing "Weight variable missing - all"

datacheck age < ., by(ccode year sample)  message(Missing age) flag nolist
rename _contra age_missing
la var age_missing "Age variable missing - all"

datacheck gender < ., by(ccode year sample)  message(Missing gender) flag nolist
rename _contra gender_missing
la var gender_missing "Gender variable missing - all"

datacheck urb < ., by(ccode year sample) varshow(age gender edulevel1 sample) message(Missing Urban) flag nolist
rename _contra urb_missing
la var urb_missing "Urban/rural variable missing - all"

sort ccode year sample

*** Education
datacheck atschool < . if age>6 & age<30, by(ccode year sample) varshow(age gender edulevel1 edulevel2  lstatus sample) message(Missing atschool) flag nolist
replace _contra = . if age<7 | age>29
rename _contra atschool_missing
la var atschool_missing "Atschool variable missing - age 7-29"


datacheck edulevelSEL <. if $condALL, by(ccode year sample) varshow(age gender edulevelSEL edulevel2  lstatus sample) message(Missing education level 2) flag nolist
replace _contra = . if $noCondALL
rename _contra edu_missing
la var edu_missing "Education variable missing for working age 15-64"


***MISSINGNESS for Labor Vars:

* Missingness of LFP


*** Details of Missingness:
*LFP
datacheck lstatus < . if $condALL, by(ccode year sample) varshow(age gender edulevel1 lstatus sample) message(Missing LFP) flag nolist
replace _contra = . if $noCondALL
rename _contra lstat_missing
la var lstat_missing "Labor Status Missing for working age 15-64"



* Missingness of Job related Vars for Employed Individuals

*Job Related Vars
datacheck empstat < . if $condALL & lstatus==1, by(ccode year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Employment Status) flag nolist
replace _contra = .   if $noCondALL | lstatus!=1 
rename _contra empstat_missing
la var empstat_missing "Employment Status Missing for employed working age 15-64"

datacheck industry < . if $condALL & lstatus==1, by(ccode year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Industry) flag nolist
replace _contra = .    if $noCondALL | lstatus!=1
rename _contra indus_missing_detailed
la var indus_missing_detail "Detailed Industry Missing for employed working age 15-64"


datacheck industry1 < . if $condALL & lstatus==1, by(ccode year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Industry) flag nolist
replace _contra = .    if $noCondALL | lstatus!=1
rename _contra indus_missing_broad
la var indus_missing_broad "Broad Industry Missing for employed working age 15-64"


datacheck occup < . if $condALL & lstatus==1, by(ccode year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Occupation) flag nolist
replace _contra = . if $noCondALL | lstatus!=1
rename _contra occup_missing
la var occup_missing "Occupation Missing for employed working age 15-64"

replace ocusec=. if ocusec>2 
datacheck ocusec < . if $condALL & lstatus==1, by(ccode year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Public ve Private) flag nolist
replace _contra = .  if $noCondALL | lstatus!=1 
rename _contra ocusec_missing
la var ocusec_missing "Public vs Private Missing for workers working age 15-64"

datacheck njobs < . if $condALL & lstatus==1, by(ccode year sample) varshow(age gender edulevel1 lstatus sample) message(Missing if Additional Jobs) flag nolist
replace _contra = . if $noCondALL | lstatus!=1 
rename _contra njob_missing
la var njob_missing "Secondary Job Missing for employed working age 15-64"

datacheck wage < .  if $condALL & lstatus==1 , by(ccode year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Wage for All) flag nolist
replace _contra = . if $noCondALL | lstatus!=1 
rename _contra wage_emp_missing
la var wage_emp_missing "Wage Missing for all workers working age 15-64"

datacheck wage < .  if $condALL & lstatus==1 & empstat==1, by(ccode year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Wage for Wage Worker) flag nolist
replace _contra = . if $noCondALL | lstatus!=1 | empstat!=1
rename _contra wage_wagewrkr_missing
la var wage_wagewrkr_missing "Wage Missing for wage workers working age 15-64"

datacheck whours < . if $condALL & lstatus==1, by(ccode year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Working Hours) flag nolist
replace _contra = .  if $noCondALL | lstatus!=1 
rename _contra whours_missing
la var whours_missing "Work hours missing for those that are employed age 15-64"


* informal
datacheck informal < . if $condALL & lstatus==1, by(ccode year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Informality) flag nolist
replace _contra = . if $noCondALL | lstatus!=1 | empstat!=1
rename _contra informal_missing
la var informal_missing "Informal missing for wage workers employed age 15-64"  

* contract
datacheck contract < . if $condALL & lstatus==1, by(ccode year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Contract) flag nolist
replace _contra = . if $noCondALL | lstatus!=1
rename _contra contract_missing
la var contract_missing "Contract missing for employed working age 15-64"


* healthins
datacheck healthins < . if $condALL & lstatus==1, by(ccode year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Health Insurance) flag nolist
replace _contra = . if $noCondALL | lstatus!=1
rename _contra healthins_missing
la var healthins_missing "Health insurance missing for employed working age 15-64"


* contract
datacheck socialsec < . if $condALL & lstatus==1, by(ccode year sample) varshow(age gender edulevel1 lstatus sample) message(Missing Social Security) flag nolist
replace _contra = . if $noCondALL | lstatus!=1
rename _contra socialsec_missing
la var socialsec_missing "Social security missing for employed working age 15-64"

compress 

** Missingness Measure

foreach x in wgt_missing age_missing gender_missing urb_missing atschool_missing  edu_missing lstat_missing empstat_missing indus_missing_broad indus_missing_detailed occup_missing ocusec_missing njob_missing wage_emp_missing wage_wagewrkr_missing whours_missing informal_missing contract_missing  healthins_missing socialsec_missing{
gen miss_`x'=`x'
}

compress

collapse miss_*, by(countryname year sample1)



la var miss_wgt_missing "Weight variable missing - all"

la var miss_age_missing "Age variable missing - all"

la var miss_gender_missing "Gender variable missing - all"

la var miss_urb_missing "Urban/rural variable missing - all"

la var miss_atschool_missing "Atschool variable missing - age 7-29"

la var miss_edu_missing "Education variable missing for working age 15-64"

la var miss_lstat_missing "Labor Status Missing for working age 15-64"

la var miss_empstat_missing "Employment Status Missing for employed working age 15-64"

la var miss_indus_missing_detail "Detailed Industry Missing for employed working age 15-64"

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

gen filter="Missing"


save "$data\`var'_missing", replace
}
