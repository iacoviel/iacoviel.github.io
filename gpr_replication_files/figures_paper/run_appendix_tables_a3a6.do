set scheme s1color, permanently

// Set each of the globals to 0/1 to generate the corresponding table

global do_apptable_a3 = 1  
global do_apptable_a4 = 0  
global do_apptable_a5 = 0  
global do_apptable_a6 = 0  







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



listtex var share meanxpre meanxpost corrx corrxpre corrxpost typeIerror using tempo1.tex  if ZZ<6, ///
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

browse var corr  meanx meanxpre meanxpost if ZZ<=`k'



}





