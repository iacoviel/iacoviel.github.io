% RBCFULL_GO: type "help rbcfull" for more help.
% Simulates rbcmodel and calculates asset pricing statistics
% THis version: 28 April 2004

% Hansen real business cycle model with power utility in leisure of the form L^eta');
% see Hansen, G., "Indivisible Labor and the Business Cycle,"');
%          Journal of Monetary Economics, 16 (1985), 281-308.');



% Setting parameters:


% Calculating the steady state:
b   = 1.0/R;  % Discount factor 
YK  = (R + d - 1)/a;  % = Y / K
K   = (YK / Z)^(1.0/(a-1)) * N;
I   = d * K;
Y   = YK * K;
C   = Y - d*K;
A   =  C^(-ro) * (1 - a) * Y/N; % Parameter in utility function


% Declaring the matrices. 

VARNAMES = ['K    ', % capital
            'R    ', % short term interest rate
            'RLT  ', % long term interest rate
            'q    ', % capital shadow price
            'C    ', % consumption
            'Y    ', % income
            'L    ', % labor
            'I    ', % investment
            'A    '];% productivity

% Translating into coefficient matrices.  
% The equations are, conveniently ordered:
% 1) 0 = - I i(t) - C c(t) + Y y(t)
% 2) 0 = I i(t) - K k(t) + (1-d) K k(t-1)
% 3) 0 = a k(t) - y(t) + (1-a) n(t) + a * z(t)
% 4) 0 = -ro c(t) + y(t) - eta n(t) 
% 5) 0 = E_t [ - ro c(t+1) + r(t) + ro c(t) ] 
% 6) 0 = - a Y/K k(t+1) + a Y/K E y(t+1) - R r(t) - fi*d* ( I(t) - K(t) - b*(1-d)*(I(+1)-K(+1)) )
% 7) 0 = RL(t) + ro c(t) 
% 8) 0 = -q(t) + (1-b)*(y(t) - k(t)) + b*(q(t+1)-R(t))
% 9) z(t+1) = psi z(t) + epsilon(t+1)
%
% Endogenous state variables "x(t)": k(t), r(t), rlt(t), q(t)
% Endogenous other variables "y(t)": c(t), y(t), n(t),  i(t)
% Exogenous state variables  "z(t)": z(t).
% 0 = AA x(t) + BB x(t-1) + CC y(t) + DD z(t)
% 0 = E_t [ FF x(t+1) + GG x(t) + HH x(t-1) + JJ y(t+1) + KK y(t) + LL z(t+1) + MM z(t)]
% z(t+1) = NN z(t) + epsilon(t+1) with E_t [ epsilon(t+1) ] = 0,

% 1) 0 = - I i(t) - C c(t) + Y y(t)
% 2) 0 = I i(t) - K k(t) + (1-d) K k(t-1)
% 3) 0 = a k(t) - y(t) + (1-a) n(t) + a * z(t)
% 4) 0 = -ro c(t) + y(t) - eta n(t) 

%     k(t)     R(t)      RL(t)    q(t)    
AA = [ 0        0         0         0       
      -K        0         0         0       
       a        0         0         0       
       0        0         0         0         ];

%    k(t-1)   R(t-1)    RL(t-1)    q(t-1) 
BB = [ 0        0         0         0     
     (1-d)*K    0         0         0       
       0        0         0         0       
       0        0         0         0       ];

%    C(t)     Y(t)      L(t)       I(t)    
CC = [-C        Y         0        -I         % Equ. 1)
       0        0         0         I         % Equ. 2)
       0       -1        1-a        0         % Equ. 3)      
      -ro       1       -eta        0    ];   % Equ. 4)

%     z(t)
DD = [ 0     
       0     
       1     
       0  ] ;


% 5) 0 = - ro c(t+1) + r(t) + ro c(t)  
% 6) 0 = - a Y/K k(t) + a Y/K y(t) - R r(t) - fi*d* ( I(t) - K(t) - b*(1-d)*(I(t+1)-K(t+1)) )
% 7) 0 = -RL(t) + ro c(t) 
% 8) 0 = -q(t) + (1-b)*(y(t) - k(t)) + b*(q(t+1)-R(t))

%        k(t+1)      R(t+1)   RL(t+1)     q(t+1)    
FF = [    0           0           0         0       
  -fi*d*(1-d)/R       0           0         0       
          0           0           0         0       
          0           0           0         b        ];

%        k(t)        R(t)      RL(t)       q(t)   
GG = [    0           1           0         0     
     -a*YK+fi*d      -R           0         0     
          0           0          -1         0     
        -(1-b)       -b           0        -1       ];

%        k(t-1)      R(t-1)    RL(t-1)    q(t-1)  
HH = [    0           0           0         0     
          0           0           0         0     
          0           0           0         0     
          0           0           0         0     ];

%       C(t+1)      Y(t+1)     L(t+1)     I(t+1)      
JJ = [  -ro            0          0         0            
         0             0          0  fi*d*(1-d)/R        
         0             0          0         0   
         0             0          0         0    ];

%       C(t)         Y(t)       L(t)       I(t)        
KK = [   ro            0          0         0          
         0          a*YK          0        -fi*d         
         ro            0          0         0
         0           1-b          0         0     ];

%    z(t+1)
LL = [ 0 
       0 
       0 
       0  ];

%    z(t)
MM = [ 0 
       0 
       0  
       0  ];

NN = [ psi ];

% variance of a*Z(t) is var_e/(1-psi^2) ;
% Lettau sets var(a*Z) = .7^2
% hence var(Z)=.7^2/a^2=var_e/(1-psi^2) --> var_e = .7^2*(1-psi^2)/a^2, Sigma = var_e^.5
var_e = (.7^2)*(1-psi^2)/a^2 ;
SIGMASHOCKS = [ var_e^.5 ];


% Setting the options:

[l_equ,m_states] = size(AA);
[l_equ,n_endog ] = size(CC);
[l_equ,k_exog  ] = size(DD);  

 OO=zeros(size(AA,1),size(KK,2));
 AA1=-[JJ,GG;OO,AA];
 BB1=[KK,HH;CC,BB];
 CC1=pinv(AA1)*BB1;
 eigCC1=eig(CC1);
 SSS1=[MM;DD];
  
 disp('EIGENVALUES')
 disp(eigCC1);
 disp('-----------------------------------------------------------------')
  
 
PERIOD     = 1;  % number of periods per year, i.e. 12 for monthly, 4 for quarterly
GNP_INDEX  = 6 ;  % Index of output among the variables selected for HP filter
IMP_SELECT = 1:(m_states+n_endog+k_exog); % vector containing indices of variables to be plotted
HP_SELECT  = 1:(m_states+n_endog+k_exog); % Selecting the variables for the HP Filter calcs.
TXT_MARKER = 1;

DO_PLOTS = 0;

DISPLAY_AT_THE_END = 0;

varnumber = 4; % number of variables you want to plot

do_it


rats=0;
eviews=0;
autocovariances=0;



varnumber=4; % number of variables you want to plot
shocks = size(MM,2); % number of shocks

SELE1 = [ 3 4 ]; SELE2 = [ 2 ]; SELE3 = [ 1 ]; SELE4 = [ 6 5 8 ];     plot_bc



fontlabel=11;

hold on; subplot(shocks,varnumber,1); ylabel('TECNO SHOCK','fontsize',fontlabel);
 
for ie =  varnumber*(shocks-1)+1  : 1 : shocks*varnumber ; 
          hold on; subplot(shocks,varnumber,ie); xlabel('quarters','fontsize',fontlabel-1); end; clear ie; 


e_cz = SS(1,1) ;
e_ck = RR(1,1) ;
e_kk = PP(1,1) ;

e_kz = QQ(1,1) ;
e_rz = QQ(2,1) ;
e_lz = QQ(3,1) ;
e_qz = QQ(4,1) ;

rbcfull_sim

% The formulas are taken straight from Lettau

disp(' _ formulas are taken from Lettau, Economic Journal paper _ ')
disp('Long bond premium is equation 26')
disp('Equity premium is equation 36')
disp('Sharpe ratio is equation 37')
 disp('__');

   disp('     ro        psi   ')
    zz1=[ro, psi];
    disp(zz1); disp('__');

   disp('    e_kk      e_kz      e_ck      e_cz  ')
    zz2=[    e_kk  ,    e_kz   ,     e_ck    ,    e_cz  ];
    disp(zz2); disp('__');
   
    
    
   disp('long_premium  equity_premium ')
    zz3=[ro*e_cz*e_lz*var_e/100, ro*e_cz*(e_rz+e_lz)*var_e/100];
    disp(zz3); disp('__');

  disp('stdev risk-free  Sharpe_ratio')
    zz4=[stdvec_sim(2),ro*abs(e_cz)*SIGMASHOCKS/100];
    disp(zz4); disp('__');
    
disp('__');
  