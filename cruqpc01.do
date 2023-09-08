
* UQPC DHIS2 Data Analysis
*------------------------------------------------------------------------------*
global user "/Users/catherine.arsenault/Dropbox"
global data "9 PAPERS & PROJECTS/UQPC/DHIS2/Data/Raw/"
global analysis "9 PAPERS & PROJECTS/UQPC/DHIS2/Data/Data for analysis"

clear all
set more off
*------------------------------------------------------------------------------*
* ADDIS ABABA
* PUBLIC HOSPITALS
	import delimited using "$user/$data/UQPC volume data for Public Hospitals.csv for 2015 EFY.csv", clear
	keep if orgunitlevel2 =="Addis Ababa Regional Health Bureau" // 180

	save "$user/$analysis/Addis_ph.dta", replace
	
	import delimited using "$user/$data/UQPC data for public hospitals for 2015", clear 
	keep if orgunitlevel2 =="Addis Ababa Regional Health Bureau" // 180
	
	merge 1:1 org* using "$user/$analysis/Addis_ph.dta"

