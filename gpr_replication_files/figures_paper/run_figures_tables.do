cls
set scheme s1color


// Set each of the globals to 1 to plot all figures
global do_figure1 = 1  // Recent GPR
global do_figure2 = 1  // Daily GPR
global do_figure3 = 1  // Historical GPR
global do_figure4 = 1  // Historical ACTS THRETS
global do_figure5 = 1  // Narrative 
global do_figure6 = 1  // Country-specific GPR
global do_figure7 = 1  // Comparison with Mil.Spending News and Deaths
global do_figure8 = 1  // Comparison with EPU and VIX

global do_appfigure_a1 = 1  // Comparison with Military Spending: Detail
global do_appfigure_a2 = 1  // Natural Disasters and Sport Events
global do_appfigure_a3 = 1  // GPR Political Slant
global do_appfigure_a4 = 1  // Hijackings, Murders...
global do_appfigure_a10 = 1  // GPR Individual Newspapers
global do_appfigure_a11 = 1  // Search Categories
global do_appfigure_a12 = 1  // Human Index
global do_appfigure_a13 = 1  // GPR Ex econ words
global do_appfigure_a14 = 1  // GPR and Other Proxies

global do_table1_contributions = 1 
global do_table1_peakmonth = 1
global do_table2 = 1  

global do_apptable_a3 = 1  
global do_apptable_a4 = 1  
global do_apptable_a5 = 1  
global do_apptable_a6 = 1  


//-----------------
// INPUT FILES
//-----------------
// data_gpr_daily_recent
// data_gpr_monthly
// data_gpr_quarterly
// data_gpr_annual



//-------------------------
// Figure 1: Plot of recent GPR
//-------------------------

if $do_figure1 == 1 {

use data_gpr_monthly, replace
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
text(170 1986.4 "U.S. Bombing", justification(left) color(black) size(1.9)) ///
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
text(164 2018.0 "U.S.-", justification(left) color(black) size(1.9)) ///
text(155 2018.0 "N.Korea", justification(left) color(black) size(1.9)) ///
text(146 2018.0 "Tensions", justification(left) color(black) size(1.9)) ///
///
text(163 2020.5 "U.S.-", justification(left) color(black) size(1.9)) ///
text(154 2020.5 "Iran", justification(left) color(black) size(1.9)) ///
text(145 2020.5 "Tensions", justification(left) color(black) size(1.9)) ///
xsc(r(1985 2021)) xlabel(1985(5)2021) ytitle("") ///
) ///
///
(scatter GPR yearm if eventplot~=" ", c() cmissing(n) ///
ylabel(, angle(horizontal) format(%5.0f))  ///
mcolor(blue) mlabsize(small) msize(.5) xtitle("")),  ///
legend(off) ///
name(F1, replace) graphregion(fcolor(white)) 


graph export results\figure_1.eps, name(F1) replace logo(off) mag(100) 




}




//--------------------------
// Figure 2: 
// Please note that the original with all labels is done with Matlab
//--------------------------

if $do_figure2 == 1 {

use data_gpr_daily_recent, clear

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

// This is a patch to show years in Stata
gen year1=year(date)
gen month1=month(date)
gen day1=day(date)
gen date1 = year1 + (day1)/30/12 + (month1-1)/12


twoway ///
(scatter date1 GPR if tin($d1,$d2), msize(0.2) ytitle("") xtitle("") title("") ///
xlabel(, angle(horizontal) format(%5.0f)) ///
ylabel(, labsize(3) angle(horizontal) )) ///
(line date1 GPR_M if day==15, lcolor(blue) ylabel(1985(5)2020) ysc(r(1985 2021)) lwidth(.5) legend(off) xsc(alt) ysc(reverse)) ///
, ///
graphregion(fcolor(white)) name(A1, replace) nodraw




graph combine A1, graphregion(fcolor(white)) rows(1) name(F2, replace)


graph export results\figure_2_nolabels.eps, name(F2) replace logo(off) mag(100) 


}






//-------------------------
// Figure 3: Plot of historical GPR
//-------------------------

if $do_figure3 == 1 {

use data_gpr_monthly, replace

gen eventshort = " "

quietly replace eventshort = "D-Day" if month==tm(1944m6)
quietly replace eventshort = "Cuban Crisis" if month==tm(1962m10)
quietly replace eventshort = "Gulf War" if month==tm(1991m1)
quietly replace eventshort = "September 11" if month==tm(2001m10)

quietly replace eventshort = "  " if month==tm(1900m7)
quietly replace eventshort = "  " if month==tm(1904m2)
quietly replace eventshort = "  " if month==tm(1914m8)
quietly replace eventshort = "  " if month==tm(1918m7)
quietly replace eventshort = "  " if month==tm(1923m1)
quietly replace eventshort = "  " if month==tm(1932m2)
quietly replace eventshort = "  " if month==tm(1935m10)
quietly replace eventshort = "  " if month==tm(1938m9)
quietly replace eventshort = "  " if month==tm(1939m9)
quietly replace eventshort = "  " if month==tm(1941m12)
quietly replace eventshort = "  " if month==tm(1950m7)
quietly replace eventshort = "  " if month==tm(1956m11)
quietly replace eventshort = "  " if month==tm(1967m6)
quietly replace eventshort = "  " if month==tm(1973m10)
quietly replace eventshort = "  " if month==tm(1980m1)
quietly replace eventshort = "  " if month==tm(1982m4)
quietly replace eventshort = "  " if month==tm(1961m9)
quietly replace eventshort = "  " if month==tm(1999m4)
quietly replace eventshort = "  " if month==tm(1990m8)
quietly replace eventshort = "  " if month==tm(2003m3)
quietly replace eventshort = "  " if month==tm(2015m12)




twoway ///
///
(line  GPRH yearm if tin(1900m1,2020m12), lcolor(blue) lwidth(.3) ///
xsc(r(1899 2021)) ysc(r(0 510)) xlabel(1900(20)2021) ytitle("") ///
///
text(126 1900.6 "Boxer", justification(left) color(black) size(1.3)) ///
text(116 1900.6 "Rebellion", justification(left) color(black) size(1.3)) ///
///
text(160 1904.1 "Russia-Japan", justification(left) color(black) size(1.5)) ///
text(150 1904.1 "War", justification(left) color(black) size(1.5)) ///
///
text(495 1914.6 "WWI", justification(left) color(black) size(1.74)) ///
text(484 1914.6 "Begins", justification(left) color(black) size(1.74)) ///
///
text(428 1918.85 "WWI", justification(left) color(black) size(1.6)) ///
text(417 1919.05 "Escalation", justification(left) color(black) size(1.6)) ///
///
text(103 1925.9 "Occupation", justification(left) color(black) size(1.6)) ///
text( 93 1925.9 "of Ruhr", justification(left) color(black) size(1.6)) ///
///
text(133 1931.7 "Shanghai", justification(left) color(black) size(1.7)) ///
text(123 1931.7 "Incident", justification(left) color(black) size(1.7)) ///
///
text(201 1931.9 "Italy-", justification(left) color(black) size(1.65)) ///
text(190 1931.9 "Ethiopia", justification(left) color(black) size(1.65)) ///
text(179 1931.9 "War", justification(left) color(black) size(1.65)) ///
///
text(240 1936.0 "Germany", justification(left) color(black) size(1.55)) ///
text(230 1936.0 "Invades", justification(left) color(black) size(1.55)) ///
text(220 1936.0 "Czechia", justification(left) color(black) size(1.55)) ///
///
text(509 1939.9 "WWII", justification(left) color(black) size(1.74)) ///
text(497 1939.9 "Begins", justification(left) color(black) size(1.74)) ///
///
text(465 1942.05 "Pearl", justification(left) color(black) size(1.35)) ///
text(455 1942.05 "Harbor", justification(left) color(black) size(1.35)) ///
///
text(264 1950.5 "Korean", justification(left) color(black) size(1.7)) ///
text(252 1950.5 "War", justification(left) color(black) size(1.7)) ///
///
text(185 1954.9 "Suez", justification(left) color(black) size(1.6)) ///
text(175 1954.9 "Crisis", justification(left) color(black) size(1.6)) ///
///
text(205 1959.5 "Berlin", justification(left) color(black) size(1.6)) ///
text(195 1959.5 "Problem", justification(left) color(black) size(1.6)) ///
///
text(203 1967.5 "Six Day", justification(left) color(black) size(1.7)) ///
text(193 1967.5 "War", justification(left) color(black) size(1.7)) ///
///
text(190 1973.9 "Yom", justification(left) color(black) size(1.6)) ///
text(180 1973.9 "Kippur", justification(left) color(black) size(1.6)) ///
text(170 1973.9 "War", justification(left) color(black) size(1.6)) ///
///
text(171 1979.0 "Afghan", justification(left) color(black) size(1.5)) ///
text(161 1979.0 "Invasion", justification(left) color(black) size(1.5)) ///
///
text(190 1982.3 "Falklands", justification(left) color(black) size(1.5)) ///
text(180 1982.3 "War", justification(left) color(black) size(1.5)) ///
///
text(218 1987.54 "Iraq", justification(left) color(black) size(1.6)) ///
text(208 1987.54 "Invades", justification(left) color(black) size(1.6)) ///
text(198 1987.54 "Kuwait", justification(left) color(black) size(1.6)) ///
///
text(105 1998.6 "Bosnian", justification(left) color(black) size(1.6)) ///
text( 95 1998.6 "War", justification(left) color(black) size(1.6)) ///
///
text(265 2003.95 "Iraq", justification(left) color(black) size(1.7)) ///
text(253 2003.95 " War", justification(left) color(black) size(1.7)) ///
///
text(163 2015.8 "Paris", justification(left) color(black) size(1.6)) ///
text(153 2015.8 "Terror", justification(left) color(black) size(1.6)) ///
text(143 2015.8 "Attacks", justification(left) color(black) size(1.6)) ///
) ///
(scatter GPRH yearm if eventshort~=" ", c() cmissing(n) mlabel(eventshort) mlabangle(0) ///
ylabel(, angle(horizontal) format(%5.0f))  ///
mlabpos(12) mcolor(blue) mlabcolor(black) mlabsize(*.6) msize(.5) xtitle("")),  ///
legend(off) ///
name(F3, replace) graphregion(fcolor(white)) 


graph export results\figure_3.eps, name(F3) replace logo(off) mag(100) 

}






//---------------------------------
// Figure 4 : Plots of historical acts and threats
//------------------------------------------



if $do_figure4 == 1 {

use data_gpr_monthly, replace

format GPRH* %5.0f

twoway ///
(line GPRHT yearm if tin(1900m1,2020m12), lwidth(.3) ytitle("") ///
lcolor(red) ylabel(, angle(horizontal))) ///
(line GPRHA yearm if tin(1900m1,2020m12), yaxis(1) lwidth(.2) xtitle("") ///
lcolor(gs3) ytitle("", axis(1)) title("") ///
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
text(590 1914.7 "WWI Begins", justification(left) color(black) size(2.5)) ///
text(480 1917.0 "US Enters War", justification(left) color(black) size(2.5)) ///
legend(off) ///
name(z1, replace) graphregion(fcolor(white)) nodraw



twoway ///
(line GPRHT yearm if tin(1938m1,1945m12), lwidth(.5) ytitle("") ///
lcolor(red) ylabel(, angle(horizontal))) ///
(line GPRHA yearm if tin(1938m1,1945m12), yaxis(1) lwidth(.3) xtitle("") ///
lcolor(gs3) ytitle("", axis(1)) title("World War II") ///
ylabel(, axis(1) angle(horizontal))), ///
xsc(r(1938 1945)) xlabel(1938(2)1944) ///
ysc(r(0 800)) ylabel(0(200)800) ///
text(437 1938.6 "Germany", justification(left) color(black) size(2.5)) ///
text(390 1938.6 "Invades", justification(left) color(black) size(2.5)) ///
text(345 1938.6 "Czechia", justification(left) color(black) size(2.5)) ///
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
text(330 1990.2 "Kuwait Invasion", justification(left) color(black) size(2.5)) ///
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





graph combine z0, rows(1) name(F4A, replace) graphregion(fcolor(white))
graph display, ysize(1) xsize(2.5)  scale(1.35)

graph combine z1 z2 z3 z4 z5 z6, rows(2) name(F4B, replace) graphregion(fcolor(white))
graph display, ysize(2) xsize(2.5)  scale(0.90)

graph export results\figure_4a.eps, name(F4A) replace logo(off) mag(100) 
graph export results\figure_4b.eps, name(F4B) replace logo(off) mag(100) 




}












//-----------------------------------
// Figure 5 : Plot of narrative and historical GPR
//-----------------------------------

if $do_figure5 == 1 {
use data_gpr_monthly, replace

// Get a list of events and peaks
gen plotme = 0
replace plotme = 1 if (rank_resid_GPRNARR<=300 | rank_RESID_GPRH<=200) & (GPRNARR>150 | GPRH>150) & tin(1900m1,2019m12)
list month yearm GPRNARR GPRH event if plotme>0 & plotme~=.





twoway ///
(line  GPRNARR yearm if tin(1900m1,2019m12),  ///
xsc(r(1900 2020)) xlabel(1900(20)2020) ///
lcolor(red) lwidth(.4) xtitle("") ytitle("") ylabel(, angle(horizontal) format(%5.0f)) ///
legend(order(1 "Narrative GPR" 2 "Historical GPR") ring(0) rows(2) position(2) size(*0.9))) ///
///
(line  GPRH yearm if tin(1900m1,2019m12), lcolor(blue) lwidth(.2) ///
///
text(217 1904.2 "Russia-Japan", justification(left) color(black) size(1.7)) ///
text(205 1904.2 "War", justification(left) color(black) size(1.7)) ///
///
text(495 1914.6 "WWI", justification(left) color(black) size(1.7)) ///
text(483 1914.6 "Begins", justification(left) color(black) size(1.7)) ///
///
text(582 1918.2 "WWI", justification(left) color(black) size(1.7)) ///
text(570 1918.2 "Escalation", justification(left) color(black) size(1.7)) ///
///
text(239 1935.7 "Italy-", justification(left) color(black) size(1.7)) ///
text(227 1935.7 "Ethiopia", justification(left) color(black) size(1.7)) ///
text(215 1935.7 "War", justification(left) color(black) size(1.7)) ///
///
text(527 1939.7 "WWII", justification(left) color(black) size(1.7)) ///
text(515 1939.7 "Begins", justification(left) color(black) size(1.7)) ///
///
text(545 1944.8 "D-Day", justification(left) color(black) size(1.7)) ///
///
text(290 1950.5 "Korean", justification(left) color(black) size(1.7)) ///
text(278 1950.5 "War", justification(left) color(black) size(1.7)) ///
///
text(250 1956.8 "Suez", justification(left) color(black) size(1.7)) ///
text(238 1956.8 "Crisis", justification(left) color(black) size(1.7)) ///
///
text(250 1962.8 "Cuban", justification(left) color(black) size(1.7)) ///
text(238 1962.8 "Crisis", justification(left) color(black) size(1.7)) ///
///
text(272 1975.2 "Fall of", justification(left) color(black) size(1.7)) ///
text(260 1975.2 "Saigon", justification(left) color(black) size(1.7)) ///
///
text(262 1982.6 "Falklands", justification(left) color(black) size(1.7)) ///
text(250 1982.6 "War", justification(left) color(black) size(1.7)) ///
///
text(337 1991 "Gulf", justification(left) color(black) size(1.7)) ///
text(324 1991 "War", justification(left) color(black) size(1.7)) ///
///
text(313 2001.1 "9/11", justification(left) color(black) size(1.7)) ///
///
text(338 2003.2 "Iraq War", justification(left) color(black) size(1.7)) ///
///
text(232 2015.8 "Paris", justification(left) color(black) size(1.7)) ///
text(220 2015.8 "Terror", justification(left) color(black) size(1.7)) ///
text(208 2015.8 "Attacks", justification(left) color(black) size(1.7)) ///
),  ///
name(F5, replace) graphregion(fcolor(white)) 


graph export results\figure_5.eps, name(F5) replace logo(off) mag(100) 



































}







//----------------------------------
// Figure 6: Plot of country GPR
//----------------------------------

if $do_figure6 == 1 {

use data_gpr_monthly, clear
sort month

global vvar = "USA GBR JPN RUS DEU KOR MEX CHN" 


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









global i=1

foreach ico of global vvar {

if $i == 1 {
global titleg="GPR United States"
}
if $i == 2 {
global titleg="GPR United Kingdom"
}
if $i == 3 {
global titleg="GPR Japan"
}
if $i == 4 {
global titleg="GPR Russia"
}
if $i == 5 {
global titleg="GPR Germany"
}
if $i == 6 {
global titleg="GPR Korea"
}
if $i == 7 {
global titleg="GPR Mexico"
}
if $i == 8 {
global titleg="GPR China"
}


twoway ///
(line  GPRC_`ico' yearm if tin(1900m1,2020m12), lcolor(blue) lwidth(.4) ///
ylabel(, angle(horizontal) labcolor(blue) format(%5.1f))  ///
xsc(r(1900 2021)) xlabel(1900(20)2021) xtitle("") ytitle("") ) ///
(scatter GPRC_`ico' yearm if event_`ico'~="", c() cmissing(n) mlabel(event_`ico') ///
mlabpos(12) mcolor(blue) mlabcolor(blue) mlabsize(vsmall) msize(.5) xtitle("")),  ///
legend(off) ///
title($titleg) ///
name(G`ico', replace) graphregion(fcolor(white)) nodraw


global i=$i+1

}



graph combine GUSA GGBR GJPN GRUS, rows(2) name(F6A, replace)
graph display, ysize(1.4) xsize(2.5)  scale(1.25)

graph combine GDEU GKOR GMEX GCHN, rows(2) name(F6B, replace)
graph display, ysize(1.4) xsize(2.5)  scale(1.25)


graph export results\figure_6a.eps, name(F6A) replace logo(off) mag(100) 
graph export results\figure_6b.eps, name(F6B) replace logo(off) mag(100) 

}




//--------------------------------------------------
// Figure 7
//--------------------------------------------------


if $do_figure7 == 1 {

use data_gpr_quarterly, clear

tsset quarter
gen milnews_gdp = 100*milnews/L.ngdp

format GPRH* %5.0f 


egen sresidgprh = std(RESID_GPRH)
egen sresidgprht = std(RESID_GPRHT)
egen sresidgprha = std(RESID_GPRHA)


label var milnews_gdp "Mil. News (% of GDP), left scale"
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

graph combine rameyall, rows(1) name(F7A, replace) graphregion(fcolor(white))
graph display, ysize(1) xsize(2.5)  scale(1.35)

graph export results\figure_7a.eps, name(F7A) replace logo(off) mag(100) 




use data_gpr_annual, clear
format GPRH* %5.0f 

tsset year
keep if year<=2020

label var WARDEATHS "War Deaths (per 100,000), left scale"
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



graph combine wardeaths, rows(1) name(F7B, replace) graphregion(fcolor(white))
graph display, ysize(1) xsize(2.5)  scale(1.35)

graph export results\figure_7b.eps, name(F7B) replace logo(off) mag(100) 







}




//-------------------------
// Figure 8 : Plot of recent GPR and comparison with VIX and EPU
//-------------------------

if $do_figure8 == 1 {

use data_gpr_monthly, replace

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


graph combine VIX1 EPU1, rows(2) name(F8, replace) graphregion(fcolor(white))


graph export results\figure_8.eps, name(F8) replace logo(off) mag(100) 


}












//--------------------------------------------------
// Figure A.1
//--------------------------------------------------

if $do_appfigure_a1 == 1 {

use data_gpr_quarterly, clear

tsset quarter
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

graph combine rameyall ramey4, rows(2) name(FA1, replace) graphregion(fcolor(white))
graph export results\figure_A1.eps, name(FA1) replace logo(off) mag(100) 


}








//--------------------------------------------------
// Figure A.2
//--------------------------------------------------


if $do_appfigure_a2 == 1 {


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
name(zz1, replace) graphregion(fcolor(white)) nodraw




twoway ///
(line SHARE_GPR yearm, lwidth(.5) ytitle("% of articles") ///
lcolor(blue) ylabel(, angle(horizontal))) ///
(line FREQ_SPORT yearm, yaxis(1) lwidth(.3) xtitle("") ///
lcolor(red) ytitle("", axis(1)) title("Sport") ylabel(, axis(1) angle(horizontal))), ///
xsc(r(1985 2020)) xlabel(1985(5)2020) ///
ysc(r(0 25)) ylabel(0(5)25) ///
legend(order(1 "GPR Share" 2 "News on Sport Events") rows(2) symysize(0.01) ring(0) position(2) size(*0.8)) ///
name(zz3, replace) graphregion(fcolor(white)) nodraw



graph combine zz1 zz3, name(FA2, replace) rows(3)
graph export results\figure_A2.eps, name(FA2) replace logo(off) mag(100) 


}





//--------------------------------------------------
// Figure A.3 and A.10
//--------------------------------------------------

if $do_appfigure_a3 == 1 | $do_appfigure_a10 == 1 {

use data_gpr_monthly, replace
keep if tin(1985m1,2019m12)

// Keep raw GPR hits, newspaper counts, ratios for each newspapers
keep GPR_??_RAW N_??_RAW RATIO_?? 

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





if $do_appfigure_a3 == 1 {

twoway ///
///
(line  GPR_LEFT yearm, lcolor(black) lwidth(.5) ///
title("Left vs Right") ///
xsc(r(1985 2020)) xlabel(1985(5)2020) ytitle("% of GPR Articles") xtitle("")) ///
///
(line GPR_RIGHT yearm, lcolor(red) lwidth(.3) ///
ylabel(, angle(horizontal) format(%5.0f))),  ///
legend(order(1 "GPR Left" 2 "GPR Right") symysize(0.01) rows(2) ring(0) position(2) size(*0.7)) ///
name(FA3, replace) graphregion(fcolor(white)) 

graph export results\figure_A3.eps, name(FA3) replace logo(off) mag(100) 


}


if $do_appfigure_a10 == 1 {

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




graph combine GPRIND1 GPRIND2 GPRIND3 GPRIND4 GPRIND5, name(FA10, replace) rows(3)
graph export results\figure_A10.eps, name(FA10) replace logo(off) mag(100) 

}








}






//--------------------------------------------------
// Figure A.4
//--------------------------------------------------

if $do_appfigure_a4 == 1 {


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



graph combine HH1 HH2 HH3 , name(FA4, replace) rows(3) graphregion(fcolor(white)) 
graph display, ysize(3) xsize(2.5) 
graph export results\figure_A4.eps,  name(FA4) replace logo(off) mag(100) 



}













//--------------------------------------------------
// Figure A.11: Search categories
//--------------------------------------------------

if $do_appfigure_a11 == 1 {



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
name(BLOCK1, replace) graphregion(fcolor(white)) nodraw

twoway ///
(line   MCOMP_2_MA12 MCOMP_4_MA12 yearm, ///
lcolor(red maroon) ///
xsc(r(1900 2020)) xlabel(1900(20)2020) ///
ysc(r(0 1.5)) ///
lwidth(0.7 0.5) xtitle("") ///
ylabel(, angle(horizontal) format(%5.1f))  ///
ytitle(Articles Share) ///
legend(order(1 "Peace Threats" 2 "Nuclear Threats") rows(2) ring(0) position(10) symysize(0.1) size(*0.6))), ///
name(BLOCK2, replace) graphregion(fcolor(white))  nodraw

twoway ///
(line   MCOMP_6_MA12 MCOMP_7_MA12 yearm, ///
lcolor(navy teal) ///
xsc(r(1900 2020)) xlabel(1900(20)2020) ///
lwidth(0.7 0.5) xtitle("") ///
ylabel(, angle(horizontal) format(%5.1f))  ///
ytitle(Articles Share) ///
legend(order(1 "Begin War" 2 "Escalation War") rows(2) ring(0) position(2) symysize(0.1) size(*0.8))), ///
ysc(r(0 7.7)) ///
name(BLOCK3, replace) graphregion(fcolor(white)) nodraw

twoway ///
(line   MCOMP_5_MA12 MCOMP_8_MA12 yearm, ///
lcolor(red navy) ///
xsc(r(1900 2020)) xlabel(1900(20)2020) ///
lwidth(0.7 0.5) xtitle("") ///
ylabel(, angle(horizontal) format(%5.1f))  ///
ytitle(Articles Share) ///
legend(order(1 "Terror Threats" 2 "Terror Acts") rows(2) ring(0) position(11) symysize(0.1) size(*0.8))), ///
ysc(r(0 4.0)) ///
name(BLOCK4, replace) graphregion(fcolor(white)) nodraw



graph combine BLOCK1 BLOCK2 BLOCK3 BLOCK4, rows(2) name(FA11, replace) graphregion(fcolor(white))


graph export results\figure_A11.eps, name(FA11) replace logo(off) mag(100) 

}













//--------------------------------------------------
// Figure A.12: Human Index
//--------------------------------------------------

if $do_appfigure_a12 == 1 {

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
name(FA12, replace) graphregion(fcolor(white)) 

graph export results\figure_A12.eps, name(FA12) replace logo(off) mag(100) 

}







//--------------------------------------------------
// Figure A.13: GPR excluding econ
//--------------------------------------------------

if $do_appfigure_a13 == 1 {



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
name(FA13, replace) graphregion(fcolor(white)) 





graph export results\figure_A13.eps, name(FA13) replace logo(off) mag(100) 


pwcorr GPR_NOECON GPR

}








//--------------------------------------------------
// Figure A.14: GPR and proxies
//--------------------------------------------------

if $do_appfigure_a14 == 1 {


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
name(ICB, replace) graphregion(fcolor(white)) nodraw



use data_gpr_monthly, replace
gen MUS_ECR_ICRG = -US_ECR_ICRG


twoway ///
(line  GPR month if tin(1985m1,2019m12),  yaxis(1) ///
ylabel(, angle(horizontal) format(%5.0f) labcolor(blue)) ///
lcolor(blue) ytitle("") lwidth(.50))  ///
///
(line SEPUCSUSECON month if tin(1985m1,2019m12), yaxis(2) lcolor(red) lwidth(.30) xtitle("") ///
ytitle("", axis(2)) ///
ylabel(, angle(horizontal) format(%5.0f) axis(2) labcolor(red))  ///
legend(ring(0) rows(2) position(2) size(*0.6) symysize(0.1) order(1 "GPR Recent (Left)" 2 "EPU National Security (Right)"))),  ///
name(EPUNATSEC, replace) graphregion(fcolor(white)) nodraw



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
name(ICRG, replace) graphregion(fcolor(white)) nodraw

graph combine ICB EPUNATSEC ICRG, name(FA14, replace) rows(3) 

graph display, ysize(3) xsize(2.5) 

graph export results\figure_A14.eps,  name(FA14) replace logo(off) mag(100) 









}














// Input: data_for_charts_in_paper.dta

//use data_for_charts_in_paper, replace




//--------------------------------------------------------------------
// Table 1 part A: Peak dates by category reported
//--------------------------------------------------------------------

if $do_table1_peakmonth == 1 {

//use data_for_charts_in_paper, replace
use data_gpr_monthly, replace

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

use data_gpr_monthly, clear

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

use data_gpr_monthly, clear

drop rank_RESID* RESID*

keep if tin(1900m1,2019m12)
sort month

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



















//---------------------------------------
// Table A.3: Validation of GPR Index: Subsample Averages and Correlations with Narrative
//---------------------------------------

if $do_apptable_a3 == 1 {

use data_gpr_monthly, replace
drop GPR
keep if tin(1900m1,2019m12)

gen NARRATIVE = GPRNARR_RAW/5*100 // Express Narrative as a ``weighted'' share

gen GPRNOEW = 100*GPRH_NOEW_RAW/N3H
gen GPRBASIC = (100*GPRH_BASIC_RAW/N3H)
gen GPRAND = (100*GPRH_AND_RAW/N3H)

rename SHARE_GPRH GPR

gen var = " "
gen corrx = .
gen corrxpre = .
gen corrxpost = .
gen share = .
gen meanx = .
gen meanxpre = .
gen meanxpost = .
gen typeIerror = .

insob 10 1
gen ZZ = _n

global varcorr "NARRATIVE GPR GPRNOEW GPRBASIC GPRAND"

local k=1

foreach x of global varcorr {

sum `x'
replace share=r(mean) if ZZ==`k' // Calculate mean prior to normalizing

replace `x'=`x'/r(mean)*100


replace var="`x'" if ZZ==`k'

spearman NARRATIVE `x', stats(p) pw
replace corrx=r(rho) if ZZ==`k'
spearman NARRATIVE `x' if year<=1959, stats(p) pw
replace corrxpre=r(rho) if ZZ==`k'
spearman NARRATIVE `x' if year>=1960, stats(p) pw
replace corrxpost=r(rho) if ZZ==`k'

sum `x'
replace meanx=r(mean) if ZZ==`k'
sum `x' if year<=1959
replace meanxpre=r(mean) if ZZ==`k'
sum `x' if year>=1960
replace meanxpost=r(mean) if ZZ==`k'

local k=`k'+1

}

format corrx* %5.2f
format meanx* %5.1f
format share %5.1f



listtex var share meanxpre meanxpost corrx corrxpre corrxpost typeIerror using apptable_a3.tex  if ZZ<6, ///
replace type rstyle(tabular) ///
head("\begin{tabular}{C{2.8cm} C{1.9cm} C{1.9cm} C{1.9cm} C{1.9cm} C{1.9cm} C{1.9cm} C{1.9cm} }" ///
"\hline" "\hline" ///
`"Index & \makecell{Share of\\Articles} & \makecell{Index:\\1900-1959} & \makecell{Index:\\1960-2019} & \makecell{Corr.with\\Narrative} & \makecell{Corr.with\\Narrative,\\1950-1959} & \makecell{Corr.with\\Narrative,\\1960-2019} & \makecell{Type I\\error}\\"' ///
"\hline" ) ///
foot("\hline" "\end{tabular}") 





list var share meanxpre meanxpost corrx corrxpre corrxpost typeIerror ZZ if ZZ<6

}









//--------------------------------------------------
// Table A.4 : Historical Frequency of Individual Words
//--------------------------------------------------

if $do_apptable_a4 == 1 {


set more off 
use data_gpr_monthly, clear
keep if tin(1900m1,2019m12)
keep month year SHARE_GPRH N3H WAR* RISK*  ACTOR* BUILDUP* FIGHT* MILITARY* PEACE* TERROR*

// 1 - WAR
// 2 - RISK
// 3 - WARBEGIN 
// 4 - ACTOR 
// 5 - BUILDUP
// 6 - FIGHT 
// 7 - MILITARY
// 8 - PEACE
// 9 - PEACEDISRUPT
// 10 - TERROR
// 11 - TERRORACT



gen wordtype = " "




forvalues i = 1(1)11 {

quietly {

global iwords = `i'

if $iwords == 1 {
global nw = 9
global word = "WAR"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" War" 				if ZZ==1
replace varheader=" Conflict"			if ZZ==2
replace varheader=" Hostilities"		if ZZ==3
replace varheader=" Revolution"			if ZZ==4
replace varheader=" Insurrection" 	 	if ZZ==5
replace varheader=" Uprising"			if ZZ==6
replace varheader=" Revolt"				if ZZ==7
replace varheader=" Coup"				if ZZ==8
replace varheader=" Geopolitical"		if ZZ==9
}

if $iwords == 2 {
global nw = 18
global word = "RISK"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Risk" 		if ZZ==1
replace varheader=" Warning"	if ZZ==2
replace varheader=" Fear" 		if ZZ==3
replace varheader=" Danger" 	if ZZ==4
replace varheader=" Threat" 	if ZZ==5
replace varheader=" Doubt"		if ZZ==6
replace varheader=" Crisis"		if ZZ==7
replace varheader=" Concern"	if ZZ==8
replace varheader=" Tension"	if ZZ==9
replace varheader=" Dispute"	if ZZ==10
replace varheader=" Peril"		if ZZ==11
replace varheader=" Menace"		if ZZ==12
replace varheader=" Brink"		if ZZ==13
replace varheader=" Scare"		if ZZ==14
replace varheader=" Imminent"	if ZZ==15
replace varheader=" Trouble"	if ZZ==16
replace varheader=" Inevitable"	if ZZ==17
replace varheader=" Footing"	if ZZ==18
}

if $iwords == 3 {
global nw = 7
global word = "WARBEGIN"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Declare" 		if ZZ==1
replace varheader=" Proclamation"	if ZZ==2
replace varheader=" Begin" 			if ZZ==3
replace varheader=" Start" 			if ZZ==4
replace varheader=" Outbreak" 		if ZZ==5
replace varheader=" Breakout"		if ZZ==6
replace varheader=" Launch"			if ZZ==7
}


if $iwords == 4 {
global nw = 8
global word = "ACTOR"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Allied" 	if ZZ==1
replace varheader=" Enemy"		if ZZ==2
replace varheader=" Foe" 		if ZZ==3
replace varheader=" Army" 		if ZZ==4
replace varheader=" Navy" 		if ZZ==5
replace varheader=" Aerial"		if ZZ==6
replace varheader=" Rebels"		if ZZ==7
replace varheader=" Insurgents"	if ZZ==8
}


if $iwords == 5 {
global nw = 7
global word = "BUILDUP"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Buildup" 		if ZZ==1
replace varheader=" Embargo"		if ZZ==2
replace varheader=" Blockade" 		if ZZ==3
replace varheader=" Sanction" 		if ZZ==4
replace varheader=" Quarantine" 	if ZZ==5
replace varheader=" Ultimatum"		if ZZ==6
replace varheader=" Mobilize"		if ZZ==7
}

if $iwords == 6 {
global nw = 10
global word = "FIGHT"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Drive" 		if ZZ==1
replace varheader=" Shell" 		if ZZ==2
replace varheader=" Advance"	if ZZ==3
replace varheader=" Offensive" 	if ZZ==4
replace varheader=" Invasion" 	if ZZ==5
replace varheader=" Clash" 		if ZZ==6
replace varheader=" Attack" 	if ZZ==7
replace varheader=" Raid"		if ZZ==8
replace varheader=" Launch"		if ZZ==9
replace varheader=" Strike"		if ZZ==10
}

if $iwords == 7 {
global nw = 7
global word = "MILITARY"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Military" 	if ZZ==1
replace varheader=" Troops"		if ZZ==2
replace varheader=" Missile" 	if ZZ==3
replace varheader=" Arms" 		if ZZ==4
replace varheader=" Weapon" 	if ZZ==5
replace varheader=" Bomb"		if ZZ==6
replace varheader=" Warhead"	if ZZ==7
}

if $iwords == 8 {
global nw = 5
global word = "PEACE"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Peace"		if ZZ==1
replace varheader=" Truce"		if ZZ==2
replace varheader=" Armistice"	if ZZ==3
replace varheader=" Treaty"		if ZZ==4
replace varheader=" Parley"		if ZZ==5

}

if $iwords == 9 {
global nw = 6
global word = "PEACEDISRUPT"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Menace" 	if ZZ==1
replace varheader=" Reject"		if ZZ==2
replace varheader=" Threat" 	if ZZ==3
replace varheader=" Peril" 		if ZZ==4
replace varheader=" Boycott" 	if ZZ==5
replace varheader=" Disrupt"	if ZZ==6
}

if $iwords == 10 {
global nw = 3
global word = "TERROR"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Terrorism/t"	if ZZ==1
replace varheader=" Guerrilla"		if ZZ==2
replace varheader=" Hostage"		if ZZ==3
}

if $iwords == 11 {
global nw = 6
global word = "TERRORACT"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Act"	if ZZ==1
replace varheader=" Bomb"	if ZZ==2
replace varheader=" Kill"	if ZZ==3
replace varheader=" Strike"	if ZZ==4
replace varheader=" Attack"	if ZZ==5
replace varheader=" Hijack"	if ZZ==6
}





gen meanvar = .
gen meanvar1 = .
gen meanvar2 = .
gen meanvar3 = .
gen corrgpr = .

forvalues i = 1(1)$nw {
gen WORDSHR`i' = 100*${word}_C`i'_RAW/N3H
}

local k = 1

forvalues i = 1(1)$nw {

sum WORDSHR`i' 
replace meanvar=r(mean) if ZZ==`k'

sum WORDSHR`i' if year<1940
replace meanvar1=r(mean) if ZZ==`k'

sum WORDSHR`i' if year>=1940 & year<1980
replace meanvar2=r(mean) if ZZ==`k'

sum WORDSHR`i' if year>=1980 & year<2020
replace meanvar3=r(mean) if ZZ==`k'

corr WORDSHR`i' SHARE_GPRH 
replace corrgpr=r(rho) if ZZ==`k'

local k = `k'+1

}

format corrgpr %5.2f
format meanvar* %5.1f

replace wordtype = "${word}"
gsort -meanvar
gen sortorder = _n

}

listtex sortorder varheader wordtype corrgpr meanvar meanvar1 meanvar2 meanvar3 if ZZ<=$nw, ///
type rstyle(tabular) ///
head("\begin{tabular}{cccccccc}" `"\textbf{Rank}&\textbf{Variable}&\textbf{Word Type}&\textbf{Corr.}&\textbf{Share}&\textbf{Share:1900-39}&\textbf{Share:1940-79}&\textbf{Share:1980-2019}\\"') ///
foot("\end{tabular}")

drop ZZ varheader meanvar* corrgpr WORDSHR* sortorder

}





}






//-----------------------------------------
// Table A.5 : Historical Frequency of Individual Bigrams
//-----------------------------------------


if $do_apptable_a5 == 1 {

set more off 
use data_gpr_monthly, clear
keep if tin(1900m1,2019m12)



gen wordtype = " "


set more off 
rename GPRH_M*_RAW	GPRTOPIC_C*_RAW


foreach i of numlist 1 2 3 4 5 6 7 {

quietly {

global iwords = `i'



if $iwords == 1 {
global nw = 8
global word = "GPRTOPIC"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" War Risk" 			if ZZ==1
replace varheader=" Peace Risk"			if ZZ==2
replace varheader=" Military Buildup" 	if ZZ==3
replace varheader=" Nuclear Risk" 		if ZZ==4
replace varheader=" Terror Risk" 		if ZZ==5
replace varheader=" War Begin"			if ZZ==6
replace varheader=" War Escalation"		if ZZ==7
replace varheader=" Terror Act"			if ZZ==8
}


if $iwords == 2 {
global nw = 9
global word = "RISK_WAR"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Risk Words N/2 War" 				if ZZ==1
replace varheader=" Risk Words N/2 Conflict"			if ZZ==2
replace varheader=" Risk Words N/2 Hostilities"			if ZZ==3
replace varheader=" Risk Words N/2 Revolution"			if ZZ==4
replace varheader=" Risk Words N/2 Insurrection" 	 	if ZZ==5
replace varheader=" Risk Words N/2 Uprising"			if ZZ==6
replace varheader=" Risk Words N/2 Revolt"				if ZZ==7
replace varheader=" Risk Words N/2 Coup"				if ZZ==8
replace varheader=" Risk Words N/2 Geopolitical"		if ZZ==9
}


if $iwords == 3 {
global nw = 7
global word = "MILITARY_BUILDUP"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Military Words AND Buildup" 		if ZZ==1
replace varheader=" Military Words AND Embargo"			if ZZ==2
replace varheader=" Military Words AND Blockade" 		if ZZ==3
replace varheader=" Military Words AND Sanction" 		if ZZ==4
replace varheader=" Military Words AND Quarantine" 		if ZZ==5
replace varheader=" Military Words AND Ultimatum"		if ZZ==6
replace varheader=" Military Words AND Mobilize"		if ZZ==7
}


if $iwords == 4 {
global nw = 9
global word = "RISK_NUKEWAR"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Nuclear War AND Risk Words" 	if ZZ==1
replace varheader=" Atomic War AND Risk Words"		if ZZ==2
replace varheader=" Nuclear Missile AND Risk Words" if ZZ==3
replace varheader=" Nuclear Bomb AND Risk Words" 	if ZZ==4
replace varheader=" Atom Bomb AND Risk Words" 		if ZZ==5
replace varheader=" H Bomb AND Risk Words" 			if ZZ==6
replace varheader=" Hydrogen Bomb AND Risk Words"	if ZZ==7
replace varheader=" Nuclear Test AND Risk Words" 	if ZZ==8
replace varheader=" Nuclear Weapons AND Risk Words" if ZZ==9
}


if $iwords == 5 {
global nw = 9
global word = "WARBEGIN_WAR"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" War-Begin Words N/2 War" 				if ZZ==1
replace varheader=" War-Begin Words N/2 Conflict"			if ZZ==2
replace varheader=" War-Begin Words N/2 Hostilities"		if ZZ==3
replace varheader=" War-Begin Words N/2 Revolution"			if ZZ==4
replace varheader=" War-Begin Words N/2 Insurrection" 	 	if ZZ==5
replace varheader=" War-Begin Words N/2 Uprising"			if ZZ==6
replace varheader=" War-Begin Words N/2 Revolt"				if ZZ==7
replace varheader=" War-Begin Words N/2 Coup"				if ZZ==8
replace varheader=" War-Begin Words N/2 Geopolitical"		if ZZ==9
}


if $iwords == 6 {
global nw = 10
global word = "ACTOR_FIGHT"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Actor Words N/2 Drive" 		if ZZ==1
replace varheader=" Actor Words N/2 Shell" 		if ZZ==2
replace varheader=" Actor Words N/2 Advance"	if ZZ==3
replace varheader=" Actor Words N/2 Offensive" 	if ZZ==4
replace varheader=" Actor Words N/2 Invasion" 	if ZZ==5
replace varheader=" Actor Words N/2 Clash" 		if ZZ==6
replace varheader=" Actor Words N/2 Attack" 	if ZZ==7
replace varheader=" Actor Words N/2 Raid"		if ZZ==8
replace varheader=" Actor Words N/2 Launch"		if ZZ==9
replace varheader=" Actor Words N/2 Strike"		if ZZ==10
}


if $iwords == 7 {
global nw = 6
global word = "TERROR_TERRORACT"
insob $nw 1
gen ZZ = _n
gen varheader = " "
replace varheader=" Terror Words N/2 Act"	if ZZ==1
replace varheader=" Terror Words N/2 Bomb"	if ZZ==2
replace varheader=" Terror Words N/2 Kill"	if ZZ==3
replace varheader=" Terror Words N/2 Strike"	if ZZ==4
replace varheader=" Terror Words N/2 Attack"	if ZZ==5
replace varheader=" Terror Words N/2 Hijack"	if ZZ==6
}





gen meanvar = .
gen meanvar1 = .
gen meanvar2 = .
gen meanvar3 = .
gen corrgpr = .

forvalues i = 1(1)$nw {
gen WORDSHR`i' = 100*${word}_C`i'_RAW/N3H
}

local k = 1

forvalues i = 1(1)$nw {

sum WORDSHR`i' 
replace meanvar=r(mean) if ZZ==`k'

sum WORDSHR`i' if year<1940
replace meanvar1=r(mean) if ZZ==`k'

sum WORDSHR`i' if year>=1940 & year<1980
replace meanvar2=r(mean) if ZZ==`k'

sum WORDSHR`i' if year>=1980 & year<2020
replace meanvar3=r(mean) if ZZ==`k'

corr WORDSHR`i' SHARE_GPRH 
replace corrgpr=r(rho) if ZZ==`k'

local k = `k'+1

}

format corrgpr %5.2f
format meanvar* %5.2f

replace wordtype = "${word}"
gsort -meanvar
gen sortorder = _n

}



listtex sortorder varheader wordtype corrgpr meanvar meanvar1 meanvar2 meanvar3 if ZZ<=$nw, ///
type rstyle(tabular) ///
head("\begin{tabular}{cccccccc}" `"\textbf{Rank}&\textbf{Variable}&\textbf{Word Type}&\textbf{Corr.}&\textbf{Share}&\textbf{Share:1900-39}&\textbf{Share:1940-79}&\textbf{Share:1980-2019}\\"') ///
foot("\end{tabular}")

drop ZZ varheader meanvar* corrgpr WORDSHR* sortorder

}

}








//--------------------------------------------------
// Appendix Table A.6: Correlations of GPR with Selected Phenomena
//--------------------------------------------------

if $do_apptable_a6 == 1 {

use data_gpr_monthly, clear
keep if tin(1900m1,2019m12)

gen var = " "
gen corr = .
gen meanx = .
gen meanxpre = .
gen meanxpost = .

insob 10 1
gen ZZ = _n

rename FREQ_* *

// Each of the words below is the raw mentions of inflation, sport, etc.. normalized by N3H

global varcorr "SHARE_GPRH INFLATION SPORT OLYMPIC DISASTER FLU PRESIDENT CAMPUS MURDER COALSTRIKE WEDDING "

local k=0
foreach x of global varcorr {

spearman SHARE_GPRH `x', stats(p) pw
local k=`k'+1
replace var="`x'" if ZZ==`k'
replace corr=r(rho) if ZZ==`k'
sum `x'
replace meanx=r(mean) if ZZ==`k'
sum `x' if year<=1959
replace meanxpre=r(mean) if ZZ==`k'
sum `x' if year>=1960
replace meanxpost=r(mean) if ZZ==`k'
}

format corr %5.2f
format meanx %5.2f
format meanxpre %5.2f
format meanxpost %5.2f

label var SHARE_GPRH  "GPR (Share)"

listtex var corr  meanx meanxpre meanxpost if ZZ<=`k', type rstyle(tabular) ///
head("\begin{tabular}{ccccc}" `"\textbf{Keyword} & \textbf{Correlation} & \textbf{Share:1900-2020} & \textbf{Share:1900-59} & \textbf{Share:1960-2020}\\"') ///
foot("\end{tabular}")

list var corr  meanx meanxpre meanxpost if ZZ<=`k'



}





























