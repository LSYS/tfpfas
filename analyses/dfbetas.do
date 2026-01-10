assert_macros mat_x mat_x_group mat_x_inc figsavedir graphformats, strict

* Drop to prevent obsolette indices when plotting the x-axis
preserve
local y pfbs
drop if missing(`y')

// ====================================================================================
* Dfbetas for pfbs - buff500m_area_transport_faciliti
qui reghdfe `y' $mat_x, absorb($mat_x_group $mat_x_inc subzone2008) residuals(residualized_y)
qui reghdfe buff500m_area_transport_faciliti $mat_x, absorb($mat_x_group $mat_x_inc subzone2008) residuals(residualized_x)

reg residualized_y residualized_x
dfbeta
rename _dfbeta_1 dfbeta
local n_sample = `e(N)'
dis `n_sample'
gen id = _n

local threshold = 2/sqrt(`n_sample')
dis `threshold'
gen dfbeta_round = round(dfbeta, 0.01)
gen mlab = string(dfbeta_round)
gen mlab2 = " (" + string(id) + ")"

grstyle init
grstyle set plain, noextend compact 

local threshold_line_opts lpattern(solid) lcolor(navy) lwidth(medium)
#delimit;

local outlier_opts 
		msize(*.8)
		mcolor(gs5)
		mlabsize(vsmall)
		mlabcolor(gs4)
		lwidth(medthin)
		lcolor(gs10)
		lpattern(shortdash)
		legend(off)
;

local outlier_opts2
		msize(*.8)
		mcolor(gs5)
		mlabsize(vsmall)
		mlabcolor(gs4)
		lwidth(medthin)
		lcolor(gs10)
		lpattern(shortdash)
		legend(off)
;


twoway (dropline dfbeta id if dfbeta <`threshold' & dfbeta > 0-`threshold',
	vertical
	mcolor(gs5)
	msize(*.4)
	lcolor(gs10)
	lwidth(thin)
	yline(`threshold',  `threshold_line_opts')
	yline(-`threshold', `threshold_line_opts')
	ytitle("dfbetas")
	xtitle(Observation index)
	graphregion(margin(0 0 0 3))
	)
	// Annotate those above threshold
	(dropline dfbeta id if dfbeta > `threshold', 
		`outlier_opts2'
		mlab(mlab)
		mlabpos(12)
		mlabgap(3)
	)	
	(dropline dfbeta id if dfbeta > `threshold', 
		`outlier_opts'
		mlabpos(12)
		mlab(mlab2)
	)
	// Annotate those below threshold
	(dropline dfbeta id if dfbeta < 0-`threshold', 
		`outlier_opts'
		mlab(mlab)
		mlabpos(6)
	)	
	(dropline dfbeta id if dfbeta < 0-`threshold', 
		`outlier_opts'
		mlab(mlab2)
		mlabpos(6)
		mlabgap(3)
	)		
;
#delimit cr
savefig, path($figsavedir/dfbetas-pfbs-buff500m-transportfacilities) format($graphformats) override(width(1000))
restore


// ====================================================================================
 // dfbetas by groups (planning area + subzone)
preserve
drop if missing(`y')

gen x = buff500m_area_transport_faciliti
global spec reghdfe `y' x $mat_x, abs($mat_x_group subzone2008) 
jackknife _b _se, cluster(subzone2008) keep: $spec

//entire sample
$spec  
local n e(N)
dis "Sample: " `n'

local x x
local b _b[`x'] 
dis "Full sampe coeff: " `b'

local se _se[`x']
dis "Full sample SE of coeff: " `se'

* Compute dfbetas
gen double b_`x' = (`n'*`b' - _b_`x')/(`n' -1)
gen double se_`x' = (`n'*`se' - _se_`x')/(`n'-1)
gen double dfbetas_`x' = (_b[`x']-b_`x')/se_`x'

* Compute pvalue
gen double tstat = _b_`x'/_se_`x'
gen double pval = 2*ttail(`n'-1, abs(tstat))

gen dfbeta_round = round(dfbetas_x, .01)
gen pval_round = round(pval, .01)
gen mlab = " (" + string(pval_round) + ")"

grstyle init
grstyle set plain, noextend compact 

local threshold_line_opts lpattern(solid) lcolor(navy) lwidth(medium)
local threshold = 2/sqrt(`n')
dis `threshold'

drop if missing(dfbetas_x)
gen id = _n
#delimit;
twoway (dropline dfbetas_x id if dfbetas_x <`threshold' & dfbetas_x > 0-`threshold',
	vertical
	mcolor(gs5)
	msize(*.6)
	lcolor(gs10)
	lwidth(thin)
	ytitle("dfbetas")
	yline(`threshold',  `threshold_line_opts')
	yline(-`threshold', `threshold_line_opts')	
 	ylabel(-.2 -.1 0 .1 , ang(h))
	xtitle(Subzone index)
	)
	(dropline dfbetas_x id if dfbetas_x >= `threshold', 
		`outlier_opts'
		mlab(subzone2008)
		mlabpos(12)

	)
	// Annotate Subzone
	(dropline dfbetas_x id if dfbetas_x <= -`threshold', 
		`outlier_opts'
		mlab(subzone2008)
		mlabpos(6)
	)
;
#delimit cr
savefig, path($figsavedir/dfbetas-subzones-pfbs-buff500m-transportfacilities) format($graphformats) override(width(1000))
restore


// ====================================================================================
preserve
drop if missing(`y')

gen x = buff500m_area_transport_faciliti
global spec reghdfe `y' x $mat_x, abs($mat_x_group subzone2008) 
jackknife _b _se, cluster(planning_area2008) keep: $spec

//entire sample
$spec  
local n e(N)
dis "Sample: " `n'

local x x
local b _b[`x'] 
dis "Full sampe coeff: " `b'

local se _se[`x']
dis "Full sample SE of coeff: " `se'

* Compute dfbetas
gen double b_`x' = (`n'*`b' - _b_`x')/(`n' -1)
gen double se_`x' = (`n'*`se' - _se_`x')/(`n'-1)
gen double dfbetas_`x' = (_b[`x']-b_`x')/se_`x'

* Compute pvalue
gen double tstat = _b_`x'/_se_`x'
gen double pval = 2*ttail(`n'-1, abs(tstat))

gen dfbeta_round = round(dfbetas_x, .01)

grstyle init
grstyle set plain, noextend compact 

local threshold_line_opts lpattern(solid) lcolor(navy) lwidth(medium)
local threshold = 2/sqrt(`n')
dis `threshold'

drop if missing(dfbetas_x)
gen id = _n
#delimit;
local outlier_opts 
		msize(*1.0)
		mcolor(gs5)
		mlabel(subzone2008)
		mlabsize(vsmall)
		mlabcolor(gs4)
		lwidth(medthin)
		lcolor(gs10)
		lpattern(shortdash)
		legend(off)
;

twoway (dropline dfbetas_x id if dfbetas_x <`threshold' & dfbetas_x > 0-`threshold',
	vertical
	mcolor(gs5)
	msize(*1.1)
	lcolor(gs10)
	lwidth(thin)
	ytitle("dfbetas")
	yline(`threshold',  `threshold_line_opts')
	yline(-`threshold', `threshold_line_opts')	
 	ylabel(-.2 -.1 0 .1 , ang(h))
	xtitle(Planning area index)
	)
	(dropline dfbetas_x id if dfbetas_x >= `threshold', 
		`outlier_opts'
		mlabpos(12)

	)
	(dropline dfbetas_x id if dfbetas_x <= -`threshold', 
		`outlier_opts'
		mlabpos(6)
	)
;
#delimit cr
savefig, path($figsavedir/dfbetas-planningarea-pfbs-buff500m-transportfacilities) format($graphformats) override(width(1000))

restore
