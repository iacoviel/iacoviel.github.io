disp('THIS M FILE IS CALLED BY SIDRAUSKI, NEVER RUN IT ALONE!!!')
disp('RUNNING SIDRAUSKI MODEL')



R = 1/be;
ayrk = 1 - (1-d)/be ;
cy = 1 - a*d/(be-(1-d));
ky = a / (be-(1-d)); 


% Declaring the matrices. 

VARNAMES = ['capital  ',
            'output   ',  
            'labour   ',  
            'money    ',
            'real rate',  
            'inflation',  
            'consumpti',
            'A        ',  
            'u        ']; 
   
   
% Translating into coefficient matrices.  
% The loglinearized equations are, conveniently ordered:

% CHECK: 7 equations, 7 variables.
%
% Endogenous state variables "x(t)": 
% Endogenous other variables "y(t)": 
% Exogenous state variables  "z(t)": A(t), u(t)

% 0 = AA x(t) + BB x(t-1) + CC y(t) + DD z(t)
% 0 = E_t [ FF x(t+1) + GG x(t) + HH x(t-1) + JJ y(t+1) + KK y(t) + LL z(t+1) + MM z(t)]
% z(t+1) = NN z(t) + epsilon(t+1) with E_t [ epsilon(t+1) ] = 0,



% DETERMINISTIC EQUATIONS:

% for x(t):
%       k(t)       y(t)       L(t)       m(t)       r(t)         
AA = [   0          -1        1-a         0          0            
         ky         -1         0          0          0                             
         0           0         0         -1          0           
         0           1       -eta      b*(1-fi)      0         ];             


% for x(t-1): 
%       k(t-1)     y(t-1)     L(t-1)     m(t-1)     r(t-1)       
BB = [   a           0         0          0          0          
       -(1-d)*ky     0         0          0          0           
         0           0         0          1          0          
         0           0         0          0          0      ];
         

% For y(t)
%       p(t)   c(t)  
CC =[    0      0
         0      cy
        -1      0
         0      -fi ];
         
%        A(t)      u(t)    
DD = [   1         0  
         0         0
         0         1
         0         0 ];
      
      
      
% EXPECTATIONAL EQUATIONS:


% For x(t+1)
%       k(t+1)     y(t+1)     L(t+1)     m(t+1)     r(t+1)     
FF = [   0         ayrk         0          0         0                             
         0           0         0       -b*(1-fi)     0                             
         0           0         0          0          0               ];             
         
% For x(t)
%       k(t)       y(t)       L(t)       m(t)       r(t)         
GG = [ -ayrk         0         0          0         -1                             
         0           0         0       b*(1-fi)     -1                             
         0           0         0      -(pi-be)/be   -1               ];
         
% For x(t-1)
%       k(t-1)     y(t-1)     L(t-1)     m(t-1)     r(t-1)       
HH = [   0           0         0          0          0                             
         0           0         0          0          0                             
         0           0         0          0          0              ];               
         
% For y(t+1)
%      p(t+1)   C(t+1)        
JJ = [   0          0
         0          fi
        -1          0  ] ; 
       
     
% For y(t)
%       p(t)    c(t)      
KK = [   0          0
         0      -fi
         0      (pi-be)/be  ] ;
        
     
% For z(t+1)
%      A(t+1)    u(t+1)
LL = [   0        0    
         0        0
         0        0 ];
         
         
% For z(t)
%      A(t)      u(t)
MM = [   0        0    
         0        0
         0        0 ];
    
    
% AUTOREGRESSIVE MATRIX FOR z(t)
NN1 = [ r_a r_u ];
NN = diag(NN1);
NN(1,2) = corr_a_u ; N(2,1) = corr_a_u ;


Sigma1 = [ sd_a sd_u ] ;
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
HORIZON=40 ;
TXT_MARKER = 1;

DO_PLOTS = 0;

DISPLAY_AT_THE_END = 0;



varnumber = 4; % number of variables you want to plot



do_it
SELE1 = [ 2 ]; SELE2 = [4]; SELE3 = [5]; SELE4 = [6];     plot_bc


fontlabel=11;
hold on; subplot(2,4,1); ylabel('PRODUCTIVITY','fontsize',fontlabel);
hold on; subplot(2,4,5); ylabel('MONETARY    ','fontsize',fontlabel);
for ie = 5:1:8; hold on; subplot(2,4,ie); xlabel('years','fontsize',fontlabel-1); end; clear ie;