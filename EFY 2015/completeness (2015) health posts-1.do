
* Completeness assessment health posts  EFY 2015 (2022-23)

*------------------------------------------------------------------------------*
* Note: before importing the data from csv file to stata i have droped one variable (orgunitlevel6 ) from both  csv files so that i can get equal number of variables (87 variables) with the same name when i import it to stata.
*Merging of health posts data: Oromia + Somali

global project "/Users/dessalegnsheabo/Desktop/UQPC/DHIS2"
import delimited "$project/DHIS2 data for utilization and quality of primary care/UQPC data for Health post for oromia regions for 2015 EFY.csv", clear 
save "$project/DHIS2 data for utilization and quality of primary care/UQPC data for Health post for oromia regions for 2015 EFY.csv-Oromia",replace

import delimited "$project/DHIS2 data for utilization and quality of primary care/UQPC data for Health post for somali regions for 2015 EFY.csv", clear

append using "$project/DHIS2 data for utilization and quality of primary care/UQPC data for Health post for oromia regions for 2015 EFY.csv-Oromia", force

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

*------------------------------------------------------------------------------*
* RENAMING 2015 VARIABLES: MCH + HIV
rename mat_immediatepostpartumcontracep Post_Contra
rename totalnumberofbirthsattendedbyski Faci_delivery

rename mat_totalnumberofpregnantwomenth ANC_first_12
rename v17  ANC_first_total

rename mat_pregnantwomenthatreceivedant ANC_four_visits
rename v19  ANC_eight_visits

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

*------------------------------------------------------------------------------
* RENAMING 2015 VARIABLES: HYPERTENSION, DIABETES, CERVICAL CANCER

rename ncd_hypertensivepatientsreferred Hyper_Referred_HC
rename ncd_individualsscreenedfordiabet Diabetes_Referred_HC

*------------------------------------------------------------------------------*
* RENAMING 2015 VARIABLES: STRUCTURAL QUALITY

rename pms_essentialdrugsavailability Essential_drug_avail // already an indicator in %

*------------------------------------------------------------------------------*/
* RENAMING 2015 VARIABLES: FP & OPD
		
*------------------------------------------------------------------------------*/	

keep region facility_name org* period Post_Contra Faci_delivery ANC_first_12	ANC_first_total ANC_four_visits	 ANC_eight_visits  	 IFA_received_preg PNC_two_days	PNC_seven_days  Penta3_received	Penta1_received Polio3_received	Polio1_received pneumococcal3_received	pneumococcal1_received Rota2_received	Rota1_received VitaminA2_received	VitaminA1_received Dewormed_second	Dewormed_first malnutrition_cured	malnutrition_exit  Hyper_Referred_HC Diabetes_Referred_HC Essential_drug_avail	
*------------------------------------------------------------------------------*/
* Removing Zeros (only 3 indicators have values of 0: PNC two days, Essential drug availability and FP_total)
  local varlist Post_Contra Faci_delivery ANC_first_12	ANC_first_total ANC_four_visits	 ANC_eight_visits  	 IFA_received_preg PNC_two_days	PNC_seven_days  Penta3_received	Penta1_received Polio3_received	Polio1_received pneumococcal3_received	pneumococcal1_received Rota2_received	Rota1_received VitaminA2_received	VitaminA1_received Dewormed_second	Dewormed_first malnutrition_cured	malnutrition_exit  Hyper_Referred_HC Diabetes_Referred_HC Essential_drug_avail
  
  foreach x of local varlist {
	replace `x'=. if `x'==0
}	

save  "$project/2014 & 2015 completenetss/data for analysis (2015)/health posts 2015.dta", replace
*------------------------------------------------------------------------------*/

* Completness table: Using the number of facilites that reproted at least onetime during the year as denominator 			
foreach x of local varlist  {
	egen count`x'=count(`x'), by(organisationunitid)
	replace count`x'=. if count`x'==0
	}	
		
collapse (count) Post_Contra Faci_delivery ANC_first_12	ANC_first_total ANC_four_visits	 ANC_eight_visits  	 IFA_received_preg PNC_two_days	PNC_seven_days  Penta3_received	Penta1_received Polio3_received	Polio1_received pneumococcal3_received	pneumococcal1_received Rota2_received	Rota1_received VitaminA2_received	VitaminA1_received Dewormed_second	Dewormed_first malnutrition_cured	malnutrition_exit  Hyper_Referred_HC Diabetes_Referred_HC Essential_drug_avail count*, by(region period)	
	
foreach x of local varlist  {
	cap gen complete`x'=(`x'/count`x')*100
	egen avg_compl_`x' = mean(complete`x'), by(region)
}

export excel using "$project/completeness_health posts 2015.xlsx", sheet(Option_two) firstrow(variable) sheetreplace

		
		
			
			
			
			
			
			
			
			
			
			
			
