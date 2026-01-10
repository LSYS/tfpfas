assert_macros pfas mat_x mat_x_group, strict

// =================================================================================
preserve
* Scale variables by std dev
foreach x of varlist $pfas buff500m_area_transport_faciliti {
	qui summ `x'
	replace `x' = `x' / r(sd) if !missing(`x')
}

local cb_file ./data/pfas-tf-model5-cordblood
cap erase `cb_file'.dta

local spec_sz $mat_x, absorb($mat_x_group subzone2008) cluster(planning_area2008)
local x buff500m_area_transport_faciliti

foreach pfas of varlist $pfas {
	reghdfe `pfas' `x' `spec_sz'
	storespecs `x', spec_name(`pfas') file(`cb_file')
}
restore
