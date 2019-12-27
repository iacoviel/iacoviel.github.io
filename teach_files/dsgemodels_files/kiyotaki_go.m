% kiyotaki_go
% develops a version of the Kiyotaki and Moore (1997) model without minimum consumption requirement
% for help, see Chapter 3 of my BC lecture notes in Graduate Macro
% 2002/2003

% CALCULATING STEADY STATE
f = m*b + (1-m)*g ;
h = 1 - (b*mu*aa*(1-f)/(g*(1-b)))^(1/(1-mu)) ;
eta = (1-h)/h/(1-mu) ;

eyh = ((1-aa*mu*(1-h)^(mu-1))/(h+aa*(1-h)^mu))*h ;


% Declaring the matrices. 

VARNAMES = ['H     ',  
            'B     ',  
            'Q     ',  
            'C     ',
            'A     '];            
        
% Endogenous state variables "x(t)": H B Q
% Endogenous other variables "y(t)": C
% Exogenous state variables  "z(t)": A

% Switch to that notation.  Find matrices for format
% 0 = AA x(t) + BB x(t-1) + CC y(t) + DD z(t)
% 0 = E_t [ FF x(t+1) + GG x(t) + HH x(t-1) + JJ y(t+1) + KK y(t) + LL z(t+1) + MM z(t)]
% z(t+1) = NN z(t) + epsilon(t+1) with E_t [ epsilon(t+1) ] = 0,

% THE LINEARIZED EQUATIONS
% (c/(qh))*c{t} + h{t} + m*b{t-1} = ((1-f)/g)*A{t} + ((1- f + g)/g)*h{t-1} + b*m*b{t}
% b{t} = q{t+1} + h{t}
% q{t} = f*q{t+1} + (1-f)A{t+1}
% q{t} = b*q{t+1} + (1-b)*(A{t+1} + h{t}/eta)

% where c/(qh)=(1-f)/g-m*(1-b) 


% DETERMINISTIC EQUATIONS
% for x(t):
%       H               B         Q 
AA = [ -1             m*b         0 ];
       
% for x(t-1): 
%       H               B         Q
BB = [(1- f + g)/g      -m         0  ];   

% For y(t)
%       C                  
CC =[-(1-f)/g+m*(1-b)     ];    

%       A
DD = [(1-f)/g  ];


            
% EXPECTATIONAL EQUATIONS:

% For x(t+1)
%        H         B     Q
FF = [   0         0     1
         0         0     f 
         0         0     b  ]  ; 
     
% For x(t)      
GG = [   1       -1      0
         0        0     -1
      (1-b)/eta   0     -1 ]; 

% For x(t-1)
HH = [    0        0     0
          0        0     0
          0        0     0 ]  ;  

%     C(t+1)   
JJ = [  0       
        0       
        0          ] ; 
       
%      C(t)    
KK = [  0        
        0       
        0         ] ;
        
%      A(t+1)
LL = [  0 
       1-f
       1-b ];

%      A(t)
MM = [  0   
        0   
        0    ];


    
% AUTOREGRESSIVE MATRIX FOR z(t)
NN1 = [ ro ];
NN = diag(NN1);

Sigma1 = [ 1 ] ;
Sigma = diag(Sigma1.^2) ;
          
          
          
% Setting the options:

[l_equ,m_states] = size(AA);
[l_equ,n_endog ] = size(CC);
[l_equ,k_exog  ] = size(DD);

  
PERIOD     = 4;  % number of periods per year, i.e. 12 for monthly, 4 for quarterly
GNP_INDEX  = 2;  % Index of output among the variables selected for HP filter
IMP_SELECT = 1:(m_states+n_endog+k_exog); % vector containing indices of variables to be plotted
HP_SELECT  = 1:(m_states+n_endog+k_exog); % Selecting the variables for the HP Filter calcs.
HORIZON=8 ;
TXT_MARKER = 1;

DO_PLOTS = 0;

do_it

varnumber=4; % number of variables you want to plot

% here you select the variables you want to plot

SELE1 = [ 1 ]; % first variable plotted is h
SELE2 = [2]; % ....
SELE3 = [3]; 
SELE4 = [5];     
plot_bc


fontlabel=11;
hold on; subplot(1,4,1); ylabel('% deviations from ss','fontsize',fontlabel);