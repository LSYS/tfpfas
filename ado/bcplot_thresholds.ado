capture program drop bcplot_thresholds
program define bcplot_thresholds 
	// ==========================================================================================
	/*
		Runs a series of regression using discretized variables (based on provided cutoffs)
			and plot the coefplot.

        - y: Name of the outcome variable.
        - x: Name of dependent variable.
        - cutoffs: Cutoffs defined using forvalues syntax (e.g. 0/10) 
		- Absorb: Variables to be absorbed and partialed out
		- Controls: Control variables
		- Cluster: Level to cluster SE at.
		- xtitle: X-axis title
		- yscale: Range of y-axis
		- ylabel: Tick labels for y-axis
		- coeflabels: Labels for the coefficients (e.g., dd0 = 0km, dd2 = 2km)

		Example
		-------
		. sysuse auto
		. bcplot_thresholds price mpg, cutoffs(20/30)

	*/
	syntax varname(min=2 max=2 numeric) [if] [in], cutoffs(string) [ABSorb(string) Controls(string) cluster(string) ///
		xtitle(string) ytitle(string) YScale(string) YLABel(string) COEFLabels(string) name(string)]
	// ==========================================================================================
    local y "`1'"
	local x: word 2 of `varlist'
	if "`ytitle'"=="" {
		// local ytitle ""Estimated coefficient" "of 1(area > threshold) indicator" "on (standardized) PFAS measurement""
		local ytitle 
	}
	else {
		local ytitle ""Estimated coefficient" "of 1(area > threshold) indicator on PFBS""
	}

    forvalues cutoff = `cutoffs' {
        gen dd`cutoff' = (`x' > `cutoff')
        dis "N above cutoff:"
        count if dd`cutoff' == 1
        qui proportion dd`cutoff'
        if "`absorb'"!="" {
        	qui eststo: reghdfe `y' dd`cutoff' `controls' `if' `in', absorb(`absorb') cluster(`cluster')    
        }
        else {
        	qui eststo: reg `y' dd`cutoff' `controls' `if' `in', cluster(`cluster')    
        }
    }
    #delimit;
    coefplot
        (est*), 
        keep(dd*)
        vertical
        legend(off)
        // Marker opts
        msymbol(o) 
        msize(vlarge)
        mcolor(gs5)   
        // CI opts
        ciopts( recast(rcap) color(gs9) lwidth(medthick) )             
        // Connect coefs
        recast(connected)
        lwidth(medthick) lpattern(dash) lcolor(navy*.7)
        // Y-axis
        yscale(`yscale')
        ylabel(`ylabel', labsize(medium))
        yline(0, lcolor(gs10) lpattern(dash) lwidth(medium) )
        ytitle(`ytitle')
        // X-axis
        xlabel(, angle(0) labsize(medium) )    
        xtitle("Threshold (area in '000 m{superscript:2})")
        plotregion(lcolor(black)  margin(0 0 0 0))      
        graphregion(margin(0 0 0 1))          
        coeflabels(`coeflabels')
        name(`name', replace)
    ;
    #delimit cr

    drop dd*
end
