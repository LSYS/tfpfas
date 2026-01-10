assert_macros tabsavedir, strict

foreach x of varlist tt10min_area_transport_facilitie tt15min_area_transport_facilitie tt20min_area_transport_facilitie {
	replace `x' = 0 if missing(`x') & ~missing(tt20min_area_transport_facilitie)
	replace `x' = `x' / 1000
}

local x transport_facilities_dist_pc2edg
runregs pfbs `x', ///
    xlabel(Distance to nearest transport facility's edge) ///
    savepath($tabsavedir/pfbs-`x'-fragment.tex)

local x transport_facilities_dist_pc2cen
runregs pfbs `x', ///
    xlabel(Distance to nearest transport facility's centroid) ///
    savepath($tabsavedir/pfbs-`x'-fragment.tex)

local x buff500m_count_transport_facilit
runregs pfbs `x', ///
    xlabel(Transport facilities within 500m) ///
    savepath($tabsavedir/pfbs-`x'-fragment.tex)

local x tt10min_area_transport_facilitie
runregs pfbs `x', ///
    xlabel(Transport facilities (area) within 10min) ///
    savepath($tabsavedir/pfbs-`x'-fragment.tex)

local x tt15min_area_transport_facilitie
runregs pfbs `x', ///
    xlabel(Transport facilities (area) within 15min) ///
    savepath($tabsavedir/pfbs-`x'-fragment.tex)

local x tt20min_area_transport_facilitie
runregs pfbs `x', ///
    xlabel(Transport facilities (area) within 20min) ///
    savepath($tabsavedir/pfbs-`x'-fragment.tex)
