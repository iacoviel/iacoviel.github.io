% PLOT_BC.m : modified version of impresp.m from Uhlig toolkit
% 
% modified 17-feb-2003
% PLOT_BC IS A MODIFIED VERSION OF IMPRESP.M FROM HARALD UHLIG TOOLKIT
% PLOTS IMPULSE RESPONSES FROM MANY SHOCKS AND WITH ONE OR MORE CALIBRATION OF THE
% MODEL PARAMETERS IN THE SAME FIGURES, THUS CREATING JUST ONE MESSY GRAPH !!!!!


% Calculations
[m_states,k_exog] = size(QQ);
[n_endog,k_exog]  = size(SS);
Time_axis = (0 : (HORIZON-1))/PERIOD;
Resp_mat = [];

%close all
%figure


for shock_counter = 1 : k_exog,
         
   Response = zeros(m_states+n_endog+k_exog,HORIZON);
   Response(m_states+n_endog+shock_counter,1) = 1;
   II_lag = [ PP, zeros(m_states,n_endog),zeros(m_states,k_exog)
              RR, zeros(n_endog, n_endog),zeros(n_endog, k_exog)
              zeros(k_exog,(m_states+n_endog)), NN                ];
   II_contemp = eye(m_states+n_endog+k_exog) + ...
        [ zeros(m_states,(m_states+n_endog)), QQ
          zeros(n_endog, (m_states+n_endog)), SS
          zeros(k_exog,  (m_states+n_endog)), zeros(k_exog,k_exog) ];
   % describing [x(t)',y(t)',z(t)']'= II_contemp*II_lag*[x(t-1)',y(t-1)',z(t-1)']';
   Response(:,1) = II_contemp*Response(:,1);
   
   for time_counter = 2 : HORIZON,
      Response(:,time_counter) = II_contemp*II_lag*Response(:,time_counter-1);
   end;
   
   
   Resp_mat = [ Resp_mat 
                Response ];
             
end;

Resp_mat = round(1000000*Resp_mat)/1000000; % this lines avoids that a response of 0.00001% looks non-zero...

xx = size(Resp_mat,1)/k_exog; % denominator is the number of shocks

% added for MR
% for i=2:1:HORIZON
%     Resp_mat(5+lags,i)=Resp_mat(3,i)-Resp_mat(3,i-1);
% end


for ii = 0:1:(k_exog-1)
         
for fract = 1:1:varnumber         
         
         if fract == 1; SELE = SELE1;   
         elseif fract==2; SELE = SELE2; 
         elseif fract==3; SELE = SELE3; 
         elseif fract==4; SELE = SELE4;  
         elseif fract==5; SELE = SELE5; end 
             
Respmato = Resp_mat((ii*xx+1):((1+ii)*xx),:);

subplot(k_exog,varnumber,varnumber*ii+fract);

if exist('cha')==0; cha=0; end

if cha==0;   symbol1='o-r';   symbol2='^:g'; symbol3='s-k'; end
if cha==1;   symbol1='^-b';   symbol2='^:b'; symbol3='^'; end
if cha==2;   symbol1=':k';    symbol2='s:k'; symbol3='s'; end
if cha==3;   symbol1='*-m';   symbol2='*:g'; symbol3='*'; end
if cha==4;   symbol1='d-g';   symbol2='d:m'; symbol3='g'; end

if cha==1 | cha==2 | cha==3 | cha==4 ; hold on; end


if length(SELE)==1; 
         hndl = plot(Time_axis,Respmato(SELE,:),symbol1,Time_axis,0*Time_axis,'k'); 
         if ii==0 & cha==0;  legend([VARNAMES(SELE(1),1:min(size(VARNAMES,2),9))]);  end 
         if grids==1; grid on; end
end

if length(SELE)==2; 
         hndl = plot(Time_axis,Respmato(SELE(1),:),symbol1,Time_axis,Respmato(SELE(2),:),symbol2,Time_axis,0*Time_axis,'k'); 
         if ii==0; legend([VARNAMES(SELE(1),1:min(size(VARNAMES,2),8))],[VARNAMES(SELE(2),1:min(size(VARNAMES,2),8))]); end
         if grids==1; grid on; end
end

if length(SELE)==3; 
         hndl = plot(Time_axis,Respmato(SELE(1),:),symbol1,Time_axis,Respmato(SELE(2),:),symbol2,...
                Time_axis,Respmato(SELE(3),:),symbol3,Time_axis,0*Time_axis,'k'); 
         if ii==0;  legend([VARNAMES(SELE(1),1:5)],[VARNAMES(SELE(2),1:5)],[VARNAMES(SELE(3),1:5)]); end
         if grids==1; grid on; end
end
  
if length(SELE)>3;  
         hndl = plot(Time_axis,0*Time_axis,'k', Time_axis,Respmato(SELE,:),'h-');
end





% these options are good for all graphs
if axistight==1 & cha==2; axis tight; end

fnam='Helvetica';
set(gca,'fontsize',10,'FontName',fnam)         

set(hndl,'markersize',4);  
if cha >= 0; set(hndl,'markersize',4);  end

end

end


