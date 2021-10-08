The file run_all reproduces the VAR results (Figures 9 and 10 and the VAR figures in the appendix) contained in the paper "Measuring Geopolitical Risk".

Change nd=20000 to obtain 20,000 draws from the posterior distribution.

SERIES MNEMONICS AS FOLLOWS.
DATA TRANSFORMATIONS are shown in the xlsx file.
DATA are pulled from csv file.
All series downloaded from Haver, except NFCI, taken from Fred.
Series downloaded on October 7, 2021.


1: SEPUI@USECON   [Economic Policy Uncertainty Index (1985-09=101.06535)]
2: FCM2@USECON   [2-Year Treasury Note Yield at Constant Maturity (% p.a.)]
3: PZTEXP@USECON   [Spot Oil Price: West Texas Intermediate [Prior'82=Posted Price] ($/Barrel)]
4: SPVXO@USECON   [CBOE Market Volatility Index: VOX, Old Method (Index)]
5: PCUN@USECON   [CPI-U: All Items (NSA, 1982-84=100)]
6: LHTPRIVA@USECON   [Aggregate Hours: Nonfarm Payrolls, Private Sector (SAAR, Bil.Hrs)]
7: FH@USECON   [Real Private Fixed Investment (SAAR, Bil.Chn.2012$)]
8: GDPH@USECON   [Real Gross Domestic Product (SAAR, Bil.Chn.2012$)]
9: LN16N@USECON   [Civilian Noninstitutional Population: 16 Years and Over (NSA, Thous)]
10: SP500@USECON   [Stock Price Index: Standard & Poor's 500 Composite  (1941-43=10)]
11: NFCI [Chicago Fed National Financial Conditions Index (https://fred.stlouisfed.org/series/NFCI)]


