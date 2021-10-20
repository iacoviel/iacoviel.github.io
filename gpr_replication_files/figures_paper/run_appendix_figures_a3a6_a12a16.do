set scheme s1color, permanently

// Set globals to 1 to plot figures

global do_appfigure_a3 = 0  // Comparison with Military Spending: Detail
global do_appfigure_a4 = 0  // Natural Disasters and Sport Events
global do_appfigure_a5 = 0  // GPR Political Slant
global do_appfigure_a6 = 0  // Hijackings, Murders...
global do_appfigure_a12 = 0  // GPR Individual Newspapers
global do_appfigure_a13 = 0  // Search Categories
global do_appfigure_a14 = 0  // Human Index
global do_appfigure_a15 = 0  // GPR Ex econ words
global do_appfigure_a16 = 0  // GPR and Other Proxies


// data_gpr_monthly
// data_gpr_daily_recent
// data_gpr_quarterly
// data_gpr_annual






//--------------------------------------------------
// Figure A.3
//--------------------------------------------------

if $do_appfigure_a3 == 1 {

use data_gpr_quarterly, clear

tsset quarter
gen ngov_gdp = 100*ngov/L.ngdp
gen milnews_gdp = 100*milnews/L.ngdp

format GPRH* %5.0f 


egen sresidgprh = std(RESID_GPRH)
egen sresidgprht = std(RESID_GPRHT)
egen sresidgprha = std(RESID_GPRHA)


label var milnews_gdp "Mil.News (% of GDP), left scale"
label var GPRH "GPR (quarterly), right scale"
label var sresidgprh "GPR Shocks"


twoway ///
(tsline milnews_gdp, lcolor(red) lwidth(.5) ytitle("") ///
ylabel(, labcolor(red) angle(horizontal))) ///
///
(tsline GPRH, lcolor(blue) yaxis(2) lwidth(.3) xtitle("") ///
ytitle("", axis(2)) ///
ylabel(, axis(2) labcolor(blue) angle(horizontal))), ///
legend(ring(0) position(2) rows(2)) ///
///
name(rameyall, replace) graphregion(fcolor(white)) nodraw






twoway ///
(tsline milnews_gdp if tin(1914q1,1919q4), lcolor(red) lwidth(.8) ytitle("") ///
ysc(r(-20 60)) ///
ylabel(, labcolor(red) angle(horizontal))) ///
(tsline sresidgprh if tin(1914q1,1919q4), yaxis(2) lwidth(.55) xtitle("") ///
lcolor(green) ytitle("", axis(2)) title(WWI) ///
ylabel(, axis(2) labcolor(green) angle(horizontal))), ///
ttick(1914q3 1917q2 1918q4) ///
tlabel(1914q3 "1914q3" 1917q2 "1917q2" 1918q4 "1918q4") ///
legend(order(1 "MilNews" 2 "GPR Shock") rows(1) ring(0) position(2) size(*0.75) symysize(0.01)) ///
name(ramey0, replace) graphregion(fcolor(white)) nodraw

twoway (tsline milnews_gdp if tin(1939q1,1945q4), lcolor(red) lwidth(.8) ytitle("") ylabel(, labcolor(red) angle(horizontal))) ///
(tsline sresidgprh if tin(1939q1,1945q4), yaxis(2) lwidth(.55) xtitle("") ///
lcolor(green) ytitle("", axis(2)) title(WWII) ///
ylabel(, axis(2) labcolor(green) angle(horizontal))), ///
ttick(1939q3 1941q4 1944q2) ///
tlabel(1939q3 "1939q3" 1941q4 "1941q4" 1944q2 "1944q2") ///
legend(off) ///
name(ramey1, replace) graphregion(fcolor(white)) nodraw

twoway (tsline milnews_gdp if tin(1950q1,1955q4), lcolor(red) lwidth(.8) ytitle("") ylabel(, labcolor(red) angle(horizontal))) ///
(tsline sresidgprh if tin(1950q1,1955q4), yaxis(2) lwidth(.55) xtitle("") ///
lcolor(green) ytitle("", axis(2)) title(Korean War) ///
ylabel(, axis(2) labcolor(green) angle(horizontal))), ///
ttick(1950q3 1953q1 1955q1) ///
tlabel(1950q3 "1950q3" 1953q1 "1953q1" 1955q1 "1955q1") ///
legend(off) ///
name(ramey2, replace) graphregion(fcolor(white)) nodraw

twoway (tsline milnews_gdp if tin(2001q1,2008q4), lcolor(red) lwidth(.8) ytitle("") ylabel(, labcolor(red) angle(horizontal))) ///
(tsline sresidgprh if tin(2001q1,2008q4), yaxis(2) lwidth(.55) xtitle("") ///
lcolor(green) ytitle("", axis(2)) title(9/11) ///
ylabel(, axis(2) labcolor(green) angle(horizontal))), ///
ttick(2001q3 2003q1 2007q4) ///
tlabel(2001q3 "01q3" 2003q1 "03q1" 2007q4 "2007q4") ///
legend(off) name(ramey3, replace) graphregion(fcolor(white)) nodraw

graph combine ramey0 ramey1 ramey2 ramey3, imargin(0 0 0 0) rows(2) name(ramey4, replace) graphregion(fcolor(white)) nodraw

graph combine rameyall ramey4, rows(2) name(ramey_episodes, replace) graphregion(fcolor(white))
graph export results\ramey_episodes.eps, name(ramey_episodes) replace logo(off) mag(100) 


}








//--------------------------------------------------
// Figure A.4
//--------------------------------------------------


if $do_appfigure_a4 == 1 {


use data_gpr_monthly, replace

keep if tin(1985m1,2019m12)



twoway ///
(line SHARE_GPR yearm, lwidth(.5) ytitle("% of articles") ///
lcolor(blue) ylabel(, angle(horizontal))) ///
(line FREQ_DISASTER yearm, yaxis(1) lwidth(.3) xtitle("") ///
lcolor(red) ytitle("", axis(1)) title("Natural Disasters") ylabel(, axis(1) angle(horizontal))), ///
xsc(r(1985 2020)) xlabel(1985(5)2020) ///
ysc(r(0 32)) ylabel(0(5)30) ///
text(15.5 2012 "Hurricane", justification(left) color(black) size(2.5)) ///
text(14.2 2012 "Sandy", justification(left) color(black) size(2.5)) ///
text(31.7 2006 "Hurricane", justification(left) color(black) size(2.5)) ///
text(30.2 2006 "Katrina", justification(left) color(black) size(2.5)) ///
text(12.0 1989 "Loma Prieta", justification(left) color(black) size(2.5)) ///
text(10.5 1989 "Earthquake", justification(left) color(black) size(2.5)) ///
text(15.8 2017 "California Wildfires", justification(left) color(black) size(2.5)) ///
legend(order(1 "GPR Share" 2 "News on Natural Disasters") rows(2) symysize(0.01) ring(0) position(10) size(*0.8)) ///
name(z1, replace) graphregion(fcolor(white)) 




twoway ///
(line SHARE_GPR yearm, lwidth(.5) ytitle("% of articles") ///
lcolor(blue) ylabel(, angle(horizontal))) ///
(line FREQ_SPORT yearm, yaxis(1) lwidth(.3) xtitle("") ///
lcolor(red) ytitle("", axis(1)) title("Sport") ylabel(, axis(1) angle(horizontal))), ///
xsc(r(1985 2020)) xlabel(1985(5)2020) ///
ysc(r(0 25)) ylabel(0(5)25) ///
legend(order(1 "GPR Share" 2 "News on Sport Events") rows(2) symysize(0.01) ring(0) position(2) size(*0.8)) ///
name(z3, replace) graphregion(fcolor(white)) 



graph combine z1 z3, name(MEDIA, replace) rows(3)
graph export results\gpr_ndi.eps, name(MEDIA) replace logo(off) mag(100) 


}





//--------------------------------------------------
// Figure A.5 and A.12
//--------------------------------------------------

if $do_appfigure_a5 == 1 | $do_appfigure_a12 == 1 {

use data_gpr_monthly, replace
keep if tin(1985m1,2019m12)

// Keep raw GPR hits, newspaper counts, ratios for each newspapers
keep GPR_CT_RAW-RATIO_WP 

gen month = ym(1985, 1) + _n - 1

gen t = _n
gen yearm = 1985 + (t-1)/12

egen SUM_GPR = rowtotal(GPR_*)
egen SUM_N = rowtotal(N*)
gen  SHARE_GPR = 100*SUM_GPR/SUM_N

rename RATIO_* *

foreach var of varlist CT-WP {
  sum `var'
  generate GPRINDEX_`var' = `var' / r(mean)*100
  replace `var' = `var'*100
}

tsset month
format month %tm

// Cronbach
alpha GPRINDEX_*

pca GPRINDEX_*

predict pc1 pc2, score

gen GPR_NONUS = 100* ///
(GPR_DT_RAW+GPR_FT_RAW+GPR_GM_RAW+GPR_GU_RAW)/ ///
(N_DT_RAW+N_FT_RAW+N_GM_RAW+N_GU_RAW)

gen GPR_US = 100* /// 
(GPR_CT_RAW+GPR_LA_RAW+GPR_NY_RAW+GPR_US_RAW+GPR_WS_RAW+GPR_WP_RAW)/ ///
(N_CT_RAW+N_LA_RAW+N_NY_RAW+N_US_RAW+N_WS_RAW+N_WP_RAW)

gen GPR_LEFT = 100* ///
(GPR_GM_RAW+GPR_GU_RAW+GPR_LA_RAW+GPR_NY_RAW+GPR_WP_RAW)/ ///
(N_GM_RAW+N_GU_RAW+N_LA_RAW+N_NY_RAW+N_WP_RAW)

gen GPR_RIGHT = 100* ///
(GPR_DT_RAW+GPR_CT_RAW+GPR_FT_RAW+GPR_WS_RAW+GPR_US_RAW)/ ///
(N_DT_RAW+N_CT_RAW+N_FT_RAW+N_WS_RAW+N_US_RAW)

pwcorr GPR_NONUS GPR_US
pwcorr GPR_LEFT GPR_RIGHT




// Drop from the chart observations where there are few newspapers in a month
foreach var of varlist CT-WP {
  replace `var' = . if N_`var'_RAW < 100
}





if $do_appfigure_a5 == 1 {

twoway ///
///
(line  GPR_LEFT yearm, lcolor(black) lwidth(.5) ///
title("Left vs Right") ///
xsc(r(1985 2020)) xlabel(1985(5)2020) ytitle("% of GPR Articles") xtitle("")) ///
///
(line GPR_RIGHT yearm, lcolor(red) lwidth(.3) ///
ylabel(, angle(horizontal) format(%5.0f))),  ///
legend(order(1 "GPR Left" 2 "GPR Right") symysize(0.01) rows(2) ring(0) position(2) size(*0.7)) ///
name(GPRIND6, replace) graphregion(fcolor(white)) 

graph export results\political_slant.eps, name(GPRIND6) replace logo(off) mag(100) 


}


if $do_appfigure_a12 == 1 {

twoway ///
///
(line  SHARE_GPR yearm, lcolor(blue) lwidth(.5) ///
title("Historical") ///
xsc(r(1985 2020)) xlabel(1985(5)2020) ytitle("% of GPR Articles") xtitle("")) ///
///
(line NY CT WP yearm, lcolor(black red green) lwidth(.3) ///
ylabel(, angle(horizontal) format(%5.0f))),  ///
legend(order(1 "GPR" 2 "NYT" 3 "CT" 4 "WP") rows(4) symysize(0.01) ring(0) position(2) size(*0.6)) ///
name(GPRIND1, replace) graphregion(fcolor(white)) nodraw



twoway ///
///
(line  SHARE_GPR yearm, lcolor(blue) lwidth(.5) ///
title("Business") ///
xsc(r(1985 2020)) xlabel(1985(5)2020) ytitle("% of GPR Articles") xtitle("")) ///
///
(line WS FT yearm, lcolor(black red) lwidth(.3) ///
ylabel(, angle(horizontal) format(%5.0f))),  ///
legend(order(1 "GPR" 2 "WSJ" 3 "FT") rows(3) symysize(0.01) ring(0) position(2) size(*0.7)) ///
name(GPRIND2, replace) graphregion(fcolor(white)) nodraw



twoway ///
///
(line  SHARE_GPR yearm, lcolor(blue) lwidth(.5) ///
title("Other U.S. General Interest") ///
xsc(r(1985 2020)) xlabel(1985(5)2020) ytitle("% of GPR Articles") xtitle("")) ///
///
(line LA US yearm, lcolor(black red) lwidth(.3) ///
ylabel(, angle(horizontal) format(%5.0f))),  ///
legend(order(1 "GPR" 2 "LA" 3 "USA") rows(3) symysize(0.01) ring(0) position(2) size(*0.7)) ///
name(GPRIND3, replace) graphregion(fcolor(white)) nodraw



twoway ///
///
(line  SHARE_GPR yearm, lcolor(blue) lwidth(.5) ///
title("Foreign General Interest") ///
xsc(r(1985 2020)) xlabel(1985(5)2020) ytitle("% of GPR Articles") xtitle("")) ///
///
(line DT GU GM yearm, lcolor(black red green) lwidth(.3) ///
ylabel(, angle(horizontal) format(%5.0f))),  ///
legend(order(1 "GPR" 2 "DT" 3 "GU" 4 "GM") rows(4) symysize(0.01)  ring(0) position(2) size(*0.7)) ///
name(GPRIND4, replace) graphregion(fcolor(white)) nodraw



twoway ///
///
(line  GPR_US yearm, lcolor(black) lwidth(.5) ///
title("U.S. vs non U.S.") ///
xsc(r(1985 2020)) xlabel(1985(5)2020) ytitle("% of GPR Articles") xtitle("")) ///
///
(line GPR_NONUS yearm, lcolor(red) lwidth(.3) ///
ylabel(, angle(horizontal) format(%5.0f))),  ///
legend(order(1 "GPR US" 2 "GPR non-US") symysize(0.01) rows(2) ring(0) position(2) size(*0.7)) ///
name(GPRIND5, replace) graphregion(fcolor(white)) nodraw




graph combine GPRIND1 GPRIND2 GPRIND3 GPRIND4 GPRIND5, name(GPR_INDPAPERS, replace) rows(3)
graph export results\gpr_indpapers_all.eps, name(GPR_INDPAPERS) replace logo(off) mag(100) 

}








}






//--------------------------------------------------
// Figure A.6
//--------------------------------------------------

if $do_appfigure_a6 == 1 {


use data_gpr_monthly, replace
collapse (sum) HIJACK_RAW WASKILLED_RAW RISK_NUKEWAR_C* N3H, by(year)

merge 1:1 year using data_gpr_annual.dta, nogenerate


pca hijackings fatalitieshijacking
predict pc_hijackings1 pc_hijackings2, score

gen murder_rate = murderrate_ucla if year<1960
replace murder_rate = murderrate_disastercenter if year>=1960



tsset year

quietly tssmooth ma HIJACK_MA3 = HIJACK_RAW, window(2 1 0)
quietly tssmooth ma pc_hijackings1_MA3 = pc_hijackings1, window(2 1 0)

quietly tssmooth ma WASKILLED_MA3 = WASKILLED_RAW, window(2 1 0)
quietly tssmooth ma murder_rate_MA3 = murder_rate, window(2 1 0)



twoway ///
(line  HIJACK_MA3 year if year>=1950, xlabel(1950(10)2020) yaxis(1) ///
ylabel(, angle(horizontal) format(%5.0f) labcolor(red)) ///
lcolor(red) ytitle("")  lwidth(.50))  ///
///
(line  pc_hijackings1_MA3 year if year>=1950, yaxis(2) lcolor(blue) lwidth(.30) xtitle("") ///
ytitle("", axis(2)) ///
ylabel(, angle(horizontal) format(%5.1f) axis(2) labcolor(blue))  ///
legend(size(*0.8) order(1 "Hijacks in Newspapers (Left)" 2 "Hijack Index (Right)"))),  ///
name(HH1, replace) graphregion(fcolor(white)) nodraw





twoway ///
(line  WASKILLED_MA3 year if year>=1900, xlabel(1900(20)2020) yaxis(1) ///
lcolor(red) ytitle("") ///
ylabel(, angle(horizontal) format(%5.0f) labcolor(red)) lwidth(.50))  ///
///
(line  murder_rate_MA3 year if year>=1900, yaxis(2) lcolor(blue) lwidth(.30) xtitle("") ///
ylabel(, angle(horizontal) format(%5.1f) axis(2) labcolor(blue)) ///
ytitle("", axis(2)) ///
legend(size(*0.8) order(1 "Murder in Newspapers (Left)" 2 "Murder Rate (Right)"))),  ///
name(HH2, replace) graphregion(fcolor(white)) nodraw



//RISK_NUKEWAR_C8 = '''AND ("nuclear test") AND (''' + risk_words + ''') '''
gen SHR_NRISK_TEST = RISK_NUKEWAR_C8_RAW / N3H * 100

twoway ///
(line  SHR_NRISK_TEST year if year>=1940 , xlabel(1940(10)2020) yaxis(1) lcolor(red) ///
ytitle("") ylabel(, angle(horizontal) format(%5.1f) labcolor(red)) lwidth(.50) )  ///
///
(line  nuketest year if year>=1940, yaxis(2) lcolor(blue) lwidth(.30) xtitle("") ///
ylabel(, angle(horizontal) format(%5.0f) axis(2) labcolor(blue)) ytitle("", axis(2)) ///
legend(size(*0.8) order(1 "GPR `Nuclear Test' (Left)" 2 "Nuclear Tests (Right)"))),  ///
name(HH3, replace) graphregion(fcolor(white)) nodraw



graph combine HH1 HH2 HH3 , name(HCOMB, replace) rows(3) graphregion(fcolor(white)) 
graph display, ysize(3) xsize(2.5) 
graph export results\hij_mur_nuc.eps,  name(HCOMB) replace logo(off) mag(100) 



}













//--------------------------------------------------
// Figure A.13: Search categories
//--------------------------------------------------

if $do_appfigure_a13 == 1 {



use data_gpr_monthly, replace

label var MCOMP_1 "WAR_T"
label var MCOMP_2 "PEA_T"
label var MCOMP_3 "MIL_T"
label var MCOMP_4 "NUK_T"
label var MCOMP_5 "TER_T"
label var MCOMP_6 "WAR_A"
label var MCOMP_7 "ACT_A"
label var MCOMP_8 "TER_A"


twoway ///
(line  MCOMP_1_MA12 MCOMP_3_MA12 yearm, ///
lcolor(red maroon) ///
xsc(r(1900 2020)) xlabel(1900(20)2020) ///
ysc(r(0 2.6)) ///
lwidth(0.7 0.5) xtitle("") ///
ylabel(, angle(horizontal) format(%5.1f))  ///
ytitle(Articles Share) ///
legend(order(1 "War Threats" 2 "Military Buildup") rows(2) ring(0) position(2) symysize(0.1) size(*0.6))), ///
name(BLOCK1, replace) graphregion(fcolor(white)) 

twoway ///
(line   MCOMP_2_MA12 MCOMP_4_MA12 yearm, ///
lcolor(red maroon) ///
xsc(r(1900 2020)) xlabel(1900(20)2020) ///
ysc(r(0 1.5)) ///
lwidth(0.7 0.5) xtitle("") ///
ylabel(, angle(horizontal) format(%5.1f))  ///
ytitle(Articles Share) ///
legend(order(1 "Peace Threats" 2 "Nuclear Threats") rows(2) ring(0) position(10) symysize(0.1) size(*0.6))), ///
name(BLOCK2, replace) graphregion(fcolor(white)) 

twoway ///
(line   MCOMP_6_MA12 MCOMP_7_MA12 yearm, ///
lcolor(navy teal) ///
xsc(r(1900 2020)) xlabel(1900(20)2020) ///
lwidth(0.7 0.5) xtitle("") ///
ylabel(, angle(horizontal) format(%5.1f))  ///
ytitle(Articles Share) ///
legend(order(1 "Begin War" 2 "Escalation War") rows(2) ring(0) position(2) symysize(0.1) size(*0.8))), ///
ysc(r(0 7.7)) ///
name(BLOCK3, replace) graphregion(fcolor(white)) 

twoway ///
(line   MCOMP_5_MA12 MCOMP_8_MA12 yearm, ///
lcolor(red navy) ///
xsc(r(1900 2020)) xlabel(1900(20)2020) ///
lwidth(0.7 0.5) xtitle("") ///
ylabel(, angle(horizontal) format(%5.1f))  ///
ytitle(Articles Share) ///
legend(order(1 "Terror Threats" 2 "Terror Acts") rows(2) ring(0) position(11) symysize(0.1) size(*0.8))), ///
ysc(r(0 4.0)) ///
name(BLOCK4, replace) graphregion(fcolor(white)) 



graph combine BLOCK1 BLOCK2 BLOCK3 BLOCK4, rows(2) name(MCOMP, replace) graphregion(fcolor(white))


graph export results\gpr_share_categories.eps, name(MCOMP) replace logo(off) mag(100) 

}













//--------------------------------------------------
// Figure A.14: Human Index
//--------------------------------------------------

if $do_appfigure_a14 == 1 {

use data_gpr_monthly, replace

egen GPHCOUNT1 = rowmean(GPHCOUNT_1_ANDREW  GPHCOUNT_1_JOSHUA)
gen SHARE_HUMAN = 100*(GPHCOUNT1/GPHCOUNT)*(GPH_RAW/N3H)
sum SHARE_HUMAN 
gen GPRH_HUMAN = SHARE_HUMAN/r(mean)*100


gen quarter = qofd(dofm(month))
format %tq quarter

collapse GPRH GPRH_HUMAN , by(year)

pwcorr GPRH GPRH_HUMAN 

tsset year

twoway ///
///
(tsline  GPRH, lcolor(blue) lwidth(.4) ///
title("") ///
xsc(r(1900 2020)) xlabel(1900(20)2020) ytitle("") xtitle("")) ///
///
(tsline GPRH_HUMAN, lcolor(dkgreen) lwidth(.25) ///
ylabel(, angle(horizontal) format(%5.0f))),  ///
legend(order(1 "GPR" 2 "Human GPR Index") symysize(0.01) rows(2) ring(0) position(2) size(*0.7)) ///
name(GPRGPRHUMAN, replace) graphregion(fcolor(white)) 

graph export results\gprh_human.eps, name(GPRGPRHUMAN) replace logo(off) mag(100) 

}







//--------------------------------------------------
// Figure A.15: GPR excluding econ
//--------------------------------------------------

if $do_appfigure_a15 == 1 {



use data_gpr_monthly, replace
keep if tin(1985m1,2020m12)

gen SHARE_GPR_NOECON = GPR_NOECON_RAW/N10
sum SHARE_GPR_NOECON if tin(1985m1,2019m12)
gen GPR_NOECON = SHARE_GPR_NOECON / r(mean)*100



twoway ///
(line GPR_NOECON yearm,  ///
xsc(r(1985 2021)) xlabel(1985(5)2020) ///
ysc(log) ///
xtitle("") ///
lcolor(red) lwidth(.4)) ///
///
(line  GPR yearm, lcolor(blue) lwidth(.2) ///
ylabel(50 100 200 400 600, angle(horizontal) format(%5.0f))  ///
legend(order(1 "GPR Excluding Econ-Related Terms" 2 "GPR") rows(2) ring(0) position(2) size(*0.7))),  ///
name(NOECON, replace) graphregion(fcolor(white)) 





graph export results\gpr_noecon.eps, name(NOECON) replace logo(off) mag(100) 


pwcorr GPR_NOECON GPR

}








//--------------------------------------------------
// Figure A.16: GPR and proxies
//--------------------------------------------------

if $do_appfigure_a16 == 1 {


use data_gpr_monthly, replace
collapse ICBCrisisCount GPRH, by(year)

twoway ///
(line  GPRH year,  yaxis(1) ///
ylabel(100 200 300 400, angle(horizontal) format(%5.0f) labcolor(blue)) ///
ysc(r(0 490)) ///
xlabel(1900(20)2020) ///
lcolor(blue) ytitle("") lwidth(.50))  ///
///
(line  ICBCrisisCount year, yaxis(2) lcolor(red) lwidth(.30) xtitle("") ///
ytitle("", axis(2)) ///
ylabel(, angle(horizontal) format(%5.0f) axis(2) labcolor(red))  ///
legend(ring(0) rows(1) position(1) size(*0.6) symysize(0.1) order(1 "GPR Historical (Left)" 2 "ICB Crisis Count (Right)"))),  ///
name(ICB, replace) graphregion(fcolor(white)) 



use data_gpr_monthly, replace
gen MUS_ECR_ICRG = -US_ECR_ICRG


twoway ///
(line  GPR month if tin(1985m1,2019m12),  yaxis(1) ///
ylabel(, angle(horizontal) format(%5.0f) labcolor(blue)) ///
lcolor(blue) ytitle("") lwidth(.50))  ///
///
(line  SEPUCSUSECON month if tin(1985m1,2019m12), yaxis(2) lcolor(red) lwidth(.30) xtitle("") ///
ytitle("", axis(2)) ///
ylabel(, angle(horizontal) format(%5.0f) axis(2) labcolor(red))  ///
legend(ring(0) rows(2) position(2) size(*0.6) symysize(0.1) order(1 "GPR Recent (Left)" 2 "EPU National Security (Right)"))),  ///
name(EPUNATSEC, replace) graphregion(fcolor(white)) 



twoway ///
(line  GPR month if tin(1985m1,2019m12),  yaxis(1) ///
ysc(r(0 550)) ///
ylabel(, angle(horizontal) format(%5.0f) labcolor(blue)) ///
lcolor(blue) ytitle("") lwidth(.50))  ///
///
(line MUS_ECR_ICRG month if tin(1985m1,2019m12), yaxis(2) lcolor(red) lwidth(.30) xtitle("") ///
ytitle("", axis(2)) ///
ylabel(-12 "12" -10 "10" -8 "8" -6 "6" -4 "4", angle(horizontal) format(%5.0f) axis(2) labcolor(red))  ///
legend(ring(0) rows(2) position(10) size(*0.6) symysize(0.1) order(1 "GPR Recent (Left)" 2 "ICRG Conflict Rating (Right)"))),  ///
name(ICRG, replace) graphregion(fcolor(white)) 

graph combine ICB EPUNATSEC ICRG, name(OP, replace) rows(3) 

graph display, ysize(3) xsize(2.5) 

graph export results\otherproxies.eps,  name(OP) replace logo(off) mag(100) 









}