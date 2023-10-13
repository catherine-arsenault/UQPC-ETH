
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
* DATA CLEANING

* Replace missing indicators to 0 when related indicator is not missing
replace Post_Contra = 0 if Faci_delivery!=. & Post_Contra==.
replace ANC_first_16 = 0 if ANC_first_total!=. & ANC_first_16 ==.
replace ANC_four_visits = 0 if ANC_first_total!=. & ANC_four_visits ==.







