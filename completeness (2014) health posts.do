
* Completeness assessment health posts oromia EFY 2014 (2021-22)

*------------------------------------------------------------------------------*
* Note: before importing the data from csv file to stata i have droped one variable (orgunitlevel6 ) from the csv file so that i can get equal number of variables (83 variables) with the same name when i import it to stata.

*------------------------------------------------------------------------------*
*Merging of health posts data: Oromia + Somali
global project "/Users/catherine.arsenault/Dropbox/9 PAPERS & PROJECTS/UQPC/DHIS2/"
import delimited "$project/Data/Raw/UQPC data for Health post for oromia regions.csv for 2014 EFY.csv", clear
save  "$project/Data/Data for analysis/Health posts 2014.dta", replace			
import delimited "$project/Data/Raw/UQPC data for Health post for somali regions.csv for 2014.csv", clear
append using "$project/Data/Data for analysis/Health posts 2014.dta"		

*global project "/Users/dessalegnsheabo/Desktop/UQPC/DHIS2"
*import delimited "$project/DHIS2 data for utilization and quality of primary care/UQPC data for Health post for oromia regions.csv for 2014 EFY.csv", clear
*save "$project/DHIS2 data for utilization and quality of primary care/UQPC data for Health post for oromia regions.csv for 2014 EFY-Oromia.dta"
*import delimited "/Users/dessalegnsheabo/Desktop/UQPC/DHIS2/DHIS2 data for utilization and quality of primary care/UQPC data for Health post for somali regions.csv for 2014.csv", clear
*append using "$project/DHIS2 data for utilization and quality of primary care/UQPC data for Health post for oromia regions.csv for 2014 EFY-Oromia.dta"

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
***data element anc 8 is not part of the 2014 dataset
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

*------------------------------------------------------------------------------*/
* RENAMING 2014 VARIABLES: HYPERTENSION, DIABETES, CERVICAL CANCER

*data for hpertension HP referal is not available for health posts in 2014
*data fir diabetes HP referal is not available for health posts in 2014

*------------------------------------------------------------------------------*/
* RENAMING 2014 VARIABLES: STRUCTURAL QUALITY 

rename essentialdrugsavailability Essential_drug_avail // this data element is numuerator over denominatory

*------------------------------------------------------------------------------*/
* RENAMING 2014 VARIABLES: OPD and FP volumes

rename (totalnewandrepeatacceptorsdisagg numberofoutpatientvisits) (FP_total OPD_total)

			
*------------------------------------------------------------------------------*/
keep region facility_name org* period Post_Contra Faci_delivery ANC_first_16 ANC_first_total ANC_four_visits IFA_received_preg PNC_seven_days PNC_two_days DPT3_received DPT1_received OPV3_received OPV1_received PCV3_received PCV1_received Rota2_received Rota1_received VitaminA2_received VitaminA1_received Dewormed_second Dewormed_first malnutrition_exit malnutrition_cured  Essential_drug_avail FP_total OPD_total

save  "$project/Data/Data for analysis/Health posts 2014.dta", replace	

*------------------------------------------------------------------------------*/
**completness table: Using the number of facilites that reproted at least onetime as denominator 

local varlist Post_Contra Faci_delivery ANC_first_16 ANC_first_total ANC_four_visits IFA_received_preg PNC_seven_days PNC_two_days DPT3_received DPT1_received OPV3_received OPV1_received PCV3_received PCV1_received Rota2_received Rota1_received VitaminA2_received VitaminA1_received Dewormed_second Dewormed_first malnutrition_exit malnutrition_cured  Essential_drug_avail FP_total OPD_total			
			
foreach x of local varlist  {
	egen count`x'=count(`x'), by(organisationunitid)
	replace count`x'=. if count`x'==0
	}	
	
collapse (count) Post_Contra Faci_delivery ANC_first_16 ANC_first_total ANC_four_visits IFA_received_preg PNC_seven_days PNC_two_days DPT3_received DPT1_received OPV3_received OPV1_received PCV3_received PCV1_received Rota2_received Rota1_received VitaminA2_received VitaminA1_received Dewormed_second Dewormed_first malnutrition_exit malnutrition_cured  Essential_drug_avail FP_total OPD_total count*, by(region period)
			
			
foreach x of local varlist  {
cap gen complete`x'=(`x'/count`x')*100
}

export excel using "$project/completeness_health post 2014.xlsx", sheet(Option_two) firstrow(variable) sheetreplace
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
