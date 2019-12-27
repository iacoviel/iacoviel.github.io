//% This is a simple example when calculation of likelihood could be done by hand
var y;
varexo eps_u;

parameters RHO SIGMAU ;

RHO=0;
SIGMAU=1;

//%model(linear);
//%y = RHO*y(-1) + eps_u ;
//%end;

model(linear);
y =  eps_u ;
end;

initval;
y = 0;
end;

steady;

shocks;
var eps_u; stderr SIGMAU;
end;



stoch_simul(order=1,drop=0,irf=0,nomoments,simul_seed=1) y;


//% These five numbers are cooked up in a way that their stdev is exactly 1
//% The formula is y=zscore(randn(5,1),1);
//% Therefore the estimation using MLE will return 1 as the estimated standard deviation of the shock

y=[   -0.5925
    0.3298
   -0.9984
    1.8028
   -0.5416];

save basic_estimation_data y ;

//% -1, classic, rho=0
//% 0 classic
//% 1 bayesian
//% 2 bayesian with uniform priors

BAYESIAN=-1;



if BAYESIAN==-1;

    //% In the classical case
    //% The formula for the minus log likelihood for each value of eps_u is:
    //% see (Greene, Econometric Analysis, third edition, formula 13.40) and (diffuseLikelihood1.m)
    //% T/2*(log(2*pi)+log(eps_u^2))+1/(2*eps_u^2)*(sum(squared residuals))
    

    
    disp('Given the residuals, minus the likelihood should be (at the MLE estimate)')
    disp('T/2*(log(2*pi)+log(eps_u^2))+1/(2*eps_u^2)*(sum(squared residuals))')
    T=numel(y);
    disp(['T/2*(log(2*pi))                       = ' num2str(T/2*(log(2*pi)),3)      ]);
    disp(['T/2*log(SIGMAU^2)                     = ' num2str(T/2*log(SIGMAU),3)          ]);
    disp(['sum(squared residuals)*log(SIGMAU^2)  = ' num2str((sum(y.^2)/2/SIGMAU^2),3) ]);
    disp(['Likelihood                            = ' num2str(T/2*(log(2*pi)+log(SIGMAU^2))+(sum(y.^2)/2/SIGMAU^2),3) ]);
    
    
    estimated_params;
    stderr eps_u,0.4,0.2,1.8;
    end;

    varobs y ;

    estimation(datafile=basic_estimation_data);

end;



if BAYESIAN==0;

    estimated_params;
    RHO, 0, -0.99,0.99;
    stderr eps_u,2,0.0001,10;
    end;

    varobs y ;

    estimation(datafile=basic_estimation_data);

end;












if BAYESIAN==1;

    estimated_params;
    RHO,0.5,0,1,beta_pdf,0.50,0.20;
    stderr eps_u,1,0,10,gamma_pdf,2,1.5;
    end;

    varobs y ;

    estimation(datafile=basic_estimation_data,
    mode_compute=4,
    mh_nblocks=1,mode_check,mh_jscale=1,mh_replic=1000,
    smoother);

end;







if BAYESIAN==2;

    estimated_params;
        stderr eps_u     ,          1.0000  ,  0    ,10.000 ,   uniform_pdf,  10.000   ,   5.7735 ;      
        RHO              ,          0.0000  ,  -0.99, 0.999 ,   uniform_pdf,   0.000   ,   0.5774   ;      
    end;

    varobs y ;

    estimation(datafile=basic_estimation_data,
    mode_compute=4,
    mh_nblocks=1,mode_check,mh_jscale=1,mh_replic=1000,
    smoother);

end;






