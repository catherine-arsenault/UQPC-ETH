
* UQPC 
* Data analysis

*------------------------------------------------------------------------------*
* EFY 2014

use "$project/Data/Data for analysis/UQPC 2014 annual by facility.dta", clear // sum of services in 11,427 facilities

	gen HP_IFA_received_preg = IFA_received_preg if ANC_first_total>0 & facility_type==1
	replace IFA_received_preg = . if facility_type==1
	
* Collapsing at regional level by facility type
	collapse (sum) Post_Contra-HP_IFA_received_preg  , by(region facility_type)

* Creating the quality indicators
gen ippcar= Post_Contra/Faci_delivery
gen timely_anc= ANC_first_16 / ANC_first_total
gen anc4_retention= ANC_four_visits / ANC_first_total
gen anc_syph = syphilis_tested_preg / ANC_first_total
gen anc_hep = Hepat_BC_tested_preg / ANC_first_total 
gen anc_hiv = HIV_tested_preg / ANC_first_total 
gen anc_IFA= IFA_received_preg / ANC_first_total 
replace anc_IFA = HP_IFA_received_preg / ANC_first_total  if facility_type==1
gen timely_pnc = PNC_two_days / PNC_seven_days 
gen dpt_retention = DPT3_received / DPT1_received 
gen opv_retention = OPV3_received / OPV1_received 
gen pcv_retention = PCV3_received / PCV1_received 
gen rota_retention = Rota2_received / Rota1_received 
gen malnut_tx_success= malnutrition_cured / malnutrition_exit  
gen ART_12retention = ART_still / ART_original 
gen viral_supress = viral_load_undetect / viral_load_tested 
gen TB_ART = TB_ART_screened / ART_total 
gen hyper_tx = Hyper_enrol_care / Hyper_raised_BP  
gen diab_tx = Diabet_enrol_care / Diabet_raised_BS 
gen hyper_6control= Hyper6_controlled / Hyper6_enrol_care
gen diab_6control = Diabet6_controlled / Diabet6_enrol_care 
gen drug_avail = Drug_presc_100 / Drug_presc_received 

order region facility_type Faci_delivery Post_Contra ippcar ANC_first_total ANC_first_16 ///
	  timely_anc ANC_four_visits anc4_retention syphilis_tested_preg anc_syph ///
	  Hepat_BC_tested_preg anc_hep HIV_tested_preg anc_hiv IFA_received_preg anc_IFA ///
	  PNC_seven_days PNC_two_days timely_pnc DPT1_received DPT3_received dpt_retention ///
	  OPV1_received OPV3_received opv_retention PCV1_received PCV3_received pcv_retention ///
	  Rota1_received Rota2_received rota_retention malnutrition_exit malnutrition_cured ///
	  malnut_tx_success ART_original ART_still ART_12retention viral_load_tested ///
	  viral_load_undetect viral_supress ART_total  TB_ART_screened TB_ART Hyper_raised_BP ///
	  Hyper_enrol_care hyper_tx Diabet_raised_BS Diabet_enrol_care diab_tx  Hyper6_enrol_care ///
	  Hyper6_controlled hyper_6control Diabet6_enrol_care Diabet6_controlled diab_6control ///
	  Drug_presc_received Drug_presc_100 drug_avail

	 export excel using "$project/EFY 2014 results.xlsx", firstrow(variable) sheetreplace
	  

* ART cohort at end of year 
	use "$project/Data/Data for analysis/UQPC 2014.dta", clear
	keep if period==12
	collapse (sum) ART_total  , by(region facility_type)






















