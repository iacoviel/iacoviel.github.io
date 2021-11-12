README file for building the data for firm-level analysis

*********************************************************

This file describes the steps to build the Stata file "firm_level.dta" that is used for the firm-level analysis in the paper "Measuring Geopolitical Risk." 

The Stata file  is built by running the file run_merge_compustat.do. This file uses all the files 1 to 9 listed below. The first file is built using Compustat.

--------------------------
run_merge_compustat.do 
--------------------------
Description: this file merges compustat data with firm-level GPR data from this paper and other additional data to create the Stata dataset firm_level.dta that can be used for the firm-level analysis used in the paper.
--------------------------

INPUTS
------
1. compustat_wrds.csv (Compustat Quarterly Firm-Level Data: This file CANNOT BE SHARED and must be created using an account at Wharton/WRDS since it contains proprietary data. Instructions on how to create the file are below.)*
2. gpri31_baseline.dta (Firm-Level raw GPR data from CI)
3. haver_macrodata_monthly.xlsx (Haver macro data, includes aggregate GPR)
4. haver_macrodata_quarterly.xlsx (Haver macro data, includes deflators)
5. industry_betas_simple.dta (Industry exposure data from CI)
6. hassan_firmquarter_2020q4.dta (Pol.Risk Data from Hassan et al.)
Auxiliary files to cross-walk from Compustat SIC to FF
7. ffind.ado
8. ffind.hlp
9. ffind_49.txt


OUTPUT
------
Files used in the firm-level analysis
1. firm_level.dta (For replication of GPR results. This file CANNOT BE SHARED since it is created using Compustat data above)
2. firm_level_gpr_only.dta (for distribution of GPR data)






INSTRUCTIONS TO BUILD the Compustat Quarterly Firm-Level Data
-----------------------------------------------------------
* The Compustat firm-level file must be created using an account at Wharton/WRDS since it contains proprietary data. 

Compustat data can be downloaded from https://wrds-www.wharton.upenn.edu/pages/
with a registered account.

The data location is Compustat Daily Updates - Fundamentals Quarterly

Step 1: Select date 1985-01 / 2020-12

Step 2: Declare TIC are company codes, select "Search the entire database"

Step 3: Select and download the following variables:
atq
capxy
ceqq
cheq
conm
cshoq
datacqtr
datafqtr
dlcq
dlttq
loc
mkvaltq
naics
ppegtq
ppentq
prccq
revtq
sic
tic

Step 4: Select as output format: (1) csv; (2) uncompressed; (3) YYMMDDn8. Then 
press the "Submit Form" button. 

As a result, you should get a dataset that contains all variables listed in step 3 above.
Note that other variables will be by default added to the dataset:
consol
costat
curcdq
datadate
datafmt
fqtr
fyearq
gvkey
indfmt
popsrc.

Note: For the record, query number 4887058, Submitted on:2021-11-11 16:13
