assert_macros figsavedir graphformats, strict

// =================================================================================
preserve
/// no observations (zero successfull measurements)
drop mnop 
local pfas_cb bpa - propylp

* Scale variables by std dev
foreach pfas of varlist `pfas_cb' {
	qui summ `pfas'
	replace `pfas' = `pfas' / r(sd) if !missing(`pfas')
}

// =================================================================================
* Correlates of pfbs
eststo clear
foreach pfas of varlist `pfas_cb' {
	eststo: reghdfe pfbs `pfas', absorb(subzone2008) cluster(planning_area2008)
}
restore

#delimit;
local graph_opts
	nooffset
    legend(off)
    // Axis labels settings (nogextend prevents gridlines from extending; glcolor = gridline color)
    // https://www.statalist.org/forums/forum/general-stata-discussion/general/1410098-twoway-graph-grid-lines-lie-on-top-of-frame-around-plot-region-how-to-avoid-that
    ylabel(, labsize(small) notick grid nogextend glcolor(gs15))
	xlabel(, labsize(small) notick grid nogextend glcolor(gs15))
	// Set to none (needed to prevent coefplot from adding its own grid)
	// which is harder to tweak (see xlabel and ylabel nogextend glcolor)
	grid( none ) 
    xline(0, lpattern(dash) lcolor(gs7) lwidth(medthin))
    // Graph and plot region settings
	graphregion(color(white) margin(0 0 0 0)) 
	// margin(tiny) needed to prevent gridlines going into borders but still have small margins
	plotregion(lcolor(black) margin(tiny))
	// Drop other variables
	drop(pfbs _cons)
	// Coefficient labels
 	coeflabel(
 		mbp = "MBP"
 		pfoa = "PFOA"
 		pfna = "PFNA"
 		mehp = "MEHP"
 		oxyben = "Oxyben"
 		pfos = "PFOS"
 		pfhxs = "PFHxS"
 		benzophe = "Benzophe"
 		pfba = "PFBA"
 		pfunda = "PFUnDA"
 		methylp = "Methylp"
 		pfda = "PFDA"
 		mecpp = "MECPP"
 		mep = "MEP"
 		pfhpa = "PFHpA"
 		mmp = "MMP"
 		mcinp = "MCINP"
 		propylp = "Propylp"
 		bps = "BPS"
 		ethylp = "Ethylp"
 		pfpea = "PFPeA"
 		pfdoda = "PFDoDA"
 		butylp = "Butylp"
 		mcpp = "MCPP"
 		mbzp = "MBzP"
 		pfhxa = "PFHxA"
 		mnop = "MNOP"
 		bpa = "BPA"
 	)
;
#delimit cr

// grstyle init 
// grstyle set plain,

#delimit;
coefplot 
	(*, pstyle(p1) mfcolor(white) mlwidth(thin) mcolor(gs8) ciopts(lcolor(gs10)))
	(*, pstyle(p1) mfcolor(gs5)   mlwidth(thin) mcolor(gs3) if(@ll>0 | @ul<0) ciopts(lcolor(gs8))), 
	sort `graph_opts' xscale(range(-.2 .4)) xlabel(-.2 0 .2 .4)
;
#delimit cr
savefig, path($figsavedir/coefplot-correlates-of-pfbs-cordblood) format($graphformats) override(width(1000))
