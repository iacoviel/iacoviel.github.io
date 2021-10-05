//set scheme lean2
set scheme s1color, permanently

cd U:\tf\GPR\GPRAER_series

global do_figure1 = 1  // Recent GPR
global do_figure2 = 1  // Daily GPR
global do_figure3 = 1  // Historical GPR
global do_figure4 = 1  // Historical ACTS THRETS
global do_figure5 = 1  // Narrative 
global do_figure6 = 1
global do_figure7 = 1
global do_figure8 = 1

// data_for_charts_in_paper
// gpr_daily_recent
// data_gpr_quarterly
// data_gpr_annual

//-------------------------
// Figure 1: Plot of recent GPR
//-------------------------

if $do_figure1 == 1 {

use data_for_charts_in_paper, replace
global t2="2020m12"

keep if tin(1985m1,2020m12)

gen eventplot = " "
replace eventplot = event if GSPIKE~=.
list GPR month eventplot if GSPIKE~=.

replace eventplot = "US Bombing Libya" if tin(1986m4,1986m4)
replace eventplot = "Iraq Airstrikes" if tin(1993m1,1993m1)
replace eventplot = "Bosnian War" if tin(1999m4,1999m4)
replace eventplot = "London Bombings" if tin(2005m7,2005m7)
replace eventplot = " " if tin(2015m12,2015m12)
replace eventplot = "September 11" if tin(2001m10,2001m10)
replace eventplot = " " if tin(2001m9,2001m9)
replace eventplot = "Iran" if tin(2020m1,2020m1)

list month eventplot if eventplot~=" "

twoway ///
///
(line  GPR yearm, lcolor(blue) lwidth(.4) ///
yscale(log) ///
ylabel(50 100 200 400 600, angle(horizontal) format(%5.0f) labcolor(blue)) ///
text(170 1986.4 "US Bombing", justification(left) color(black) size(1.9)) ///
text(160 1986.4 "Libya", justification(left) color(black) size(1.9)) ///
///
text(295 1989.8 "Iraq", justification(left) color(black) size(1.9)) ///
text(278 1989.8 "Invades", justification(left) color(black) size(1.9)) ///
text(263 1989.8 "Kuwait", justification(left) color(black) size(1.9)) ///
///
text(400 1991.0 "Gulf War", justification(left) color(black) size(1.9)) ///
///
text(145 1993.0 "Airstrikes", justification(left) color(black) size(1.9)) ///
text(135 1993.0 "on Iraq", justification(left) color(black) size(1.9)) ///
///
text(122 1999.3 "Bosnian", justification(left) color(black) size(1.9)) ///
text(113 1999.3 "War", justification(left) color(black) size(1.9)) ///
///
text(545 2001.9 "September 11", justification(left) color(black) size(2)) ///
///
text(385 2003.3 "Iraq War", justification(left) color(black) size(2)) ///
///
text(190 2005.5 "London", justification(left) color(black) size(1.9)) ///
text(178 2005.5 "Bombings", justification(left) color(black) size(1.9)) ///
///
text(155 2011.0 "Interv.", justification(left) color(black) size(1.9)) ///
text(145 2011.0 "Libya", justification(left) color(black) size(1.9)) ///
///
text(146 2013.2 "Russia", justification(left) color(black) size(1.9)) ///
text(137 2013.2 "Annexes", justification(left) color(black) size(1.9)) ///
text(128 2013.2 "Crimea", justification(left) color(black) size(1.9)) ///
///
text(170 2015.7 "Paris", justification(left) color(black) size(1.9)) ///
text(160 2015.7 "Attacks", justification(left) color(black) size(1.9)) ///
///
text(164 2018.1 "US", justification(left) color(black) size(1.9)) ///
text(155 2018.1 "N.Korea", justification(left) color(black) size(1.9)) ///
text(146 2018.1 "Tensions", justification(left) color(black) size(1.9)) ///
///
text(154 2020.6 "US-Iran", justification(left) color(black) size(1.9)) ///
text(145 2020.6 "Tensions", justification(left) color(black) size(1.9)) ///
xsc(r(1985 2021)) xlabel(1985(5)2021) ytitle("") ///
) ///
///
(scatter GPR yearm if eventplot~=" ", c() cmissing(n) ///
ylabel(, angle(horizontal) format(%5.0f))  ///
mcolor(blue) mlabsize(small) msize(.5) xtitle("")),  ///
legend(off) ///
name(GPR85LOG, replace) graphregion(fcolor(white)) 


graph export results\gpr_1985.eps, name(GPR85LOG) replace logo(off) mag(100) 




}




//--------------------------
// Figure 2: 
// TO FIX: Original with all labels is done with Matlab
//--------------------------

if $do_figure2 == 1 {


use gpr_daily_recent, clear


tsset date
sum GPR if tin(1jan1985,31dec2019)
replace GPR = GPR/r(mean)*100

gen day = day(date)
gen month = month(date)
gen year = year(date)
egen GPR_M = mean(GPR), by(month year)

quietly tssmooth ma GPR_MA30 = GPR, window(29 1 0)

global d1="1jan1985"
global d2="31dec2020"


twoway ///
(scatter GPR date if tin($d1,$d2), msize(0.2) xtitle("") title(Daily GPR) ///
ylabel(, angle(horizontal) format(%5.0f)) ///
xlabel(, labsize(3) angle(horizontal) format(%tdd.m.y))) ///
(tsline GPR_M if day==15, lcolor(blue) lwidth(.5) legend(off)) ///
, ///
graphregion(fcolor(white)) nodraw name(A1, replace)



graph combine A1, graphregion(fcolor(white)) rows(1) name(gpr_daily, replace)


graph export results\gpr_daily.eps, name(gpr_daily) replace logo(off) mag(100) 


}






//-------------------------
// Figure 3: Plot of historical GPR
//-------------------------

if $do_figure3 == 1 {

use data_for_charts_in_paper, replace

gen eventshort = " "
quietly replace eventshort = "WWI Begins" if tin(1914m8,1914m8)
quietly replace eventshort = "WWII Begins" if month==tm(1939m9)
quietly replace eventshort = "D-Day" if month==tm(1944m6)
quietly replace eventshort = "Korean War" if month==tm(1950m7)
quietly replace eventshort = "Suez Crisis" if month==tm(1956m11)
quietly replace eventshort = "Cuban Crisis" if month==tm(1962m10)
quietly replace eventshort = "Falklands" if month==tm(1982m4)
quietly replace eventshort = "Gulf War" if month==tm(1991m1)
quietly replace eventshort = "September 11" if month==tm(2001m10)
quietly replace eventshort = "Paris Attacks" if month==tm(2015m12)

quietly replace eventshort = "  " if month==tm(1904m2)
quietly replace eventshort = "  " if tin(1918m7,1918m7)
quietly replace eventshort = "  " if tin(1900m7,1900m7)
quietly replace eventshort = "  " if tin(1923m1,1923m1)
quietly replace eventshort = "  " if month==tm(1932m2)
quietly replace eventshort = "  " if month==tm(1935m10)
quietly replace eventshort = "  " if month==tm(1938m9)
quietly replace eventshort = "  " if month==tm(1941m12)
quietly replace eventshort = "  " if month==tm(1950m7)
quietly replace eventshort = "  " if month==tm(1967m6)
quietly replace eventshort = "  " if month==tm(1973m10)
quietly replace eventshort = "  " if month==tm(1980m1)
quietly replace eventshort = "  " if month==tm(1961m9)
quietly replace eventshort = "  " if month==tm(1999m4)
quietly replace eventshort = "  " if tin(1990m8,1990m8)
quietly replace eventshort = "  " if tin(2003m3,2003m3)




twoway ///
///
(line  GPRH yearm if tin(1900m1,2020m12), lcolor(blue) lwidth(.3) ///
xsc(r(1900 2021)) xlabel(1900(20)2021) ytitle("") ///
///
text(125 1900.7 "Boxer", justification(left) color(black) size(1.3)) ///
text(115 1900.7 "Rebellion", justification(left) color(black) size(1.3)) ///
///
text(160 1904.1 "Russo-Japan,", justification(left) color(black) size(1.35)) ///
text(150 1904.1 "War", justification(left) color(black) size(1.35)) ///
///
text(426 1918.6 "WWI", justification(left) color(black) size(1.5)) ///
text(416 1918.6 "Escalation", justification(left) color(black) size(1.5)) ///
///
text(103 1925.8 "Occupation", justification(left) color(black) size(1.7)) ///
text( 93 1925.8 "of Ruhr", justification(left) color(black) size(1.7)) ///
///
text(133 1932.0 "Shanghai", justification(left) color(black) size(1.7)) ///
text(123 1932.0 "Incident", justification(left) color(black) size(1.7)) ///
///
text(200 1932.0 "Italy War", justification(left) color(black) size(1.65)) ///
text(190 1932.0 "Ethiopia", justification(left) color(black) size(1.65)) ///
///
text(240 1936.0 "Germany", justification(left) color(black) size(1.55)) ///
text(230 1936.0 "Invades", justification(left) color(black) size(1.55)) ///
text(220 1936.0 "Czechia", justification(left) color(black) size(1.55)) ///
///
text(465 1942.0 "Pearl", justification(left) color(black) size(1.4)) ///
text(455 1942.0 "Harbor", justification(left) color(black) size(1.4)) ///
///
text(260 1950.5 "Korean", justification(left) color(black) size(1.7)) ///
text(250 1950.5 "War", justification(left) color(black) size(1.7)) ///
///
text(205 1959.5 "Berlin", justification(left) color(black) size(1.6)) ///
text(195 1959.5 "Problem", justification(left) color(black) size(1.6)) ///
///
text(203 1967.5 "Six Day", justification(left) color(black) size(1.7)) ///
text(193 1967.5 "War", justification(left) color(black) size(1.7)) ///
///
text(190 1973.9 "Yom", justification(left) color(black) size(1.7)) ///
text(180 1973.9 "Kippur", justification(left) color(black) size(1.7)) ///
text(170 1973.9 "War", justification(left) color(black) size(1.7)) ///
///
text(170 1979.0 "Afghan", justification(left) color(black) size(1.5)) ///
text(160 1979.0 "Invasion", justification(left) color(black) size(1.5)) ///
///
text(210 1987.5 "Iraq", justification(left) color(black) size(1.7)) ///
text(200 1987.5 "Invades", justification(left) color(black) size(1.7)) ///
text(190 1987.5 "Kuwait", justification(left) color(black) size(1.7)) ///
///
text(105 1998.6 "Bosnian", justification(left) color(black) size(1.7)) ///
text( 95 1998.6 "War", justification(left) color(black) size(1.7)) ///
///
text(263 2003.8 "Iraq", justification(left) color(black) size(1.7)) ///
text(253 2003.8 "War", justification(left) color(black) size(1.7)) ///
) ///
(scatter GPRH yearm if eventshort~=" ", c() cmissing(n) mlabel(eventshort) mlabangle(0) ///
ylabel(, angle(horizontal) format(%5.0f))  ///
mlabpos(12) mcolor(blue) mlabcolor(black) mlabsize(*.6) msize(.5) xtitle("")),  ///
legend(off) ///
name(GPRH1900, replace) graphregion(fcolor(white)) 


graph export results\gprh_1900.eps, name(GPRH1900) replace logo(off) mag(100) 

}






//---------------------------------
// Figure 4 : Plots of historical acts and threats
//------------------------------------------



if $do_figure4 == 1 {

use data_for_charts_in_paper, replace

format GPRH* %5.0f

twoway ///
(line GPRHT yearm if tin(1900m1,2020m12), lwidth(.3) ytitle("") ///
lcolor(red) ylabel(, angle(horizontal))) ///
(line GPRHA yearm if tin(1900m1,2020m12), yaxis(1) lwidth(.2) xtitle("") ///
lcolor(gs3) ytitle("", axis(1)) title("Full Sample", size(3)) ///
ylabel(,  axis(1) angle(horizontal))), ///
xsc(r(1900 2021)) ///
xlabel(1900(20)2021, labsize(3)) ///
ysc(r(0 700)) ///
ylabel(0(100)700, labsize(3)) ///
legend(order(1 "GPR Threats" 2 "GPR Acts") rows(1) ring(0) position(2) size(*0.8)) ///
name(z0, replace) graphregion(fcolor(white)) nodraw


twoway ///
(line GPRHT yearm if tin(1913m1,1918m12), lwidth(.5) ytitle("") ///
lcolor(red) ylabel(, angle(horizontal))) ///
(line GPRHA yearm if tin(1913m1,1918m12), yaxis(1) lwidth(.3) xtitle("") ///
lcolor(gs3) ytitle("", axis(1)) title("World War I") ylabel(, axis(1) angle(horizontal))), ///
xsc(r(1913 1919)) xlabel(1913(2)1919) ///
ysc(r(0 650)) ylabel(0(200)600) ///
text(225 1913.7 "Occupation", justification(left) color(black) size(2.5)) ///
text(180 1913.7 "Vera Cruz", justification(left) color(black) size(2.5)) ///
text(590 1914.7 "WWI begins", justification(left) color(black) size(2.5)) ///
text(480 1917.1 "US Enters War", justification(left) color(black) size(2.5)) ///
legend(off) ///
name(z1, replace) graphregion(fcolor(white)) nodraw



twoway ///
(line GPRHT yearm if tin(1938m1,1945m12), lwidth(.5) ytitle("") ///
lcolor(red) ylabel(, angle(horizontal))) ///
(line GPRHA yearm if tin(1938m1,1945m12), yaxis(1) lwidth(.3) xtitle("") ///
lcolor(gs3) ytitle("", axis(1)) title("World War II") ///
ylabel(, axis(1) angle(horizontal))), ///
xsc(r(1938 1945)) xlabel(1938(2)1945) ///
ysc(r(0 800)) ylabel(0(200)800) ///
text(435 1938.5 "Germany", justification(left) color(black) size(2.5)) ///
text(390 1938.5 "Invades", justification(left) color(black) size(2.5)) ///
text(340 1938.5 "Czechia", justification(left) color(black) size(2.5)) ///
text(590 1939.7 "WWII begins", justification(left) color(black) size(2.5)) ///
text(690 1941.9 "Pearl Harbor", justification(left) color(black) size(2.5)) ///
text(770 1944.4 "D-Day", justification(left) color(black) size(2.5)) ///
legend(off) ///
name(z2, replace) graphregion(fcolor(white)) nodraw

twoway ///
(line GPRHT yearm if tin(1961m1,1963m12), lwidth(.5) ytitle("") ///
lcolor(red) ylabel(, angle(horizontal))) ///
(line GPRHA yearm if tin(1961m1,1963m12), yaxis(1) lwidth(.3) xtitle("") ///
lcolor(gs3) ytitle("", axis(1)) title("Early 1960s") ylabel(, axis(1) angle(horizontal))), ///
xsc(r(1961 1964)) xlabel(1961(1)1964) ///
ysc(r(0 400)) ylabel(0(100)400) ///
text(320 1961.7 "Berlin Problem", justification(left) color(black) size(2.5)) ///
text(390 1962.8 "Cuban Crisis", justification(left) color(black) size(2.5)) ///
legend(off) ///
name(z3, replace) graphregion(fcolor(white)) nodraw

twoway ///
(line GPRHT yearm if tin(1989m1,1991m12), lwidth(.5) ytitle("") ///
lcolor(red) ylabel(, angle(horizontal))) ///
(line GPRHA yearm if tin(1989m1,1991m12), yaxis(1) lwidth(.3) xtitle("") ///
lcolor(gs3) ytitle("", axis(1)) title("Gulf War") ylabel(, axis(1) angle(horizontal))), ///
xsc(r(1989 1992)) xlabel(1989(1)1992) ///
ysc(r(0 350)) ylabel(0(100)350) ///
text(330 1990.3 "Kuwait Invasion", justification(left) color(black) size(2.5)) ///
text(315 1991.2 "Gulf War", justification(left) color(black) size(2.5)) ///
legend(off) ///
name(z4, replace) graphregion(fcolor(white)) nodraw



twoway ///
(line GPRHT yearm if tin(2001m1,2003m12), lwidth(.5) ytitle("") ///
lcolor(red) ylabel(, angle(horizontal))) ///
(line GPRHA yearm if tin(2001m1,2003m12), yaxis(1) lwidth(.3) xtitle("") ///
lcolor(gs3) ytitle("", axis(1)) title("9/11 and Iraq War") ylabel(, axis(1) angle(horizontal))), ///
xsc(r(2001 2004)) xlabel(2001(1)2004) ///
ysc(r(0 500)) ylabel(0(100)500) ///
text(490 2001.8 "9/11", justification(left) color(black) size(2.5)) ///
text(315 2003.5 "Iraq War", justification(left) color(black) size(2.5)) ///
legend(off) ///
name(z5, replace) graphregion(fcolor(white)) nodraw

twoway ///
(line GPRHT yearm if tin(2016m1,2020m12), lwidth(.5) ytitle("") ///
lcolor(red) ylabel(, angle(horizontal))) ///
(line GPRHA yearm if tin(2016m1,2020m12), yaxis(1) lwidth(.3) xtitle("") ///
lcolor(gs3) ytitle("", axis(1)) title("2016-2020") ylabel(, axis(1) angle(horizontal))), ///
xsc(r(2016 2021)) xlabel(2016(1)2020) ///
ysc(r(0 180)) ylabel(0(50)180) ///
text(155 2017.5 "US-North Korea", justification(left) color(black) size(2.5)) ///
text(175 2020 "US-Iran", justification(left) color(black) size(2.5)) ///
legend(off) ///
name(z6, replace) graphregion(fcolor(white)) nodraw





graph combine z0, rows(1) fysize(65) name(z0rx, replace) 
graph combine z1 z2 z3 z1 z2 z3, rows(2) fysize(80) name(z1z2z3x, replace)
graph combine z4 z5 z6 z4 z5 z6, rows(2) fysize(80) name(z4z5z6x, replace) 

graph export results\gpr_ta_1.eps, name(z0rx) replace logo(off) mag(100) 
graph export results\gpr_ta_2.eps, name(z1z2z3x) replace logo(off) mag(100) 
graph export results\gpr_ta_3.eps, name(z4z5z6x) replace logo(off) mag(100) 

// graph export results\gpr_ta_2.eps, name(z1z2x) replace logo(off) mag(100) 
// graph export results\gpr_ta_3.eps, name(z3z4x) replace logo(off) mag(100) 



}












//-----------------------------------
// Figure 5 : Plot of narrative and historical GPR
//-----------------------------------

if $do_figure5 == 1 {
use data_for_charts_in_paper, replace

cap drop eventshort
gen eventshort = " "
replace eventshort = event if rank_resid_GPRNARR<=100
replace eventshort = event if rank_RESID_GPRH<=10
replace eventshort = "Cuban Crisis" if month==tm(1962m10)
replace eventshort = "US-Ger.Crisis" if month==tm(1917m2)
replace eventshort = "Kuwait Invasion" if month==tm(1990m8)
replace eventshort = "Occupation Ruhr" if tin(1923m1,1923m1)
replace eventshort = "Vera Cruz" if tin(1914m4,1914m4)
replace eventshort = "9/11" if tin(2001m9,2001m9)
quietly replace eventshort = "Ger.Invades W.Europe" if month==tm(1940m5)
quietly replace eventshort = "Ger.occupies Czechia" if month==tm(1938m9)

gen plotevent = 0
replace plotevent = 1 if (rank_resid_GPRNARR<=8 | rank_RESID_GPRH<=8) & GPRNARR>GPRH
replace plotevent = 2 if (rank_resid_GPRNARR<=8 | rank_RESID_GPRH<=8) & GPRNARR<=GPRH

gen eventshort_n = " "
replace eventshort_n = eventshort if plotevent==1 & GPRNARR>GPRH

gen eventshort_g = " "
replace eventshort_g = eventshort if plotevent==2 & GPRNARR<=GPRH

twoway ///
(line  GPRNARR yearm if tin(1900m1,2019m12),  ///
xsc(r(1900 2020)) xlabel(1900(20)2020) ///
lcolor(red) lwidth(.4)) ///
///
(line  GPRH yearm if tin(1900m1,2019m12), lcolor(blue) lwidth(.2)) ///
///
(scatter GPRNARR yearm if plotevent==1, ///
c() cmissing(n) mlabel(eventshort_n) ///
mlabpos(12) mcolor(red) mlabcolor(red) mlabsize(vsmall) msize(.5) xtitle(""))  ///
///
(scatter GPRH yearm if plotevent==2, ///
c() cmissing(n) mlabel(eventshort_g) ///
ylabel(, angle(horizontal) format(%5.0f))  ///
mlabpos(12) mcolor(blue) mlabcolor(blue) mlabsize(vsmall) msize(.5) xtitle("") ///
legend(order(1 "Narrative GPR" 2 "Historical GPR") ring(0) rows(2) position(2) size(*0.9))),  ///
name(NARR, replace) graphregion(fcolor(white)) 



graph export results\gpr_narrative.eps, name(NARR) replace logo(off) mag(100) 

}







//----------------------------------
// Figure 6: Plot of country GPR
//----------------------------------

if $do_figure6 == 1 {

use data_for_charts_in_paper, clear

global vvar = "USA GBR JPN RUS CHN MEX DEU KOR" 


gen eventx = event
replace eventx = "" if month==tm(1941m12)
replace eventx = "Shanghai Inc." if month==tm(1932m2)
replace eventx = "Iraq" if month==tm(2003m3)
replace eventx = "Gulf" if month==tm(1991m1)
replace eventx = "9/11" if month==tm(2001m9)
replace eventx = "WWI" if month==tm(1914m8)
replace eventx = "WWII" if month==tm(1939m9)
replace eventx = "" if month==tm(1917m2)
replace eventx = "Cuba" if month==tm(1962m10)
replace eventx = "" if month==tm(1990m8)
replace eventx = "" if month==tm(1982m4)
replace eventx = "RUS-JPN War" if month==tm(1904m2)

foreach ico of global vvar {

qui gen GREL_`ico' = GPRC_`ico'/GPRH^0.1

qui regress GREL_`ico' L(1/12).GREL_`ico'
qui predict GREL_`ico'_RES, resid

egen rank_`ico' = rank(-GREL_`ico'_RES), unique

qui sum GREL_`ico'_RES, detail
qui gen event_`ico' = eventx if rank_`ico' <=10

}

cls
foreach ico of global vvar {
sort rank_`ico'
list month event_`ico' GPRC_`ico' rank_`ico' if rank_`ico' <= 40 & year>1900
}

sort month

replace event_RUS = "Revolution" if month==tm(1917m3)

replace event_KOR = "Nucl.Crisis" if month==tm(1994m6)
replace event_KOR = "Flight007" if month==tm(1983m9)
replace event_KOR = "" if month==tm(1950m12)
replace event_KOR = "" if month==tm(1904m2)

replace event_GBR = "Falklands" if month==tm(1982m4)

replace event_MEX = "Vera Cruz" if month==tm(1914m4)
replace event_MEX = "Revolution" if month==tm(1911m3)
replace event_MEX = "Huerta Rebell." if month==tm(1923m12)
replace event_MEX = "Carrizal" if month==tm(1916m6)

replace event_CHN = "Tienanmen" if month==tm(1989m6)
replace event_CHN = "Sino-Jap.War" if month==tm(1900m7)
replace event_CHN = "" if month==tm(1958m9)
replace event_CHN = "Indo-Pak.War" if month==tm(1965m9)

replace event_DEU = "" if month==tm(1961m7)
replace event_DEU = "Berlin Crisis" if month==tm(1961m8)
replace event_DEU = "" if month==tm(1938m9)

replace event_RUS = "Gulf War" if month==tm(1991m2)
replace event_RUS = "Afghan Inv." if month==tm(1980m1)
replace event_RUS = "Ukraine Annex." if month==tm(2014m3)

replace event_JPN = "Hiroshima" if month==tm(1945m8)
replace event_JPN = "Pearl Harbor" if month==tm(1941m12)

replace event_USA = "Korea" if month==tm(1950m7)

replace event_GBR = "" if month==tm(1938m9)
replace event_GBR = "Falklands" if month==tm(1982m5)
replace event_GBR = "" if month==tm(1982m4)


foreach ico of global vvar {

twoway ///
(line  GPRC_`ico' yearm if tin(1900m1,2020m12), lcolor(blue) lwidth(.4) ///
ylabel(, angle(horizontal) labcolor(blue) format(%5.1f))  ///
xsc(r(1900 2021)) xlabel(1900(20)2021) xtitle("") ytitle("") ) ///
(scatter GPRC_`ico' yearm if event_`ico'~="", c() cmissing(n) mlabel(event_`ico') ///
mlabpos(12) mcolor(blue) mlabcolor(blue) mlabsize(vsmall) msize(.5) xtitle("")),  ///
legend(off) ///
title(`ico') ///
name(G`ico', replace) graphregion(fcolor(white)) nodraw

}



graph combine GUSA GGBR GJPN GRUS, rows(2) name(GPRCOUNTRIES1, replace)
graph combine GDEU GKOR GMEX GCHN, rows(2) name(GPRCOUNTRIES2, replace)

graph export results\gpr_countries1.eps, name(GPRCOUNTRIES1) replace logo(off) mag(100) 
graph export results\gpr_countries2.eps, name(GPRCOUNTRIES2) replace logo(off) mag(100) 


}




//--------------------------------------------------
// Figure 7
//--------------------------------------------------


if $do_figure7 == 1 {

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

graph combine rameyall rameyall, rows(2) name(fig7a, replace) graphregion(fcolor(white))
graph export results\rameyall_top.eps, name(fig7a) replace logo(off) mag(100) 





use data_gpr_annual, clear

tsset year
keep if year<=2020

label var WARDEATHS "War Deaths (per million), left scale"
label var GPRH "GPR (annual), right scale"

twoway ///
(tsline WARDEATHS if year<=2020, lcolor(black) lwidth(.5) ytitle("") ///
xsc(r(1900 2020)) xlabel(1900(20)2020) ///
ysc(r(0 350)) ///
ylabel(0(50)350) ///
ylabel(, labcolor(black) angle(horizontal))) ///
///
(tsline GPRH, lcolor(blue) yaxis(2) lwidth(.3) xtitle("") ///
ytitle("", axis(2)) ///
xsc(r(1900 2020))  xlabel(1900(20)2020) ///
ylabel(, axis(2) labcolor(blue) angle(horizontal))), ///
legend(ring(0) position(2) rows(2) size(*1)) ///
///
name(wardeaths, replace) graphregion(fcolor(white)) nodraw


graph combine wardeaths wardeaths, rows(2) name(fig7b, replace) graphregion(fcolor(white))
graph export results\wardeaths_bottom.eps, name(fig7b) replace logo(off) mag(100) 







}




//-------------------------
// Figure 8 : Plot of recent GPR and comparison with VIX and EPU
//-------------------------

if $do_figure8 == 1 {

use data_for_charts_in_paper, replace

keep if yearm>1984.9999
keep if yearm<2020.9999


twoway ///
(line  GPR yearm, xlabel(1985(5)2021) yaxis(1) ///
ylabel(50 100 200 400 600, angle(horizontal) format(%5.0f) labcolor(blue)) ///
lcolor(blue) ytitle("") yscale(log) lwidth(.50))  ///
///
(line  SPVXOUSECON yearm, yaxis(2) lcolor(red) lwidth(.30) xtitle("") ///
ytitle("", axis(2)) ///
ylabel(, angle(horizontal) format(%5.0f) axis(2) labcolor(red))  ///
legend(size(*.85) ring(0) symysize(*0.01) symxsize(*0.4) position(2) rows(1) order(1 "GPR, left scale" 2 "VIX, right scale"))),  ///
name(VIX1, replace) graphregion(fcolor(white)) nodraw



twoway ///
(line  GPR yearm, xlabel(1985(5)2021) yaxis(1) ///
ylabel(50 100 200 400 600, angle(horizontal) format(%5.0f) labcolor(blue)) ///
lcolor(blue) ytitle("") yscale(log) lwidth(.50))  ///
///
(line  SEPUIUSECON yearm, yaxis(2) lcolor(red) lwidth(.30) xtitle("") ///
ytitle("", axis(2)) ///
ylabel(, angle(horizontal) format(%5.0f) axis(2) labcolor(red))  ///
legend(size(*.85) ring(0) symysize(*0.01) symxsize(*0.4) position(2) rows(1) order(1 "GPR, left scale" 2 "EPU, right scale"))),  ///
name(EPU1, replace) graphregion(fcolor(white)) nodraw


graph combine VIX1 EPU1, rows(2) name(GPR_EPU_VIX, replace) graphregion(fcolor(white))


graph export results\gpr_epu_vix.eps, name(GPR_EPU_VIX) replace logo(off) mag(100) 


}





















