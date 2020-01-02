% KIYOTAKI.M
% see kiyotaki_go for more help

clear;
close all;

b = .99 ;
g = .98 ;
m = 0.5 ;

ro = 0.5 ;

% aa=A'/A
aa = .8 ;

mu = .5 ;





% A BUNCH OF OPTIONS THAT YOU DONT WANT TO CHANGE HERE
axistight=1; grids=1;


% HERE YOU HAVE THE CHANCE TO CALIBRATE A FEW PARAMETERS AND THEN COMPARE THE IMPULSE RESPONSES OF THE MODEL
% CHANGING SOME OF THEM EACH TIME

cha=0;
kiyotaki_go ; 
