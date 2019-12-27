% THIS FILE IS called by leeper.M, never run it alone!!!

% Declaring the matrices. 

VARNAMES = ['debt      ',  % DEBT
            'real money',  % REAL MONEY
            'int.rates ',  % NOMINAL RATES
            'taxes     ',  % TAXES
            'output    ',  % OUTPUT
            'inflation ',  % INFLATION
            'u         ',  % FPS
            'e         ']; % MPS
         
% The loglinearized equations are, conveniently ordered:

% 1) 0 = (I-1)*T(t) + m*( m(t) - m(t-1) + p(t) ) + b(t) - I* ( I(t-1) + b(t-1) - p(t) )  
% 2) 0 = -T(t) + g*b(t-1) + u(t) 
% 3) 0 = m(t) + eta/(I-1) * I(t) - (eta/s)*Y(t)
% 4) 0 = I(t) - a*P(t) - e(t) - ay*Y(t)
% 5) 0 = I(t) - P(t+1) + (1/s) * ( Y(t) - Y(t+1) ) = 0
% 6) 0 = -p(t) + beta *p(t+1) + k * y(t)  


% CHECK: 6 equations, 6 variables.
% Endogenous state variables "x(t)": b(t), m(t), I(t), T(t), Y(t)
% Endogenous other variables "y(t)": P(t)
% Exogenous state variables  "z(t)": e(t), u(t).

% 0 = AA x(t) + BB x(t-1) + CC y(t) + DD z(t)
% 0 = E_t [ FF x(t+1) + GG x(t) + HH x(t-1) + JJ y(t+1) + KK y(t) + LL z(t+1) + MM z(t)]
% z(t+1) = NN z(t) + epsilon(t+1) with E_t [ epsilon(t+1) ] = 0,

if a>1 & g<1 ; disp('ACTIVE MONETARY POLICY AND ACTIVE FISCAL POLICY'); end
if a>1 & g>1 ; disp('ACTIVE MONETARY POLICY AND PASSIVE FISCAL POLICY'); end
if a<1 & g<1 ; disp('PASSIVE MONETARY POLICY AND ACTIVE FISCAL POLICY'); end
if a<1 & g>1 ; disp('PASSIVE MONETARY POLICY AND PASSIVE FISCAL POLICY'); end



% DETERMINISTIC EQUATIONS:

% 1) 0 = (I-1)*T(t) + m*( m(t) - m(t-1) + p(t) ) + b(t) - I* ( I(t-1) + b(t-1) - p(t) )  
% 2) 0 = -T(t) + g*b(t-1) + u(t) 
% 3) 0 = m(t) + eta/(I-1) * I(t) - (eta/s)*Y(t)


% for x(t):
%      b(t)        m(t)        I(t)         T(t)        Y(t)
AA = [  1           m           0           I-1          0
        0           0           0           -1           0
        0           1        eta/(I-1)       0        -(eta/s)   ];

% for x(t-1): 
%      b(t-1)     m(t-1)      I(t-1)       T(t-1)     Y(t-1)
BB = [ -I          -m          -I            0           0
        g           0           0            0           0
        0           0           0            0           0 ];
    
% For y(t)
%       p(t)  
CC =[   m+I    
        0
        0   ];    
    
%        u(t)     e(t)
DD = [     0        0
           1        0
           0        0        ];
      
      
      
% EXPECTATIONAL EQUATIONS:
% 4) 0 = I(t) - a*P(t) - e(t) - ay*Y(t)
% 5) 0 = I(t) - P(t+1) + (1/s) * ( Y(t) - Y(t+1) ) = 0
% 6) 0 = -p(t) + beta *p(t+1) + k * y(t)  

% For x(t+1)
%      b(t+1)     m(t+1)      I(t+1)       T(t+1)      Y(t+1)
FF = [    0        0             0            0          0
          0        0             0            0        -1/s
          0        0             0            0          0 ]  ; 

% For x(t)
%        b(t)     m(t)          I(t)        T(t)        Y(t)
GG = [    0        0             1            0        -ay
          0        0             1            0         1/s  
          0        0             0            0          k ]  ; 

% For x(t-1)
%      b(t-1)     m(t-1)      I(t-1)       T(t-1)       Y(t-1)
HH = [    0        0             0            0          0
          0        0             0            0          0
          0        0             0            0          0   ]  ; 

% For y(t+1)
%      p(t+1)        
JJ = [   0
        -1  
        beta] ; 
       
     
% For y(t)
%       p(t)      
KK = [  -a
         0
         -1] ;
        
     
% For z(t+1)
%      u(t+1)      e(t+1)
LL = [   0           0   
         0           0   
         0           0    ];

% For z(t)
%      u(t)        e(t)
MM = [   0          -1
         0           0
         0           0    ];
    
    
% AUTOREGRESSIVE MATRIX FOR z(t)
NN1 = [ r_u r_e];
NN = diag(NN1);

Sigma1 = [ sd_u sd_e ] ;
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
TXT_MARKER = 1;

DO_PLOTS = 0;

DISPLAY_AT_THE_END = 0;

do_it

varnumber=5; % number of variables you want to plot
shocks = size(MM,2); % number of shocks

SELE1 = [ 1  ]; SELE2 = [ 2  ]; SELE3 = [3]; SELE4 = [6]; SELE5 = [7 8];   

if k<1000
    SELE1 = [ 5 ]; SELE2 = [ 1 2];
end

  plot_bc

fontlabel=11;
hold on; subplot(shocks,varnumber,1); ylabel('CONTRACTIONARY FPS','fontsize',fontlabel);
hold on; subplot(shocks,varnumber,varnumber+1); ylabel('CONTRACTIONARY MPS','fontsize',fontlabel);



for ie =  varnumber*(shocks-1)+1  : 1 : shocks*varnumber ; 
    hold on; subplot(shocks,varnumber,ie); xlabel('years','fontsize',fontlabel-1); end; clear ie;