%=========================================================================%
% Routine Extra_Figures.m
% Created by: Danny Galvis, Darren Walsh, James Rankin
% This routine creates some extra plots not used in the paper
% Go through each module in succession. The program will pause after each
% one.
%=========================================================================%
%% Initialize
restoredefaultpath;clear;clc;
% Add paths to auxillary functions and parameter files
addpath('functions');addpath('result_files');
% If this file doesn't exist, run create_data_file.m
% This is the experimental dataset
load comparison_data.mat;
%% Figure 1B supplemental for all 21 runs
% figure();clf;hold all;
% 
% % There were 21 optimizations. Set thresholds for the error.
% % Results in the bounds are plotted in black, others in green
% error_max = 0.82;% NOTE min = 0.8101/max = 0.9371
% error_min = 0;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run for each of the optimizations
% for num = 1:21,
%     % import
%     input_file = ['parameters_final',num2str(num),'_ga.mat'];
%     load(input_file);
%     % check to see if the error was within the bounds
%     % flag good-plot in black / bad-plot in green
%     if(Error_tot < error_max && Error_tot > error_min)
%         vis_param_supp(result,state_num,data,'good');
%     else
%         vis_param_supp(result,state_num,data,'bad');
%     end
% end
% disp('press enter');
% pause;clc;
%% Figure 3 supplemental for all 21 runs
% figure();clf;hold all;
% 
% % Run over all parameter sets (full data set results)
% error_max = 0.82;% NOTE min = 0.8101/max = 0.9371
% error_min = 0;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Plot the model trajectories and the dataset for all optimizations
% for num = 1:21,
%     % import
%     input_file = ['parameters_final',num2str(num),'_ga.mat'];
%     load(input_file);
%     % check to see if the error was within the bounds
%     % flag good-plot in black / bad-plot in green
%     if(Error_tot < error_max && Error_tot > error_min)
%         vis_traj_supp(result,state_num,fit,data,'good');
%     end
%     
% end
% disp('press enter');
% pause;clc;
%% Extra Figure 1 - increasing/decreasing parameter values (sensitivity)
%   The transitions for proliferative states Pi -> X i = 1...N are defined
%   by a line using endpoints. In this case, we increase and decrease those
%   lines without changing the slope.
%   This produces the bar plots for the sensitivity analysis (intercept)

% figure();clf;hold all;
% %import 
% input_file = 'sensitive_intercept.mat'; % Created by Run_sens
% load(input_file);
% % labels of the bar plot
% labels = {'Pi -> Pi+1','Pi->GA','GA->S','Pi->A','Pi->S','A->D','%PinH2Ax','%GAinKi67','%GAinH2Ax'};
% % create bar plot
% vis_sens(sensitive,labels);
% title('Percent change in error wrt percent change in parameters (intercept)');
% 
% disp('press enter');
% pause;clc;
%% Extra Figure 2 - increasing/decreasing parameters values (slope)
%   The transitions for proliferative states Pi -> X i = 1...N are defined
%   by a line using endpoints. In this case, change the slopes of those
%   lines (where possible) without changing the middle value of the line.
%   This produces the bar plots for the sensitivity analysis (slope)
% figure();clf;hold all;
% % import
% input_file = 'sensitive_slope.mat'; % Created by Run_sens
% load(input_file);
% % labels of the bar plot
% labels = {'Pi -> Pi+1','Pi->GA','Pi->A','Pi->S'};
% % create bar plot
% vis_sens(sensitive,labels);
% title('Percent change in error wrt percent change in parameters (slope)');
% disp('press enter');
% pause;clc;

%% Extra Figure 3 - percent change in error with change in state_num
% figure();clf;hold all;
% load('parameters_final_best.mat');
% original_error = Error_tot;
% 
% load('parameters_40_best.mat');
% err(1) = (Error_tot-original_error)/original_error;
% load('parameters_60_best.mat');
% err(2) = (Error_tot-original_error)/original_error;
% load('parameters_100_best.mat');
% err(3) = (Error_tot-original_error)/original_error;
% load('parameters_150_best.mat');
% err(4) = (Error_tot-original_error)/original_error;
% 
% err = 100*err;
% bar(err,'FaceColor',[0.3,0.3,0.3])
% xticks([1,2,3,4])
% xticklabels({'40','60','100','150'});
% ylabel('relative error');
% title('%Change in Error wrt. reoptimization with X proliferative states');
% disp('press enter');
% pause;clc;clear err;
%% Extra Figure 4 - plots of all trajectories for different state_num 
% figure();clf;
% % import
% input_file = 'parameters_40_best.mat';
% load(input_file);
% % visualize
% vis_traj(result,state_num,fit,data);
% input_file = 'parameters_60_best.mat';
% load(input_file);
% % visualize
% vis_traj(result,state_num,fit,data);
% input_file = 'parameters_100_best.mat';
% load(input_file);
% % visualize
% vis_traj(result,state_num,fit,data);
% input_file = 'parameters_150_best.mat';
% load(input_file);
% % visualize
% vis_traj(result,state_num,fit,data);
% input_file = 'parameters_final_best.mat';
% load(input_file);
% % visualize
% vis_traj(result,state_num,fit,data);
% 
% disp('press enter');
% pause;clc;
%% Extra Figure 5 - Comparing population trajectory features to changes in parameters (intercept)
%   The transitions for proliferative states Pi -> X i = 1...N are defined
%   by a line using endpoints. In this case, we increase and decrease those
%   lines without changing the slope.
%   This produces the bar plots for the trajectory features (intercept)

% figure();clf;hold all;
% % import
% input_file = 'curves_intercept.mat';
% load(input_file);
% % create bar plot
% labels = {'Pi -> Pi+1','Pi->GA','Q->S','Pi->A','Pi->S','A->D'};
% vis_curve_full(curve,labels);
% 
% disp('press enter');
% pause;clc;
%% Extra Figure 6 - Comparing population trajectory features to changes in parameters (slopes)
%   The transitions for proliferative states Pi -> X i = 1...N are defined
%   by a line using endpoints. In this case, change the slopes of those
%   lines (where possible) without changing the middle value of the line.
%   This produces the bar plots for the trajectory features (slope)

% figure();clf;hold all;
% % import
% input_file = 'curves_slope.mat';
% load(input_file);
% % create bar plot
% labels = {'Pi -> Pi+1','Pi->GA','Pi->A','Pi->S'};
% vis_curve_full(curve,labels);
% 
% disp('press enter');
% pause;clc;
%% Extra Figure 7 - Sigmoid fitting/peaks
% This plots an illustration of the different features that are analyzed
% wrt to changes in the parameters values

figure();clf;hold all;
% import
input_file = 'parameters_final_best.mat';
load(input_file);
% plot features for the parameter set 
vis_features(result, state_num);

disp('press enter');
pause;clc;