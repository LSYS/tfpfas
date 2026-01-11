capture program drop runregs
program define runregs
    /* This program runs a series of regression analyses and generates a table using esttab.
       It takes the following inputs:
       - y: Name of the outcome variable.
       - x: Name of dependent variable.
       - xlabel: Label for x in the table.
       - savepath: Path to save the output table.

       Example usage:
       myprogram y s, reg-table-frag.tex
    */
    syntax varname(min=2 max=2 numeric) [if] [in], [xlabel(string) savepath(string)]

    local y "`1'"
    local x: word 2 of `varlist'

    if "`savepath'" == "" local savepath "`y'-`x'-reg-frag.tex"
    if "`xlabel'" == "" local xlabel "`x'"
    dis "`savepath'"

    // Define specifications
    local spec1 reghdfe `y' `x' $mat_x `if' `in', absorb($mat_x_group planning_area2008) cluster(planning_area2008)
    local spec2 reghdfe `y' `x' $mat_x `if' `in', absorb($mat_x_group subzone2008) cluster(planning_area2008)
    local spec3 reghdfe `y' `x' $mat_x `if' `in', absorb($mat_x_group $mat_x_inc subzone2008) cluster(planning_area2008)

    eststo clear
    forvalues i = 1/3 {
        eststo: `spec`i''
        
        // Get mean of y
        sum `e(depvar)' if e(sample)
        local ymean: display %9.1fc `r(mean)'
        estadd local ymean "`ymean'"
        
        // Get std dev. of x
        sum `x' if e(sample)
        local xsd: display %9.1fc `r(sd)'
        estadd local xsd "`xsd'"  
        
        // Get coverage
        count if (`x' > 0) & ~missing(`x') & e(sample)
        estadd local x_coverage "\multicolumn{1}{c}{$`r(N)'$}"
        
        // Get obs
        local nobs: display %9.0fc `e(N)'
        estadd local nobs "\multicolumn{1}{c}{$`nobs'$}"
        
        // Labels
        estadd local Nclusters = "\multicolumn{1}{c}{$`e(N_clust1)'$}"
        estadd local demo "\multicolumn{1}{c}{Yes}"
        
        // Set fixed effects checklist
        if `i' == 1 {
            estadd local areaFE "\multicolumn{1}{c}{Yes}"
        }
        if `i' > 1 {
            estadd local szFE "\multicolumn{1}{c}{Yes}"
        }       
        if `i' == 3 {
            estadd local income "\multicolumn{1}{c}{Yes}"
        }
    }

    #delimit;
    esttab using "`savepath'",
       cell(
          b (                   fmt(%9.3f) star) 
          se(par                fmt(%9.3f))
          ci(par(\multicolumn{1}{r}{\text{[$ \text{--} $]}}) fmt(%9.3f))
          p (par(\multicolumn{1}{r}{\text{$<p= >$}})           fmt(%4.3f)) 
        )     
        varwidth(20)
        modelwidth(8)    
        star (c 0.1 b 0.05 a 0.01)
        obslast
        label
        nobase     
        noobs
        nomtitle
        keep(`x' _cons)
        collabels(, none)
        coeflabel(
            `x' "`xlabel'"
            _cons "Constant"
            )
        scalar(
            "r2 R$^2$" 
            "demo Maternal baselines"
            "income Income"
            "areaFE Area fixed effects: Planning area"
            "szFE Area fixed effects: Subzone"
            "ymean Mean Dep Var."
            "xsd Std. dev. of  X"
            "x_coverage n(`xlabel' > 0)"
            "Nclusters n(Clusters)"
            "nobs N"
            ) 
        alignment(D{.}{.}{-1})
        substitute(\_ _)
        fragment booktabs replace        
        ;
    #delimit cr  
end
