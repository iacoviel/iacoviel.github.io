% by iacoviel@bc.edu, 8 october 2002
% to be used with companion instructions in the file

disp('EXAMPLE: simple NEOCLASSICAL GROWTH MODEL WITHOUT DEPRECIATION');




% Setting parameters:

R_bar     = 1;     % Normalization
alfa      = .5;    % Capital share
delta     = 1;     % Depreciation rate for capital
beta      = .98;   % discount factor
rho       = .0 ;  % autocorrelation of tecnology shock
sigma_eps = .712;  % Standard deviation of  shock.  Units: Percent.


% Calculating the steady state:

R  = 1/beta  % Interest rate pre-shock
CK = (1-beta)/(alfa*beta) % consumption-capital ratio
ata = (1-alfa)*(1-beta)/(alfa*beta)
atu = (1-alfa)*(1-beta)

% Declaring the matrices. 

VARNAMES = ['capital       ',
            'consumption   ',
            'TECNOLOGY     '];
         
        
        
% Translating into coefficient matrices.  
% The loglinearized equations are, conveniently ordered:

% 1) 0 = k(t) -  R * k(t-1) +  CK * c(t) + ata*z(t)

% 2) 0 = E_t [ c(t+1) - c(t) + (1-alfa)*(1-beta)*k(t) + atu*z(t) ]

% 3) z(t) = rho*z(t-1) + epsilon(t)


% CHECK: 3 equations, 3 variables.
%
% Endogenous state variables "x(t)": k(t)
% Endogenous other variables "y(t)": c(t)
% Exogenous state variables  "z(t)": z(t).
% Switch to that notation.  Find matrices for format
% 0 = AA x(t) + BB x(t-1) + CC y(t) + DD z(t)
% 0 = E_t [ FF x(t+1) + GG x(t) + HH x(t-1) + JJ y(t+1) + KK y(t) + LL z(t+1) + MM z(t)]
% z(t+1) = NN z(t) + epsilon(t+1) with E_t [ epsilon(t+1) ] = 0,

% DETERMINISTIC EQUATIONS:

% for x(t):
%      k(t)  
AA = [ 1   ];   % 1 eq
     
% for x(t-1): 
%     k(t-1)     
BB = [ -R    ]   % 1 eq
     
% For y(t)
%        c(t)
CC = [  CK  ];   % 1 eq

% For z(t):
%      z(t) 
DD =  [ -ata  ]  % 
             

% EXPECTATIONAL EQUATIONS:
% 5) 0 = E_t [ c(t+1) - c(t) + (1-alfa)*(1-beta)*k(t) + atu*z(t) ]

% For x(t+1)
%      k(t+1)   
FF = [  0   ];    % 5 eq

% For x(t)
%      k(t)     
GG = [ (1-alfa)*(1-beta)   ]   ;   % 4 eq

% For x(t-1)
%      k(t-1) 
HH = [  0     ];  % 5 eq

% For y(t+1)
%      c(t+1)
JJ = [  1  ];   % 5 eq
        
% For y(t)
%      c(t)
KK = [    -1  ];   % 5 eq
        
     
% For z(t+1)
%      r(t+1)  
LL = [    -atu    ]; %   5 eq

% For z(t)
%     r(t)  
MM = [   0  ];
    
    
% AUTOREGRESSIVE MATRIX FOR z(t)
NN = [  rho ];


Sigma = [ sigma_eps^2]




OO=zeros(size(AA,1),size(KK,2));
AA1=-[JJ,GG;OO,AA];
BB1=[KK,HH;CC,BB];
CC1=AA1^(-1)*BB1;
eigCC1=eig(CC1);
SSS1=[MM;DD];


disp('EIGENVALUES')
disp(eigCC1);
disp('-----------------------------------------------------------------')





% Setting the options:

[l_equ,m_states] = size(AA);
[l_equ,n_endog ] = size(CC);
[l_equ,k_exog  ] = size(DD);

  
PERIOD     = 4;  % number of periods per year, i.e. 12 for monthly, 4 for quarterly
GNP_INDEX  = 1;  % Index of output among the variables selected for HP filter
IMP_SELECT = [ 1 2 ] ;
   %  a vector containing the indices of the variables to be plotted
HP_SELECT  = 1:(m_states+n_endog+k_exog); % Selecting the variables for the HP Filter calcs.


% Starting the calculations:

do_it;
