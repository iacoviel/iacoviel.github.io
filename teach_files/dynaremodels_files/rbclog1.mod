//% example 1 from EC861

var k a c ;
varexo u ;

parameters ALPHA, BETA, RHO, SIGMA ;

ALPHA = 0.33;
BETA  = 0.99;
RHO   = 0.98;
SIGMA = 0.01 ;

model;
exp(k) - exp(k(-1)) = (exp(a))^(1-ALPHA)*exp(k(-1))^ALPHA - exp(c) ;
1/exp(c) = BETA/exp(c(+1))*(ALPHA*(exp(a(+1))/exp(k))^(1-ALPHA)+1) ;
a=RHO*a(-1)+u ;
end;

initval;
a = 0;
k = 0;
c = 0;
end;

steady;

shocks;
var u; stderr SIGMA ;
end;

stoch_simul(periods=1000,order=1,irf=40) c k a ;