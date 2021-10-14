***************************************************
***************************************************
* Disaster and quantile Regressions
* Updated October 14, 2021 with count of countries/years

***************************************************
***************************************************

set seed 21565052


use "gprh_annual.dta", clear


tabulate year, summarize(disastern)
tabulate year, summarize(disasterc)
tabulate year, summarize(prob_)



*************************************************
* DEPENDENT VARIABLE CONVERSIONS * 
*************************************************

* Generate lag, growth * 
foreach v of varlist milit_exp_share gdp_full TFP {
local varlabel : var label `v'
*Lag*
gen l`v' = L.`v'
label variable l`v' "Lag `varlabel'"
*Growth*
gen g`v' = 100*(`v'/l`v'-1)
label variable g`v' "`varlabel' Growth"
}

*Generate forward growths * 
foreach i of varlist milit_exp_share ggdp_full gTFP {
gen F`i' = F.`i'
}

label variable Fggdp_full "GDP Growth(t+1)"
label var Fmilit_exp_share  "Military Exp.(t+1)"
label var FgTFP "TFP Growth(t+1)"


* GENERATE RUSSIA + CHINA DISASTER *
* Disasters happen at 18% in our date * 
xtile rus_b5 = ggdp_full if iso == "RUS", nq(5)
tab year if rus_b5 == 1
xtile chn_b5 = ggdp_full if iso == "CHN", nq(5)
tab year if chn_b5 == 1

replace disastern = . if iso == "CHN" | iso == "RUS"
gen disastern_plus = disastern
replace disastern_plus = 0 if (iso == "RUS" | iso == "CHN") & year <= 2006
replace disastern_plus = 1 if iso == "RUS" & year >= 1914 & year <= 1920
replace disastern_plus = 1 if iso == "RUS" & year >= 1941 & year <= 1945
replace disastern_plus = 1 if iso == "RUS" & year >= 1990 & year <= 1995
replace disastern_plus = 1 if iso == "CHN" & year >= 1940 & year <= 1946
replace disastern_plus = 1 if iso == "CHN" & year >= 1960 & year <= 1968
label variable disastern_plus "Nakamura Disaster Dummy w China & Russia values"


gen disasterc_plus = disasterc
replace disasterc_plus = disastern_plus if disasterc_plus==. & disastern_plus~=.
replace disasterc_plus = 0 if (iso == "RUS" | iso == "CHN") & year > 2006 & year<=2019
label variable disasterc_plus "CI Disaster Dummy w China & Russia values"

tabulate year, summarize(disasterc_plus)
tabulate year, summarize(disastern_plus)
tabulate year, summarize(prob_)




* Generate year dummys * 
sort iso year
gen dum_1 = 0
replace dum_1 = 1 if year <= 1945
gen dum_2 = 0
replace dum_2 = 1 if year >= 1946 & year <= 1972
gen dum_3 = 0
replace dum_3 = 1 if year >= 1973
label var dum_1 "Dummy Pre-1946"
label var dum_2 "Dummy 1946-1972"
label var dum_3 "Dummy Post-1972"


gen dum_war = 0
replace dum_war = 1 if year >= 1939 & year <= 1945 
replace dum_war = 1 if year >= 1914 & year <= 1918 
label var dum_war "Dummy WWI/WWII"









xtset countrycode year
gen Lggdp_full = L.ggdp_full
label var Lggdp_full "GDP Growth t-1"




//---------------------------
// GLOBAL GPR
//---------------------------

gen GPR = GPR_RATIO_G
label var GPR "Global GPR (share of articles)"
egen SGPR = std(GPR_RATIO_G)



//------------------------------
// GLOBAL GPR SPIKES
//------------------------------

tssmooth ma GPR_SMOOTH = GPR, window(20 0 0)
gen GPR_DETREND = GPR - GPR_SMOOTH
egen rank_GPR_DETREND = rank(-GPR_DETREND), by(country) unique
gen SGPR_SPIKES = cond(rank_GPR_DETREND<=10,SGPR,0,.)

label var GPR_DETREND "Detrended global GPR"
label var GPR_SMOOTH "Global GPR, 20-yr MA"






//------------------------------
// COUNTRY GPR
//------------------------------

gen SGPRCO_SMOOTH=.
gen GPRCO = 100*GPR_RAW_C / N3H_RAW

sort country
by country: egen GPRCO_mean = mean(GPRCO)
by country: egen GPRCO_sd  = sd(GPRCO)
gen SGPRCO = (GPRCO-GPRCO_mean)/GPRCO_sd

label var GPRCO_mean "Within country mean of GPR"
label var GPRCO_sd "Within country sd of GPR"
label var GPRCO "Country GPR, share of articles"


//------------------------------
// COUNTRY GPR SPIKES
//------------------------------

levelsof iso, local(countrylist) 
foreach c of local countrylist {
sort iso
di "`c'"
quietly tssmooth ma SGPRCO_SMOOTH0 = SGPRCO if iso == "`c'", window(20 0 0)
replace SGPRCO_SMOOTH = SGPRCO_SMOOTH0 if iso == "`c'"
drop SGPRCO_SMOOTH0 
}

gen SGPRCO_DETREND = SGPRCO-SGPRCO_SMOOTH

label var SGPRCO_DETREND "Detrened country GPR"
label var SGPRCO_SMOOTH "Country GPR, 20-yr MA"

gen SGPRCO_SPIKES = cond(SGPRCO_DETREND>2,SGPRCO_DETREND,0,.)





// Obs with non-zero country spikes
sum country year SGPRCO_SPIKES if SGPRCO_SPIKES~=. & SGPRCO_SPIKES>0

// Rank of country spikes
egen rank_SGPRCO_SPIKES = rank(-SGPRCO_SPIKES), unique


// List of global spikes
list year rank_GPR_DETREND GPR GPR_SMOOTH if rank_GPR_DETREND<=10 & country=="Belgium"









//***************************************************
//***************************************************
//***************************************************
// DISASTER REGRESSIONS
//*********************************************
//***************************************************
//***************************************************


// REPORTING CORRELATIONS WITH NAKAMURA ET AL.
pwcorr disastern disasterc
tetrachoric disastern disasterc





xtset countrycode year

// Label variables used in regressions
label var SGPRCO "Country GPR"
label var SGPRCO_SPIKES "Country GPR Spikes"
label var SGPR "GPR"
label var SGPR_SPIKES "GPR Spikes"
label var disasterc_plus "Disaster"







// Trick to calculate # of countries for table below
xtreg disasterc_plus SGPR
global ncountry = e(N_g)





*************************
* Model 1
*************************


global regressors_m1 = "Lggdp_full SGPR "

reghdfe disasterc_plus $regressors_m1, noabsorb cl(country year)

eststo globbase, refresh
global r2 = e(r2)
local pr2 : di %7.2fc $r2
global n = e(N)
local N : di %8.0fc $n
estadd local "N2" "`N'"
estadd local "pr2" "`pr2'"
estadd local "nc" "$ncountry"
estadd local "cfe" "No"








 
*************************
* Model 2
*************************

global regressors_m2 = "Lggdp_full SGPR SGPRCO"

reghdfe disasterc_plus $regressors_m2, ab(country) cl(country year)


eststo globcoun, refresh
global r2 = e(r2)
global n = e(N)
local N : di %8.0fc $n
local pr2 : di %7.2fc $r2
estadd local "N2" "`N'"
estadd local "pr2" "`pr2'"
estadd local "nc" "$ncountry"
estadd local "cfe" "Yes"




*************************
*  Model 3
*************************

global regressors_m3 = "Lggdp_full SGPR_SPIKES SGPRCO_SPIKES "

reghdfe disasterc_plus $regressors_m3, ab(country) cl(country year)

eststo spikes, refresh
global r2 = e(r2)
global n = e(N)
local N : di %8.0fc $n
local pr2 : di %7.2fc $r2
estadd local "N2" "`N'"
estadd local "pr2" "`pr2'"
estadd local "nc" "$ncountry"
estadd local "cfe" "Yes"



*************************
*  Model 4
*************************

global regressors_m4 = "SGPR SGPRCO dum_1 dum_2 dum_3 Lggdp_full"

reghdfe disasterc_plus $regressors_m4, ab(country) cl(country year)
eststo preferred, refresh
 
global r2 = e(r2)
local pr2 : di %7.2fc $r2
global n = e(N)
local N : di %8.0fc $n
estadd local "N2" "`N'"
estadd local "pr2" "`pr2'"
estadd local "nc" "$ncountry" 
estadd local "cfe" "Yes"




*************************
*  Model 5
*************************

global regressors_m5 = "dum_war SGPR SGPRCO Lggdp_full"

reghdfe disasterc_plus $regressors_m5, ab(country) cl(country year)
eststo dumwar, refresh
 
global r2 = e(r2)
local pr2 : di %7.2fc $r2
global n = e(N)
local N : di %8.0fc $n
estadd local "N2" "`N'"
estadd local "pr2" "`pr2'"
estadd local "nc" "$ncountry" 
estadd local "cfe" "Yes"





*************************
*  Model 6
*************************
sort countrycode year
gen onset_disaster = max(0,D.disasterc_plus)
replace onset_disaster = . if onset_disaster==0 & disasterc_plus==1
gen lagged_disaster = L.disasterc_plus

sum onset_disaster	

label var onset_disaster "Onset"
label var lagged_disaster "Lagged dep.var."

global regressors_m6 = "SGPR SGPRCO Lggdp_full "

reghdfe onset_disaster $regressors_m6, ab(country) cl(country year)
eststo onset, refresh

global r2 = e(r2)
local pr2 : di %7.2fc $r2
global n = e(N)
local N : di %8.0fc $n
estadd local "N2" "`N'"
estadd local "pr2" "`pr2'"
estadd local "nc" "$ncountry" 
estadd local "cfe" "Yes"



*************************
 *  Model 7
 *************************
gen ending_disaster = .
replace ending_disaster = disasterc_plus if F.D.disasterc_plus==-1
replace ending_disaster = 0 if disasterc_plus==1 & ending_disaster==. & onset_disaster~=1

list country year disasterc_plus onset_disaster ending_disaster if country=="United States"


label var ending_disaster "Ending"

global regressors_m7 = "SGPR SGPRCO Lggdp_full "
 
reghdfe ending_disaster $regressors_m7, ab(country) cl(country year)
eststo ending, refresh

global r2 = e(r2)
local pr2 : di %7.2fc $r2
global n = e(N)
local N : di %8.0fc $n
estadd local "N2" "`N'"
estadd local "pr2" "`pr2'"
estadd local "nc" "$ncountry" 
estadd local "cfe" "Yes"


* Output to Latex

esttab globbase globcoun dumwar spikes preferred  onset ending ///
using table_disaster.tex, ///
nor2 replace depvars label noobs se compress drop(dum_3) b(4) ///
scalars("N2 Observations" "pr2 R^2" "nc Countries" "cfe Country Fixed Effects") ///
title(\label{table:disastermodels}Disaster Models) 














//***************************************************
//***************************************************
//***************************************************
// QUANTILE REGRESSIONS
//***************************************************
//***************************************************
//***************************************************
//***************************************************

global nreps = 500


*------------------
* OLS Regressions * 
*------------------
reg Fggdp_full SGPRCO SGPR, vce(bootstrap, rep($nreps))
eststo gdp_ols

reg FgTFP SGPRCO SGPR, vce(bootstrap, rep($nreps))
eststo tfp_ols

reg Fmilit_exp_share SGPRCO SGPR, vce(bootstrap, rep($nreps))
eststo milit_ols



esttab gdp_ols tfp_ols milit_ols   using table_quantile.tex, ///
coeflabels(SGPRCO "\textbf{OLS}") drop(SGPR _cons) nocons replace depvars label noobs se compress  b(2) ///
title(\label{table:quantilemodels}Quantile Regression Models) nonote


 


*------------------
* Quantile Regressions * 
*------------------


* GDP * 
qui xtreg Fggdp_full SGPRCO SGPR
global ncountry = e(N_g)


sqreg Fggdp_full SGPRCO SGPR, q(.10 .50 .90) rep($nreps)
eststo gdp
estadd local "nc" "$ncountry" 
estadd local "y" ""
gen oo_gdp = e(sample)
sum year if oo_gdp==1
estadd local "min_year" "`r(min)'"
estadd local "max_year" "`r(max)'"



* TFP *
qui xtreg  FgTFP SGPRCO SGPR
global ncountry = e(N_g)

sqreg FgTFP SGPRCO SGPR, q(.10 .50 .90) rep($nreps)
eststo tfp
estadd local "nc" "$ncountry" 
estadd local "y" ""
gen oo_tfp = e(sample)
sum year if oo_tfp==1
estadd local "min_year" "`r(min)'"
estadd local "max_year" "`r(max)'"



* Military Expenditure * 
qui xtreg  Fmilit_exp_share SGPRCO SGPR 
global ncountry = e(N_g)

sqreg Fmilit_exp_share SGPRCO SGPR, q(.10 .50 .90) rep($nreps)
eststo milit
estadd local "nc" "$ncountry" 
estadd local "y" ""
gen oo_mil = e(sample)
sum year if oo_mil==1
estadd local "min_year" "`r(min)'"
estadd local "max_year" "`r(max)'"


esttab gdp tfp milit  using table_quantile.tex, ///
nocons append  label se compress nomtitles nonumbers  b(2) drop(SGPR _cons) ///
scalars( "nc Countries" "min_year Start Year" "max_year End Year" )  

xtdes if disasterc_plus~=.