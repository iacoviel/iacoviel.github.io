set scheme s1color, permanently
cls


global do_table1_contributions = 0 
global do_table1_peakmonth = 0
global do_table2 = 0  

// Input: data_for_charts_in_paper.dta

use data_for_charts_in_paper, replace




//--------------------------------------------------------------------
// Table 1 part A: Peak dates by category reported
//--------------------------------------------------------------------

if $do_table1_peakmonth == 1 {

use data_for_charts_in_paper, replace

global COMPTYPE "1 2 3 4 5 6 7 8"

format SCOMP_* MCOMP_* SHARE_GPRH %5.2f

label var MCOMP_1 "WAR_T articles divided by total articles"
label var MCOMP_2 "PEA_T articles divided by total articles"
label var MCOMP_3 "MIL_T articles divided by total articles"
label var MCOMP_4 "NUK_T articles divided by total articles"
label var MCOMP_5 "TER_T articles divided by total articles"
label var MCOMP_6 "WAR_A articles divided by total articles"
label var MCOMP_7 "ACT_A articles divided by total articles"
label var MCOMP_8 "TER_A articles divided by total articles"

label var SCOMP_1 "WAR_T articles not mentioning other categories divided by total articles"
label var SCOMP_2 "PEA_T articles not mentioning other categories divided by total articles"
label var SCOMP_3 "MIL_T articles not mentioning other categories divided by total articles"
label var SCOMP_4 "NUK_T articles not mentioning other categories divided by total articles"
label var SCOMP_5 "TER_T articles not mentioning other categories divided by total articles"
label var SCOMP_6 "WAR_A articles not mentioning other categories divided by total articles"
label var SCOMP_7 "ACT_A articles not mentioning other categories divided by total articles"
label var SCOMP_8 "TER_A articles not mentioning other categories divided by total articles"



// Take average of two criteria to measure a category contribution in order to calculate peak
foreach x of global COMPTYPE {
gen TCOMP_`x' = SCOMP_`x' + MCOMP_`x'
egen rank_TCOMP_`x' = rank(-TCOMP_`x'), unique
gen top_TCOMP_`x' = 1 if rank_TCOMP_`x'==1
}



// CREATE INITIAL PEAK-MONTH CATEGORY

foreach x of global COMPTYPE {
list month rank_TCOMP_`x' TCOMP_`x' SHARE_GPRH event if (rank_TCOMP_`x' <= 2 )
}

// Manually swap 1939 with 1962 in category 3 because 1939 has already another peak
replace rank_TCOMP_3 = 2 if tin(1939m9,1939m9)
replace rank_TCOMP_3 = 1 if tin(1962m10,1962m10)



// CREATE FINAl PEAK-MONTH CATEGORY
foreach x of global COMPTYPE {
list month rank_TCOMP_`x' TCOMP_`x' SHARE_GPRH event if (rank_TCOMP_`x' <= 1 )
}




}






//-------------------------
// Table 1 part B: Components of the index
//-------------------------

if $do_table1_contributions == 1 {


//-----------------------------------------
// Table 1A: SHARES OF INDEX BY CATEGORY 
//-----------------------------------------


global COMPTYPE "1 2 3 4 5 6 7 8"

label var GPRH_M1_RAW "raw number of articles belonging to cat.1"
label var GPRH_M2_RAW "raw number of articles belonging to cat.2"
label var GPRH_M3_RAW "raw number of articles belonging to cat.3"
label var GPRH_M4_RAW "raw number of articles belonging to cat.4"
label var GPRH_M5_RAW "raw number of articles belonging to cat.5"
label var GPRH_M6_RAW "raw number of articles belonging to cat.6"
label var GPRH_M7_RAW "raw number of articles belonging to cat.7"
label var GPRH_M8_RAW "raw number of articles belonging to cat.8"

egen ntotal = rowtotal(GPRH_M?_RAW)

foreach x of global COMPTYPE {
gen CONT`x' = 100*GPRH_M`x'_RAW/ntotal
}

format CONT* %5.1f

sum CONT*
sum CONT* if tin(1900m1,1959m12)
sum CONT* if tin(1960m1,2019m12)


insob 10 1
gen ZZ = _n

local k=0
gen meanx1=.
gen meanx2=.
gen meanx3=.
gen varv=" "

foreach x of global COMPTYPE {

local k=`k'+1

quietly sum CONT`x' 
quietly replace meanx1=r(mean) if ZZ==`k'
quietly sum CONT`x' if tin(1900m1,1959m12)
quietly replace meanx2=r(mean) if ZZ==`k'
quietly sum CONT`x' if tin(1960m1,2019m12)
quietly replace meanx3=r(mean) if ZZ==`k'

}

format meanx* %5.1f

replace varv= "War Threats (1)" if ZZ==1
replace varv= "Peace Threats (2)" if ZZ==2
replace varv= "Military Buildups (3)" if ZZ==3
replace varv= "Nuclear War Threats (4)" if ZZ==4
replace varv= "Terrorist Threats (5)" if ZZ==5
replace varv= "War Acts (6)" if ZZ==6
replace varv= "War Escalation (7)" if ZZ==7
replace varv= "Terror Acts (8)" if ZZ==8

list varv meanx* if ZZ<=8

}









//-------------------------
// Table 2: Largest GPRH Shocks
//-------------------------

if $do_table2 == 1 {

use data_for_charts_in_paper, replace

drop rank_RESID* RESID*

keep if tin(1900m1,2019m12)


// Calculate shocks from autoregression of each variable on its first 3 lags, get residuals and rank them

foreach yy of varlist GPRH {

cap regress `yy' L(1/3).`yy'
cap predict RESID_`yy', residuals 
egen rank_RESID_`yy' = rank(-RESID_`yy'), unique

cap regress `yy'T L(1/3).`yy'T
cap predict RESID_`yy'T, residuals 
egen rank_RESID_`yy'T = rank(-RESID_`yy'T), unique

cap regress `yy'A L(1/3).`yy'A
cap predict RESID_`yy'A, residuals 
egen rank_RESID_`yy'A = rank(-RESID_`yy'A), unique


}





format GPRH* %5.1f
format RESID* %5.1f

// RANK GPR
global nshocks=15

list month rank_RESID_GPRH GPRH RESID_GPRH event if rank_RESID_GPRH<=$nshocks

listtex month rank_RESID_GPRH GPRH RESID_GPRH event if rank_RESID_GPRH<=$nshocks, type rstyle(tabular) ///
head("\begin{tabular}{ccccc}" `"\textbf{Month}&\textbf{Rank}&\textbf{GPR}&\textbf{Shock to GPR}&\textbf{Event}\\"') ///
foot("\end{tabular}")



// RANK GPR THREATS
global nshocks=5

list month rank_RESID_GPRHT GPRHT RESID_GPRHT event if rank_RESID_GPRHT<=$nshocks

listtex month rank_RESID_GPRHT GPRHT RESID_GPRHT event if rank_RESID_GPRHT<=$nshocks, type rstyle(tabular) ///
head("\begin{tabular}{ccccc}" `"\textbf{Month}&\textbf{Rank}&\textbf{GPR Threats}&\textbf{Shock to GPR}&\textbf{Event}\\"') ///
foot("\end{tabular}")


// RANK GPR ACTS
global nshocks=5

list month rank_RESID_GPRHA GPRHA RESID_GPRHA event if rank_RESID_GPRHA<=$nshocks

listtex month rank_RESID_GPRHA GPRHA RESID_GPRHA event if rank_RESID_GPRHA<=$nshocks, type rstyle(tabular) ///
head("\begin{tabular}{ccccc}" `"\textbf{Month}&\textbf{Rank}&\textbf{GPR Acts}&\textbf{Shock to GPR}&\textbf{Event}\\"') ///
foot("\end{tabular}")

















}


