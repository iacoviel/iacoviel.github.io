//% RBC Model solved with second order, to calculate equity premium
//% example 2 from EC861, FALL 2007
//% September 4, 2007
//%
//% VARIABLES
//% c : log of consumption
//% w : log of wage
//% k : log of capital stock
//% q : log of equity price
//% y : log output
//% p : log of bond price
//% a : log of technology process
//% gc : growth rate of consumption
//% req : return on equity
//% rbo : return on bond
//% ep : equity premium


//% Declare endogenous and exogenous variables
var c w k q y p a req rbo ep gc ;
varexo u;

//% Declare model parameters (convention: use uppercase for parameters,
//% lowercase for variables) 

parameters ALPHA, BETA, RHO, SIGMA, DELTA, STDERRU ;
ALPHA = 0.33 ;
BETA  = 0.96 ;
RHO   = 0.80 ;
STDERRU = 0.025 ;
SIGMA = 5 ;
DELTA = 0.10 ;



//% Write down model equations here. Remember: as many equations as variables,
//% and put ";" at the end of each equation

model;
exp(q)/(exp(c)^SIGMA) = BETA/(exp(c(+1))^SIGMA)*(exp(q(+1))+exp(c(+1))-exp(w(+1))) ;

1/(exp(c)^SIGMA) = BETA/(exp(c(+1))^SIGMA)*(ALPHA*(exp(y(+1))/exp(k))+1-DELTA) ;
exp(w) = (1-ALPHA)*exp(y) ;

exp(c) + exp(k) - (1-DELTA)*exp(k(-1)) = exp(y) ;

exp(y) = exp(a)*exp(k(-1))^ALPHA ;

exp(p) = BETA*(exp(c)^SIGMA)/(exp(c(+1))^SIGMA) ;

req = (exp(q)+exp(c)-exp(w))/exp(q(-1)) - 1 ;
rbo = 1/exp(p) - 1 ;
ep = req - rbo ;
gc = c - c(-1) ;

a=RHO*a(-1)+(1-RHO^2)^0.5*u ;
end;


//% Make guess for initial values of variables

initval;
a = 0;
c = 0;
k = 0;
p = 0;
q = 0;
w = 0;
y = 0;
ep = 0;
gc = 0;
req = 0;
rbo = 0;
end;

steady;

shocks;
var u; stderr STDERRU ;
end;

stoch_simul(order=2,irf=10) gc ep req rbo  ;

//% disp(' ') ;
//% disp('theoretical equity premium (cov b/w req and gc, times SIGMA)') ;
//% disp(SIGMA*oo_.var(1,3)) ;
