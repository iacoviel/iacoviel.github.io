// Daily Fama-French Portfolio returns & GPR

cd C:\Research\GPR_firmlevel\famafrench_data

clear all
set more off



************************************************************
* ENTER START/END DATE IN ddMONyyyy format (e.g. 01jan1985)
* ENTER YEAR INCREMENT OF ROLLING REGRESSION (e.g. 1, 2,...)
************************************************************

local start_date 01jan1985
local end_date 31dec2019

use fama_french_equal_gpr, clear

encode ff49, gen(ff)
drop if ff49==""
xtset ff date

label var ff49 "Industry"
label var ff "Industry (encoded)"



bysort ff: gen fgpr = F.gpr
bysort ff: gen dfgpr = D.fgpr
label var dfgpr "Change in GPR from previous calendar day"
label var fgpr "GPR from previous calendar day"
label var sprtrn "SP 500 return"

egen sdfgpr = std(dfgpr)
egen sfgpr = std(fgpr)



egen group = group(ff49)




// Industry returns: daily, %
// RF is the daily return on a t-bill
label var rf "Daily return on a t-bill"
gen ret0 = ret - rf
label var ret0 "Industry return minus RF"

label var ret "Industry return"

sort date (group)
summ group





sort date
di "Largest changes in GPR in the sample"
list date sdfgpr if (sdfgpr > 5 & sdfgpr~=. & ff49=="gold")


reg ret0 c.sdfgpr#i.ff i.ff, allbaselevels



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
nofill name(EXPO_TO_GPR, replace)

//graph export industry_exposure.eps, replace

//save industry_betas_simple, replace










