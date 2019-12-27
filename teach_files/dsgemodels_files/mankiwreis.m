% MANKIWREIS.M :  simulates  Mankiw and Reis (2002), QJE, Sticky information: A proposal to replace the Phillips curve

clear;
close all;

r_a = 1 ; % DEMAND SHOCK PERSISTENCE

sd_a = 0.03 ;

% A BUNCH OF OPTIONS THAT YOU DONT WANT TO CHANGE HERE
axistight=1; grids=0;

a = .1;
s = .25;

lags = 15 ;
HORIZON = 50 ;


% HERE YOU HAVE THE CHANCE TO CALIBRATE A FEW PARAMETERS AND THEN COMPARE THE IMPULSE RESPONSES OF THE MODEL
% CHANGING SOME OF THEM EACH TIME

cha=0;
mankiwreis_go

