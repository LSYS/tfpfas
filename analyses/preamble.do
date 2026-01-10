use ./data/edc-gusto.dta, clear

* Scale
#delimit;
local tf 
	buff100m_area_transport_faciliti 
	buff500m_area_transport_faciliti
	buff1000m_area_transport_facilit 
	buff1500m_area_transport_facilit;
#delimit cr
foreach x of varlist `tf' {
    replace `x' = `x' / 1000 if !missing(`x')
}

global pfas pfbs pfna pfoa pfos pfhxs pfba pfunda pfda

* =====================================================================================
* Maternal characteristics
* =====================================================================================
global mat_x 	   c.mother_age_delivery##c.mother_age_delivery 
global mat_x_group mother_ethnicity mother_place_of_birth mother_highest_education mother_occupation marital_status hdb_gusto parity
global mat_x_inc   mother_income household_income

foreach x of varlist mother_ethnicity mother_place_of_birth mother_highest_education mother_occupation marital_status {
	rename `x' `x'_str
	encode `x'_str, gen(`x')
}

foreach x of global mat_x_inc {
	rename `x' `x'_str
	encode `x'_str, gen(`x')
}

replace mover = 0 if missing(mover)
