% MC_GO: executes MC, type "help mc" for more help


% Declaring the matrices. 

VARNAMES = ['Rate     ',  % NOMINAL INTEREST RATE
            'output   ',  % GDP
            'inflation',  % INFLATION
            'v        ',  % IS SHOCK TERM
            'ybar     ',  % POTENTIAL OUTPUT TERM
            'u        ',  % INFLATION SHOCK TERM
            'e        ']; % MONETARY POLICY SHOCK TERM
         
        
        
% Translating into coefficient matrices.  
% The loglinearized equations are, conveniently ordered:

% 1) -r(t) + (1-m3)*(1+m1)*p(t) + m2*(1-m3)*y(t) - m2*(1-m3)*ybar(t) + m3*r(t-1) + e(t)
% 2) -y(t) + b1*r(t) - b1*p(t+1) + (1-te)*y(t+1) + te*y(t-1) + v(t)
% 3) -p(t) + b *p(t+1) + a * [ y(t) - ybar(t) ] + u(t) 
% 4)  v(t)    = rv     * v(t-1)    + e_v(t)
% 5)  ybar(t) = r_ybar * ybar(t-1) + e_ybar(t)
% 6)  u(t)    = ru     * u(t-1)    + e_u(t)
% 7)  e(t)    = re     * e(t-1)    + e_e(t)

% CHECK: 7 equations, 7 variables.
%
% Endogenous state variables "x(t)": r(t), y(t)
% Endogenous other variables "y(t)": p(t)
% Exogenous state variables  "z(t)": v(t), ybar(t), u(t), e(t).

% Switch to that notation.  Find matrices for format
% 0 = AA x(t) + BB x(t-1) + CC y(t) + DD z(t)
% 0 = E_t [ FF x(t+1) + GG x(t) + HH x(t-1) + JJ y(t+1) + KK y(t) + LL z(t+1) + MM z(t)]
% z(t+1) = NN z(t) + epsilon(t+1) with E_t [ epsilon(t+1) ] = 0,



% DETERMINISTIC EQUATIONS:
% 1) -r(t) + (1-m3)*(1+m1)*p(t) + m2*(1-m3)*y(t) - m2*(1-m3)*ybar(t) + m3*r(t-1) + e(t)

% for x(t):
%      R(t)     y(t)
AA = [ -1        m2*(1-m3)  ];
       
% for x(t-1): 
%      R(t-1)   y(t-1)
BB = [ m3         0  ] ;

% For y(t)
%       p(t)  
CC =[ (1-m3)*(1+m1) ];    

%        v(t)   ybar(t)    u(t)    e(t)
DD = [    0    -m2*(1-m3)   0        1    ];
      
      
      
% EXPECTATIONAL EQUATIONS:
% 2) -y(t) + b1*r(t) - b1*p(t+1) + (1-te)*y(t+1) + te*y(t-1) + v(t)
% 3) -p(t) + b *p(t+1) + a* [ y(t) - ybar(t) ] + u(t) 

% For x(t+1)
%       R(t+1)   y(t+1)  
FF = [    0      1-te   
          0        0    ]  ; 

% For x(t)
%        R(t)     y(t)
GG = [    b1      -1  
           0       a ]; 

% For x(t-1)
%        R(t-1)   y(t-1)
HH = [    0       te    
          0        0 ]  ;  

% For y(t+1)
%      p(t+1)        
JJ = [  -b1
        b   ] ; 
       
     
% For y(t)
%       p(t)      
KK = [   0
        -1  ] ;
        
     
% For z(t+1)
%     v(t+1)    ybar(t+1) u(t+1)      e(t+1)
LL = [  0        0          0           0   
        0        0          0           0    ];

% For z(t)
%     v(t)     ybar(t)     u(t)        e(t)
MM = [  1         0         0           0   
        0        -a         1           0    ];
    
    
% AUTOREGRESSIVE MATRIX FOR z(t)
NN1 = [ r_v r_ybar r_u r_e];
NN = diag(NN1);

Sigma1 = [ sd_v sd_ybar sd_u sd_e ] ;
Sigma = diag(Sigma1.^2) ;
          
          
          
% Setting the options:

[l_equ,m_states] = size(AA);
[l_equ,n_endog ] = size(CC);
[l_equ,k_exog  ] = size(DD);



OO=zeros(size(AA,1),size(KK,2));
AA1=-[JJ,GG;OO,AA];
BB1=[KK,HH;CC,BB];
CC1=AA1^(-1)*BB1;
eigCC1=eig(CC1);
SSS1=[MM;DD];


disp('EIGENVALUES')
disp(eigCC1);
disp('-----------------------------------------------------------------')

  

  
PERIOD     = 4;  % number of periods per year, i.e. 12 for monthly, 4 for quarterly
GNP_INDEX  = 2;  % Index of output among the variables selected for HP filter
IMP_SELECT = 1:(m_states+n_endog+k_exog); % vector containing indices of variables to be plotted
HP_SELECT  = 1:(m_states+n_endog+k_exog); % Selecting the variables for the HP Filter calcs.
HORIZON=20 ;
TXT_MARKER = 1;

DO_PLOTS = 0;

DISPLAY_AT_THE_END = 0;

do_it

varnumber=3; % number of variables you want to plot

SELE1 = [ 1 ]; SELE2 = [2]; SELE3 = [3]; plot_bc


fontlabel=11;
hold on; subplot(4,3,1); ylabel('IS SHOCK','fontsize',fontlabel);
hold on; subplot(4,3,4); ylabel('POTENTIAL Y','fontsize',fontlabel);
hold on; subplot(4,3,7); ylabel('INFLATION','fontsize',fontlabel);
hold on; subplot(4,3,10); ylabel('MONETARY','fontsize',fontlabel);


for ie = 10:1:12; hold on; subplot(4,3,ie); xlabel('years','fontsize',fontlabel-1); end; clear ie;