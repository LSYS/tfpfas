// cap net install here, from("https://raw.githubusercontent.com/korenmiklos/here/master/")
cap here
if _rc == 0 {
	here, set
	cd ${here}
}
else {
	global here "\\wsl.localhost\Debian\home\lsys\gusto\scripts\tfpfas"
	cd $here
}

cap log close
local log ./logs/tf-pfas
log using `log'.smcl, replace smcl

* =============================================================================
* Program Setup
* =============================================================================
cls 					// Clear results window
clear all               // Start with a clean slate
set more off            // Disable partitioned output
macro drop _all         // Clear all macros to avoid namespace conflicts
set linesize 150        // Line size limit to make output more readable, affects logs
set varabbrev off 

// Still on version 13
version 13              
local stata_version : display c(version)

// Add path to ados
adopath ++ ./ado 		

global figsavedir ./figures
global tabsavedir ./tables
global graphformats png pdf eps

tictoc tic

do ./analyses/preamble

* ---------------------------------------------------------
// Tabulate PFAS
* ---------------------------------------------------------
* Tabulate PFBS results
do ./analyses/tabulate-estimates

* all PFAS coefficients for forestplot
do ./analyses/standardized-estimates

* ---------------------------------------------------------
// dfbetas for influential points
* ---------------------------------------------------------
do ./analyses/dfbetas

// * ---------------------------------------------------------
* Make the plot for dummies based on different thresholds
* 	using area of transport facilities in 500m radius
// * ---------------------------------------------------------
do ./analyses/coefplot-threshold-dose-response

// * ---------------------------------------------------------
// // Add built and social environmental covariates
// * ---------------------------------------------------------
do ./analyses/env-covariates-coefplot

* ---------------------------------------------------------
* Movers and future addresses
* ---------------------------------------------------------
do ./analyses/movers-future-exposure

// * ---------------------------------------------------------
// Negatives w/ spatial instruments 
// that should not affect PFBS measures
// * ---------------------------------------------------------
do ./analyses/negatives-spatial-instruments

 * ---------------------------------------------------------
* Other PFAS substances
* ---------------------------------------------------------
* Plot Correlates of cord blood-based PFAS
do ./analyses/correlates-pfbs-pfas

* ---------------------------------------------------------
* Make the binscatterhist plots
* ---------------------------------------------------------
if `c(version)' >= 15 {
    do ./analyses/binscatter
}

* ---------------------------------------------------------
* S-PRESTO
* ---------------------------------------------------------
do ./analyses/spresto

// ========================================================
* ---------------------------------------------------------
tictoc toc
log close
local log ./logs/tf-pfas
translate `log'.smcl `log'.log, replace
translate `log'.smcl `log'.pdf, replace
