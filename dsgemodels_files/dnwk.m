% DNWK.M : dynamic neo-keynesian model, set baseline parameters here
% @Matteo 12 April 2003
%
% May call DNWK_GO (dynamic neo-keynesian model with adjustment costs for capital and habit persistence)
%
% May also call DNWK_P_GO (DNK model a-la rotemberg-woodford, with consumption chosen 2 periods in advance 
% and inflation chosen one period in advance. 
% The latter model is a bit more sensitive than the other to changes in parameter values, and works
% well when a=0;
% reference is Boivin and Giannoni, "Has Monetary Policy Become More Effective", 2003
% and chapter 3 in Mike Woodford book
%
% To reduce this model to the model we have studied in class (EC751, Chapter 4),
% you need to keep
% a=0.00001 (no capital in the production function)
% e=0.00001 (no habit persistence in consuption)
% fi=0.0001 (no adjustment costs for capital)
% pb=0.0001 (no backwardlookingness in the Phillips curve)

clear;
close all;

r_a = 0.5 ; % TECHNOLOGY SHOCK PERSISTENCE
r_u = 0.0 ; % inflation shock persistence
r_e = 0.0 ; % interest rate shock persistence


sd_a = 0.0003 ;
sd_u = 0.03 ;
sd_e = 0.01 ;

b = .99; % beta

eta = 1.5 ; % PARAMETER DESCRIBING HOW ELASTIC LABOUR SUPPLY IS  [ LAB_ELASTICITY IS 1/(ETA-1) ]

te = .75 ; % probability of not changing prices

X = 1.1 ; % steady state markup

ro = 1 ; % RISK AVERSION in consumption



r_r = 0.8 ; r_p = 2 ; r_y =0.0 ; % Taylor rule coefficients

e = 0 ; % degree of habit persistence, DEFAULT 0
fi = 0 ; % adj cost for K, default 0
pb = 0 ; % BACKWARDLOOKINGNESS IN THE PHILLIPS CURVE, default 0
a = .000001 ; % SHARE OF K IN PROD FUNCTION, default 0
d = .03 ; % DEPRECIATION RATE OF CAPITAL



% A BUNCH OF OPTIONS THAT YOU DONT WANT TO CHANGE HERE
axistight=1; % makes axis limits tight
grids=0; % no grids on the plots
HORIZON=20 ;




% HERE YOU HAVE THE CHANCE TO CALIBRATE A FEW PARAMETERS AND THEN COMPARE THE IMPULSE RESPONSES OF THE MODEL
% CHANGING SOME OF THEM EACH TIME

dnwk_go
