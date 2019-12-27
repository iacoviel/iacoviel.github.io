//% Three equations model in McCallum AER 2001
var y, p, r;
varexo eps_g eps_u;

parameters KAPPA BETA FIP SIGMAG SIGMAU ;

KAPPA=0.05;
BETA=0.99;
FIP=1.5;
SIGMAG=0.02;
SIGMAU=0.02;

model(linear);
y = y(+1) - r + p(+1) + eps_g ;
r = FIP*p ;
p = BETA*p(+1) + KAPPA*y + eps_u ;
end;

initval;
y = 0;
r = 0;
p = 0;
end;

steady;

shocks;
var eps_g; stderr SIGMAG;
var eps_u; stderr SIGMAU;
end;



stoch_simul(order=1,drop=0,periods=100,irf=0,nomoments,simul_seed=1) y p;

y(4)=0;
p(4)=0;

save data1 y p ;



BAYESIAN=1;



if BAYESIAN==0;

    estimated_params;
    FIP,1.5,1,10;
    stderr eps_g,0.02,0.0001,0.1;
    stderr eps_u,0.02,0.0001,0.1;
    end;

    varobs y p ;

    estimation(datafile=data1);

end;









if BAYESIAN==1;

    estimated_params;
    BETA,0.95,0,1,beta_pdf,0.50,0.10;
    FIP,1.5,1,20,normal_pdf,2,0.25;
    stderr eps_g,0.01,0,0.2,gamma_pdf,0.02,0.015;
    stderr eps_u,0.01,0,0.2,gamma_pdf,0.02,0.015;
    end;

    varobs y p ;

    estimation(datafile=data1,mode_compute=4,mh_nblocks=1,mode_check,mh_jscale=1,mh_replic=1000);

end;





