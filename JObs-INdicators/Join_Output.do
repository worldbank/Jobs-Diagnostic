foreach var in  ECA_v2  {

use "$data\`var'_test", clear

** Reduce to necessary variables
keep no_* sh_* wages_* mean_hours countryname ccode year_s year sample1 gender sample_type sample_size age_x urb wgt age low_edu  age_worker* mean_* agemin agemax ageint
drop no_contract no_healthins no_socialsec sh_missing__ sh_ind_miss_ sh_agr_det


compress

*********************************************
************** ALL ************************
*********************************************

use "$data\`var'_test", clear

** Reduce to necessary variables
keep no_* sh_* wages_* mean_hours countryname ccode year_s year sample1 gender sample_type sample_size age_x urb wgt age low_edu  age_worker* mean_* agemin agemax ageint
drop no_contract no_healthins no_socialsec sh_missing__ sh_ind_miss_ sh_agr_det


compress

	

local shares countryname  year sample1 sample_type sample_size no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap  ///
no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young ///
sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women ///
sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ ///
sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ ///
sh_underemp sh_excemp  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ ///
sh_sec_educ sh_postsec_educ sh_formal_con sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real ///
wages_monthly_usd sh_non_ag_wage sh_non_ag_unpaid sh_non_ag_empl sh_non_ag_se sh_non_ag_wage_young sh_ag_wage sh_indu_wage sh_serv_wage mean_wages_hourly_def mean_wages_monthly_def mean_wages_monthly_def_agri mean_wages_monthly_def_indu ///
mean_wages_monthly_def_serv mean_wages_hourly_def_real mean_wages_monthly_def_real mean_wages_hourly_usd mean_wages_monthly_usd age_worker age age_worker_agriculture ///
age_worker_industry age_worker_services age_worker_wage age_worker_se_unpaid age_worker_employer sh_educy sh_literacy sh_enrolled sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag 

foreach x in `shares'{
local l`x' : variable label `x' 
}


collapse (count) no_* agemin agemax ageint (mean) sh_*  mean_hours mean_wages_* age age_worker* (median) wages_* [iw=wgt], by(countryname year sample1 sample_type sample_size)



foreach x in `shares' {
label var `x' "`l`x''" 
local varlabel: var label `x'
}	

gen ratio_gender_gap=wages_female/wages_male
label var ratio_gender_gap "Female to Male gender wage gap, calculated with median wages"

gen ratio_sector_gap=wages_public/wages_private
label var ratio_sector_gap "Public to Private wage gap, calculated with median wages"

drop wages_female wages_male wages_public wages_private


bys countryname year sample1: gen  sh_dependency=((agemin+agemax)/ageint)
bys countryname year sample1: gen  sh_dependency_youth=(agemin/ageint)
bys countryname year sample1: gen  sh_dependency_old=(agemax/ageint)

la var sh_dependency		"Dependency Rate, all compared to 15-64"
la var sh_dependency_youth 	"Youth Dependency Rate, younger than 15 compared to 15-64"
la var sh_dependency_old	"Old Age Dependency Rate, older than 64 compared to 15-64"


gen filter="All"

order countryname year sample1 sample_type sample_size filter no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_  mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_edu  sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag

 


save "$data\`var'_test_all", replace


*********************************************
************** Urban ************************
*********************************************

use "$data\`var'_test", clear

** Reduce to necessary variables
keep no_* sh_* wages_* mean_hours countryname ccode year_s year sample1 gender sample_type sample_size age_x urb wgt age low_edu  age_worker* mean_* agemin agemax ageint
drop no_contract no_healthins no_socialsec sh_missing__ sh_ind_miss_ sh_agr_det


compress



gen sh_dependency=. 
gen sh_dependency_youth=.
gen sh_dependency_old=.

keep if urb==1



local shares countryname  year sample1 sample_type sample_size no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap  ///
no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young ///
sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women ///
sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ ///
sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ ///
sh_underemp sh_excemp  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ ///
sh_sec_educ sh_postsec_educ sh_formal_con sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real ///
wages_monthly_usd sh_non_ag_wage sh_non_ag_unpaid sh_non_ag_empl sh_non_ag_se sh_non_ag_wage_young sh_ag_wage sh_indu_wage sh_serv_wage mean_wages_hourly_def mean_wages_monthly_def mean_wages_monthly_def_agri mean_wages_monthly_def_indu ///
mean_wages_monthly_def_serv mean_wages_hourly_def_real mean_wages_monthly_def_real mean_wages_hourly_usd mean_wages_monthly_usd age_worker age age_worker_agriculture ///
age_worker_industry age_worker_services age_worker_wage age_worker_se_unpaid age_worker_employer sh_educy sh_literacy sh_enrolled sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag 

foreach x in `shares'{
local l`x' : variable label `x' 
}



	
collapse (count) no_* (mean) sh_*  mean_hours mean_wages_* age age_worker* (median) wages_* [iw=wgt], by(countryname year sample1 sample_type sample_size)


foreach x in `shares' {
label var `x' "`l`x''" 
local varlabel: var label `x'
}	

gen ratio_gender_gap=wages_female/wages_male
label var ratio_gender_gap "Female to Male gender wage gap, calculated with median wages"

gen ratio_sector_gap=wages_public/wages_private
label var ratio_sector_gap "Public to Private wage gap, calculated with median wages"

drop wages_female wages_male wages_public wages_private

gen filter="Urban"

order countryname year sample1 sample_type sample_size filter no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_edu  sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag

save "$data\`var'_test_urban", replace







*********************************************
************** Rural ************************
*********************************************


use "$data\`var'_test", clear

** Reduce to necessary variables
keep no_* sh_* wages_* mean_hours countryname ccode year_s year sample1 gender sample_type sample_size age_x urb wgt age low_edu  age_worker* mean_* agemin agemax ageint
drop no_contract no_healthins no_socialsec sh_missing__ sh_ind_miss_ sh_agr_det


compress



gen sh_dependency=. 
gen sh_dependency_youth=.
gen sh_dependency_old=.

keep if urb==2


local shares countryname  year sample1 sample_type sample_size no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap  ///
no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young ///
sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women ///
sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ ///
sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ ///
sh_underemp sh_excemp  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ ///
sh_sec_educ sh_postsec_educ sh_formal_con sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real ///
wages_monthly_usd sh_non_ag_wage sh_non_ag_unpaid sh_non_ag_empl sh_non_ag_se sh_non_ag_wage_young sh_ag_wage sh_indu_wage sh_serv_wage mean_wages_hourly_def mean_wages_monthly_def mean_wages_monthly_def_agri mean_wages_monthly_def_indu ///
mean_wages_monthly_def_serv mean_wages_hourly_def_real mean_wages_monthly_def_real mean_wages_hourly_usd mean_wages_monthly_usd age_worker age age_worker_agriculture ///
age_worker_industry age_worker_services age_worker_wage age_worker_se_unpaid age_worker_employer sh_educy sh_literacy sh_enrolled sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag 

foreach x in `shares'{
local l`x' : variable label `x' 
}


collapse (count) no_* (mean) sh_*  mean_hours mean_wages_* age age_worker* (median) wages_* [iw=wgt], by(countryname year sample1 sample_type sample_size)

	

foreach x in `shares' {
label var `x' "`l`x''" 
local varlabel: var label `x'
}	

gen ratio_gender_gap=wages_female/wages_male
label var ratio_gender_gap "Female to Male gender wage gap, calculated with median wages"

gen ratio_sector_gap=wages_public/wages_private
label var ratio_sector_gap "Public to Private wage gap, calculated with median wages"

drop wages_female wages_male wages_public wages_private

gen filter="Rural"

order countryname year sample1 sample_type sample_size filter no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_  mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_edu sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag

save "$data\`var'_test_rural", replace





*********************************************
************** Old ************************
*********************************************


use "$data\`var'_test", clear

** Reduce to necessary variables
keep no_* sh_* wages_* mean_hours countryname ccode year_s year sample1 gender sample_type sample_size age_x urb wgt age low_edu  age_worker* mean_* agemin agemax ageint
drop no_contract no_healthins no_socialsec sh_missing__ sh_ind_miss_ sh_agr_det


compress



gen sh_dependency=. 
gen sh_dependency_youth=.
gen sh_dependency_old=.

keep if age_x==2


local shares countryname  year sample1 sample_type sample_size no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap  ///
no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young ///
sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women ///
sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ ///
sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ ///
sh_underemp sh_excemp  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ ///
sh_sec_educ sh_postsec_educ sh_formal_con sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real ///
wages_monthly_usd sh_non_ag_wage sh_non_ag_unpaid sh_non_ag_empl sh_non_ag_se sh_non_ag_wage_young sh_ag_wage sh_indu_wage sh_serv_wage mean_wages_hourly_def mean_wages_monthly_def mean_wages_monthly_def_agri mean_wages_monthly_def_indu ///
mean_wages_monthly_def_serv mean_wages_hourly_def_real mean_wages_monthly_def_real mean_wages_hourly_usd mean_wages_monthly_usd age_worker age age_worker_agriculture ///
age_worker_industry age_worker_services age_worker_wage age_worker_se_unpaid age_worker_employer sh_educy sh_literacy sh_enrolled sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag 

foreach x in `shares'{
local l`x' : variable label `x' 
}

collapse (count) no_* (mean) sh_*  mean_hours mean_wages_* age age_worker* (median) wages_* [iw=wgt], by(countryname year sample1 sample_type sample_size)


foreach x in `shares' {
label var `x' "`l`x''" 
local varlabel: var label `x'
}	

gen ratio_gender_gap=wages_female/wages_male
label var ratio_gender_gap "Female to Male gender wage gap, calculated with median wages"

gen ratio_sector_gap=wages_public/wages_private
label var ratio_sector_gap "Public to Private wage gap, calculated with median wages"

drop wages_female wages_male wages_public wages_private

gen filter="Old"

order countryname year sample1 sample_type sample_size filter no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_  mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_edu sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag

save "$data\`var'_test_old", replace




*********************************************
************** Young ************************
*********************************************


use "$data\`var'_test", clear

** Reduce to necessary variables
keep no_* sh_* wages_* mean_hours countryname ccode year_s year sample1 gender sample_type sample_size age_x urb wgt age low_edu  age_worker* mean_* agemin agemax ageint
drop no_contract no_healthins no_socialsec sh_missing__ sh_ind_miss_ sh_agr_det


compress



gen sh_dependency=. 
gen sh_dependency_youth=.
gen sh_dependency_old=.

keep if age_x==1


local shares countryname  year sample1 sample_type sample_size no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap  ///
no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young ///
sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women ///
sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ ///
sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ ///
sh_underemp sh_excemp  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ ///
sh_sec_educ sh_postsec_educ sh_formal_con sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real ///
wages_monthly_usd sh_non_ag_wage sh_non_ag_unpaid sh_non_ag_empl sh_non_ag_se sh_non_ag_wage_young sh_ag_wage sh_indu_wage sh_serv_wage mean_wages_hourly_def mean_wages_monthly_def mean_wages_monthly_def_agri mean_wages_monthly_def_indu ///
mean_wages_monthly_def_serv mean_wages_hourly_def_real mean_wages_monthly_def_real mean_wages_hourly_usd mean_wages_monthly_usd age_worker age age_worker_agriculture ///
age_worker_industry age_worker_services age_worker_wage age_worker_se_unpaid age_worker_employer sh_educy sh_literacy sh_enrolled sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag 


foreach x in `shares'{
local l`x' : variable label `x' 
}


collapse (count) no_* (mean) sh_*  mean_hours mean_wages_* age age_worker* (median) wages_* [iw=wgt], by(countryname year sample1 sample_type sample_size)

	


foreach x in `shares' {
label var `x' "`l`x''" 
local varlabel: var label `x'
}	

gen ratio_gender_gap=wages_female/wages_male
label var ratio_gender_gap "Female to Male gender wage gap, calculated with median wages"

gen ratio_sector_gap=wages_public/wages_private
label var ratio_sector_gap "Public to Private wage gap, calculated with median wages"

drop wages_female wages_male wages_public wages_private

gen filter="Young"

order countryname year sample1 sample_type sample_size filter no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_  mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_edu sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag

save "$data\`var'_test_young", replace




*********************************************
************** Male ************************
*********************************************


use "$data\`var'_test", clear

** Reduce to necessary variables
keep no_* sh_* wages_* mean_hours countryname ccode year_s year sample1 gender sample_type sample_size age_x urb wgt age low_edu  age_worker* mean_* agemin agemax ageint
drop no_contract no_healthins no_socialsec sh_missing__ sh_ind_miss_ sh_agr_det


compress



gen sh_dependency=. 
gen sh_dependency_youth=.
gen sh_dependency_old=.

keep if gender==1


local shares countryname  year sample1 sample_type sample_size no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap  ///
no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young ///
sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women ///
sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ ///
sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ ///
sh_underemp sh_excemp  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ ///
sh_sec_educ sh_postsec_educ sh_formal_con sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real ///
wages_monthly_usd sh_non_ag_wage sh_non_ag_unpaid sh_non_ag_empl sh_non_ag_se sh_non_ag_wage_young sh_ag_wage sh_indu_wage sh_serv_wage mean_wages_hourly_def mean_wages_monthly_def mean_wages_monthly_def_agri mean_wages_monthly_def_indu ///
mean_wages_monthly_def_serv mean_wages_hourly_def_real mean_wages_monthly_def_real mean_wages_hourly_usd mean_wages_monthly_usd age_worker age age_worker_agriculture ///
age_worker_industry age_worker_services age_worker_wage age_worker_se_unpaid age_worker_employer sh_educy sh_literacy sh_enrolled sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag 

foreach x in `shares'{
local l`x' : variable label `x' 
}

collapse (count) no_* (mean) sh_*  mean_hours mean_wages_* age age_worker* (median) wages_* [iw=wgt], by(countryname year sample1 sample_type sample_size)


foreach x in `shares' {
label var `x' "`l`x''" 
local varlabel: var label `x'
}	

gen ratio_gender_gap=wages_female/wages_male
label var ratio_gender_gap "Female to Male gender wage gap, calculated with median wages"

gen ratio_sector_gap=wages_public/wages_private
label var ratio_sector_gap "Public to Private wage gap, calculated with median wages"

drop wages_female wages_male wages_public wages_private

gen filter="Male"

order countryname year sample1 sample_type sample_size filter no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_  mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_edu sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag

save "$data\`var'_test_male", replace



*********************************************
************** Female ***********************
*********************************************


use "$data\`var'_test", clear

** Reduce to necessary variables
keep no_* sh_* wages_* mean_hours countryname ccode year_s year sample1 gender sample_type sample_size age_x urb wgt age low_edu  age_worker* mean_* agemin agemax ageint
drop no_contract no_healthins no_socialsec sh_missing__ sh_ind_miss_ sh_agr_det


compress



gen sh_dependency=. 
gen sh_dependency_youth=.
gen sh_dependency_old=.

keep if gender==2


local shares countryname  year sample1 sample_type sample_size no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap  ///
no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young ///
sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women ///
sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ ///
sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ ///
sh_underemp sh_excemp  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ ///
sh_sec_educ sh_postsec_educ sh_formal_con sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real ///
wages_monthly_usd sh_non_ag_wage sh_non_ag_unpaid sh_non_ag_empl sh_non_ag_se sh_non_ag_wage_young sh_ag_wage sh_indu_wage sh_serv_wage mean_wages_hourly_def mean_wages_monthly_def mean_wages_monthly_def_agri mean_wages_monthly_def_indu ///
mean_wages_monthly_def_serv mean_wages_hourly_def_real mean_wages_monthly_def_real mean_wages_hourly_usd mean_wages_monthly_usd age_worker age age_worker_agriculture ///
age_worker_industry age_worker_services age_worker_wage age_worker_se_unpaid age_worker_employer sh_educy sh_literacy sh_enrolled sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag 


foreach x in `shares'{
local l`x' : variable label `x' 
}

collapse (count) no_* (mean) sh_*  mean_hours mean_wages_* age age_worker* (median) wages_* [iw=wgt], by(countryname year sample1 sample_type sample_size)


foreach x in `shares' {
label var `x' "`l`x''" 
local varlabel: var label `x'
}	

gen ratio_gender_gap=wages_female/wages_male
label var ratio_gender_gap "Female to Male gender wage gap, calculated with median wages"

gen ratio_sector_gap=wages_public/wages_private
label var ratio_sector_gap "Public to Private wage gap, calculated with median wages"

drop wages_female wages_male wages_public wages_private

gen filter="Female"

order countryname year sample1 sample_type sample_size filter no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_  sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_  mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_edu sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag

save "$data\`var'_test_female", replace



*********************************************
************** High education****************
*********************************************


use "$data\`var'_test", clear

** Reduce to necessary variables
keep no_* sh_* wages_* mean_hours countryname ccode year_s year sample1 gender sample_type sample_size age_x urb wgt age low_edu  age_worker* mean_* agemin agemax ageint
drop no_contract no_healthins no_socialsec sh_missing__ sh_ind_miss_ sh_agr_det


compress



gen sh_dependency=. 
gen sh_dependency_youth=.
gen sh_dependency_old=.

keep if low_edu==0


local shares countryname  year sample1 sample_type sample_size no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap  ///
no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young ///
sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women ///
sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ ///
sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ ///
sh_underemp sh_excemp  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ ///
sh_sec_educ sh_postsec_educ sh_formal_con sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real ///
wages_monthly_usd sh_non_ag_wage sh_non_ag_unpaid sh_non_ag_empl sh_non_ag_se sh_non_ag_wage_young sh_ag_wage sh_indu_wage sh_serv_wage mean_wages_hourly_def mean_wages_monthly_def mean_wages_monthly_def_agri mean_wages_monthly_def_indu ///
mean_wages_monthly_def_serv mean_wages_hourly_def_real mean_wages_monthly_def_real mean_wages_hourly_usd mean_wages_monthly_usd age_worker age age_worker_agriculture ///
age_worker_industry age_worker_services age_worker_wage age_worker_se_unpaid age_worker_employer sh_educy sh_literacy sh_enrolled sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag 


foreach x in `shares'{
local l`x' : variable label `x' 
}

collapse (count) no_* (mean) sh_*  mean_hours mean_wages_* age age_worker* (median) wages_* [iw=wgt], by(countryname year sample1 sample_type sample_size)


foreach x in `shares' {
label var `x' "`l`x''" 
local varlabel: var label `x'
}	

gen ratio_gender_gap=wages_female/wages_male
label var ratio_gender_gap "Female to Male gender wage gap, calculated with median wages"

gen ratio_sector_gap=wages_public/wages_private
label var ratio_sector_gap "Public to Private wage gap, calculated with median wages"

drop wages_female wages_male wages_public wages_private

gen filter="High Education"

order countryname year sample1 sample_type sample_size filter no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_  mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_edu  sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag

save "$data\`var'_test_High_Edu", replace



*********************************************
************** Low Education*****************
*********************************************


use "$data\`var'_test", clear

** Reduce to necessary variables
keep no_* sh_* wages_* mean_hours countryname ccode year_s year sample1 gender sample_type sample_size age_x urb wgt age low_edu  age_worker* mean_* agemin agemax ageint
drop no_contract no_healthins no_socialsec sh_missing__ sh_ind_miss_ sh_agr_det


compress



gen sh_dependency=. 
gen sh_dependency_youth=.
gen sh_dependency_old=.

keep if low_edu==1



local shares countryname  year sample1 sample_type sample_size no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap  ///
no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young ///
sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_informal_ sh_formal_ sh_formal_miss_  sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women ///
sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ ///
sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_ mean_hours_ ///
sh_underemp sh_excemp  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv sh_no_educ sh_prim_educ ///
sh_sec_educ sh_postsec_educ sh_formal_con sh_UnSe_ sh_formal_health_ sh_formal_socialsec_	wages_hourly_def_real wages_hourly_usd wages_monthly_def_real ///
wages_monthly_usd sh_non_ag_wage sh_non_ag_unpaid sh_non_ag_empl sh_non_ag_se sh_non_ag_wage_young sh_ag_wage sh_indu_wage sh_serv_wage mean_wages_hourly_def mean_wages_monthly_def mean_wages_monthly_def_agri mean_wages_monthly_def_indu ///
mean_wages_monthly_def_serv mean_wages_hourly_def_real mean_wages_monthly_def_real mean_wages_hourly_usd mean_wages_monthly_usd age_worker age age_worker_agriculture ///
age_worker_industry age_worker_services age_worker_wage age_worker_se_unpaid age_worker_employer sh_educy sh_literacy sh_enrolled sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag 


foreach x in `shares'{
local l`x' : variable label `x' 
}

collapse (count) no_* (mean) sh_*  mean_hours mean_wages_* age age_worker* (median) wages_* [iw=wgt], by(countryname year sample1 sample_type sample_size)



foreach x in `shares' {
label var `x' "`l`x''" 
local varlabel: var label `x'
}	

gen ratio_gender_gap=wages_female/wages_male
label var ratio_gender_gap "Female to Male gender wage gap, calculated with median wages"

gen ratio_sector_gap=wages_public/wages_private
label var ratio_sector_gap "Public to Private wage gap, calculated with median wages"

drop wages_female wages_male wages_public wages_private

gen filter="Low Education"

order countryname year sample1 sample_type sample_size filter no_pop_ sh_child_ sh_youth_  sh_adult_  sh_elderly_  sh_urb sh_wap sh_dependency sh_dependency_youth sh_dependency_old no_lf_numb sh_lf_  sh_lf_fem sh_nlfe_young sh_empl_ sh_secondary sh_empr_all  sh_unempr_all sh_empr_young sh_unempr_young  sh_wage_ sh_self_ sh_unpaid_ sh_emps_ sh_UnSe_ sh_informal_ sh_formal_ sh_formal_miss_  sh_formal_con sh_formal_health_ sh_formal_socialsec_ sh_pub_ sh_agr_ sh_ind_ sh_serv_ sh_nonagr_women sh_nonagr_youth sh_ind_min 	sh_ind_manu sh_ind_pub sh_ind_cons sh_serv_com sh_serv_trans sh_serv_fbs  sh_serv_pa sh_serv_rest sh_occup_senior_ sh_occup_prof_ sh_occup_techn_ sh_occup_clerk_ sh_occup_servi_ sh_occup_skillagr_ sh_occup_craft_ sh_occup_machi_ sh_occup_eleme_ sh_occup_armed_  mean_hours_ sh_underemp sh_excemp 	  wages_hourly_def  wages_monthly_def wages_monthly_def_agri wages_monthly_def_indu wages_monthly_def_serv wages_hourly_def_real wages_hourly_usd wages_monthly_def_real wages_monthly_usd ratio_gender_gap ratio_sector_gap sh_no_educ sh_prim_educ sh_sec_educ sh_postsec_edu  sh_informal_ext sh_informal_narrow sh_informal_non_ag_wide sh_informal_non_ag

save "$data\`var'_test_Low_Edu", replace



***
use "$data\`var'_test_all", clear

append using "$data\`var'_test_urban"
append using "$data\`var'_test_rural"
append using "$data\`var'_test_young"
append using "$data\`var'_test_old"
append using "$data\`var'_test_Low_Edu"
append using "$data\`var'_test_High_Edu"
append using "$data\`var'_test_female"
append using "$data\`var'_test_male"
gen str region="`var'"
sort countryname year sample1 filter
merge m:m countryname year sample1 using "$data\`var'_missing"
drop _merge


** Mark non-sharable surveys

** Exclude non-sharable surveys
gen byte restriction=0
/*replace restriction=1 if countryname=="AUS" | ccode=="MYS" | ccode=="TUV" | ccode=="KIR" | (ccode=="HTI" & year==2007) | (ccode=="ZMB" & year==2014) | ccode=="SAU"
/* RESTRICTIONS FROM MARCO RANZANI*/
replace restriction=1 if (ccode=="LBR" & year==2010) | (ccode=="NAM" & (year==2012 | year==2013 | year==2014)) | (ccode=="ZMB" & year==2012) ///
                       | (ccode=="NGA" & year==2012) | (ccode=="AFG" & year==2013)
*/
label var restriction "Do not share publicly"

*** Dependencies shares are only kept for the overall group and not the sub-groups
replace sh_dependency=.  if filter!="All"
replace sh_dependency_youth=. if filter!="All" 
replace sh_dependency_old=. if filter!="All"

drop sh_formal_miss_  /// Exclude this for easier calculation



save "$data\`var'_all", replace

erase "$data\`var'_test_urban.dta"
erase "$data\`var'_test_rural.dta"
erase "$data\`var'_test_young.dta"
erase "$data\`var'_test_old.dta"
erase "$data\`var'_test_Low_Edu.dta"
erase "$data\`var'_test_High_Edu.dta"
erase "$data\`var'_test_female.dta"
erase "$data\`var'_test_male.dta"
*erase "$data\`var'_test.dta"
erase "$data\`var'_test_all.dta"
erase "$data\`var'_missing.dta"
}


/*
use "$data\SSA_all", clear

foreach var in  SA MNA NA  ECA EAP LAC_NO_BRAZIL LAC_BRAZIL  {
append using "$data\`var'_all"
}
 



