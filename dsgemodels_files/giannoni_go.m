% Declaring the matrices. 

VARNAMES = ['\xi 1      '
            '\xi 2      '
            'r          '
            '\pi        '
            'x          '  
            'u          ',  % s1
            'e          ']; % S2
         
% The loglinearized equations are, conveniently ordered:

% 1) 0 = p(t) - (b*s)^(-1)*f1(t-1) + f2(t) - f2(t-1)  
% 2) 0 = lx*x(t) + f1(t) - f1(t-1)/b - k*f2(t)
% 3) 0 = lr*r(t) + f1(t)/s
% 4) 0 = -p(t) + b *p(t+1) + k * y(t) - u(t)
% 5) 0 = r(t) - p(t+1) - n(t) + s*x(t) - s*x(t+1) = 0

% CHECK: 5 equations, 5 variables.
% Endogenous state variables "x(t)": f1(t), f2(t), r(t)
% Endogenous other variables "y(t)": P(t), x(t)
% Exogenous state variables  "z(t)": n(t), u(t).

% 0 = AA x(t) + BB x(t-1) + CC y(t) + DD z(t)
% 0 = E_t [ FF x(t+1) + GG x(t) + HH x(t-1) + JJ y(t+1) + KK y(t) + LL z(t+1) + MM z(t)]
% z(t+1) = NN z(t) + epsilon(t+1) with E_t [ epsilon(t+1) ] = 0,


% DETERMINISTIC EQUATIONS:

% 1) 0 = p(t) - (b*s)^(-1)*f1(t-1) + f2(t) - f2(t-1)  
% 2) 0 = lx*x(t) + f1(t) - f1(t-1)/b - k*f2(t)
% 3) 0 = lr*r(t) + f1(t)/s


% for x(t):
%     f1(t)       f2(t)        I(t)        
AA = [  0           1           0          
        1          -k           0        
       1/s          0          lr    ];

% for x(t-1): 
%     f1(t-1)     f2(t-1)     I(t-1)        
BB = [ -1/(b*s)    -1           0          
       -1/b         0           0        
        0           0           0    ];
    
% For y(t)
%       p(t)        x(t)  
CC =[   1           0    
        0          lx
        0           0   ];    
    
%        n(t)     u(t)
DD = [     0        0
           0        0
           0        0        ];
      
      
      
% EXPECTATIONAL EQUATIONS:
% 4) 0 = -p(t) + b *p(t+1) + k * x(t) + u(t)
% 5) 0 = r(t) - p(t+1) - n(t) + s*x(t) - s*x(t+1) = 0

% For x(t+1)
%     f1(t+1)     f2(t+1)      I(t+1)        
FF = [  0           0           0          
        0           0           0    ];

% For x(t)
%     f1(t)      f2(t)      I(t)        
GG = [  0           0         0          
        0           0         1    ];

% For x(t-1)
%     f1(t-1)     f2(t-1)      I(t-1)        
HH = [  0           0           0          
        0           0           0    ];

% For y(t+1)
%      p(t+1)     x(t+1)        
JJ = [   b          0
        -1         -s   ];       
     
% For y(t)
%      p(t)       x(t)        
KK = [  -1          k
         0          s   ];       
        
     
% For z(t+1)
%      n(t+1)      u(t+1)
LL = [   0           0   
         0           0    ];

% For z(t)
%      n(t)        u(t)
MM = [   0           1
        -1           0    ];
    
    
% AUTOREGRESSIVE MATRIX FOR z(t)
NN1 = [ r_n r_u];
NN = diag(NN1);

Sigma1 = [ sd_n sd_u ] ;
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

varnumber=4; % number of variables you want to plot
shocks = size(MM,2); % number of shocks

SELE1 = [ 5 ]; SELE2 = [3]; SELE3 = [4]; SELE4 = [6 7];     plot_bc


fontlabel=11;
hold on; subplot(shocks,varnumber,1); ylabel('DEMAND SHOCK','fontsize',fontlabel);
hold on; subplot(shocks,varnumber,varnumber+1); ylabel('INFLATION SHOCK','fontsize',fontlabel);


for ie =  varnumber*(shocks-1)+1  : 1 : shocks*varnumber ; 
    hold on; subplot(shocks,varnumber,ie); xlabel('years','fontsize',fontlabel-1); end; clear ie;