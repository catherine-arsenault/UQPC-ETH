
* UQPC 
* Data cleaning
* EFY 2014
*------------------------------------------------------------------------------*
global project "/Users/catherine.arsenault/Dropbox/9 PAPERS & PROJECTS/UQPC/DHIS2/"

* Appending facility types 
*HP
use "$project/Data/Data for analysis/Health posts 2014.dta", clear
drop region facility_name
gen facility_type = 1
save "$project/Data/Data for analysis/UQPC 2014.dta", replace

*HC
use "$project/Data/Data for analysis/Health centers 2014.dta", clear
drop region facility_name
gen facility_type = 2
append using "$project/Data/Data for analysis/UQPC 2014.dta"
save "$project/Data/Data for analysis/UQPC 2014.dta", replace

*Clinics
use "$project/Data/Data for analysis/Private clinics 2014.dta", clear
drop region facility_name
gen facility_type = 3
append using "$project/Data/Data for analysis/UQPC 2014.dta"
save "$project/Data/Data for analysis/UQPC 2014.dta", replace

* Public H
use "$project/Data/Data for analysis/Public hospital 2014.dta", clear
drop region facility_name
gen facility_type = 4
append using "$project/Data/Data for analysis/UQPC 2014.dta"
save "$project/Data/Data for analysis/UQPC 2014.dta", replace

* Private H
use "$project/Data/Data for analysis/Private hospital 2014.dta", clear
drop region facility_name
gen facility_type = 5
append using "$project/Data/Data for analysis/UQPC 2014.dta", force
save "$project/Data/Data for analysis/UQPC 2014.dta", replace

order facility_type, after(orgunitlevel2)
lab def facility_type 1"Health posts" 2"Health centers" 3"Private clinics" 4"Public hospitals" 5"Private hospitals"
lab val facility_type facility_type

*------------------------------------------------------------------------------*
encode orgunitlevel2, gen(region)
drop orgunitlevel1

* Removing 6 facilities that were duplicated in two facility type datasets
drop if organisationunitid =="NWbRyTbZ6Tl" & facility_type==3 // Asella Rehoboth Hospital is a private hospital
drop if organisationunitid =="rKk9wG6waw3"  & facility_type==3 // Chilaloo Shede Hospital is a private hospital
drop if organisationunitid =="MEJYJtqSqlT" & facility_type==5 // Modjo Primary Hospital is a public hospital
drop if organisationunitid =="eVTPDz6hLUx" & facility_type==3 // Negelle Arsi General Hospital and Medical College is a Private Hospital
drop if organisationunitid =="JSpq4Ygdf99" & facility_type==3 // Rifty Valley Hospital is a Private Hospital
drop if organisationunitid =="AfLp2iNnWDH" & facility_type==1 // Sadi Mikael Health Center is a health center

* Unique facility ids
encode organisationunitid, gen(facid)
order region period facility_type facid org*

sort region facility_type facid period 
save "$project/Data/Data for analysis/UQPC 2014.dta", replace
*------------------------------------------------------------------------------*
* FACILITY-LEVEL DATA CLEANING: MONTLY DATA

* Outlier value
replace ART_total=. if organisationunitid=="CANLdN1PnUh" & period==9 // outlier value over 2 billion

* Replace missing indicators to 0 when related indicator is not missing
replace Post_Contra = 0 if Faci_delivery!=. & Faci_delivery!=0 & Post_Contra==.
replace ANC_first_16 = 0 if ANC_first_total!=. & ANC_first_total!=0 & ANC_first_16 ==.

replace syphilis_tested_preg= 0 if ANC_first_total!=. & ANC_first_total!=0 & syphilis_tested_preg==. & facility_type!=1
replace Hepat_BC_tested_preg= 0 if ANC_first_total!=. & ANC_first_total!=0 & Hepat_BC_tested_preg==. & facility_type!=1
replace HIV_tested_preg = 0 if ANC_first_total!=. & ANC_first_total!=0 & HIV_tested_preg==. & facility_type!=1

replace IFA_received_preg= 0 if  ANC_first_total!=. & ANC_first_total!=0  & IFA_received_preg==.

replace PNC_seven_days = PNC_two_days if PNC_seven_days==. & PNC_two_days!=.
replace malnutrition_exit= malnutrition_cured if malnutrition_exit==. & malnutrition_cured!=.

replace Hyper_raised_BP = Hyper_enrol_care if Hyper_raised_BP==. & Hyper_enrol_care!=.
replace Diabet_raised_BS = Diabet_enrol_care if Diabet_raised_BS==. & Diabet_enrol_care !=.

replace Diabet6_enrol_care = Diabet6_controlled if Diabet6_enrol_care==. & Diabet6_controlled!=.
replace Hyper6_enrol_care = Hyper6_controlled if Hyper6_enrol_care==. & Hyper6_controlled!=.

replace Drug_presc_received = Drug_presc_100 if Drug_presc_received==. & Drug_presc_100!=.

*------------------------------------------------------------------------------*
* CHECK COMPLETENESS AFTER IMPUTING ZEROS
preserve 
	local varlist Post_Contra  Faci_delivery ANC_first_16 ANC_first_total ANC_four_visits syphilis_tested_preg Hepat_BC_tested_preg HIV_tested_preg IFA_received_preg PNC_seven_days PNC_two_days DPT3_received DPT1_received OPV3_received OPV1_received PCV3_received PCV1_received Rota2_received Rota1_received VitaminA2_received VitaminA1_received Dewormed_second Dewormed_first malnutrition_exit malnutrition_cured ART_still ART_original viral_load_undetect viral_load_tested TB_ART_screened ART_total Hyper_raised_BP Diabet_raised_BS Hyper_enrol_care Diabet_enrol_care Diabet6_controlled Diabet6_enrol_care Hyper6_controlled Hyper6_enrol_care Drug_presc_100 Drug_presc_received Essential_drug_avail FP_total OPD_total

	foreach x of local varlist  {
		egen count`x'=count(`x'), by(organisationunitid)
		replace count`x'=. if count`x'==0
		}	
		
	collapse (count) Post_Contra-countOPD_total, by(region period facility_type)
			
	foreach x of local varlist  {
	cap gen complete`x'=(`x'/count`x')*100
	}
	export excel using "$project/completeness_2014_after_cleaning.xlsx", firstrow(variable) sheetreplace
restore 		
*------------------------------------------------------------------------------*
* FACILITY-LEVEL DATA CLEANING: ANNUAL LEVEL

* Collapse at the annual level for each facility 
collapse (sum) Post_Contra-OPD_total, by(region facility_type facid org*)

replace ART_original = ART_still if ART_original==0 & ART_still!=0
replace ART_total= TB_ART_screened if ART_total==0 & TB_ART_screened!=0 
replace viral_load_test= viral_load_undetect if viral_load_test==0 & viral_load_undetect!=0


* Collapse by region and facility type
preserve 
	collapse (sum) Post_Contra-OPD_total  , by(region facility_type)
	export excel using "$project/EFY 2014 results.xlsx", sheet("Sums") firstrow(variable) sheetreplace
restore

	collapse (count) Post_Contra-OPD_total  , by(region facility_type)
	export excel using "$project/EFY 2014 results.xlsx", sheet("Counts") firstrow(variable) sheetreplace

