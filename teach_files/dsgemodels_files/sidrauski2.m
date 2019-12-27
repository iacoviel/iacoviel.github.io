% SIDRAUSKI2.M : sets us SIDRAUSKI model of money in utility function with endogenous capital and labor
% SET THE BASELINE PARAMETERS HERE
% @Matteo September 2003
% for help see Section 3.3 of my BC2003-2004 lecture notes

clear;
close all;


r_a = .95 ; % TECHNOLOGY SHOCK PERSISTENCE
r_u = .8 ; % money shock persistence
corr_a_u = 0; % CORRELATION B/W SHOCKS

sd_a = 0.007 ;
sd_u = 0.0089 ;

% Model parameters

%	u  = ( ( ( a C_{t} ^ {1-b} + (1-a) m_{t} ^ {1-b} ) ^ { ( (1-a)/(1-b) ) } ) /(1-a)  - ((L_{t}^{?})/?)
%	Y_{t} = A_{t} K_{t-1}^{a} L_{t}^{1-a}


alfa = .36; % SHARE OF K IN PROD FUNCTION
d = .019 ; % DEPRECIATION RATE OF CAPITAL
be = .989 ; % beta
te = 1.0125 ; % STEADY STATE GROWTH RATE OF MONEY SUPPLY
fi = 2 ; % SUBSTITUTABILITY BETWEEN C AND M/P

eta = 1.5 ; % PARAMETER DESCRIBING HOW ELASTIC LABOUR SUPPLY IS  [ LAB_ELASTICITY IS 1/(ETA-1) ]

a = .978 ; % WEIGHT ON CONSUMPTION IN UTILITY FUNCTION

b = 14 ; % ELASTICITY OF REAL BALANCES TO NOMINAL INTEREST RATE


% A BUNCH OF OPTIONS THAT YOU DONT WANT TO CHANGE HERE
axistight=1; grids=1;


% HERE YOU HAVE THE CHANCE TO CALIBRATE A FEW PARAMETERS AND THEN COMPARE THE IMPULSE RESPONSES OF THE MODEL
% CHANGING SOME OF THEM EACH TIME

% FIRST CALIBRATION. 


cha=0; % CHA=0 MEANS THAT THE IRF WILL BE RED/CIRCLED
sidrauski2_go % RUNS THE MODEL, DONT CHANGE 

% 
cha=1;
fi=20;
sidrauski2_go % RUNS THE MODEL, DONT CHANGE 