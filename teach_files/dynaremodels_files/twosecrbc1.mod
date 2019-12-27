//% Showing the equivalence between the one-sector neoclassical growth
//% model and an equivalent two-sector RBC model where the technology 
//% to produce consumption and capital goods is the same.
//
//% Variable names
//% c: consumption in the 2-sector model
//% k: capital in the 2-sector model
//% f: the production function for c 
//% g: the production function for i
//% s: the share s (1-s) of capital used in the c-sector (i-sector)
//% nc: hours worked in the c sector
//% nh: hours worked in the k sector
//% lambda: shadow price of c
//% miu: shadow price of k
//%
//% zc, zn, zk, zi, zy: the 1-sector variables


//% Model details
//% Production is Cobb-Douglas
//% Period utility is of the form log(c)-((nc+nh)^(1+ETA))/(1+ETA)

var f g k s nc nh c lambda miu a zc zy zi zn zk ;
varexo eps_a ;

parameters ALPHA BETA ETA RHO_A DELTA;

ALPHA  = 0.33 ;
BETA   = 0.99 ;
ETA    = 1.00 ;
RHO_A  = 0.9  ;
DELTA  = 0.03 ;


model;

//% The two-sector block

exp(c) = exp(f) ;

exp(k) = exp(g) + (1-DELTA)*(exp(k(-1)))  ;

exp(f)=exp(a)*(s*exp(k(-1)))^ALPHA*exp(nc)^(1-ALPHA) ;
exp(g)=exp(a)*((1-s)*exp(k(-1)))^ALPHA*exp(nh)^(1-ALPHA) ;

1/exp(c) = exp(lambda);
(exp(nc)+exp(nh))^ETA = exp(lambda)*(1-ALPHA)*exp(f)/exp(nc);
(exp(nc)+exp(nh))^ETA = exp(miu)*(1-ALPHA)*exp(g)/exp(nh);

exp(miu) = BETA*exp(lambda(+1))*ALPHA*exp(f(+1))/exp(k) + BETA*exp(miu(+1))*(ALPHA*exp(g(+1))/exp(k)+1-DELTA);

exp(lambda)*ALPHA*exp(f)/s = exp(miu)*ALPHA*exp(g)/(1-s) ;


//% The one sector block

1/exp(zc)*ALPHA*exp(zy)/exp(zn) = exp(zn)^ETA ;
exp(zy)=exp(a)*exp(zk(-1))^(1-ALPHA)*exp(zn)^(1-ALPHA);
1/exp(zc)=BETA/exp(zc(+1))*(ALPHA*exp(zy(+1))/exp(zk)+1-DELTA) ;
exp(zc)+exp(zk)-(1-DELTA)*exp(zk(-1))=exp(zy);
exp(zi)=exp(zy)-exp(zc);

//% The technology (common to both sectors)
a = RHO_A*a(-1) + eps_a ;

end;



initval;
f	=	0	;
g	=	0	;
k	=	0	;
s	=	0.5	;
nc	=	0	;
nh	=	0	;
c	=	0	;
lambda	=	0	;
miu	=	0	;
a	=	0	;

zc = 0;
zi = 0;
zy = 0;
zk = 0;
zn = 0;


end;

steady(solve_algo=0);

shocks;
var eps_a; stderr 1;
end;

stoch_simul(order=1,irf=10) f g s nc nh c zy zn zk a ;
