% LEEPER.M ANALYSES THE MODEL DESCRIBED IN LEEPER (2002), MACRO POLICY AND INFLATION: AN OVERVIEW,
% AND IN LEEPER JME PAPER.
% HOWEVER I HAVE ALSO ADDED AN AGGREGATE SUPPLY CURVE SO THAT IN THE END THE LEEPER MODEL
% CAN BE NESTED INTO WOODFORD (1995) MODEL WHEN AS CURVE IS VERTICAL

% REFERENCES
% Leeper, Eric M. (1991). “Equilibria Under 'Active' and 'Passive' Monetary and Fiscal Policies.”, 
%       Journal of Monetary Economics 27, February, 129-147.
% Leeper, Eric (2002), “Macro Policy and Inflation: An Overview”, mimeo, University of Indiana 
% Woodford, Michael (1995), “Control of the Public Debt: A Requirement for Price Stability?" NBER working paper no. 5684, July 1996.

% IF YOU HAVE ANY PROBLEMS EITHER SAY A PRAYER OR ASK YOUR FLATMATES OR EMAIL ME AT IACOVIEL@BC.EDU
% @ MATTEO IACOVIELLO, 2002

% TO BE RUN TOGETHER WITH COMPANION FILE LEEPER_GO


clear;
close all;

% The loglinearized equations OF THE MODEL are :

% 1) 0 = (I-1)*T(t) + m*( m(t) - m(t-1) + p(t) ) + b(t) - I* ( I(t-1) + b(t-1) - p(t) )  
% 2) 0 = -T(t) + g*b(t-1) + u(t) 
% 3) 0 = m(t) + eta/(I-1) * I(t) - (eta/s)*Y(t)
% 4) 0 = I(t) - a*P(t) - e(t) - ay*Y(t)
% 5) 0 = I(t) - P(t+1) + (1/s) * ( Y(t) - Y(t+1) ) = 0
% 6) 0 = -p(t) + beta *p(t+1) + k * y(t)  

% 1 IS THE GOVT FLOW OF FUNDS
% 2 IS THE TAX RULE
% 3 IS THE MONEY DEMAND EQUATION
% 4 IS THE INTEREST RATE RULE
% 5 IS THE AGGREGATE DEMAND EQUATION
% 6 IS THE PHILLIPS CURVE





% system is described by:

r_u = .9 ; % persistence in deficit process
r_e = .9 ; % persistence in Taylor rule process

m = 1; % ratio M/B, money/public debt
a = 0; % weight on inflation in interest rate rule, greater than 1 means active monetary policy
g = 0; % weight on real public debt in the tax rule, greater than 1 implies passive fiscal policy

eta = 1; % elasticity of money demand to interest rate

beta = .99; % discount rate
te = 1; % steady state inflation

I = te/beta; % ss nominal interest rate



% if you also want price rigidity added to your model you need to calibrate k and s and ay, which are defined below

k = 1000000000; % elasticity of inflation to output, with flexible prices (in the Leeper model) k becomes very large!!
s = 10 ;        % elasticity of substitution in consumption
ay = 0;         % weight on output in the Taylor rule



sd_e = 0.03 ;
sd_u = 0.02 ;

HORIZON=16;



% A BUNCH OF OPTIONS THAT YOU DONT WANT TO CHANGE HERE
axistight=1; grids=1;




% HERE YOU HAVE THE CHANCE TO CALIBRATE A FEW PARAMETERS AND THEN COMPARE THE IMPULSE RESPONSES OF THE MODEL
% CHANGING SOME OF THEM EACH TIME




cha=0; leeper_go

% this is the calibration chosen by Woodford in his 1995 NBER working paper
% woodford NBER WORKING PAPER CALIBRATION 1995

% cha=0; k = .3; beta = .99; s = 1;  eta = 1; m = .1; a = .1; g=0; ay = .1;  r_u = .6;  leeper_go;


