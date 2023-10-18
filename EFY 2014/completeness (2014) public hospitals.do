
* Completeness assessment public hospitals EFY 2014 (2021-22)

*------------------------------------------------------------------------------*

*Note: as Sultan Sheikh Hassan Memorial Referral Hospital was reported as a private hospital while it is a public hospital. So we need to append it to public hospital dataset 

global project "/Users/catherine.arsenault/Dropbox/9 PAPERS & PROJECTS/UQPC/DHIS2/"
import delimited "$project/Data/Raw/UQPC data for private hospitals.csv for 2014 EFY.csv", clear

*global project "/Users/dessalegnsheabo/Desktop/UQPC/DHIS2"
* import delimited "$project/DHIS2 data for utilization and quality of primary care/UQPC data for private hospitals.csv for 2014 EFY.csv", clear

keep if orgunitlevel3 == "Sultan Sheikh Hassan Memorial Referral Hospital"

save  "$project/Data/Data for analysis/Private hospital 2014.dta", replace
		
* save "$project/DHIS2 data for utilization and quality of primary care/UQPC data for private hospitals.csv for 2014 EFY-sultan.dta"
*import delimited "$project/DHIS2 data for utilization and quality of primary care/UQPC data for public hospitals.csv for 2014 EFY.csv", clear
import delimited "$project/Data/Raw/UQPC data for public hospitals.csv for 2014 EFY.csv", clear
append using "$project/Data/Data for analysis/Private hospital 2014.dta", force

*append using "$project/DHIS2 data for utilization and quality of primary care/UQPC data for private hospitals.csv for 2014 EFY-sultan.dta", force

sort orgunitlevel2  organisationunitid  periodname
encode orgunitlevel2, gen(region)
encode organisationunitname, gen(facility_name)
egen id=group(organisationunitid facility_name region)
order id region facility_name

label define period 1"Hamle 2013" 2"Nehase 2013" 3"Meskerem 2014" 4"Tikemet 2014" ///
				5"Hidar 2014" 6"Tahesas 2014" 7"Tir 2014" 8"Yekatit 2014" 9"Megabit 2014" ///
				10"Miazia 2014" 11"Ginbot 2014" 12"Sene 2014", modify
encode periodname, generate(period) label(period)
move period orgunitlevel1
*------------------------------------------------------------------------------*
* RENAMING 2014 VARIABLES: MCH + HIV
rename totalimmediatepostpartumcontrace Post_Contra
rename totalnumberofbirthsattendedbyski Faci_delivery
rename numberofpregnantwomenwhoreceived ANC_first_16 
rename v17  ANC_first_total
rename totalnumberofpregnantwomenthatre ANC_four_visits
*data element anc 8 is not part of the 2014 dataset
rename totalnumberofpregnantwomentested   syphilis_tested_preg
rename v20 Hepat_BC_tested_preg 
rename numberofpregnantwomentestedandkn  HIV_tested_preg
*data element malnutrition_screened_PLW is not part of the 2014 dataset 
rename totalnumberofpregnantwomenreceiv IFA_received_preg
rename numberofpostnatalvisitsfor02days PNC_two_days
rename numberofpostnatalvisitswithin7da PNC_seven_days
rename numberofchildrenunderoneyearofag DPT3_received
rename v29 DPT1_received
rename v30 OPV3_received
rename v31 OPV1_received
rename v32 PCV3_received
rename v33 PCV1_received
rename v34 Rota2_received
rename v35 Rota1_received
rename totalnumberofchildrenaged659mont VitaminA2_received
rename v37 VitaminA1_received
rename totalnumberofchildrenaged2459mon Dewormed_second
rename v39 Dewormed_first 
rename treatmentoutcomeformanagementofs malnutrition_cured
rename numberofchildrenwhoexitfromsever malnutrition_exit
rename numberofadultsandchildrenwhoares ART_still
rename numberofpersonsonartintheorigina ART_original
rename numberofadultandpediatricpatient viral_load_undetect
rename numberofadultandpediatricartpati viral_load_tested
rename numberofclientsenrolledinhivcare TB_ART_screened
rename numberofadultsandchildrenwhoarec ART_total

*------------------------------------------------------------------------------*/
* RENAMING 2014 VARIABLES: HYPERTENSION, DIABETES, CERVICAL CANCER

rename totalnumberofhypertensivepatient Hyper_enrol_care // numerator
rename totalnumberofindividualswithrai Hyper_raised_BP // denominator

rename v70 Hyper6_controlled // numerator 
rename totalnumberofcohorthypertensivep Hyper6_enrol_care // denominator

rename totalnumberofnewdiabeticpatien Diabet_enrol_care // numerator
rename v64 Diabet_raised_BS // denominator

rename totalnumberofdiabeticpatientsenr Diabet6_controlled // numerator
rename totalnumberofcohortdiabeticpatie Diabet6_enrol_care // denominator

*------------------------------------------------------------------------------*/
* RENAMING 2014 VARIABLES: STRUCTURAL QUALITY 

rename essentialdrugsavailability Essential_drug_avail // this data element is numuerator over denominatory

rename numberofclientswhoreceived100ofp Drug_presc_100 // numerator
rename totalnumberofclientswhoreceivedp Drug_presc_received // denominator
			
*------------------------------------------------------------------------------*/
* RENAMING 2014 VARIABLES: FP & OPD

rename (totalnewandrepeatacceptorsdisagg numberofoutpatientvisits) (FP_total OPD_total)
		
keep region facility_name org* period Post_Contra Faci_delivery ANC_first_16 ANC_first_total ANC_four_visits syphilis_tested_preg Hepat_BC_tested_preg HIV_tested_preg IFA_received_preg PNC_seven_days PNC_two_days DPT3_received DPT1_received OPV3_received OPV1_received PCV3_received PCV1_received Rota2_received Rota1_received VitaminA2_received VitaminA1_received Dewormed_second Dewormed_first malnutrition_exit malnutrition_cured ART_still ART_original viral_load_undetect viral_load_tested TB_ART_screened ART_total Hyper_raised_BP Diabet_raised_BS Hyper_enrol_care Diabet_enrol_care Diabet6_controlled Diabet6_enrol_care Hyper6_controlled Hyper6_enrol_care Drug_presc_100 Drug_presc_received Essential_drug_avail	FP_total OPD_total		

*------------------------------------------------------------------------------*/
* Removing Zeros (only 5 indicators have values of 0: PNC two days, ART total, Essential drug availability and FP_total)
local varlist Post_Contra Faci_delivery ANC_first_16 ANC_first_total ANC_four_visits syphilis_tested_preg Hepat_BC_tested_preg HIV_tested_preg IFA_received_preg PNC_seven_days PNC_two_days DPT3_received DPT1_received OPV3_received OPV1_received PCV3_received PCV1_received Rota2_received Rota1_received VitaminA2_received VitaminA1_received Dewormed_second Dewormed_first malnutrition_exit malnutrition_cured ART_still ART_original viral_load_undetect viral_load_tested TB_ART_screened ART_total Hyper_raised_BP Diabet_raised_BS Hyper_enrol_care Diabet_enrol_care Diabet6_controlled Diabet6_enrol_care Hyper6_controlled Hyper6_enrol_care Drug_presc_100 Drug_presc_received Essential_drug_avail FP_total OPD_total			
foreach x of local varlist {
	replace `x'=. if `x'==0
}

save  "$project/Data/Data for analysis/Public hospital 2014.dta", replace

*------------------------------------------------------------------------------*/	
*Completness table: Using the number of facilites that reproted at least onetime as denominator 							
foreach x of local varlist  {
	egen count`x'=count(`x'), by(organisationunitid)
	replace count`x'=. if count`x'==0
	}	
	
collapse (count) Post_Contra Faci_delivery ANC_first_16 ANC_first_total ANC_four_visits syphilis_tested_preg Hepat_BC_tested_preg HIV_tested_preg IFA_received_preg PNC_seven_days PNC_two_days DPT3_received DPT1_received OPV3_received OPV1_received PCV3_received PCV1_received Rota2_received Rota1_received VitaminA2_received VitaminA1_received Dewormed_second Dewormed_first malnutrition_exit malnutrition_cured ART_still ART_original viral_load_undetect viral_load_tested TB_ART_screened ART_total Hyper_raised_BP Diabet_raised_BS Hyper_enrol_care Diabet_enrol_care Diabet6_controlled Diabet6_enrol_care Hyper6_controlled Hyper6_enrol_care Drug_presc_100 Drug_presc_received Essential_drug_avail FP_total OPD_total count*, by(region period)
			
			
foreach x of local varlist  {
cap gen complete`x'=(`x'/count`x')*100
egen avg_compl_`x' = mean(complete`x'), by(region)
}

export excel using "$project/completeness_Public hospital 2014.xlsx", sheet(Option_two) firstrow(variable) sheetreplace

	
			
			
			
			
			
