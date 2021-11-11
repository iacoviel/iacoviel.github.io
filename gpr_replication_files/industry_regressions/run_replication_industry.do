// Daily Fama-French Portfolio returns & GPR


clear all
set more off



************************************************************
* ENTER START/END DATE IN ddMONyyyy format (e.g. 01jan1985)
* ENTER YEAR INCREMENT OF ROLLING REGRESSION (e.g. 1, 2,...)
************************************************************

local start_date 01jan1985
local end_date 31dec2019













//------------------------------------------
// Import Daily GPR data
//------------------------------------------
preserve
import excel gprnew_20210615.xlsx, firstrow sheet("GPR_DAILY_RECENT") clear 
keep DAY GPRD GPRD_THREAT GPRD_ACT
rename DAY Day
rename GPRD gpr
rename GPRD_THREAT gpr_threat
rename GPRD_ACT gpr_act
tostring Day, replace
gen date = dofd(date(Day, "YMD"))
format date %td
drop Day
sort date
drop if date==.
label var gpr "GPRD (Daily GPR)"
label var gpr_threat "GPRD_THREAT (Daily GPR Threats)"
label var gpr_act "GPRD_ACT (Daily GPR Acts)"
save temp_i_gpr_daily, replace
restore






//------------------------------------------
// Import Fama-French 3 factors + Risk Free
// Data pulled from http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/F-F_Research_Data_Factors_daily_CSV.zip
//------------------------------------------
preserve
import delimited F-F_Research_Data_Factors_daily.csv, varnames(1) clear
rename v1 date1


* Generate new date variables
tostring date1, replace 
gen date = date(date1, "YMD")
drop date1
format date %td
order date, first
drop if year(date)<1985 
drop if date==. 
save temp_i_ff_factors_daily, replace
restore





//------------------------------------------
// Import Fama-French Equal weighted returns
// Data pulled from http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/49_Industry_Portfolios_daily_CSV.zip
// File name: 49 Industry Portfolios [Daily]
//------------------------------------------

import delimited using 49_Industry_Portfolios_Daily_equal_weighted.CSV, encoding(UTF-8) clear 


drop in L
rename v1 date
tostring date, replace
gen date1 = date(date, "YMD")
format date1 %td
drop date
rename date1 date
order date, first
drop if year(date)<1985


foreach var of varlist agric-other {
	rename `var' ret`var'
}

tsset date, daily
tsfill

reshape long ret, i(date) j(ff49) string






//--------------------------------------
// Merge back with all other variables
//--------------------------------------

merge m:1 date using temp_i_ff_factors_daily, nogen

merge m:1 date using temp_i_gpr_daily, nogen
drop if gpr ==.
sort ff49 (date)






//-----------------------------------
// Add labels, clean data
//-----------------------------------


encode ff49, gen(ff)
drop if ff49==""
xtset ff date

label var ff49 "Industry"
label var ff "Industry (encoded)"



bysort ff: gen fgpr = F.gpr
bysort ff: gen dfgpr = D.fgpr
label var dfgpr "Change in GPR from previous calendar day"
label var fgpr "GPR from previous calendar day"

egen sdfgpr = std(dfgpr)
egen sfgpr = std(fgpr)

egen group = group(ff49)



label var rf "Daily return on a T-Bill"
gen ret_minus_rf = ret - rf
label var ret_minus_rf "Industry Return minus RF"
label var ret "Industry Return"

sort date (group)
summ group



sort date
di "Largest changes in GPR in the sample"
list date sdfgpr if (sdfgpr > 5 & sdfgpr~=. & ff49=="gold")









//------------------------------------------
// RUN INDUSTRY EXPOSURE REGRESSION
//------------------------------------------

reg ret_minus_rf c.sdfgpr#i.ff i.ff, allbaselevels



margins ff, dydx(sdfgpr) atmeans nose 

matrix B = r(b)
matrix list B 

gen beta = .
forvalues g = 1/49 {
    replace beta = B[1, `g'] if ff == `g'
}


rename ff49 ffportfolio 

collapse beta, by(ffportfolio)


capture gen ffportfoliolong = "Agriculture" if ffportfolio=="agric"
capture replace ffportfoliolong = "Food Products" if ffportfolio=="food"
capture replace ffportfoliolong = "Candy & Soda" if ffportfolio=="soda"
capture replace ffportfoliolong = "Beer & Liquor" if ffportfolio=="beer"
capture replace ffportfoliolong = "Business Services" if ffportfolio=="bussv"
capture replace ffportfoliolong = "Tobacco Products" if ffportfolio=="smoke"
capture replace ffportfoliolong = "Recreation" if ffportfolio=="toys"
capture replace ffportfoliolong = "Entertainment" if ffportfolio=="fun"
capture replace ffportfoliolong = "Printing and Publishing" if ffportfolio=="books"
capture replace ffportfoliolong = "Consumer Goods" if ffportfolio=="hshld"
capture replace ffportfoliolong = "Apparel" if ffportfolio=="clths"
capture replace ffportfoliolong = "Healthcare" if ffportfolio=="hlth"
capture replace ffportfoliolong = "Medical Equip." if ffportfolio=="medeq"
capture replace ffportfoliolong = "Pharmaceutical Products" if ffportfolio=="drugs"
capture replace ffportfoliolong = "Chemicals" if ffportfolio=="chems"
capture replace ffportfoliolong = "Rubber and Plastic" if ffportfolio=="rubbr"
capture replace ffportfoliolong = "Textiles" if ffportfolio=="txtls"
capture replace ffportfoliolong = "Construction Materials" if ffportfolio=="bldmt"
capture replace ffportfoliolong = "Construction" if ffportfolio=="cnstr"
capture replace ffportfoliolong = "Steel Works" if ffportfolio=="steel"
capture replace ffportfoliolong = "Fabricated Products" if ffportfolio=="fabpr"
capture replace ffportfoliolong = "Machinery" if ffportfolio=="mach"
capture replace ffportfoliolong = "Electrical Equip." if ffportfolio=="elceq"
capture replace ffportfoliolong = "Automobiles and Trucks" if ffportfolio=="autos"
capture replace ffportfoliolong = "Aircraft" if ffportfolio=="aero"
capture replace ffportfoliolong = "Shipbuilding, Railroad Equip." if ffportfolio=="ships"
capture replace ffportfoliolong = "Defense" if ffportfolio=="guns"
capture replace ffportfoliolong = "Precious Metals" if ffportfolio=="gold"
capture replace ffportfoliolong = "Industrial Metal Mining" if ffportfolio=="mines"
capture replace ffportfoliolong = "Coal" if ffportfolio=="coal"
capture replace ffportfoliolong = "Petroleum and Natural Gas" if ffportfolio=="oil"
capture replace ffportfoliolong = "Utilities" if ffportfolio=="util"
capture replace ffportfoliolong = "Communication" if ffportfolio=="telcm"
capture replace ffportfoliolong = "Personal Services" if ffportfolio=="persv"
capture replace ffportfoliolong = "Business Services" if ffportfolio=="bussv"
capture replace ffportfoliolong = "Computers" if ffportfolio=="hardw"
capture replace ffportfoliolong = "Computer Software" if ffportfolio=="softw"
capture replace ffportfoliolong = "Electronic Equip." if ffportfolio=="chips"
capture replace ffportfoliolong = "Measuring and Control Equip." if ffportfolio=="labeq"
capture replace ffportfoliolong = "Business Supplies" if ffportfolio=="paper"
capture replace ffportfoliolong = "Shipping Containers" if ffportfolio=="boxes"
capture replace ffportfoliolong = "Transportation" if ffportfolio=="trans"
capture replace ffportfoliolong = "Wholesale" if ffportfolio=="whlsl"
capture replace ffportfoliolong = "Retail" if ffportfolio=="rtail"
capture replace ffportfoliolong = "Restaurants, Hotels, Motels" if ffportfolio=="meals"
capture replace ffportfoliolong = "Banking" if ffportfolio=="banks"
capture replace ffportfoliolong = "Insurance" if ffportfolio=="insur"
capture replace ffportfoliolong = "Real Estate" if ffportfolio=="rlest"
capture replace ffportfoliolong = "Trading" if ffportfolio=="fin"
capture replace ffportfoliolong = "Other" if ffportfolio=="other"







egen std_beta = std(-beta)

global minbeta = r(min)
global maxbeta = r(max)
global minbeta = $minbeta-1
global maxbeta = $maxbeta+1


//*** Plot Industry Exposure ***
graph hbar std_beta, ///
over(ffportfoliolong, sort(std_beta) label(nolabels)) ///
blabel(group, format(%9.3f) size(vsmall)) ///
b1title(Average Exposure) ytitle("") ysc(r($minbeta $maxbeta)) ///
graphregion(fcolor(white)) ///
ylab(,nogrid) ///
ysc(r(-4 3)) ///
nofill name(EXPOSURE_TO_GPR, replace)


save industry_betas_simple, replace










