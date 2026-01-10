assert_macros tabsavedir, strict

* Movers only
runregs pfbs buff500m_area_transport_faciliti if mover==1, ///
		xlabel(Transport facilities (area) within 500m buffer) ///
		savepath($tabsavedir/pfbs-500m-transportfacilities-moversonly-fragment.tex)

* Future residence
preserve
use ./data/edc-gusto-2019features.dta, clear
merge 1:1 sid using "./data/edc-gusto.dta", keepusing(parity)
replace buff500m_transport_facilities = buff500m_transport_facilities / 1000

runregs_future pfbs buff500m_transport_facilities if mover==1, ///
		xlabel(Transport facilities (area) within 500m buffer) ///
		savepath($tabsavedir/pfbs-500m-transportfacilities-movedaddress-fragment.tex)
restore
