assert_macros mat_x mat_x_group figsavedir graphformats, strict

local y pfbs
local x buff500m_area_transport_faciliti
eststo clear

// Standardize main variable
egen stf = std(`x')

// Standardize each control variable
egen sroad = std(buff500m_area_road)
egen smrt = std(buff500m_area_mass_rapid_transit)
egen slrt = std(buff500m_area_light_rapid_transi)
egen sbusiness = std(buff500m_area_business_2_white)
egen spsm = std(psm_mean)
egen sresiddensity = std(pop2010_int_e)
su pings_median_int_b, d
replace pings_median_int_b = r(p99) if pings_median_int_b > r(p99) & !missing(pings_median_int_b)
egen sdensity = std(pings_median_int_b)

eststo m0: reghdfe `y' stf $mat_x      i.parity, absorb($mat_x_group subzone2008) cluster(planning_area2008)
eststo m1: reghdfe `y' stf $mat_x sroad     i.parity, absorb($mat_x_group subzone2008) cluster(planning_area2008)
eststo m2: reghdfe `y' stf $mat_x smrt      i.parity, absorb($mat_x_group subzone2008) cluster(planning_area2008)
eststo m3: reghdfe `y' stf $mat_x slrt      i.parity, absorb($mat_x_group subzone2008) cluster(planning_area2008)
eststo m4: reghdfe `y' stf $mat_x sbusiness i.parity, absorb($mat_x_group subzone2008) cluster(planning_area2008)
eststo m5: reghdfe `y' stf $mat_x spsm i.parity, absorb($mat_x_group subzone2008) cluster(planning_area2008)
eststo m6: reghdfe `y' stf $mat_x sresiddensity i.parity, absorb($mat_x_group subzone2008) cluster(planning_area2008)
eststo m7: reghdfe `y' stf $mat_x sdensity i.parity, absorb($mat_x_group subzone2008) cluster(planning_area2008)

*==============================================================
* Styling macros
*==============================================================
grstyle init
grstyle set plain, horizontal
grstyle color background white
grstyle set color #ae2b6c #44AA99
grstyle set symbol

local xmin -4
local xmax  4

local baseopts ///
    drop(_cons) ///
    xline(0, lcolor(gs10) lpattern(dash)) ///
    ylabel(, labsize(medlarge) noticks) ///    
    legend(off) ///
    graphregion(color(white)) ///
    plotregion(margin(zero)) ///            
    yscale(noline) ///
    xscale(range(`xmin' `xmax')) ///
    xlabel(`xmin'(2)`xmax', labsize(medlarge))

local mat_opts  msymbol(T)  msize(large)   
local ctrl_opts msymbol(S)  msize(large)   

local tstyle size(medlarge) justification(left) margin(small)

* Panel title strings
local t0 "{bf:Baseline model}"
local t1 "{bf:Baseline + Road}"
local t2 "{bf:Baseline + Mass Rapid Transit (MRT)}"
local t3 "{bf:Baseline + Light Rail Transit (LRT)}"
local t4 "{bf:Baseline + Business 2/White}"
local t5 "{bf:Baseline + Neighborhood affluence (house price, 0.1km{superscript:2})}"
local t6 "{bf:Baseline + Residential population density (0.1km{superscript:2})}"
local t7 "{bf:Baseline + Urban pedestrian density (0.1km{superscript:2})}"

*==============================================================
* One coefplot per model (created but not drawn)
*==============================================================
* Baseline only
coefplot ///
    (m0, keep(stf) `mat_opts'), ///
    `baseopts' ///
    coeflabels( ///
        stf = "Transport facilities" ///
    ) ///
    order(stf) ///
    title("`t0'", `tstyle') ///
    name(g0, replace) nodraw

* m1: baseline + Road
coefplot ///
    (m1, keep(stf)   `mat_opts') ///
    (m1, keep(sroad) `ctrl_opts'), ///
    `baseopts' ///
    coeflabels( ///
        stf   = "Transport facilities" ///
        sroad = "Road" ///
    ) ///
    order(stf sroad) ///
    title("`t1'", `tstyle') ///
    name(g1, replace) nodraw

* m2: baseline + MRT
coefplot ///
    (m2, keep(stf)  `mat_opts') ///
    (m2, keep(smrt) `ctrl_opts'), ///
    `baseopts' ///
    coeflabels( ///
        stf  = "Transport facilities" ///
        smrt = "MRT" ///
    ) ///
    order(stf smrt) ///
    title("`t2'", `tstyle') ///
    name(g2, replace) nodraw

* m3: baseline + LRT
coefplot ///
    (m3, keep(stf)  `mat_opts') ///
    (m3, keep(slrt) `ctrl_opts'), ///
    `baseopts' ///
    coeflabels( ///
        stf  = "Transport facilities" ///
        slrt = "LRT" ///
    ) ///
    order(stf slrt) ///
    title("`t3'", `tstyle') ///
    name(g3, replace) nodraw

* m4: baseline + Business
coefplot ///
    (m4, keep(stf)       `mat_opts') ///
    (m4, keep(sbusiness) `ctrl_opts'), ///
    `baseopts' ///
    coeflabels( ///
        stf       = "Transport facilities" ///
        sbusiness = "Business 2/White" ///
    ) ///
    order(stf sbusiness) ///
    title("`t4'", `tstyle') ///
    name(g4, replace) nodraw

* m5: baseline + PSM / neighborhood price
coefplot ///
    (m5, keep(stf)  `mat_opts') ///
    (m5, keep(spsm) `ctrl_opts'), ///
    `baseopts' ///
    coeflabels( ///
        stf  = "Transport facilities" ///
        spsm = "Housing prices" ///
    ) ///
    order(stf spsm) ///
    title("`t5'", `tstyle') ///
    name(g5, replace) nodraw

* m6: baseline + residential density
coefplot ///
    (m6, keep(stf)           `mat_opts') ///
    (m6, keep(sresiddensity) `ctrl_opts'), ///
    `baseopts' ///
    coeflabels( ///
        stf           = "Transport facilities" ///
        sresiddensity = "Residential density" ///
    ) ///
    order(stf sresiddensity) ///
    title("`t6'", `tstyle') ///
    name(g6, replace) nodraw

* m7: baseline + urban pedestrian density
coefplot ///
    (m7, keep(stf)      `mat_opts') ///
    (m7, keep(sdensity) `ctrl_opts'), ///
    `baseopts' ///
    coeflabels( ///
        stf      = "Transport facilities" ///
        sdensity = "Urban density" ///
    ) ///
    order(stf sdensity) ///
    title("`t7'", `tstyle') ///
    name(g7, replace) nodraw

*==============================================================
* Final combined plot
*==============================================================
graph combine g0 g1 g2 g3 g4 g5 g6 g7, ///
    cols(1) xcommon imargin(0 0 0 0) ///
    graphregion(color(white)) ///
    ysize(5) xsize(4)

savefig, path($figsavedir/env-covariates-coefplot) format($graphformats) override(width(1000))

