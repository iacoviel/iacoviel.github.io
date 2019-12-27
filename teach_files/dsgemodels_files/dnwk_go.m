% DNWK_GO :  type "help dnwk" for help
% Executes Dynamic neo-keynesian model with capital, a-la Gertler

kappa = (1-te)*(1-b*te)/te ;
R = 1/b;
ayrk = 1 - (1-d)*b ;
ky = a / ( X * (R-(1-d)) ); 
cy = 1 - d*ky ;

fip = (1-r_r)*(1+r_p) ;
fiy = (1-r_r)*r_y ;

% Declaring the matrices. 

VARNAMES = ['K           ', % 1
            'Y           ', % 2 
            'L           ', % 3 
            'X           ', % 4
            'R           ', % 5 
            'c           ', % 6
            '\pi         ',  
            '\lambda     ', % lambda is marginal utility of consumption ( l(t)=-ro*c(t) in basic model )
            'A           ',  
            'u           ',  
            'e           ']; 
   
   
% Translating into coefficient matrices.  
% The loglinearized equations are, conveniently ordered:

% CHECK: 7 equations, 7 variables.
%
% Endogenous state variables "x(t)": 
% Endogenous other variables "y(t)": 
% Exogenous state variables  "z(t)": A(t), u(t), e(t)

% 0 = AA x(t) + BB x(t-1) + CC y(t) + DD z(t)
% 0 = E_t [ FF x(t+1) + GG x(t) + HH x(t-1) + JJ y(t+1) + KK y(t) + LL z(t+1) + MM z(t)]
% z(t+1) = NN z(t) + epsilon(t+1) with E_t [ epsilon(t+1) ] = 0,

% 	y_{t} = A_{t} + a*k_{t-1} + (1-a)L_{t}   #1
% 	y_{t} = (C/Y) C_{t} + (K/Y) (k_{t}-(1-d)k_{t-1})   #2
% 	R_{t}-Pi_{t+1} = (1-b(1-d))(y_{t+1}-k_{t}-x_{t+1})-fi/d*(k_{t}-k_{t-1}-b(1-d)(k_{t+1}-k_{t})) #3
% 	R_{t}-Pi_{t+1} = ro(lmbd_{t}-lmbd_{t+1})   #4
% 	y_{t}-x_{t} = eta*L_{t}-lmbd_{t}   #5
% 	Pi_{t} = p_{b}Pi_{t-1}+(1-p_{b})b*Pi_{t+1}-kappa*x_{t}+u(t)   #6
% 	R_{t} = r_{r}R_{t-1}+(1-r_{r})(1+rp})Pi_{t}-(1-r_{r})(1+ry})X_{t}+e_{t}   #7
% 	(1-b*e)lmbd_{t} = ((ro*e)/(1-e))c_{t-1}-((ro(1+b*e^2))/(1-e))c_{t}+((ro*b*e)/(1-e))E_{t}c_{t+1} #8
 


% DETERMINISTIC EQUATIONS:

% for x(t):
%       k(t)       y(t)       L(t)       X(t)       r(t)     c(t)     p(t)   
AA = [   0          -1        1-a         0          0        0        0   % 1 production function 
         ky         -1         0          0          0       cy        0   % 2 definition of income                  
         0           0         0        -fiy        -1        0       fip  % 7 policy rule
         0           1       -eta        -1          0        0        0   ];  % 5 labor supply

         

% for x(t-1): 
%       k(t-1)     y(t-1)     L(t-1)     X(t-1)     r(t-1)   c(t-1)  p(t-1)
BB = [   a           0         0          0          0        0        0     
       -(1-d)*ky     0         0          0          0        0        0      
         0           0         0          0          r_r      0        0      
         0           0         0          0          0        0        0    ];
         

% For y(t)
%      lambda(t)  
CC =[    0
         0
         0
         1 ];
         
%        A(t)      u(t)      e(t)    
DD = [   1         0          0  
         0         0          0
         0         0          1 
         0         0          0 ];
      
      
      
% EXPECTATIONAL EQUATIONS:
ak_t = fi*(1-d)*(1+b) ;   ak_ld = b*fi*(1-d)^2 ;         ak_lg = fi*(1-d) ; 
ac_lg = ro*e/(1-e) ;      ac_t = ro*(1+b*e^2)/(1-e) ;    ac_ld = ro*b*e/(1-e) ;


% For x(t+1)
%       k(t+1)     y(t+1)     L(t+1)    X(t+1)     r(t+1)  c(t+1)   p(t+1) 
FF = [ ak_ld       ayrk        0        -ayrk        0       0       1        % 3 capital demand               
         0           0         0          0          0       0       1        % 4 consumption               
         0           0         0          0          0       0    b*(1-pb)    % 6 inflation               
         0           0         0          0          0    ac_ld      0     ]; % 8 lambda         
         
% For x(t)
%       k(t)       y(t)       L(t)       X(t)       r(t)    c(t)    p(t)  
GG = [-ayrk-ak_t     0         0          0         -1       0       0                
         0           0         0          0         -1       0       0               
         0           0         0        -kappa       0       0      -1    
         0           0         0          0          0    -ac_t      0  ]; % 8 lambda         
         
% For x(t-1)
%       k(t-1)     y(t-1)     L(t-1)     X(t-1)     r(t-1)  c(t-1) p(t-1)   
HH = [  ak_lg        0         0          0          0        0      0                
         0           0         0          0          0        0      0                    
         0           0         0          0          0        0     pb             
         0           0         0          0          0      ac_lg    0      ]; % 8 lambda               
         
% For y(t+1)
%      lambda(t+1)        
JJ = [   0
        -ro
         0  
         0    ] ; 
       
     
% For y(t)
%       lambda(t)      
KK = [   0
         ro
         0 
      -(1-b*e)   ] ;
        
     
% For z(t+1)
%      A(t+1)    u(t+1)     e(t+1)
LL = [   0        0           0    
         0        0           0
         0        0           0
         0        0           0   ];
         
         
% For z(t)
%      A(t)      u(t)       e(t)
MM = [   0        0           0    
         0        0           0
         0        1           0
         0        0           0      ];
    


    
% AUTOREGRESSIVE MATRIX FOR z(t)
NN1 = [ r_a r_u r_e ];
NN = diag(NN1);



Sigma1 = [ sd_a sd_u sd_e ] ;
Sigma = diag(Sigma1.^2) ;
          
          
          
% Setting the options:
[l_equ,m_states] = size(AA);
[l_equ,n_endog ] = size(CC);
[l_equ,k_exog  ] = size(DD);




  
PERIOD     = 1;  % number of periods per year, i.e. 12 for monthly, 4 for quarterly
GNP_INDEX  = 2;  % Index of output among the variables selected for HP filter
IMP_SELECT = 1:(m_states+n_endog+k_exog); % vector containing indices of variables to be plotted
HP_SELECT  = 1:(m_states+n_endog+k_exog); % Selecting the variables for the HP Filter calcs.
TXT_MARKER = 1;

DO_PLOTS = 0;

DISPLAY_AT_THE_END = 1 ;

varnumber = 4; % number of variables you want to plot

do_it

rats=0;
eviews=0;
autocovariances=0;

shocks = size(MM,2); % number of shocks

% SELE1 = [ 2 3 ]; SELE2 = [ 5 ]; SELE3 = [ 6 ]; SELE4 = [ 4 7 ];     plot_bc
SELE1 = [  2 ]; SELE2 = [ 5 ]; SELE3 = [ 4 ]; SELE4 = [ 7 ];     plot_bc
% SELE1 = [ 2 ]; SELE2 = [ 7 ]; SELE3 = [ 5 ];   plot_bc



fontlabel=11;
hold on; subplot(shocks,varnumber,1); ylabel('TECNO SHOCK','fontsize',fontlabel);
hold on; subplot(shocks,varnumber,varnumber+1); ylabel('INFLATION SHOCK','fontsize',fontlabel);
hold on; subplot(shocks,varnumber,2*varnumber+1); ylabel('MONETARY SHOCK','fontsize',fontlabel);


for ie =  varnumber*(shocks-1)+1  : 1 : shocks*varnumber ; 
    hold on; subplot(shocks,varnumber,ie); xlabel('years','fontsize',fontlabel-1); end; clear ie;