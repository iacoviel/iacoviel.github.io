% DNLAG_GO 
% MODEL A LA ROTEMBERG WOODFORD without capital
% for model with capital, see dnwk
% THE CONSUMPTION EULER EQUATION IS LIKE IN BOIVIN-GIANNONI
% THE PHILLIPS CURVE IS INFERRED FROM ROTEMBERG-WOODOFORD
% @Matteo Iacoviello 27 April 2004
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

disp('running DNLAG_GO')
disp('DNK model with two lags in consumption and one lag in prices')

kappa = (1-te)*(1-b*te)/te ;
R = 1/b;
cy = 1  ;

fip = (1-r_r)*(1+r_p);


ac_lg = ro*e/(1-e) ;      ac_t = ro*(1+b*e^2)/(1-e) ;    ac_ld = ro*b*e/(1-e) ;


% Declaring the matrices. 

VARNAMES = ['\lambda     ',  
            'L           ',  
            'X           ',
            'R           ',  
            'c           ',
            '\pi         ',
            'c(t+1)      ',
            'c(t+2)      ',
            '\lambda(t+1)',
            '\pi(t+1)    ',
            'Y           ',
            'A           ',  
            'e           ']; 
   
   
% Endogenous state variables "x(t)": 
% Endogenous other variables "y(t)": 
% Exogenous state variables  "z(t)": A(t), e(t)

% 0 = AA x(t) + BB x(t-1) + CC y(t) + DD z(t)
% 0 = E_t [ FF x(t+1) + GG x(t) + HH x(t-1) + JJ y(t+1) + KK y(t) + LL z(t+1) + MM z(t)]
% z(t+1) = NN z(t) + epsilon(t+1) with E_t [ epsilon(t+1) ] = 0,

% 	Y(t) = A(t)  +  L(t)                          # 1 PRODUCTION
% 	y(t) = (C/Y) C(t)                             # 2 GOODS MKT
% 	y(t) - X(t) = eta*L(t) - lm(t)                # 3 LABOR SUPPLY

% c(t) = L{c(t+1)}
% c(t+1) = L{c(t+2)}
% p(t) = L{p(t+1)}


% DETERMINISTIC EQUATIONS:


%       lm(t)   L(t)    X(t)    r(t)    c(t)    p(t)   c(t+1)  c(t+2)  lt(t+1)   p(t+1) 
AA = [   0       1       0       0       0       0       0       0       0        0     % 1
         0       0       0       0      cy       0       0       0       0        0     % 2 
         1     -eta     -1       0       0       0       0       0       0        0     % 3
         0       0       0       0       1       0       0       0       0        0     % 4 
         0       0       0       0       0       0       1       0       0        0     % 5
         0       0       0       0       0       1       0       0       0        0   ];% 6
      
% X(t-1): 
%       lm(t-1) L(-1)  X(t-1)  r(t-1)  c(-1)  p(-1)     c(t)  c(t+1)   lt(t)     p(t)    
BB = [   0       0       0       0       0       0       0       0       0        0      % 1 
         0       0       0       0       0       0       0       0       0        0      % 2 
         0       0       0       0       0       0       0       0       0        0      % 3 
         0       0       0       0       0       0      -1       0       0        0      % 4 
         0       0       0       0       0       0       0      -1       0        0      % 5 
         0       0       0       0       0       0       0       0       0       -1  ];  % 6
          
% Y(t)
%       Y(t)  
CC =[   -1       % 1
        -1       % 2
         1       % 3
         0       % 4
         0       % 5
         0   ];  % 6
         
%        A(t)      e(t)    
DD = [   1         0     % 1
         0         0     % 2
         0         0     % 3
         0         0     % 4
         0         0     % 5
         0         0  ]; % 6
      
            
% EXPECTATIONAL EQUATIONS:

% R(t)-P(t+1) = ro ( lm(t) - lm(t+1) )                                                  # 8 EULER CONSUMPTION      
% p(t) - pb p(t-1) = E(t-1) ( p(t+1) - pb P(t) ) - kappa * E(t-1) X(t)                  # 9 MODIFIED PHILLIPS CURVE
% E(t-2) [ (1-b*e) lm_(t) = ac_lg c_(t-1) - ac_t c_(t) + ac_ld c_(t+1) ]                # 10 LAMBDA 
% R_(t) = r_r R_(t-1) + (1-rr)(1+rp) P_(t) + u_(t)                                      # 11 TAYLOR RULE 
% E lm(t+1) = E lm(t+1)                                                                 # 12 

% E(t)X(t+1)
%      lm(t+1) L(t+1) X(t+1)   r(t+1)  c(t+1)   p(+1)  c(t+2)  c(t+3) lm(t+2)   P(t+2) 
FF = [  -ro       0       0       0       0       1       0       0       0       0    % 8
          0       0   -kappa      0       0      -1       0       0       0       1    % 9   
          0       0       0       0     ac_lg     0    -ac_t   ac_ld  -(1-b*e)    0    % 10   
          0       0       0       0       0       0       0       0       0       0    % 11
          1       0       0       0       0       0       0       0       0       0 ]; % 12
         

% X(t)
%       lm(t)    L(t)    X(t)    r(t)    c(t)    p(t)   c(t+1)  c(t+2)  lm(t+1)  P(t+1)  
GG = [  ro       0       0      -1       0       0       0       0       0       0    % 8    
         0       0       0       0       0      pb       0       0       0      -pb   % 9          
         0       0       0       0       0       0       0       0       0       0    % 10   
         0       0       0      -1       0      fip      0       0       0       0    % 11
         0       0       0       0       0       0       0       0      -1       0 ]; % 12
         
% E(t)x(t-1)
%      lm(t-1) L(t-1) X(t-1)  r(t-1)  c(t-1)  p(t-1)   c(t)   c(t-1)   lm(t)    P(t)    
HH = [   0       0       0       0       0       0       0       0       0       0    % 8                
         0       0       0       0       0       0       0       0       0       0    % 9       
         0       0       0       0       0       0       0       0       0       0    % 10     
         0       0       0      r_r      0       0       0       0       0       0    % 11  
         0       0       0       0       0       0       0       0       0       0 ]; % 12
          
% y(t+1)
%       Y(t+1)        
JJ = [   0
         0  
         0
         0 
         0 ];
                
% y(t)
%        Y(t)      
KK = [   0
         0 
         0 
         0
         0 ];

%      A(t+1)    e(t+1)
LL = [   0        0
         0        0
         0        0
         0        0
         0        0 ];     
         
%      A(t)      e(t)
MM = [   0        0     
         0        0     
         0        0     
         0        1
         0        0     ];  
      
    
% AUTOREGRESSIVE MATRIX FOR z(t)
NN1 = [ r_a r_e ];
NN = diag(NN1);
NN(1,2) = corr_a_e ; N(2,1) = corr_a_e ;


Sigma1 = [ sd_a sd_e ] ;
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

DO_QZ = 1;

varnumber = 4; % number of variables you want to plot
HORIZON=10 ;

do_it

rats=0;
eviews=0;
autocovariances=0;




varnumber=4; % number of variables you want to plot
shocks = size(MM,2); % number of shocks

SELE1 = [ 6 ]; SELE2 = [ 4 ]; SELE3 = [ 2 ]; SELE4 = [ 11 ];     plot_bc



fontlabel=11;
hold on; subplot(shocks,varnumber,1); ylabel('TECNO SHOCK','fontsize',fontlabel);
hold on; subplot(shocks,varnumber,varnumber+1); ylabel('MONETARY SHOCK','fontsize',fontlabel);


for ie =  varnumber*(shocks-1)+1  : 1 : shocks*varnumber ; 
    hold on; subplot(shocks,varnumber,ie); xlabel('quarters','fontsize',fontlabel-1); end; clear ie;