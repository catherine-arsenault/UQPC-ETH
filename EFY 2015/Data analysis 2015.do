
* UQPC 
* Data analysis
*------------------------------------------------------------------------------*
* EFY 2015
*global project "/Users/dessalegnsheabo/Desktop/UQPC/DHIS2"
global project "/Users/catherine.arsenault/Dropbox/9 PAPERS & PROJECTS/UQPC/DHIS2/"

use "$project/Data/Data for analysis/UQPC 2015 annual by facility.dta", clear  // annual results in 12,061 facilities

	*gen HP_IFA_received_preg = IFA_received_preg if ANC_first_total>0 & facility_type==1
	*replace IFA_received_preg = . if facility_type==1
	
* Collapsing at regional level by facility type
	collapse (sum) FP_total-TB_case_completed (count) c_FP_total=FP_total  ///
	c_OPD_total=OPD_total c_Post_Contra=Post_Contra c_Faci_delivery=Faci_delivery ///
	c_ANC_first_12=ANC_first_12 c_ANC_first_total=ANC_first_total ///
	c_ANC_four_visits=ANC_four_visits c_syphilis_tested_preg=syphilis_tested_preg ///
	c_HIV_tested_preg=HIV_tested_preg c_IFA_received_preg=IFA_received_preg ///
	c_Penta3_received=Penta3_received c_Penta1_received=Penta1_received ///
	c_Rota2_received=Rota2_received c_Rota1_received=Rota1_received c_ART_still=ART_still ///
	c_ART_original=ART_original c_Viral_load_undetect=Viral_load_undetect ///
	c_Viral_load_tested=Viral_load_tested c_TB_case_total=TB_case_total ///
	c_Hyper6_controlled=Hyper6_controlled c_Hyper6_enrol_care=Hyper6_enrol_care ///
	c_Diabet6_controlled=Diabet6_controlled c_Diabet6_enrol_care=Diabet6_enrol_care ///
	c_Antibio_enco_1plus=Antibio_enco_1plus c_Antibio_enco_total=Antibio_enco_total ///
	c_Drug_presc_100=Drug_presc_100 c_Drug_presc_received = Drug_presc_received ///
	c_TB_case_completed=TB_case_completed, by(region facility_type)

	 export excel using "$project/EFY 2015 results.xlsx", firstrow(variable) sheetreplace
	  

/* ART cohort at end of year 
	use "$project/Data/Data for analysis/UQPC 2015.dta", clear
	keep if period==12
	collapse (sum) ART_total  , by(region facility_type)


	

















