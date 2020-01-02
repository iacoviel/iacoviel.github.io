% RBCFULL: simulates RBC model and calculates asset pricing statistics: model based on Lettau, Economic Journal, 2003
% see RBCFULL_GO for details
% THis version: 28 April 2004

clear; close all


% Setting parameters:

N     = 1.0/3;  % Steady state employment is a third of total time endowment
Z     = 1;      % Normalization
a     = 0.333 ;  % Capital share
d     = 0.025;  % Depreciation rate for capital
R     = 1.015;   % One percent real interest per quarter

ro       = 1 ; % constant of relative risk aversion = 1/(coeff. of intertemporal substitution)

psi       = .95 ; % autocorrelation of technology shock
% for stdev of technology shock, see matrix Sigma

% adjustment cost for capital
fi = 0;

eta = 1000 ; % labor supply elasticity is 1/(eta-1)

HORIZON=41 ;
DO_HP_FILTER = 0;

grids = 1; 
axistight = 1;


% TABLE 1, penultimate row
eta = 200000; % zero LS elasticity
ro = 1; % relative risk aversion
psi = 0.95; % persistence in productivity



rbcfull_go;
