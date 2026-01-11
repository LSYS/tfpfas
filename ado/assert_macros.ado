capture program drop assert_macros
program define assert_macros
    syntax anything(name=macros) [, STRICT]
    ///////////////////////////////////////////////////////////////////////////////
    // Description:
    // ------------
    //      Asserts that global macro(s) are defined (not empty).
    //
    // Syntax:
    // -------
    //      assert_macros macro1 macro2 ... [, strict]
    //
    // Options:
    // --------
    //      strict  - Break execution if any macro is empty/undefined
    //
    // MWE:
    // ----
    //      sysuse auto
    //      global m1 price make
    //      assert_macros m1 m2              // Just warns
    //      assert_macros m1 m2, strict      // Breaks on error
    ///////////////////////////////////////////////////////////////////////////////
    if "`macros'"!="" {
        foreach global_macro in `macros' {
            dis "Checking `global_macro':"
            capture assert "$`global_macro'" != ""
            if _rc != 0 {
                display as error "`global_macro' is empty (not defined)."
                if "`strict'" != "" {
                    error 111  // Break execution in strict mode
                }
            }
            else {
                display "`global_macro' contains: $`global_macro'"
            }
        }
    }
    else {
        noisily dis "No macros stated..."
    }
end
