
* UQPC 
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
* FACILITY-LEVEL DATA CLEANING: MONTHLY DATA

* no outlier value

* Replace missing indicators to 0 when related indicator is not missing
replace Post_Contra = 0 if Faci_delivery!=. & Faci_delivery!=0 & Post_Contra==.

replace ANC_first_12 = 0 if ANC_first_total!=. & ANC_first_total!=0 & ANC_first_12 ==.

replace syphilis_tested_preg= 0 if ANC_first_total!=. & ANC_first_total!=0 & syphilis_tested_preg==. & facility_type!=1
replace Hepat_B_tested_preg= 0 if ANC_first_total!=.  & ANC_first_total!=0 & Hepat_B_tested_preg==. & facility_type!=1
replace HIV_tested_preg = 0 if ANC_first_total!=.     & ANC_first_total!=0 & HIV_tested_preg==. & facility_type!=1

replace IFA_received_preg= 0 if  ANC_first_total!=. & ANC_first_total!=0  & IFA_received_preg==.

replace PNC_seven_days = PNC_two_days if PNC_seven_days==. & PNC_two_days!=.
replace malnutrition_exit= malnutrition_cured if malnutrition_exit==. & malnutrition_cured!=.

replace Hyper_raised_BP = Hyper_enrol_care if Hyper_raised_BP==. & Hyper_enrol_care!=.

replace Diabet_raised_BS = Diabet_enrol_care if Diabet_raised_BS==. & Diabet_enrol_care !=.

replace Diabet6_enrol_care = Diabet6_controlled if Diabet6_enrol_care==. & Diabet6_controlled!=.
replace Hyper6_enrol_care = Hyper6_controlled if Hyper6_enrol_care==. & Hyper6_controlled!=.

replace Drug_presc_received = Drug_presc_100 if Drug_presc_received==. & Drug_presc_100!=.

drop VitaminA2_received VitaminA1_received Dewormed_second Dewormed_first Essential_drug_avail // removing these from the analysis

save "$project/Data/Data for analysis/UQPC 2015.dta", replace
*------------------------------------------------------------------------------*
* CHECK COMPLETENESS AFTER IMPUTING ZEROS
preserve 
	local varlist Post_Contra Faci_delivery ANC_first_12	ANC_first_total ANC_four_visits	 ANC_eight_visits  syphilis_tested_preg Hepat_B_tested_preg HIV_tested_preg malnu_screened_PLW	 IFA_received_preg PNC_two_days	PNC_seven_days  Penta3_received	Penta1_received Polio3_received	Polio1_received pneumococcal3_received	pneumococcal1_received Rota2_received	Rota1_received malnutrition_cured	malnutrition_exit ART_still ART_original Viral_load_undetect	Viral_load_tested TB_ART_screened	ART_total TB_case_completed	TB_case_total TPT_treat_completed	TPT_treat_started Hyper_enrol_care	Hyper_raised_BP Hyper6_controlled	Hyper6_enrol_care Diabet_enrol_care	Diabet_raised_BS  Diabet6_controlled	Diabet6_enrol_care cervical_treated	cervical_test_positive 	 Antibio_enco_1plus	Antibio_enco_total Drug_presc_100	Drug_presc_received Hyper_Referred_HC Diabetes_Referred_HC Hyper_raisedHP Diabetes_raisedHP FP_total OPD_total

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
	
	order avg_*, after(completeDiabetes_Referred_HC)
	export excel using "$project/completeness_2015_after_cleaning.xlsx", firstrow(variable) sheetreplace
restore 		
*------------------------------------------------------------------------------*
* FACILITY-LEVEL DATA CLEANING: ANNUAL LEVEL

* Collapse at the annual level for each facility 
collapse (sum) FP_total-Diabetes_raisedHP, by(region facility_type facid org*)

replace ART_original = ART_still if ART_original==0 & ART_still!=0 // what about the transfers ?
replace ART_total= TB_ART_screened if ART_total==0 & TB_ART_screened!=0 
replace Viral_load_tested= Viral_load_undetect if Viral_load_tested==0 & Viral_load_undetect!=0

* Drop facilities that report none of the indicators included
egen total = rowtotal(FP_total-Diabetes_raisedHP) // 15,578 facilities listed
drop if total==0 // 3512 reported none of the indicators, remaining total is 12066 facilities
drop total

save "$project/Data/Data for analysis/UQPC 2015 annual by facility.dta", replace














