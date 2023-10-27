
* UQPC 
* Data analysis
*------------------------------------------------------------------------------*
* EFY 2015
*global project "/Users/dessalegnsheabo/Desktop/UQPC/DHIS2"
global project "/Users/catherine.arsenault/Dropbox/9 PAPERS & PROJECTS/UQPC/DHIS2/"

use "$project/Data/Data for analysis/UQPC 2015 annual by facility.dta", clear  // sum of services in 12066 facilities

	gen HP_IFA_received_preg = IFA_received_preg if ANC_first_total>0 & facility_type==1
	replace IFA_received_preg = . if facility_type==1
	
* Collapsing at regional level by facility type
	collapse (sum) FP_total-HP_IFA_received_preg  , by(region facility_type)

* Creating the quality indicators
gen ippcar = Post_Contra/Faci_delivery
gen timely_anc = ANC_first_12 / ANC_first_total
gen anc4_retention = ANC_four_visits / ANC_first_total
gen anc8_retention = ANC_eight_visits / ANC_first_total
gen anc_syph = syphilis_tested_preg / ANC_first_total
gen anc_hep = Hepat_B_tested_preg / ANC_first_total 
gen anc_hiv = HIV_tested_preg / ANC_first_total 
gen anc_malnu = malnu_screened_PLW / ANC_first_total 
gen anc_IFA = IFA_received_preg / ANC_first_total 
replace anc_IFA = HP_IFA_received_preg / ANC_first_total  if facility_type==1
gen timely_pnc = PNC_two_days / PNC_seven_days
gen pnc_rate =  PNC_seven_days / Faci_delivery //check how much the result is sensible
gen penta_retention = Penta3_received / Penta1_received
gen polio_retention = Polio3_received / Polio1_received 
gen pneumococcal_retention = pneumococcal3_received / pneumococcal1_received
gen rota_retention = Rota2_received / Rota1_received 
gen malnut_tx_success = malnutrition_cured / malnutrition_exit  
gen ART_12retention = ART_still / ART_original 
gen viral_supress = Viral_load_undetect / Viral_load_tested 
gen TB_ART = TB_ART_screened / ART_total
gen TB_success = TB_case_completed / TB_case_total
gen TPT_compl = TPT_treat_completed / TPT_treat_started
gen hyper_referal = Hyper_Referred_HC / Hyper_raisedHP
gen diab_referal =  Diabetes_Referred_HC / Diabetes_raisedHP
gen hyper_tx = Hyper_enrol_care / Hyper_raised_BP  
gen diab_tx = Diabet_enrol_care / Diabet_raised_BS 
gen hyper_6control= Hyper6_controlled / Hyper6_enrol_care
gen diab_6control = Diabet6_controlled / Diabet6_enrol_care 
gen cervical_tx = cervical_treated / cervical_test_positive
gen antibio_prescrip = Antibio_enco_1plus /Antibio_enco_total
gen drug_avail = Drug_presc_100 / Drug_presc_received 



order region facility_type Faci_delivery Post_Contra ippcar ANC_first_total ANC_first_12  timely_anc ///
	  ANC_four_visits anc4_retention ANC_eight_visits anc8_retention syphilis_tested_preg anc_syph ///
	  Hepat_B_tested_preg anc_hep HIV_tested_preg anc_hiv malnu_screened_PLW anc_malnu IFA_received_preg ///
	  anc_IFA PNC_seven_days PNC_two_days timely_pnc pnc_rate Penta1_received Penta3_received penta_retention ///
	  Polio1_received Polio3_received polio_retention pneumococcal1_received pneumococcal3_received ///
	  pneumococcal_retention  Rota1_received Rota2_received rota_retention malnutrition_exit malnutrition_cured ///
	  malnut_tx_success ART_original ART_still ART_12retention Viral_load_tested Viral_load_undetect ///
	  viral_supress ART_total  TB_ART_screened TB_ART TB_case_total TB_case_completed TB_success  TPT_treat_started ///
	  TPT_treat_completed TPT_compl  Hyper_raisedHP Hyper_Referred_HC   hyper_referal Diabet_raised_BS  ///
	  Diabetes_Referred_HC diab_referal Hyper_raised_BP  Hyper_enrol_care hyper_tx Diabet_raised_BS  ///
	  Diabet_enrol_care diab_tx  Hyper6_enrol_care Hyper6_controlled hyper_6control Diabet6_enrol_care ///
	  Diabet6_controlled diab_6control cervical_test_positive  cervical_treated  cervical_tx ///
	  Antibio_enco_total Antibio_enco_1plus antibio_prescrip Drug_presc_received ///
	  Drug_presc_100 drug_avail

	 export excel using "$project/EFY 2015 results.xlsx", firstrow(variable) sheetreplace
	  

* ART cohort at end of year 
	use "$project/Data/Data for analysis/UQPC 2015.dta", clear
	keep if period==12
	collapse (sum) ART_total  , by(region facility_type)






















