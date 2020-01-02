% MANKIWREIS_GO : type "help mankiwreis" for more help
% @Matteo 27 April 2004
%
% How to deal with expectations taken as of t-1 ?
% consider the following equation
%  p(t) = E(t-1) p(t+1)  - kappa * E(t-1) X(t)
% as a matter of fact, p(t) is known as of time t, hence p(t) will be a state variable
%
% which means that you will define additional variable p(t+1) - besides p(t) - and then 
% will set p(t) = Lagged p(t+1) in the set of deterministic equations
%
% ...as for the equation itself,
% scroll it forward p(t+1) = E(t) p(t+2)  - kappa * E(t) X(t+1)
% fill the matrix FF with these three coefficients...

% Declaring the matrices. 

VARNAMES1 = ['z           '
             'y           '  
             'p           '  
             'w(t)        '
             '\pi         '
             'm           ']; 


FILL(1:lags,1:cols(VARNAMES1))=['x']   ;        

VARNAMES = [ VARNAMES1(1:4,1:cols(VARNAMES1))         
                    FILL
             VARNAMES1(5:6,1:cols(VARNAMES1)) ];
         
% Endogenous state variables "x(t)": 
% Endogenous other variables "y(t)": 
% Exogenous state variables  "z(t)": A(t), u(t)

% 0 = AA x(t) + BB x(t-1) + CC y(t) + DD z(t)
% 0 = E_t [ FF x(t+1) + GG x(t) + HH x(t-1) + JJ y(t+1) + KK y(t) + LL z(t+1) + MM z(t)]
% z(t+1) = NN z(t) + epsilon(t+1) with E_t [ epsilon(t+1) ] = 0,

% 	z(t) = a ( y(t) - y(t-1) ) + Dp(t)
%  Dp(t) = p(t) - p(t-1)
%   m(t) = p(t) + y(t)
%  Dp(t) = s [ a/(1-s)*y(t) + E(t-1)z(t) + (1-s)E(t-2)z(t) + ...
%                         + (1-s)^2 E(t-3)z(t) + + (1-s)^3 E(t-4)z(t) + (1-s)^4/s E(t-5)z(t) ] + u(t)
% w(t-1) = E(t-1)z(t) = L{w(t)}
% w(t-2) = E(t-2)z(t) = L{w(t-1)}
% .... and so on

% DETERMINISTIC EQUATIONS:
% X(t)
%       z(t)    y(t)    p(t)   w(t)    
AA1 = [ -1      a       0       0       
         0      0       1       0       
         0      1       1       0       
         0    s*a/(1-s) 0       0  ]; 
     
%  POLYMAT = zeros(1,lags);
%  HERE I fill the AA and BB matrix with as many lags as possible...
for i=1:1:lags;   POLYMAT(1,i)=s*(1-s)^(i-1) ; end
     
AA = [ AA1(1:3,1:4)  zeros(3,lags)
       AA1(4,1:4)     POLYMAT
      zeros(lags,4)  eye(lags,lags)  ];
    
% X(t-1): 
%       z(t-1) y(t-1)  p(t-1)  w(t-1) 
BB1 = [  0     -a       0       0     
         0      0      -1       0     
         0      0       0       0     
         0      0       0       0    ];
     
BB = [         BB1(1:3,1:4)                  zeros(3,lags)
                BB1(4,1:4)             zeros(1,lags-1) (1-s)^(lags-1)
      zeros(lags,3)    -eye(lags,lags)       zeros(lags,1)            ];
          
% Y(t)
%      Dp(t)  
CC1 =[   1 
        -1
         0
        -1  ];
    
CC = [ CC1
      zeros(lags,1) ];
         
%       m(t)          
DD1 = [  0              % 
         0              % 
        -1            % 
         0         ]; % 
      
DD = [ DD1
      zeros(lags,1) ];

     
% EXPECTATIONAL EQUATIONS:
% w(t-1) =: E(t-1)z(t)  forwarded one period

% E(t)X(t+1)
%       z(t+1)  y(t+1)  p(t+1) w(t+1) 
FF1 = [  -1      0       0       1      ];      
FF = [ FF1 zeros(1,lags) ] ;

%       z(t)    y(t)    p(t)   w(t)  
GG1 = [   0      0       0       0     ];   
GG = [ GG1 zeros(1,lags) ] ;

%       z(t-1)  y(t-1)  p(t-1) w(t-1) 
HH1 = [   0      0       0       0     ];      
HH = [ HH1 zeros(1,lags) ] ;

% y(t+1)
%      dp(t+1)        
JJ = [   0    ];
                
% y(t)
%      Dp(t)      
KK = [   0  ];

%      m(t+1)  
LL = [   0      ];     
         
%      m(t)      
MM = [   0   ];  
      
    
% AUTOREGRESSIVE MATRIX FOR z(t)
NN1 = [ r_a ];
NN = diag(NN1);

Sigma1 = [ sd_a  ] ;
Sigma = diag(Sigma1.^2) ;
          
          
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
GNP_INDEX  = 2;  % Index of output among the variables selected for HP filter
IMP_SELECT = 1:(m_states+n_endog+k_exog); % vector containing indices of variables to be plotted
HP_SELECT  = 1:(m_states+n_endog+k_exog); % Selecting the variables for the HP Filter calcs.
TXT_MARKER = 1;
DO_PLOTS = 0;
DISPLAY_AT_THE_END = 0;

varnumber = 4; % number of variables you want to plot

HORIZON

do_it

rats=0;eviews=0;autocovariances=0;

varnumber=4; % number of variables you want to plot
shocks = size(MM,2); % number of shocks

SELE1 = [ 2 ]; SELE2 = [ 3 ]; SELE3 = [ 4+lags+1 ]; SELE4 = [ 4+lags+2 ];     plot_bc

fontlabel=11;
hold on; subplot(shocks,varnumber,1); ylabel('DEMAND SHOCK','fontsize',fontlabel);

for ie =  varnumber*(shocks-1)+1  : 1 : shocks*varnumber ; 
    hold on; subplot(shocks,varnumber,ie); xlabel('quarters','fontsize',fontlabel-1); end; clear ie;