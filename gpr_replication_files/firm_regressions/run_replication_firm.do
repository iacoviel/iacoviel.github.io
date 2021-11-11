// Replication of firm-level analysis

use firm_level.dta, clear

global do_run_firm_level_analysis = 1 // Set do_run_firm_level_analysis to 1 to run firm-level regressions
global do_plot_firm_level_gpr = 0 // Set do_plot_firm_level_gpr to 1 to plot figure A.11



xtset firm fquarter
sort firm fquarter

gen dcapxy = capxy if fqtr==1
by firm: replace dcapxy = D.capxy if fqtr>1


gen tobinq = ((prccq*cshoq) + atq - ceqq)/atq 
replace tobinq = . if atq<0

gen cfrate=.
bysort firm: replace cfrate = cheq/L.ppentq

label var cfrate "cheq/L.ppentq"
label var tobinq "((prccq*cshoq) + atq - ceqq)/atq (. if atq<0)"
label var dcapxy "capxy if fqtr==1, D.capxy if fqtr>1"



xtset firm quarter
sort firm quarter

egen sgpr = std(log(GPR))

drop if ffportfolio=="fin" | ffportfolio=="banks" | ffportfolio=="other"

bysort firm: gen kk = ppentq
bysort firm: gen lag1kk = L1.ppentq
bysort firm: gen lag2kk = L2.ppentq
gen d1kk = (kk/lag1kk)-1
gen d2kk = (lag1kk/lag2kk)-1

gen flag_bigdk = 0
replace flag_bigdk = 1 if d1kk>0.5  & d2kk<-0.5 & d1kk!=. & d2kk!=. & kk!=.
replace flag_bigdk = 1 if d1kk<-0.5 & d2kk>0.5  & d1kk!=. & d2kk!=. & kk!=.

gen ik=.
bysort firm: gen lppentq = L.ppentq
bysort firm: replace ik = 100*dcapxy/lppentq 
gen lppentqr = lppentq/JGDP*100

replace ik =. if (dcapxy<0 | lppentqr<5 | loc!="USA" | flag_bigdk==1) 
egen ik_count = total(!missing(ik)), by(firm)

winsor2 tobinq, s(_tr) cuts(1 99)
winsor2 cfrate, s(_tr) cuts(1 99)
label var cfrate_tr "Cash Flow"
label var tobinq_tr "Tobin's Q"

gen gprit = 100*gprix / words

label var gprit "GPR Words to Words Ratio in firm transcript"

egen sgprit = std(gprit)
label var sgprit "GPR Firm-Level"

encode(ffportfolio), gen(ffcode)






if $do_plot_firm_level_gpr == 1 {

cls

preserve

gen gg = gprit

egen gg_count = total(!missing(gg)), by(firm)
drop if gg_count < 2 // Drop if a firm has less than 2 observations on GPR

egen gpri = mean(gg), by(firm)
gen gprifd = gg - gpri // For the chart, firm-level GPR removes firm-level mean
egen gprfd = mean(gprifd), by(quarter) // Aggregate firm-level GPR is mean by quarter



keep if tin(2005q1,2019q4)

collapse sgpr* GPR* gprfd, by(quarter)

egen sgprfd = std(gprfd)

egen sgpragg = std(GPR)


label var sgprfd "Earnings Call: Aggregate GPR (standardized)"
label var sgpragg "GPR Index (standardized)"

pwcorr sgpragg sgprfd 

twoway ///
(tsline sgprfd, recast(connected) color(red) lwidth(thick)  ) ///
(tsline sgpragg,  ///
ylabel(, angle(horizontal)) ///
ysc(r(-2 3.3)) ///
tlabel(2005q1(8)2019q4)  lwidth(medthick) color(blue))  ///
if tin(2005q1,2019q4), ///
graphr(color(white)) ///
legend(order(1 "Earnings Calls: Aggregate GPR, standardized" 2 "GPR Index, standardized") ///
rows(2) symysize(0.01) ring(0) position(10) size(*0.7)) ///
ttitle(" ") name(GG, replace)

gr export gpr_firms_aggregate.eps, replace

restore

}













if $do_run_firm_level_analysis == 1 {

//---------------------------------
// Local Projection
//---------------------------------

gen bet1 = .
gen bet1_se = .
gen horizon = .
gen bet1x = .
gen bet1_lbx = .
gen bet1_ubx = .
gen zero_line = 0
gen L1yy = .
gen L1xx = .
gen F0yy = .
gen F1yy = .
gen F2yy = .
gen F3yy = .
gen F4yy = .
gen F5yy = .
gen F6yy = .
gen yy = .
gen xx = .




global shock_size = 2
global nperiods = 6

forvalues x = 0/$nperiods {
replace horizon = `x' if quarter == quarterly("2015q1", "YQ") + `x'
}
label var horizon "Quarters"

gen dsgpr = D.sgpr
egen GPRxALL = std(dsgpr)

egen mdsgpr = mean(dsgpr), by(quarter)
replace dsgpr = mdsgpr if dsgpr==.

global smpl1 = "1985q1"
global smpl2 = "2019q4"
keep if tin($smpl1,$smpl2)

gen lik = log(ik)
replace lik=. if ik_count<10
winsor2 lik, s(tr) cuts(1 99)
replace lik = 100*liktr



egen mbeta = mean(beta), by(ffcode)
egen smbeta = std(mbeta)
gen dumexpo = 0 if smbeta~=.
quietly sum mbeta, detail
replace dumexpo = 1 if mbeta<=r(p50)
gen GPRxEXPOD = dumexpo*GPRxALL
gen GPRxEXPON = -smbeta*GPRxALL




foreach ii of numlist 0 1 {

global igpr = `ii'

if $igpr == 0 { 
global yvar "lik"
global xvar "GPRxEXPOD" 
global absorb_controls = "firm " 
global cluster_controls = "ffind49 quarter" 
global thetitle "Firm-Level Investment: Response to GPR of Exposed Industries"
global reg_controls = "L1yy GPRxALL cfrate_tr tobinq_tr" 
}



if $igpr == 1 { 
global yvar "lik"
global xvar "sgprit" 
global absorb_controls = "firm i.quarter#i.ffind49" 
global cluster_controls = "firm i.quarter#i.ffind49" 
global thetitle "Firm-Level Investment: Response to Idiosyncratic GPR"
global reg_controls = "L1yy cfrate_tr tobinq_tr" 
}




sort firm quarter

replace yy = $yvar
replace xx = $xvar
replace L1yy = L1.yy
replace L1xx = L1.xx
replace F0yy = yy
replace F1yy = F1.yy 
replace F2yy = F2.yy 
replace F3yy = F3.yy 
replace F4yy = F4.yy 
replace F5yy = F5.yy 
replace F6yy = F6.yy 


sort firm quarter




forvalues x = 0/$nperiods {

reghdfe F`x'yy xx $reg_controls if tin($smpl1,$smpl2), ab($absorb_controls) vce(cl $cluster_controls) nosample

replace bet1 = _b[xx] if quarter == quarterly("2015q1", "YQ") + `x'
replace bet1_se =  _se[xx] if quarter == quarterly("2015q1", "YQ") + `x'

}


replace bet1x = bet1*($shock_size)
replace bet1_lbx = (bet1 - 1.645*bet1_se)*($shock_size)
replace bet1_ubx = (bet1 + 1.645*bet1_se)*($shock_size)

sort horizon

twoway ///
(rarea bet1_ubx bet1_lbx horizon if horizon!=. & ticker=="AAPL", color(erose%70)) /// 
(line bet1x zero_line horizon if horizon!=. & ticker=="AAPL", ///
lc(cranberry black) lwidth(thick thin)), ///
xtitle(Quarters, size(medium)) ///
legend(off) ///
ytitle(Percent response)  ///
title(" $thetitle ", color(black) ) ///
ylabel(, ax(1) nogrid angle(horizontal)) ///
name(IRF${igpr}, replace) 


if $igpr == 0 { 
gr combine IRF0, xcommon cols(1) name(CC${igpr}, replace)
}


if $igpr == 1 { 
gr combine IRF0 IRF1, xcommon cols(1) graphr(color(white)) name(CC${igpr}, replace)
gr export irf_local_projection_gpr.eps, replace
}



}






//-------------------------------------
// Regression table
//-------------------------------------



label var GPRxEXPOD "$ \Delta $ GPR x Dummy Industry Exposure"
label var GPRxEXPON "$ \Delta $ GPR x Exposure"
label var GPRxALL "$ \Delta $ GPR "
label var L1yy "$ IK(t-1) $"

egen sprisk = std(PRisk)
label var sprisk "Political Risk Hassan et al."






// REGRESSION #1

reghdfe F2yy GPRxEXPOD L1yy cfrate_tr tobinq_tr GPRxALL ///
if tin(1985q1,2019q4), ///
ab(firm) vce(cl ffind49 quarter)

gen oo1 = e(sample)

local N : di %9.0fc e(N)
local r2 : di %9.2fc e(r2)
outreg using table_firm_regressions.tex, replace varlabels ///
addrows(" ", " " \ "Observations", "`N'" \ "Firm Fixed Effects", "Yes" \ ///
 "Time Effects", "No"  \ "R-squared", "`r2'" \ "Sample", "85Q1-19Q4" ) ///
ctitles(" \$ IK(t+2) \$", "1") ///
se nolegend nocons noautosumm sdec(2) tex star starlevels(5 1 0.1) starloc(1)





// REGRESSION #2

reghdfe F2yy GPRxEXPOD L1yy cfrate_tr tobinq_tr ///
if tin(1985q1,2019q4), ///
ab(firm quarter) vce(cl ffind49 quarter)

gen oo2 = e(sample)

local N : di %9.0fc e(N)
local r2 : di %9.2fc e(r2)
outreg using table_firm_regressions.tex, merge varlabels ///
addrows(" ", " " \ "Observations", "`N'" \ "Firm Fixed Effects", "Yes" \ ///
 "Time Effects", "Yes"  \ "R-squared", "`r2'" \ "Sample", "85Q1-19Q4") ///
ctitles(" \$ IK(t+2) \$", "2") ///
se nolegend nocons noautosumm sdec(2) tex star starlevels(5 1 0.1) starloc(1)




// REGRESSION #3

reghdfe F2yy sgprit L1yy cfrate_tr tobinq_tr ///
if tin(2005q1,2019q4), ///
ab(firm i.quarter#i.ffind49) vce(cl firm i.quarter#i.ffind49)

gen oo3 = e(sample)

local N : di %9.0fc e(N)
local r2 : di %9.2fc e(r2)
outreg using table_firm_regressions.tex, merge varlabels ///
addrows(" ", " " \ "Observations", "`N'" \ "Firm Fixed Effects", "Yes" \ ///
 "Time Effects", "Yes"  \ "R-squared", "`r2'" \ "Sample", "05Q1-19Q4") ///
ctitles(" \$ IK(t+2) \$", "3") ///
se nolegend nocons noautosumm sdec(2) tex star starlevels(5 1 0.1) starloc(1)






// REGRESSION #4

reghdfe F2yy sprisk L1yy cfrate_tr tobinq_tr ///
if tin(2005q1,2019q4), ///
ab(firm i.quarter#i.ffind49) vce(cl firm i.quarter#i.ffind49)

gen oo4 = e(sample)

local N : di %9.0fc e(N)
local r2 : di %9.2fc e(r2)
outreg using table_firm_regressions.tex, merge varlabels ///
addrows(" ", " " \ "Observations", "`N'" \ "Firm Fixed Effects", "Yes" \ ///
 "Time Effects", "Yes"  \ "R-squared", "`r2'" \ "Sample", "05Q1-19Q4") ///
ctitles(" \$ IK(t+2) \$", "4") ///
se nolegend nocons noautosumm sdec(2) tex star starlevels(5 1 0.1) starloc(1) ///
keep(sprisk cfrate_tr tobinq_tr L1yy) 











// Robustness (appendix)

// REGRESSION #5

reghdfe F2yy GPRxEXPON L1yy cfrate_tr tobinq_tr GPRxALL ///
if tin(1985q1,2019q4), ///
ab(firm) vce(cl ffind49 quarter)

gen oo5 = e(sample)


local N : di %9.0fc e(N)
local r2 : di %9.2fc e(r2)
outreg using table_firm_regressions_robust.tex, replace varlabels ///
addrows(" ", " " \ "Observations", "`N'" \ "Firm Fixed Effects", "Yes" \ ///
 "Time Effects", "No"  \ "R-squared", "`r2'" \ "Sample", "85Q1-19Q4" ) ///
ctitles(" \$ IK(t+2) \$", "1") ///
se nolegend nocons noautosumm sdec(2) tex star starlevels(5 1 0.1) starloc(1)





// REGRESSION #6

reghdfe F2yy GPRxEXPON L1yy cfrate_tr tobinq_tr ///
if tin(1985q1,2019q4), ///
ab(firm quarter) vce(cl ffind49 quarter)

gen oo6 = e(sample)

local N : di %9.0fc e(N)
local r2 : di %9.2fc e(r2)
outreg using table_firm_regressions_robust.tex, merge varlabels ///
addrows(" ", " " \ "Observations", "`N'" \ "Firm Fixed Effects", "Yes" \ ///
 "Time Effects", "Yes"  \ "R-squared", "`r2'" \ "Sample", "85Q1-19Q4") ///
ctitles(" \$ IK(t+2) \$", "2") ///
se nolegend nocons noautosumm sdec(2) tex star starlevels(5 1 0.1) starloc(1)



}














