assert_macros pfas mat_x mat_x_group figsavedir graphformats, strict

preserve
* standardized
foreach chem of varlist $pfas {
    qui su `chem'
    replace `chem' = `chem'/r(sd) if !missing(`chem')

    eststo clear
    #delimit;
    bcplot_thresholds `chem' buff500m_area_transport_faciliti,
        cutoffs(0(2)20)     
        controls($mat_x) 
        absorb($mat_x_group subzone2008)
        cluster(planning_area2008)
        yscale(range(-.6 1.4))
        ylabel(-.5 0 .5 1)
        coeflabels(
            dd0 = "0"
            dd2 = "2"
            dd4 = "4"
            dd6 = "6"
            dd8 = "8"
            dd10 = "10"
            dd12 = "12"
            dd14 = "14"
            dd16 = "16"
            dd18 = "18"
            dd20 = "20"
            dd22 = "22"
            dd24 = "24"
            dd26 = "26"
            dd28 = "28"
            dd30 = "30"     
        )
        name(`chem')
    ;
    #delimit cr
    savefig, path($figsavedir/coefplot-`chem'-binary-cutoff) format($graphformats) override(width(1000))
}
restore

* Unstandardize for PFBS
eststo clear
#delimit;
    bcplot_thresholds pfbs buff500m_area_transport_faciliti,
        cutoffs(0(2)20)     
        controls($mat_x) 
        absorb($mat_x_group subzone2008)
        cluster(planning_area2008)
        // yscale(range(-6 18))
        // ylabel(-4(4)16)
        coeflabels(
            dd0 = "0"
            dd2 = "2"
            dd4 = "4"
            dd6 = "6"
            dd8 = "8"
            dd10 = "10"
            dd12 = "12"
            dd14 = "14"
            dd16 = "16"
            dd18 = "18"
            dd20 = "20"
            dd22 = "22"
            dd24 = "24"
            dd26 = "26"
            dd28 = "28"
            dd30 = "30"     
        )
        name(pfbs_unstandardized)
        ytitle(pfbs unstandardized)
    ;
#delimit cr
savefig, path($figsavedir/coefplot-unstandardized-pfbs-binary-cutoff-buff500m_transport_facilities) format($graphformats) override(width(1000))

