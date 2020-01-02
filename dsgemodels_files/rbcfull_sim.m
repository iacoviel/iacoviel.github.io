% RBCFULL_SIM.M simulates the model: based on sim_out in Uhlig's toolkit

SIM_MODE=2 ;
SIM_JOINT=0 ;
SIM_TRACK_N = 0;
simul;
SIM_GRAPH = 0 ; 


% based on sim_out.m

time_axis = (0:(SIM_LENGTH-1))/PERIOD + SIM_DATE0;
n_select = max(size(SIM_SELECT));

plotsimulation=1;

if plotsimulation == 1
         
figure(gcf+1)
      
subplot(2,2,1); SIM_SELECT = [ 2 ];
plot(time_axis(1:min(SIM_LENGTH,SIM_MAX)), sim_xyz(SIM_SELECT,1:min(SIM_LENGTH,SIM_MAX)), 'g');
[mx,pos]=max(abs(sim_raw(SIM_SELECT,1:floor(SIM_CUT*min(SIM_LENGTH,SIM_MAX)))'));
n_select = max(size(SIM_SELECT));
   ylabel('% deviation from steady state'); xlabel('Quarter');
   legend(VARNAMES(SIM_SELECT,:))
   
subplot(2,2,2); SIM_SELECT = [ 3 4 ];
plot(time_axis(1:min(SIM_LENGTH,SIM_MAX)), sim_xyz(SIM_SELECT,1:min(SIM_LENGTH,SIM_MAX)));
[mx,pos]=max(abs(sim_raw(SIM_SELECT,1:floor(SIM_CUT*min(SIM_LENGTH,SIM_MAX)))'));
n_select = max(size(SIM_SELECT));
   xlabel('Quarter'); ylabel('% deviation from steady state');
 legend(VARNAMES(SIM_SELECT,:))         
         
 subplot(2,2,3); SIM_SELECT = [ 5 6 ];
 plot(time_axis(1:min(SIM_LENGTH,SIM_MAX)), sim_xyz(SIM_SELECT,1:min(SIM_LENGTH,SIM_MAX)));
 [mx,pos]=max(abs(sim_raw(SIM_SELECT,1:floor(SIM_CUT*min(SIM_LENGTH,SIM_MAX)))'));
 n_select = max(size(SIM_SELECT));
   xlabel('Quarter'); ylabel('% deviation from steady state');
   legend(VARNAMES(SIM_SELECT,:))
   
 subplot(2,2,4)
 title('Simulated data');
 xlabel('Quarter');
 ylabel('% deviation from steady state');
 SIM_SELECT = [ 7 8 ] ;
 plot(time_axis(1:min(SIM_LENGTH,SIM_MAX)), sim_xyz(SIM_SELECT,1:min(SIM_LENGTH,SIM_MAX)));
 [mx,pos]=max(abs(sim_raw(SIM_SELECT,1:floor(SIM_CUT*min(SIM_LENGTH,SIM_MAX)))'));
 n_select = max(size(SIM_SELECT));
   xlabel('Quarter'); ylabel('% deviation from steady state');
    legend(VARNAMES(SIM_SELECT,:))
    

end




% VERSION 2.0, MARCH 1997, COPYRIGHT H. UHLIG.
% SIM_OUT.M produces output for SIMUL.M.  It is controlled 
% by several options to be described
% below.  All these options are set in OPTIONS.M,
% see that file for further details.
%
% The series will be plotted
% if SIM_GRAPH is set to 1.  In that case, further
% modifications can be done in particular with:
%   DO_ENLARGE : = 1, if you want large font sizes for the text on your plots.
%                     Good for slides.
%   SIM_JOINT  : = 1, if you want all series on the same graph, else = 0.
%   PRINT_FIG  : = 1, if you want plots to be printed on your printer
%   SAVE_FIG   : = 1, if you want plots to be saved as encaps. postscript. 
%                     Set PRINT_FIG = 0 also. The filenames are sim_ser1.eps, ...
%                     if SIM_JOINT = 0, and sim_data.eps is SIM_JOINT = 1.
%   SIM_PLOT_RAW : = 1, if you want a plot of the raw, unfiltered series, 
%                       even though you have chosen to HP-filter, DO_HP_FILTER = 1.                       
%                       Note, that if you have chosen to save figures, then
%                       the previously saved figures will be overwritten.
%                       This option is useful, if you want to look at the plot
%                       of the raw simulations, after having already seen the filtered
%                       ones: simply type
%                       SIM_PLOT_RAW = 1;
%                       sim_out;
%
% For printing the numbers of the autocorrelation table, 
% the following options are helpful:
%   
%  SIM_DO_DISP1: Set to = 1 to see printout of the autocorrelation matrix. 
%  SIM_DO_DISP2: Set to = 1 to see printout of the variance-covariance matrix.
%  SIM_DO_DISP3: Set to = 1 to see printout of the vector of variances.


% Copyright: H. Uhlig.  Feel free to copy, modify and use at your own risk.
% However, you are not allowed to sell this software or otherwise impinge
% on its free distribution.

SIM_SELECT = HP_SELECT ;


n_select = max(size(SIM_SELECT));

if SIM_GRAPH,
   time_axis = (0:(SIM_LENGTH-1))/PERIOD + SIM_DATE0;
   if SIM_JOINT
      if SIM_PLOT_RAW,
         hndl = plot(time_axis(1:min(SIM_LENGTH,SIM_MAX)),...
            sim_raw(SIM_SELECT,1:min(SIM_LENGTH,SIM_MAX)));
         [mx,pos]=max(abs(sim_raw(SIM_SELECT,1:floor(SIM_CUT*min(SIM_LENGTH,SIM_MAX)))'));
         for var_index = 1:n_select,
%            text(time_axis(SIM_TXT_MARKER), sim_raw(var_index,SIM_TXT_MARKER),...
%              VARNAMES(SIM_SELECT(var_index),:));
            text(time_axis(pos(var_index)), sim_raw(var_index,pos(var_index)),...
              VARNAMES(SIM_SELECT(var_index),:));
         end;
      else
         hndl = plot(time_axis(1:min(SIM_LENGTH,SIM_MAX)),...
            sim_xyz(SIM_SELECT,1:min(SIM_LENGTH,SIM_MAX)));
         [mx,pos]=max(abs(sim_xyz(SIM_SELECT,1:floor(SIM_CUT*min(SIM_LENGTH,SIM_MAX)))'));
         for var_index = 1:n_select,
%            text(time_axis(SIM_TXT_MARKER), sim_xyz(var_index,SIM_TXT_MARKER),...
%              VARNAMES(SIM_SELECT(var_index),:));
            text(time_axis(pos(var_index)), sim_xyz(var_index,pos(var_index)),...
              VARNAMES(SIM_SELECT(var_index),:));
         end;
      end;
      set(hndl,'LineWidth',2);
      grid;
      if DO_HP_FILTER & ~SIM_PLOT_RAW,
         title('Simulated data (HP-filtered)');
      else
         title('Simulated data');
      end;
      xlabel('Quarter');
      ylabel('Percent deviation from steady state');
      if DO_ENLARGE,
         enlarge;
      end;
      if PRINT_FIG,
         disp('SIM_OUT: Printing plot of Simulated data');
         print;
      elseif SAVE_FIG
         disp('SIM_OUT: Saving plot of Simulated data.  Filename is sim_data.eps ...');
         print -deps sim_data.eps
      else                     
         disp('Inspect figure. Hit key when ready...');
         pause;
      end;
   else
      for var_index = 1:n_select,
         if SIM_PLOT_RAW,
            hndl = plot(time_axis(1:min(SIM_LENGTH,SIM_MAX)),...
               sim_raw(SIM_SELECT(var_index),1:min(SIM_LENGTH,SIM_MAX)));
            % text(time_axis(SIM_TXT_MARKER), sim_raw(var_index,SIM_TXT_MARKER),...
            %    VARNAMES(SIM_SELECT(var_index),:));
         else
            hndl = plot(time_axis(1:min(SIM_LENGTH,SIM_MAX)),...
               sim_xyz(SIM_SELECT(var_index),1:min(SIM_LENGTH,SIM_MAX)));
            % text(time_axis(SIM_TXT_MARKER), sim_xyz(var_index,SIM_TXT_MARKER),...
            %    VARNAMES(SIM_SELECT(var_index),:));
         end;
         set(hndl,'LineWidth',2);
         grid;
         if DO_HP_FILTER & ~SIM_PLOT_RAW,
            title(['Simulated data (HP-filtered): ',VARNAMES(SIM_SELECT(var_index),:)]);
         else
            title(['Simulated data: ',VARNAMES(SIM_SELECT(var_index),:)]);
         end;
         xlabel('Quarter');
         ylabel('Percent deviation from steady state');
         if DO_ENLARGE,
            enlarge;
         end;
         if PRINT_FIG,
            disp(['SIM_OUT.M: Printing simulation of ',VARNAMES(var_index,:),'...']);
            print;
         elseif SAVE_FIG
            if var_index == 1,
               disp(['SIM_OUT.M: Saving simulation of ',VARNAMES(var_index,:)]);
               disp( '         as encapsulated postscript file. Filename is sim_ser1.eps ...'); 
               print -deps sim_ser1.eps
            elseif var_index == 2,
               disp(['SIM_OUT.M: Saving simulation of ',VARNAMES(var_index,:)]);
               disp( '         as encapsulated postscript file. Filename is sim_ser2.eps ...'); 
               print -deps sim_ser2.eps
            elseif var_index > 2,
               disp(['           I cannot save the simulation of ',VARNAMES(var_index,:)]);
            end;
         else                     
            disp('Inspect figure. Hit key when ready...');
            pause;
         end;
      end;
   end;
end;

%if SIM_DO_1 | SIM_DO_DISP2 | SIM_DO_DISP3,
%   disp(sprintf('           Simulation length = %10d',SIM_LENGTH));
%   if SIM_MODE == 2,
%   disp(sprintf('           repeated %10d times.',SIM_N_SERIES));
%   end;      
% end;
if SIM_DO_DISP1,
   if DO_HP_FILTER,
   else
   end;
   for var_index = 1 : n_select,
   end; 
   if (SIM_N_SERIES > 3) & (SIM_MODE == 2),
      for var_index = 1 : n_select,
      end; 
   end;
end;
if SIM_DO_DISP2,
   if DO_HP_FILTER,
   else
   end;
   for var_index = 1 : n_select,
   end;
   if (SIM_N_SERIES > 3) & (SIM_MODE == 2),
      for var_index = 1 : n_select,
      end;
   end;
end;
if SIM_DO_DISP3,
   if DO_HP_FILTER
   else
   end;
   if (SIM_N_SERIES > 3) & (SIM_MODE == 2),
   end;
end;






disp(' ');
if SIM_DO_DISP1 | SIM_DO_DISP2 | SIM_DO_DISP3,
   disp(        'SIM_OUT.M: Simulation-based calculation of moments');
   disp(sprintf('           Simulation length = %10d',SIM_LENGTH));
   if SIM_MODE == 2,
      disp(sprintf('           repeated %10d times.',SIM_N_SERIES));
   end;      
   disp('The variables ares:');
   disp(VARNAMES(SIM_SELECT,:));
   disp(' ');
end;
if SIM_DO_DISP1,
   if DO_HP_FILTER,
      disp('Autocorrelation Table (HP-filtered series), corr(v(t+j),GNP(t)).  Last row shows j');
   else
      disp('Autocorrelation Table, corr(v(t+j),GNP(t)).  Last row shows j');
   end;
     for var_index = 1 : n_select,
     disp(sprintf('  %5.2f',autcor_sim(SIM_SELECT(var_index),:)));
     end; 
   disp(sprintf('  %5.0f',autcor_sim(max(size(VARNAMES))+1,:)));
   disp(' ');
   if (SIM_N_SERIES > 3) & (SIM_MODE == 2),
      disp('Small sample standard errors for the Autocorrelation Table:');
      for var_index = 1 : n_select,
         disp(sprintf('  %5.2f',autcor_std(SIM_SELECT(var_index),:)));
      end; 
      disp(sprintf('  %5.0f',autcor_sim(max(size(VARNAMES))+1,:)));
      disp(' ');
   end;
end;
if SIM_DO_DISP2,
   if DO_HP_FILTER,
      disp('Variance-Covariance Matrix (HP-filtered series):');
   else
      disp('Variance-Covariance Matrix:');
   end;
   for var_index = 1 : n_select,
            disp(sprintf(' %6.3f',covmat_sim(SIM_SELECT(var_index),:)));
            % for future reference, here the square root of the diagonal of the variance covariance matrix
            % shows same results one would obtain using diagV', that is
            % [ diagV' diag(covmat_sim(1:24,:)).^.5 ]  are almost similar

   end;
   disp(' ');
   if (SIM_N_SERIES > 3) & (SIM_MODE == 2),
      disp('Small sample standard errors for the Variance-Covariance Matrix:');
      for var_index = 1 : n_select,
         disp(sprintf(' %6.3f',covmat_std(SIM_SELECT(var_index),:)));
      end;
      disp(' ');
   end;
end;
if SIM_DO_DISP3,
   if DO_HP_FILTER
      disp('Standard deviations (HP-filtered series):');
   else
      disp('Standard deviations:');
   end;
   
   for var_index = 1 : n_select,
   disp(sprintf(' %6.3f',stdvec_sim(SIM_SELECT(var_index),:)));
   end;

   if (SIM_N_SERIES > 3) & (SIM_MODE == 2),
      disp('Small sample standard errors for the Standard deviations:');
   for var_index = 1 : n_select,
   disp(sprintf(' %6.3f',stdvec_std(SIM_SELECT(var_index),:)));
   end;
   
end;
end;
