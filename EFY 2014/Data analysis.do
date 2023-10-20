
* UQPC 
* Data analysis

*------------------------------------------------------------------------------*
* EFY 2014

use "$project/Data/Data for analysis/UQPC 2014 annual by facility.dta", clear // sum of services in 11,427 facilities

* Collapsing at regional level by facility type
	collapse (sum) Post_Contra-OPD_total  , by(region facility_type)
	export excel using "$project/EFY 2014 results.xlsx", sheet("Sums") firstrow(variable) sheetreplace

* Creating the quality indicators

gen ippcar= Post_Contra/Faci_delivery
gen timely_anc= ANC_first_16 / ANC_first_total
gen anc4_retention= ANC_four_visits / ANC_first_total
gen anc_syph = syphilis_tested_preg / ANC_first_total
gen anc_hep = Hepat_BC_tested_preg / ANC_first_total 
gen anc_hiv = HIV_tested_preg / ANC_first_total 
gen anc_IFA= IFA_received_preg / ANC_first_total 
gen timely_pnc = PNC_two_days / PNC_seven_days 
gen dpt_retention = DPT3_received / DPT1_received 
gen opv_retention = OPV3_received / OPV1_received 
gen pcv_retention = PCV3_received / PCV1_received 
gen rota_retention = Rota2_received / Rota1_received 
gen malnut_tx_success= malnutrition_exit malnutrition_cured ART_still ART_original viral_load_undetect viral_load_tested TB_ART_screened ART_total Hyper_raised_BP Diabet_raised_BS Hyper_enrol_care Diabet_enrol_care Diabet6_controlled Diabet6_enrol_care Hyper6_controlled Hyper6_enrol_care Drug_presc_100 Drug_presc_received Essential_drug_avail


forval i = 1/3 {
	di `i'
	kwallis timely_anc if region==`i' , by(facility_type)
}
