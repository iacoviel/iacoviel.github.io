
% mc.M : simple three equations DNK model  a-la McCallum
% McCALLUM, BENNETT T. (2001), "Should monetary policy respond strongly to Output Gaps?", 
% AER papers and proceedings, 91, 2, page 259


clear;
close all;


% system is described by:
% 1) -r(t) + (1-m3)*(1+m1)*p(t) + m2*(1-m3)*y(t) - m2*(1-m3)*ybar(t) + m3*r(t-1) + e(t)
% 2) -y(t) + b1*r(t) - b1*p(t+1) + (1-te)*y(t+1) + te*y(t-1) + v(t)
% 3) -p(t) + b *p(t+1) + a * [ y(t) - ybar(t) ] + u(t) 


b1 = -1 ; % elasticity of substitution in consumption
b = .99 ; % discount rate
a = .03 ; % elasticity of inflation to output gap

m1 = .2 ; % weight on inflation over and above 1 in the Taylor rule
m2 = 0 ; % weight on output gap in Taylor rulle
m3 = .8 ;  % interest rate smoothing term

r_v = 0.8 ; % persistence in IS shock
r_u = 0.8 ; % persistence in inflation shock
r_e = 0 ; % persistence in monetary shock
r_ybar = 0.8 ; % persistene in output gap shock

sd_v = 0.03 ;
sd_u = 0.02 ;
sd_e = 0.0017 ;
sd_ybar = 0.007 ;

te = 0 ; % backward output is IS



% A BUNCH OF OPTIONS THAT YOU DONT WANT TO CHANGE HERE
axistight=1; grids=1;


% HERE YOU HAVE THE CHANCE TO CALIBRATE A FEW PARAMETERS AND THEN COMPARE THE IMPULSE RESPONSES OF THE MODEL
% CHANGING SOME OF THEM EACH TIME

% FIRST CALIBRATION. 
cha=0; % CHA=0 MEANS THAT THE IRF WILL BE BLUE/TRIANGLES
mc_go ; % RUNS THE MODEL, DONT CHANGE 