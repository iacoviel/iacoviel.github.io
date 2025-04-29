// Test global macro database

// Load GMD
* Rename variables and update labels 
use GMD.dta, clear
keep if year>=1900

foreach var of varlist * {
        * Store the current label
        local oldlabel : variable label `var'
        
        * If no label exists, use the variable name as the label
        if "`oldlabel'" == "" {
            local oldlabel "`var'"
        }
        
        * Rename the variable
        rename `var' gmd_`var'
        
        * Add "GMD:" to the label
        label variable gmd_`var' "GMD: `oldlabel'"
}

rename (gmd_ISO3) (iso), norenumber
rename (gmd_year) (year), norenumber
drop gmd_countryname
drop gmd_id
format gmd_infl %5.1f

save GMD_1900_2025_TEMP.dta, replace


// USE GPRH DATABASE AND MERGE
use gprh_annual_infl_v12.dta, clear
merge 1:1 iso year using GMD_1900_2025_TEMP.dta, keep(1 3) 


* FIX ARGENTINA'S PROBLEM
replace gmd_infl = 100*gmd_infl if countrylong=="Argentina" & year<2019

* Create label for scatter plot
gen iso_year = iso + "_" + string(year)

// Chart showing discrepancies
graph twoway ///
(scatter inflation gmd_infl if inflation<100 & inflation>-80, mcolor(navy) msize(.5) msymbol(circle)) ///
(scatter inflation gmd_infl if inflation<100 & inflation>-80 & abs(inflation-gmd_infl)>20, ///
    mcolor(red) msymbol(diamond) msize(.5) mlabel(iso_year) mlabposition(12) mlabsize(vsmall)), ///
title("Comparison of Inflation Measures") ///
subtitle("Highlighting discrepancies > 20 percentage points") ///
xlabel(, grid) ylabel(, grid) ///
legend(order(1 "All observations" 2 "Large discrepancies")) ///
aspect(0.6) name(infl_comp, replace)


// List of countries with largest discrepancies
gen inf_gaps = abs(inflation-gmd_infl)
tabulate iso if inf_gaps > 10 & inf_gaps~=.

// List of observations across two databases (exclude hh)
sum inflation gmd_infl if inflation<10000 | gmd_infl<10000
sum gmd_infl if inflation==.
sum inflation if gmd_infl==.

// List of super-negative inflation obs
list country year inflation gmd_infl code_inflation if gmd_infl<-30 | inflation<-30, header(10)

// List of cases for which GMD has data and we don't
list country year inflation gmd_infl if gmd_infl~=. & inflation==., header(10)


