
% MC3.M : simple three equations DNK model  a-la McCallum
% McCALLUM, BENNETT T. (2001), "Should monetary policy respond strongly to Output Gaps?", 
% AER papers and proceedings, 91, 2, page 259
%
% This is a modified version of mc.m which features:
% - only 3 shocks (potential output ybar is assumed constant)
% - no lagged output in the demand equation


clear;
close all;


% system is described by:
% 1) -r(t) + (1-m3)*(1+m1)*p(t) + m2*(1-m3)*y(t) + m3*r(t-1) + e(t) = 0
% 2) -y(t) + te*r(t) - te*p(t+1) + y(t+1) + v(t) = 0
% 3) -p(t) + b *p(t+1) + a * [ y(t) - ybar(t) ] + u(t) = 0


te = 1 ; % elasticity of substitution in consumption
b = .99 ; % discount rate
a = .03 ; % elasticity of inflation to output

m1 = 1 ; % weight on inflation over and above 1 in the Taylor rule
m2 = 1 ; % weight on output in Taylor rulle
m3 = .8 ;  % interest rate smoothing term

r_v = 0 ; % persistence in IS shock
r_u = 0 ; % persistence in inflation shock
r_e = 0 ; % persistence in monetary shock



% A BUNCH OF OPTIONS THAT YOU DONT WANT TO CHANGE HERE
axistight=1; grids=1;


% HERE YOU HAVE THE CHANCE TO CALIBRATE A FEW PARAMETERS AND THEN COMPARE THE IMPULSE RESPONSES OF THE MODEL
% CHANGING SOME OF THEM EACH TIME

sd_v = 1 ;
sd_u = 1 ;
sd_e = 1 ;

mc3_go ; % RUNS THE MODEL, DONT CHANGE 

