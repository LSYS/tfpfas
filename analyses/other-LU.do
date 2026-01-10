do preamble

// ---------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------
preserve
eststo clear 
global other_lu buff500m_area_agriculture-buff500m_area_sports___recreatio buff500m_area_utility buff500m_area_waterbody buff500m_area_white
foreach lu of varlist $other_lu {
	replace `lu' = `lu'/1000 if !missing(`lu')
	eststo: reghdfe buff500m_area_transport_faciliti `lu', absorb(subzone2008) cluster(planning_area2008)
} 

// ---------------------------------------------------------------------------------
// Settings
#delimit;
local graph_opts
	nooffset
    legend(off)
    // Axis labels settings (nogextend prevents gridlines from extending; glcolor = gridline color)
    // https://www.statalist.org/forums/forum/general-stata-discussion/general/1410098-twoway-graph-grid-lines-lie-on-top-of-frame-around-plot-region-how-to-avoid-that
    ylabel(, labsize(vsmall) notick grid nogextend glcolor(gs15))
	xlabel(, labsize(vsmall) notick grid nogextend glcolor(gs15))
	// Set to none (needed to prevent coefplot from adding its own grid)
	// which is harder to tweak (see xlabel and ylabel nogextend glcolor)
	grid( none ) 
    xline(0, lpattern(dash) lcolor(gs7) lwidth(medthin))
    // Graph and plot region settings
	graphregion(color(white) margin(0 0 0 0)) 
	// margin(tiny) needed to prevent gridlines going into borders but still have small margins
	plotregion(lcolor(black) margin(tiny))
	// Drop other variables
	drop(buff500m_area_transport_faciliti _cons)
	// Coefficient labels
 	coeflabel(
 		buff500m_area_agriculture = "Agriculture"
 		buff500m_area_beach_area = "Beach"
 		buff500m_area_business_1 = "Business 1"
 		buff500m_area_business_1_white = "Business 1 - White"
 		buff500m_area_business_2 = "Business 2"
 		buff500m_area_business_2_white = "Business 2 - White"
 		buff500m_area_business_park = "Business Park"
 		buff500m_area_business_park_whit = "Business Park - White"
 		buff500m_area_cemetery = "Cemetery"
 		buff500m_area_civic___community_ = "Civic & Community Institution"
 		buff500m_area_commercial = "Commercial"
 		buff500m_area_commercial___resid = "Commercial & Residential"
 		buff500m_area_commercial_institu = "Commercial/Institution"
 		buff500m_area_educational_instit = "Educational Institution"
 		buff500m_area_health___medical_c = "Health & Medical Care"
 		buff500m_area_hotel = "Hotel"
 		buff500m_area_light_rapid_transi = "Light Rapid Transit"
 		buff500m_area_mass_rapid_transit = "Mass Rapid Transit"
 		buff500m_area_open_space = "Open Space"
 		buff500m_area_place_of_worship = "Place of Worship"
 		buff500m_area_port_airport = "Port/Airport"
 		buff500m_area_reserve_site = "Reserve Site"
 		buff500m_area_residential = "Residential"
 		buff500m_area_residential_instit = "Residential/Institution"
 		buff500m_area_residential_with_c = "Residential with Commercial at 1st storey"
 		buff500m_area_road = "Road"
 		buff500m_area_special_use = "Special Use"
 		buff500m_area_sports___recreatio = "Sports & Recreation"
 		buff500m_area_transport_faciliti = "Transport Facilities"
 		buff500m_area_utility = "Utility"
 		buff500m_area_waterbody = "Waterbody"
 		buff500m_area_white = "White"
 		buff500m_area_park = "Park"
 	)
;
#delimit cr

grstyle init 
grstyle set plain, 

local ll -1
local hl 1.5
// Coefplot
#delimit;
coefplot 
	(*, pstyle(p1) mfcolor(white) mlwidth(thin) mcolor(gs8) ciopts(lcolor(gs10)))
    (*, pstyle(p1) mfcolor(white) mlwidth(thin) mcolor(gs8) if(@ll>`ll'&@ul>=`hl')  ciopts(lcolor(gs10) recast(pcarrow)  color(gs6)))  
	(*, pstyle(p1) mfcolor(white) mlwidth(thin) mcolor(gs8) if(@ll<=`ll'&@ul>=`hl') ciopts(lcolor(gs10) recast(pcbarrow) color(gs6)))
	(*, pstyle(p1) mfcolor(gs5)   mlwidth(thin) mcolor(gs3) if(@ll>0 | @ul<0) ciopts(lcolor(gs8))), 
	transform(* = min(max(@,`ll'),`hl'))
	sort `graph_opts' xscale(range(`ll' `hl')) 
	xtitle("Association between transport facilities" "and other land use types", size(small))
; 
#delimit cr
savefig, path($figsavedir/coefplot-correlates-of-tf500m-sorted) format($graphformats) override(width(1000))
restore
	

// ---------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------	
preserve
eststo clear
foreach lu of varlist  buff500m_area_agriculture - buff500m_area_white {
	egen _x = std(`lu') if !missing(`lu')
	replace `lu' = _x
	su `lu'
	drop _x 
	cap eststo: qui reghdfe pfbs `lu' $mat_x, absorb($mat_x_group subzone2008) cluster(planning_area2008)
} 

// ---------------------------------------------------------------------------------
// Settings
#delimit;
local graph_opts
	nooffset
    legend(off)
    // Axis labels settings (nogextend prevents gridlines from extending; glcolor = gridline color)
    // https://www.statalist.org/forums/forum/general-stata-discussion/general/1410098-twoway-graph-grid-lines-lie-on-top-of-frame-around-plot-region-how-to-avoid-that
    ylabel(, labsize(vsmall) notick grid nogextend glcolor(gs15))
	xlabel(, labsize(vsmall) notick grid nogextend glcolor(gs15))
	// Set to none (needed to prevent coefplot from adding its own grid)
	// which is harder to tweak (see xlabel and ylabel nogextend glcolor)
	grid( none ) 
    xline(0, lpattern(dash) lcolor(gs7) lwidth(medthin))
    // Graph and plot region settings
	graphregion(color(white) margin(1 1 1 1)) 
	// margin(tiny) needed to prevent gridlines going into borders but still have small margins
	plotregion(lcolor(black) margin(tiny))
	// Drop other variables
	drop(*mother* _cons)
	// Coefficient labels
 	coeflabel(
 		buff500m_area_agriculture = "Agriculture"
 		buff500m_area_beach_area = "Beach"
 		buff500m_area_business_1 = "Business 1"
 		buff500m_area_business_1_white = "Business 1 - White"
 		buff500m_area_business_2 = "Business 2"
 		buff500m_area_business_2_white = "Business 2 - White"
 		buff500m_area_business_park = "Business Park"
 		buff500m_area_business_park_whit = "Business Park - White"
 		buff500m_area_cemetery = "Cemetery"
 		buff500m_area_civic___community_ = "Civic & Community Institution"
 		buff500m_area_commercial = "Commercial"
 		buff500m_area_commercial___resid = "Commercial & Residential"
 		buff500m_area_commercial_institu = "Commercial/Institution"
 		buff500m_area_educational_instit = "Educational Institution"
 		buff500m_area_health___medical_c = "Health & Medical Care"
 		buff500m_area_hotel = "Hotel"
 		buff500m_area_light_rapid_transi = "Light Rapid Transit"
 		buff500m_area_mass_rapid_transit = "Mass Rapid Transit"
 		buff500m_area_open_space = "Open Space"
 		buff500m_area_place_of_worship = "Place of Worship"
 		buff500m_area_port_airport = "Port/Airport"
 		buff500m_area_reserve_site = "Reserve Site"
 		buff500m_area_residential = "Residential"
 		buff500m_area_residential_instit = "Residential/Institution"
 		buff500m_area_residential_with_c = "Residential with Commercial at 1st storey"
 		buff500m_area_road = "Road"
 		buff500m_area_special_use = "Special Use"
 		buff500m_area_sports___recreatio = "Sports & Recreation"
 		buff500m_area_transport_faciliti = "Transport Facilities"
 		buff500m_area_utility = "Utility"
 		buff500m_area_waterbody = "Waterbody"
 		buff500m_area_white = "White"
 		buff500m_area_park = "Park"
 	)
;
#delimit cr

// local ll -.05
// local hl .05

local ll -5
local hl 3.5

#delimit;
coefplot 
	(*, pstyle(p1) mfcolor(white) mlwidth(thin) mcolor(gs8) if(@ll>=`ll' & @ul<=`hl')
		ciopts(lcolor(gs10)))
	// Right truncated only (upper limit exceeds hl)
    (*, pstyle(p1) mfcolor(white) mlwidth(thin) mcolor(gs8) if(@ll>=`ll' & @ul>`hl')  
		ciopts(recast(pcarrow) lcolor(gs10)))
	// Left truncated only (lower limit below ll)
    (*, pstyle(p1) mfcolor(white) mlwidth(thin) mcolor(gs8) if(@ll<`ll' & @ul<=`hl')  
		ciopts(recast(pcrarrow) lcolor(gs10)))
	// Both truncated
	(*, pstyle(p1) mfcolor(white) mlwidth(thin) mcolor(gs8) if(@ll<`ll' & @ul>`hl') 
		ciopts(recast(pcbarrow) lcolor(gs10)))
	// Significant coefficients (overlay)
	(*, pstyle(p1) mfcolor(gs5) mlwidth(thin) mcolor(gs3) if(@ll>0 | @ul<0) 
		ciopts(lcolor(gs8))), 
	transform(* = min(max(@,`ll'),`hl'))
	sort `graph_opts'
; 
#delimit cr
savefig, path($figsavedir/coefplot-pfbs-lu-association) format($graphformats) override(width(1000))
