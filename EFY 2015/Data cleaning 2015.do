
* Primary care performance
* Data cleaning
* EFY 2015
*------------------------------------------------------------------------------*
*global project "/Users/dessalegnsheabo/Desktop/UQPC/DHIS2"
global project "/Users/catherine.arsenault/Dropbox/9 PAPERS & PROJECTS/UQPC/DHIS2/"

* Appending facility types 
	*HP
	use "$project/Data/Data for analysis/Health posts 2015.dta", clear
	drop region facility_name
	gen facility_type = 1
	save "$project/Data/Data for analysis/UQPC 2015.dta", replace
	*HC
	use "$project/Data/Data for analysis/Health centers 2015.dta", clear
	drop region facility_name
	gen facility_type = 2
	append using "$project/Data/Data for analysis/UQPC 2015.dta", force
	save "$project/Data/Data for analysis/UQPC 2015.dta", replace

	*Clinics
	use "$project/Data/Data for analysis/Private clinics 2015.dta", clear
	drop region facility_name
	gen facility_type = 3
	append using "$project/Data/Data for analysis/UQPC 2015.dta", force
	save "$project/Data/Data for analysis/UQPC 2015.dta", replace

	* Public H
	use "$project/Data/Data for analysis/Public hospitals 2015.dta", clear
	drop region facility_name
	gen facility_type = 4
	append using "$project/Data/Data for analysis/UQPC 2015.dta" , force
	save "$project/Data/Data for analysis/UQPC 2015.dta", replace

	* Private H
	use "$project/Data/Data for analysis/Private hospitals 2015.dta", clear
	drop region facility_name
	gen facility_type = 5
	append using "$project/Data/Data for analysis/UQPC 2015.dta", force
	save "$project/Data/Data for analysis/UQPC 2015.dta", replace

	order facility_type, after(orgunitlevel2)
	lab def facility_type 1"Health posts" 2"Health centers" 3"Private clinics" 4"Public hospitals" 5"Private hospitals"
	lab val facility_type facility_type
*------------------------------------------------------------------------------*
encode orgunitlevel2, gen(region)
drop orgunitlevel1

* Removing 4 facilities that were duplicated as two different facility types
drop if organisationunitid =="NWbRyTbZ6Tl" & facility_type==3 // Asella Rehoboth Hospital is a private hospital
drop if organisationunitid =="rKk9wG6waw3"  & facility_type==3 // Chilaloo Shede Hospital is a private hospital
drop if organisationunitid =="MEJYJtqSqlT" & facility_type==5 // Modjo Primary Hospital is a public hospital
drop if organisationunitid =="JSpq4Ygdf99" & facility_type==3 // Rifty Valley Hospital is a Private Hospital

* Unique facility ids
encode organisationunitid, gen(facid)
order region period facility_type facid org*

sort region facility_type facid period 
save "$project/Data/Data for analysis/UQPC 2015.dta", replace

*------------------------------------------------------------------------------*
* CHECK COMPLETENESS 
preserve 
	local varlist Post_Contra Faci_delivery ANC_first_12 ANC_first_total ANC_four_visits	 ANC_eight_visits  syphilis_tested_preg Hepat_B_tested_preg HIV_tested_preg malnu_screened_PLW	 IFA_received_preg PNC_two_days	PNC_seven_days  Penta3_received	Penta1_received Polio3_received	Polio1_received pneumococcal3_received	pneumococcal1_received Rota2_received	Rota1_received malnutrition_cured	malnutrition_exit ART_still ART_original Viral_load_undetect	Viral_load_tested TB_ART_screened	ART_total TB_case_completed	TB_case_total TPT_treat_completed	TPT_treat_started Hyper_enrol_care	Hyper_raised_BP Hyper6_controlled	Hyper6_enrol_care Diabet_enrol_care	Diabet_raised_BS  Diabet6_controlled	Diabet6_enrol_care cervical_treated	cervical_test_positive 	 Antibio_enco_1plus	Antibio_enco_total Drug_presc_100	Drug_presc_received Hyper_Referred_HC Diabetes_Referred_HC Hyper_raisedHP Diabetes_raisedHP FP_total OPD_total

	foreach x of local varlist  {
		egen count`x'=count(`x'), by(organisationunitid)
		replace count`x'=. if count`x'==0
		}	
		
	collapse (count) FP_total-countOPD_total, by(region period facility_type)
	sort region facility_type period
	
	foreach x of local varlist  {
		gen complete`x'=(`x'/count`x')*100
		egen avg_compl_`x' = mean(complete`x'), by(region facility_type) 
	}
	
	order avg_*, after(completeOPD_total)
	export excel using "$project/completeness_2015_after_cleaning.xlsx", firstrow(variable) sheet("By fac type") sheetreplace
restore 		

preserve
foreach x of local varlist  {
		egen count`x'=count(`x'), by(organisationunitid)
		replace count`x'=. if count`x'==0
		}	
		
	collapse (count) FP_total-countOPD_total, by(region period )
	sort region period
	
	foreach x of local varlist  {
		gen complete`x'=(`x'/count`x')*100
		egen avg_compl_`x' = mean(complete`x'), by(region) 
	}
	
	order avg_*, after(completeDiabetes_Referred_HC)
	export excel using "$project/completeness_2015_after_cleaning.xlsx", firstrow(variable) sheet("By region") sheetreplace
restore 
*------------------------------------------------------------------------------*
* Analysis focused on a subset of data elements
global finallist FP_total OPD_total Post_Contra Faci_delivery ANC_first_12 ANC_first_total ANC_four_visits syphilis_tested_preg HIV_tested_preg IFA_received_preg Penta3_received Penta1_received Rota2_received Rota1_received ART_still ART_original Viral_load_undetect Viral_load_tested TB_case_total TB_case_completed Hyper6_controlled Hyper6_enrol_care Diabet6_controlled Diabet6_enrol_care Antibio_enco_1plus Antibio_enco_total Drug_presc_100	Drug_presc_received

* Removing facilities that don't report 
egen total = rowtotal($finallist)
egen maxtotal= max(total), by(organisationunitid)
drop if maxtotal ==0
drop total maxtotal // 144,744 observations and 12,062 unique facilities

/* Identifying outliers
 Outliers defined as observations that are greater than 3 SD from the mean over the year
 and are volumes larger than 100 clients.
*/
foreach x of global finallist {
	egen mean`x'= mean(`x'), by(organisationunitid)
	egen sd`x'= sd(`x'), by(organisationunitid)
	gen pos_out`x' = mean`x'+(3*(sd`x')) 
	gen flag_pout`x' = 1 if `x'> pos_out`x' & `x'<.
	replace flag_pout`x' =. if mean`x' <100
	egen flag`x' = max(flag_pout`x'), by(organisationunitid)
}
	tabstat flag_pout*, stat(count) col(stat)
 	tabstat $finallist , stat(count) col(stat)
	
	
* Replace outliers to missing
foreach x of global finallist {
	replace `x'= . if flag_pout`x' == 1
}

*------------------------------------------------------------------------------*
* FACILITY-LEVEL DATA CLEANING: ANNUAL LEVEL
	keep region period facility_type facid org* $finallist
	
* Collapse at the annual level for each facility 
	collapse (sum) FP_total-TB_case_completed, by(region facility_type facid org*)

*replace ART_original = ART_still if ART_original==0 & ART_still!=0 // what about the transfers in ?
*replace ART_total= TB_ART_screened if ART_total==0 & TB_ART_screened!=0 
* replace Viral_load_tested= Viral_load_undetect if Viral_load_tested==0 & Viral_load_undetect!=0

save "$project/Data/Data for analysis/UQPC 2015 annual by facility.dta", replace














