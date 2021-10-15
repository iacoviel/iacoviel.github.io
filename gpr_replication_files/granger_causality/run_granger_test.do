clear all
set more off



import delimited vardatagprgc.csv, varnames(1) clear 

gen date1 = mofd(date(dates, "MDY"))
drop dates
rename date1 dates
format dates %tm
order dates

// Convert to a monthly time series
tsset dates


gen dlus_ip = lus_ip - L.lus_ip
gen dlus_emp_tpi = lus_emp_tpi - L.lus_emp_tpi
gen dlus_oil_wti = lus_oil_wti - L.lus_oil_wti
gen dlus_sp500 = lus_sp500 - L.lus_sp500


********************************************************************************
* SET UP VARIABLE GROUPS
********************************************************************************
/*
THREE SETS OF REGRESSIONS

LHS : Xt = {GPR GPR_THREAT GPR_ACT} 

RHS : Mt = {IP, EMPLOYMENT, OIL}
	  Ft = {S&P RETURNS, 10-YEAR YIELD} 
	  Ut = {EPU, VIX/VXO}
*/


// GPR 
// Xt : gpr gprt gpra 

// Macro variables
// Mt : lus_ip, lus_emp_tpi, lus_oil_wti

// Financial variables
// Ft : lus_sp500, us_yld_10y

// Uncertainty
// Ut : epu, vxo

********************************************************************************

// Lags:
local lags = 3
local yield us_yld_10y


// Initialize empty lists of local variables
local gpr_lags
local threat_lags
local act_lags
local Mt
local Ft
local Ut

gen lepu = 100*log(epu)

forvalues i = 1/`lags' {

	local gpr_lags `gpr_lags' L`i'.lgpr
	local threat_lags `threat_lags' L`i'.lgprt
	local act_lags `act_lags' L`i'.lgpra
	
	local Mt `Mt' L`i'.dlus_ip L`i'.dlus_emp_tpi L`i'.lus_oil_wti
			
	local Ft `Ft' L`i'.dlus_sp500 L`i'.`yield'
	
	local Ut `Ut' L`i'.lepu L`i'.vxo

}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
* 								REGRESSION 1: GPR
/////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

local residual_count = 1


////////////////////////////////////////////////////
* 			ADD MACRO, FIN, UNCERTIAIN
///////////////////////////////////////////////////


qui reg lgpr `gpr_lags' `Mt' `Ft' `Ut'
local RsqA : di %9.2fc e(r2_a) 

qui newey lgpr `gpr_lags' `Mt' `Ft' `Ut', lag(1)

predict lgprhat if e(sample)
corr lgpr lgprhat if e(sample)
local Rsq : di %9.2fc r(rho)^2
drop lgprhat

// GPR
testparm L(1/3).lgpr
local F_gpr : di %9.2fc r(F)
local p_gpr : di %9.2fc r(p)

// Macro variables -
testparm L(1/3).dlus_ip L(1/3).dlus_emp_tpi L(1/3).lus_oil_wti
local F_m      : di %9.2fc r(F)
local p_macro  : di %9.2fc r(p)


// Financial variables -
testparm L(1/3).dlus_sp500 L(1/3).`yield'
local F_f      : di %9.2fc r(F)
local p_fin    : di %9.2fc r(p)

// Uncertainty variables -
testparm L(1/3).lepu L(1/3).vxo
local F_u      : di %9.2fc r(F)
local p_unc    : di %9.2fc r(p)


   
local pvals `p_macro' `p_fin' `p_unc' `p_gpr'  
local p_length : word count `pvals'


forvalues p = 1/`p_length' {
	
	local value : word `p' of `pvals'
	
	if `value' > 0.1 {
	local star_`p' ""
	}	  
	if `value'  <= 0.1 & `value'  > 0.05 {
	local star_`p' ""
	}
	if `value'  <= 0.05 & `value'  > 0.01 {
	local star_`p' ""
	}
	if `value'  <= 0.01 {
	local star_`p' ""
	}
	
}

predict double res_`residual_count', residuals
local ++residual_count


******************************
******	TABLE CREATION	******
outreg using table_gc.tex, replace varlabels ///
addrows("Macro", "`F_m'`star_1'" \ "", "\begin{footnotesize}[`p_macro']\end{footnotesize}" ///
		\ "Financial", "`F_f'`star_2'" \ "", "\begin{footnotesize}[`p_fin']\end{footnotesize}" ///
		\ "Uncertainty", "`F_u'`star_3'" \ "", "\begin{footnotesize}[`p_unc']\end{footnotesize}" ///
		\ "LGPR", "`F_gpr'`star_4'" \ "", "\begin{footnotesize}[`p_gpr']\end{footnotesize}" ///
		\ "LGPRA", "" \ "", "" ///
		\ "LGPRT", "" \ "", "" ///
		\ "Adj. \$ R^2\$", "`RsqA'") ///
ctitles("\textit{Variables}", "(1)" \ "", "LGPR") ///
se nolegend nocons noautosumm keep(L1.lgpr) sdec(3) tex
******************************
******************************



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
* 						REGRESSION 3: GPR ACTS
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////
* 			ADD MACRO, FIN, UNCERTIAIN
///////////////////////////////////////////////////

qui reg lgpra `act_lags' `threat_lags' `Mt' `Ft' `Ut'
local RsqA : di %9.2fc e(r2_a) 

qui newey lgpra `act_lags' `threat_lags' `Mt' `Ft' `Ut', lag(1)

predict lgprahat if e(sample)
corr lgpra lgprahat if e(sample)
local Rsq : di %9.2fc r(rho)^2
drop lgprahat


* JOINT SIGNIFICANCE OF:

// Lags of GPRT & GPRA -
testparm L(1/3).lgprt
local F_threats : di %9.2fc r(F)
local p_threats : di %9.2fc r(p)

testparm L(1/3).lgpra
local F_acts : di %9.2fc r(F)
local p_acts : di %9.2fc r(p)


// Macro variables -
testparm L(1/3).dlus_ip L(1/3).dlus_emp_tpi L(1/3).lus_oil_wti
local F_m       : di %9.2fc r(F)
local p_macro  : di %9.2fc r(p)


// Financial variables -
testparm L(1/3).dlus_sp500 L(1/3).`yield'
local F_f       : di %9.2fc r(F)
local p_fin    : di %9.2fc r(p)

// Uncertainty variables -
testparm L(1/3).lepu L(1/3).vxo
local F_u       : di %9.2fc r(F)
local p_unc    : di %9.2fc r(p)


local pvals `p_macro' `p_fin' `p_unc' `p_threats' `p_acts' 
local p_length : word count `pvals'


forvalues p = 1/`p_length' {
	
	local value : word `p' of `pvals'
	
	if `value' > 0.1 {
	local star_`p' ""
	}	  
	if `value'  <= 0.1 & `value'  > 0.05 {
	local star_`p' ""
	}
	if `value'  <= 0.05 & `value'  > 0.01 {
	local star_`p' ""
	}
	if `value'  <= 0.01 {
	local star_`p' ""
	}
}
  
predict double res_`residual_count', residuals
local ++residual_count



******************************
******	TABLE CREATION	******  
outreg using table_gc.tex, merge varlabels ///
addrows("Macro", "`F_m'`star_1'" \ "", "\begin{footnotesize}[`p_macro']\end{footnotesize}" ///
		\ "Financial", "`F_f'`star_2'" \ "", "\begin{footnotesize}[`p_fin']\end{footnotesize}" ///
		\ "Uncertainty", "`F_u'`star_3'" \ "", "\begin{footnotesize}[`p_unc']\end{footnotesize}" ///
		\ "LGPR", "" \ "", "" ///
		\ "LGPRA", "`F_acts'`star_5'" \ "", "\begin{footnotesize}[`p_acts']\end{footnotesize}" ///
		\ "LGPRT", "`F_threats'`star_4'" \ "", "\begin{footnotesize}[`p_threats']\end{footnotesize}" ///
		\ "Adj. \$ R^2\$", "`RsqA'") ///
ctitles("\textit{Variables}", "(2)" \ "", "LGPRA") ///
se nolegend nocons noautosumm keep(L1.lgprt) sdec(3) tex 
******************************
******************************

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
* 						REGRESSION 2: GPR THREATS
/////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////
* 			ADD MACRO, FIN, UNCERTIAIN
///////////////////////////////////////////////////


qui reg lgprt `threat_lags' `act_lags' `Mt' `Ft' `Ut'
local RsqA : di %9.2fc e(r2_a)

qui newey lgprt `threat_lags' `act_lags' `Mt' `Ft' `Ut', lag(1)

predict lgprthat if e(sample)
corr lgprt lgprthat if e(sample)
local Rsq : di %9.2fc r(rho)^2
drop lgprthat


* JOINT SIGNIFICANCE OF:
// Lags of GPRT & GPRA -

testparm L(1/3).lgprt
local F_threats : di %9.2fc r(F)
local p_threats : di %9.2fc r(p)

testparm L(1/3).lgpra
local F_acts : di %9.2fc r(F)
local p_acts : di %9.2fc r(p)

// Macro variables -
testparm L(1/3).dlus_ip L(1/3).dlus_emp_tpi L(1/3).lus_oil_wti
local F_m       : di %9.2fc r(F)
local p_macro  : di %9.2fc r(p)


// Financial variables -
testparm L(1/3).dlus_sp500 L(1/3).`yield'
local F_f       : di %9.2fc r(F)
local p_fin    : di %9.2fc r(p)

// Uncertainty variables -
testparm L(1/3).lepu L(1/3).vxo
local F_u       : di %9.2fc r(F)
local p_unc    : di %9.2fc r(p)


local pvals `p_macro' `p_fin' `p_unc' `p_threats' `p_acts' 
local p_length : word count `pvals'


forvalues p = 1/`p_length' {
	
	local value : word `p' of `pvals'
	
	if `value' > 0.1 {
	local star_`p' ""
	}	  
	if `value'  <= 0.1 & `value'  > 0.05 {
	local star_`p' ""
	}
	if `value'  <= 0.05 & `value'  > 0.01 {
	local star_`p' ""
	}
	if `value'  <= 0.01 {
	local star_`p' ""
	}
}
*/	   
predict double res_`residual_count', residuals
local ++residual_count
 

******************************
******	TABLE CREATION	******
outreg using table_gc.tex, merge varlabels ///
addrows("Macro", "`F_m'`star_1'" \ "", "\begin{footnotesize}[`p_macro']\end{footnotesize}" ///
		\ "Financial", "`F_f'`star_2'" \ "", "\begin{footnotesize}[`p_fin']\end{footnotesize}" ///
		\ "Uncertainty", "`F_u'`star_3'" \ "", "\begin{footnotesize}[`p_unc']\end{footnotesize}" ///
		\ "LGPR", "" \ "", "" ///		
		\ "LGPRA", "`F_acts'`star_5'" \ "", "\begin{footnotesize}[`p_acts']\end{footnotesize}" ///
		\ "LGPRT", "`F_threats'`star_4'" \ "", "\begin{footnotesize}[`p_threats']\end{footnotesize}" ///
		\ "Adj. \$ R^2\$", "`RsqA'") ///
ctitles("\textit{Variables}", "(3)" \"", "LGPRT") ///
hlines(101{0}10000010) ///
spacebef(11{0}10101010101) ///
se nolegend nocons noautosumm keep(L1.lgprt) sdec(3) tex 
******************************
******************************




