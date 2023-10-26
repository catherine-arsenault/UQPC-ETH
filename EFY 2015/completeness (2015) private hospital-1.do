
* Completeness assessment private hospitals EFY 2015 (2022-23)

*------------------------------------------------------------------------------*
* Note: before importing the data from csv file i have added one variable (orgunitlevel5) in the csv file so that we can get equal number of variables (87 variables) with the same name when we import it to stata.

global project "/Users/dessalegnsheabo/Desktop/UQPC/DHIS2"
import delimited "$project/DHIS2 data for utilization and quality of primary care/UQPC data for private hospitals for 2015 EFY.csv", clear


sort orgunitlevel2  organisationunitid  periodname
encode orgunitlevel2, gen(region)
encode organisationunitname, gen(facility_name)
egen id=group(organisationunitid facility_name region)
order id region facility_name

label define period 1"Hamle 2014" 2"Nehase 2014" 3"Meskerem 2015" 4"Tikemet 2015" ///
				5"Hidar 2015" 6"Tahesas 2015" 7"Tir 2015" 8"Yekatit 2015" 9"Megabit 2015" ///
				10"Miazia 2015" 11"Ginbot 2015" 12"Sene 2015", modify
encode periodname, generate(period) label(period)
move period orgunitlevel1
sort region facility_name period

*------------------------------------------------------------------------------*
* RENAMING 2015 VARIABLES: MCH + HIV
rename mat_immediatepostpartumcontracep Post_Contra
rename totalnumberofbirthsattendedbyski Faci_delivery

rename mat_totalnumberofpregnantwomenth ANC_first_12
rename v17  ANC_first_total

rename mat_pregnantwomenthatreceivedant ANC_four_visits
rename v19  ANC_eight_visits

rename mat_pregnantwomentestedforsyphil syphilis_tested_preg
rename mat_pregnantwomentestedforhepati Hepat_B_tested_preg
rename mtct_pregnantwomentestedandknowt HIV_tested_preg
rename nut_totalnumberofplwscreenedfora malnu_screened_PLW
rename nut_totalnumberofpregnantwomenre IFA_received_preg

rename mat_numberofpostnatalvisitsfor02 PNC_two_days
rename mat_postnatalvisitswithin7daysof PNC_seven_days

rename epi_childrenunderoneyearofagewho Penta3_received 
rename v31 Penta1_received 
rename v32 Polio3_received
rename v33 Polio1_received
rename v34 pneumococcal3_received
rename v35 pneumococcal1_received
rename v36 Rota2_received
rename v37 Rota1_received

rename v39 VitaminA2_received
rename nut_totalnumberofchildrenaged659 VitaminA1_received

rename nut_totalnumberofchildrenaged245 Dewormed_second
rename v41 Dewormed_first

rename nut_numberofchildrencured malnutrition_cured
rename nut_numberofchildrenwhoexitfroms malnutrition_exit

rename hiv_adultsandchildrenwhoarestill ART_still
rename hiv_personsonartintheoriginalcoh ART_original

rename hiv_adultandpaediatricartpatient Viral_load_undetect
rename hiv_adultandpediatricartpatients Viral_load_tested

egen TB_ART_screened= rowtotal(hiv_newlyenrolledartclientswhowe hiv_plhivspreviouslyonartandscre) // added these 2 vars (new and already on ART)
rename numberofadultsandchildrenwhoarec ART_total

*------------------------------------------------------------------------------
* RENAMING 2015 VARIABLES: TUBERCULOSIS
egen TB_case_completed = rowtotal(tb_treatmentoutcomeofcohortofnew v60) // completed + cured 
rename  v61 TB_case_total // total registered

rename tb_numberofcohortofindividualsth TPT_treat_completed
rename tb_numberofcohortofindividualsst TPT_treat_started
*------------------------------------------------------------------------------*
* RENAMING 2015 VARIABLES: HYPERTENSION, DIABETES, CERVICAL CANCER

rename ncd_hypertensivepatientsenrolled Hyper_enrol_care
rename ncd_numberofindividualsscreenedf Hyper_raised_BP

rename ncd_treatmentoutcomeforcohortofp Hyper6_controlled
rename v70  Hyper6_enrol_care

rename ncd_diabeticpatientsenrolledtoca Diabet_enrol_care
rename v67  Diabet_raised_BS 


rename v72 Diabet6_controlled 
rename v73 Diabet6_enrol_care

rename ncd_eligiblewomenwhoreceivedtrea cervical_treated
rename ncd_womenage3049yearswhohavebeen cervical_test_positive
*------------------------------------------------------------------------------*
* RENAMING 2015 VARIABLES: STRUCTURAL QUALITY

rename pms_essentialdrugsavailability Essential_drug_avail // already an indicator in %

rename ms_numberofclientswhoreceived100 Drug_presc_100
rename ms_totalnumberofclientswhoreceiv Drug_presc_received 

rename pms_numberofencounterwithoneormo Antibio_enco_1plus
rename ms_totalnumberofencounters Antibio_enco_total

*------------------------------------------------------------------------------*/
* RENAMING 2015 VARIABLES: FP & OPD
		
*------------------------------------------------------------------------------*/	

keep region facility_name org* period Post_Contra Faci_delivery ANC_first_12	ANC_first_total ANC_four_visits	 ANC_eight_visits  syphilis_tested_preg Hepat_B_tested_preg HIV_tested_preg malnu_screened_PLW	 IFA_received_preg PNC_two_days	PNC_seven_days  Penta3_received	Penta1_received Polio3_received	Polio1_received pneumococcal3_received	pneumococcal1_received Rota2_received	Rota1_received VitaminA2_received	VitaminA1_received Dewormed_second	Dewormed_first malnutrition_cured	malnutrition_exit ART_still ART_original Viral_load_undetect	Viral_load_tested TB_ART_screened	ART_total TB_case_completed	TB_case_total TPT_treat_completed	TPT_treat_started Hyper_enrol_care	Hyper_raised_BP Hyper6_controlled	Hyper6_enrol_care Diabet_enrol_care	Diabet_raised_BS  Diabet6_controlled	Diabet6_enrol_care cervical_treated	cervical_test_positive Essential_drug_avail	 Antibio_enco_1plus	Antibio_enco_total Drug_presc_100	Drug_presc_received 
*------------------------------------------------------------------------------*/
* Removing Zeros (only 3 indicators have values of 0: Essential_drug_avail TB_ART_screened TB_case_completed)

local varlist Post_Contra Faci_delivery ANC_first_12	ANC_first_total ANC_four_visits	 ANC_eight_visits  syphilis_tested_preg Hepat_B_tested_preg HIV_tested_preg malnu_screened_PLW	 IFA_received_preg PNC_two_days	PNC_seven_days  Penta3_received	Penta1_received Polio3_received	Polio1_received pneumococcal3_received	pneumococcal1_received Rota2_received	Rota1_received VitaminA2_received	VitaminA1_received Dewormed_second	Dewormed_first malnutrition_cured	malnutrition_exit ART_still ART_original Viral_load_undetect	Viral_load_tested TB_ART_screened	ART_total TB_case_completed	TB_case_total TPT_treat_completed	TPT_treat_started Hyper_enrol_care	Hyper_raised_BP Hyper6_controlled	Hyper6_enrol_care Diabet_enrol_care	Diabet_raised_BS  Diabet6_controlled	Diabet6_enrol_care cervical_treated	cervical_test_positive Essential_drug_avail	 Antibio_enco_1plus	Antibio_enco_total Drug_presc_100	Drug_presc_received

foreach x of local varlist {
	replace `x'=. if `x'==0
}

save  "$project/2014 & 2015 completenetss/data for analysis (2015)/Private hospitals 2015.dta", replace
*------------------------------------------------------------------------------*/
*completness table: Using the number of facilites that reproted at least onetime as denominator 

	foreach x of local varlist   {
		egen count`x'=count(`x'), by(organisationunitid) 
		replace count`x'=. if count`x'==0
	}	
		
collapse (count) Post_Contra Faci_delivery ANC_first_12	ANC_first_total ANC_four_visits	 ANC_eight_visits  syphilis_tested_preg Hepat_B_tested_preg HIV_tested_preg malnu_screened_PLW	 IFA_received_preg PNC_two_days	PNC_seven_days  Penta3_received	Penta1_received Polio3_received	Polio1_received pneumococcal3_received	pneumococcal1_received Rota2_received	Rota1_received VitaminA2_received	VitaminA1_received Dewormed_second	Dewormed_first malnutrition_cured	malnutrition_exit ART_still ART_original Viral_load_undetect	Viral_load_tested TB_ART_screened	ART_total TB_case_completed	TB_case_total TPT_treat_completed	TPT_treat_started Hyper_enrol_care	Hyper_raised_BP Hyper6_controlled	Hyper6_enrol_care Diabet_enrol_care	Diabet_raised_BS  Diabet6_controlled	Diabet6_enrol_care cervical_treated	cervical_test_positive Essential_drug_avail	 Antibio_enco_1plus	Antibio_enco_total Drug_presc_100	Drug_presc_received	 count*, by(region period)	
	
foreach x of local varlist  {
cap gen complete`x'=(`x'/count`x')*100
egen avg_compl_`x' = mean(complete`x'), by(region)
}

export excel using "$project/completeness_private hospital 2015.xlsx", sheet(Option_two) firstrow(variable) sheetreplace

		
		
			
			
			
			
			
			
			
