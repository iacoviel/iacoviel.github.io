% RBCSYMPLE.M : simple RBC model with zero depreciation
% see Obstfeld and Rogoff "Foundations of International Macroeconomics", page 502 for details
% 
% by iacoviel@bc.edu, January 2005
% to be used with companion instructions in the file REMODELS.TEX




% Setting parameters:

R_bar     = 1;     % Normalization
alfa      = .33;    % Capital share
beta      = .99;   % discount factor
rho       = .98 ;  % autocorrelation of tecnology shock
sigma_eps = .712;  % Standard deviation of  shock.  Units: Percent.





% call

rbcsimple_go