% SIDRAUSKI2_GO : type "help sidrauski2" for more help
disp('THIS M FILE IS CALLED BY SIDRAUSKI2, NEVER RUN IT ALONE!!!')
disp('RUNNING SIDRAUSKI2 MODEL')

pi = te ;
R = 1/be;
ayrk = 1 - (1-d)/be ;
cy = 1 - alfa*d/(R-(1-d));
ky = alfa / (R-(1-d)); 

cm = ((te/(te-be))*((1-a)/a))^(-1/b) ; % ratio c/m in steady state (see Walsh 2nd ed, page 58)

g = 1/(1 + ((1-a)/a)*((1/cm)^(1-b)));

om1 = g*fi + (1-g)*b ;
om2 = (b-fi)*(1-g) ; 

% Declaring the matrices. 
VARNAMES = ['capital  ',
            'output   ',  
            'labour   ',  
            'money    ',
            'real rate',  
            'nominal r',
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

% Equations are

% 	Y_{t} = alfa k_{t-1}+(1-alfa)L_{t}+A_{t}   1
% 	Y_{t} = (C/Y)C_{t}+(K/Y)(K_{t}-(1-d)K_{t-1})   #2
% 	R_{t} = ((alfa*b)Y)/k)(E_{t}Y_{t+1}-K_{t})   #3
%	-R_{t} = om1(C_{t}-C_{t+1}) - om2 (m_{t}-m_{t+1})   #4
% 	eta*L_{t} = Y_{t}- om1 C_{t} + om2 m_{t}   #5
% 	R_{t}+E_{t}Pi_{t+1} = b*(te/be-1) (C_{t}-m_{t})   #6
% 	m_{t}-m_{t-1} = u_{t}-Pi_{t}   #7
%   I(t) = R(t) + E(t)P(t+1)   # 8




% DETERMINISTIC EQUATIONS:

% for x(t):
%       k(t)       y(t)       L(t)       m(t)       r(t)     I(t)    
AA = [   0          -1        1-alfa      0          0        0  % 1  
         ky         -1         0          0          0        0  % 2                   
         0           0         0         -1          0        0  % 7 
         0           1       -eta        om2         0        0];  % 5           


% for x(t-1): 
%       k(t-1)     y(t-1)     L(t-1)     m(t-1)     r(t-1) I(t-1)  
BB = [   alfa        0         0          0          0        0 
       -(1-d)*ky     0         0          0          0        0   
         0           0         0          1          0        0  
         0           0         0          0          0        0 ];
         

% For y(t)
%       p(t)   c(t)  
CC =[    0      0
         0      cy
        -1      0
         0     -om1 ];
         
%        A(t)      u(t)    
DD = [   1         0  
         0         0
         0         1
         0         0 ];
      
      
      
% EXPECTATIONAL EQUATIONS:


% 	R_{t} = ((alfa*b)Y)/k)(E_{t}Y_{t+1}-K_{t})   #3
%	-R_{t} = om1(C_{t}-C_{t+1}) - om2 (m_{t}-m_{t+1})   #4
% 	R_{t}+E_{t}Pi_{t+1} = b*(te/be-1) (C_{t}-m_{t})   #6
%   I(t) = R(t) + E(t)P(t+1)   # 8


% For x(t+1)
%       k(t+1)     y(t+1)     L(t+1)     m(t+1)     r(t+1)  I(t+1)     
FF = [   0         ayrk        0          0          0        0    % 3              
         0           0         0        om2          0        0    % 4              
         0           0         0          0          0        0    % 6              
         0           0         0          0          0        0 ]; % 8            
         
% For x(t)
%       k(t)       y(t)       L(t)       m(t)       r(t)    I(t)     
GG = [ -ayrk         0         0          0         -1        0                     
         0           0         0        -om2         1        0                  
         0           0         0    -b*(te/be-1)    -1        0    % 6              
         0           0         0          0          1       -1  ];
         
% For x(t-1)
%       k(t-1)     y(t-1)     L(t-1)     m(t-1)     r(t-1)  I(t-1)     
HH = [   0           0         0          0          0        0                     
         0           0         0          0          0        0                     
         0           0         0          0          0        0                     
         0           0         0          0          0        0  ];               
         
% For y(t+1)
%      p(t+1)   C(t+1)        
JJ = [   0          0
         0        -om1
        -1          0 
         1          0  ] ; 
       
     
% For y(t)
%       p(t)    c(t)      
KK = [   0         0
         0        om1
         0     b*(te/be-1)
         0         0   ] ;
        
     
% For z(t+1)
%      A(t+1)    u(t+1)
LL = [   0        0    
         0        0
         0        0 
         0        0  ];
         
         
% For z(t)
%      A(t)      u(t)
MM = [   0        0    
         0        0
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
SELE1 = [ 2 ]; SELE2 = [4]; SELE3 = [5]; SELE4 = [7 ];     plot_bc

fontlabel=11;
hold on; subplot(2,4,1); ylabel('PRODUCTIVITY','fontsize',fontlabel);
hold on; subplot(2,4,5); ylabel('MONETARY    ','fontsize',fontlabel);
for ie = 5:1:8; hold on; subplot(2,4,ie); xlabel('years','fontsize',fontlabel-1); end; clear ie;

