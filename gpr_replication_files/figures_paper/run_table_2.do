set scheme s1color, permanently
cls


global do_table2 = 1  

// Input: data_for_charts_in_paper.dta

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


