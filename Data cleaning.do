
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


* Drops duplicates (for now)
drop if organisationunitid =="NWbRyTbZ6Tl" | organisationunitid =="rKk9wG6waw3" ///
| organisationunitid =="MEJYJtqSqlT" | organisationunitid =="eVTPDz6hLUx" ///
| organisationunitid =="JSpq4Ygdf99" | organisationunitid =="AfLp2iNnWDH"


* Unique facility ids
encode organisationunitid, gen(facid)
order region period facility_type facid org*

sort region facility_type facid period 
save "$project/Data/Data for analysis/UQPC 2014.dta", replace
*------------------------------------------------------------------------------*
* FACILITY-LEVEL DATA CLEANING: MONTLY DATA

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
* FACILITY-LEVEL DATA CLEANING: ANNUAL LEVEL

* Collapse at the annual level for each facility 
collapse (sum) Post_Contra-OPD_total, by(region facility_type facid org*)

replace ART_original = ART_still if ART_original==0 & ART_still!=0
replace ART_total= TB_ART_screened if ART_total==0 & TB_ART_screened!=0 
replace viral_load_test= viral_load_undetect if viral_load_test==0 & viral_load_undetect!=0

* Collapse by region and facility type
collapse (sum) Post_Contra-OPD_total, by(region facility_type)


