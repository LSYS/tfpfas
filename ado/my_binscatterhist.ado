capture program drop my_binscatterhist
program define my_binscatterhist
	//////////////////////////////////////////////////////////////////////////////////////////
	// Generate event study coefficients.													//
	// Dependencies: 																		//
	//		* binscatterhist			 													//
	//		* reghdfe (for fixed effects)													//
	//		* ftools																		//
	//		* addplot																		//
	//		* binscatter																	//
	// Partials out:  																		//
	//  (1) subzone FE 																		//
	//	(1) Maternal characteristics 														//
	//////////////////////////////////////////////////////////////////////////////////////////
    syntax varlist(min=2 max=2 numeric), [xlab(string) ylab(string)]
// 		[fe(string)]
    
    local y "`1'"
	local x: word 2 of `varlist'
	dis "`y'"
	dis "`x'"

	if "`xlab'" == "" local xlab "`x'"
	if "`ylab'" == "" local ylab "`y'"

    cap gen _x = `x'

	#delimit;
    binscatterhist `y' _x, 
    	absorb($mat_x_group subzone2008) 
    	cluster(planning_area2008) 
    	controls($mat_x)
        coef(0.001)
		xhistbins(50) yhistbins(50)
		hist(`y' _x) 
        ci(95)
        sample
        stars(3)
        ybstyle(outline) xbstyle(outline)
        scatter(N)
        ytitle("`ylab'")
        xtitle(`xlab')
        n(5)
        savegraph($figsavedir/scatter-`y'-`x'.pdf) replace
	;
	#delimit cr
	drop _x
end
