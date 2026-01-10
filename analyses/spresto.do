use ./data/edc-spresto.dta, clear
// ============================================================================
* PFAS
local pfas_spresto pfhxs pfos_linear pfos_branched pfoa_linear pfna pfhps pfda pfhpa 

* Prep basic family demo
encode pcv1_working_status, gen(employed)
encode pcv1_highest_education_completed, gen(educ)
encode pcv1_marital_status, gen(marital)
encode ethnic_group, gen(ethnic)
encode hhincome_txt, gen(hhincome)

local baselines c.age_at_recruitment##c.age_at_recruitment i.employed i.educ i.marital i.ethnic i.hhincome

// ============================================================================
local storespecs_file ./data/pfas-tf-spresto

cap erase `storespecs_file'.dta
local x buff500m_transport_facilities
preserve
qui su `x'
replace `x' = `x' / r(sd) if !missing(`x')

foreach pfas of varlist `pfas_spresto' {
	qui su `pfas'
	replace `pfas' = `pfas' / r(sd) if !missing(`pfas')
	reghdfe `pfas' `x' `baselines', abs(subzone2014) cluster(planning_area2014) keepsing
	storespecs `x', spec_name(`pfas') file(`storespecs_file')
}
