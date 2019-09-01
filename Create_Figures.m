%=========================================================================%
% Routine Create_Figures.m
% Created by: Danny Galvis, Darren Walsh, James Rankin
% This routine creates the plots for the paper as well as some supplemental
% plots
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

%% Figure 1B - This illustrates the change in parameters Pi -> X vs. state i
% figure();clf;hold all;
% % import
% input_file = 'parameters_final_best.mat';
% load(input_file);
% % visualize
% vis_param(result,state_num,data);
% disp('press enter');
% pause;clc;

%% Figure 3 - This illustrates the trajectory of th solution and fit to data
% figure();clf;hold all;
% % import
% input_file = 'parameters_final_best.mat';
% load(input_file)
% % Plot the model trajectories and the dataset
% vis_traj(result,state_num,fit,data);
% disp('press enter');
% pause;clc;
%% Figure 4 Top Left Panel Visualize 
%reoptimization as a function of first passage optimized.

% We start at passage 2,3,4,5,6,7 or 8 (so 1-7 points are omitted)
% figure();clf;hold all;
% load('parameters_final_best.mat');
% original_error = Error_tot;
% 
% load parameters_fpo1_best.mat;
% err(1) = (Error_tot-original_error)/original_error;
% load parameters_fpo2_best.mat;
% err(2) = (Error_tot-original_error)/original_error;
% load parameters_fpo3_best.mat;
% err(3) = (Error_tot-original_error)/original_error;
% load parameters_fpo4_best.mat;
% err(4) = (Error_tot-original_error)/original_error;
% load parameters_fpo5_best.mat;
% err(5) = (Error_tot-original_error)/original_error;
% load parameters_fpo6_best.mat;
% err(6) = (Error_tot-original_error)/original_error;
% load parameters_fpo7_best.mat;
% err(7) = (Error_tot-original_error)/original_error;
% err = 100*err;
% 
% title('points removed from beginning');
% ylabel('% change in error');
% xlabel('number of points removed');
% bar(err,'FaceColor',[0.3,0.3,0.3]);
% xticks([1,2,3,4,5,6,7]);
% xticklabels({'1','2','3','4','5','6','7'});
% axis([0,8,0,200]);
% disp('press enter');
% pause;clc;clear err;
%% Figure 4 Top right panel
%reoptimization as a function of first passage optimized.

% load parameters_fpo4_best.mat;
% figure();clf;hold all;
% vis_sene_traj(result,state_num,fit,data);
% disp('press enter');
% pause;clc;clear err;
%% Figure 4 Row 2 Left
% Visualize reoptimization as a function of the last passage optimized.
% We stop at passage the end-1,end-2...end-7 (so 1-7 points are omitted).

% figure();clf;hold all;
% load('parameters_final_best.mat');
% original_error = Error_tot;
% 
% load parameters_lpo1_best.mat;
% err(1) = (Error_tot-original_error)/original_error;
% load parameters_lpo2_best.mat;
% err(2) = (Error_tot-original_error)/original_error;
% load parameters_lpo3_best.mat;
% err(3) = (Error_tot-original_error)/original_error;
% load parameters_lpo4_best.mat;
% err(4) = (Error_tot-original_error)/original_error;
% load parameters_lpo5_best.mat;
% err(5) = (Error_tot-original_error)/original_error;
% load parameters_lpo6_best.mat;
% err(6) = (Error_tot-original_error)/original_error;
% load parameters_lpo7_best.mat;
% err(7) = (Error_tot-original_error)/original_error;
% err = 100*err;
% 
% title('points removed from end');
% bar(err,'FaceColor',[0.3,0.3,0.3]);
% xticks([1,2,3,4,5,6,7]);
% xticklabels({'1','2','3','4','5','6','7'});
% axis([0,8,0,200]);
% disp('press enter');
% pause;clc;clear err;
%% Figure 4 Row 2 Right
% load parameters_lpo4_best.mat;
% figure();clf;hold all;
% vis_sene_traj(result,state_num,fit,data);
% disp('press enter');
% pause;clc;clear err;
%% Figure 4 Row 3 Left 
% Visualize reoptimization as a function of interval between passages.
% We keep 1 skip 1, keep 1 skip 2, and keep 1 skip 3 (so 8,10,12 points are
% omitted)

% figure();clf;hold all;
% load('parameters_final_best.mat');
% original_error = Error_tot;
% 
% load parameters_skip1_best.mat;
% err(1) = (Error_tot-original_error)/original_error;
% load parameters_skip2_best.mat;
% err(2) = (Error_tot-original_error)/original_error;
% load parameters_skip3_best.mat;
% err(3) = (Error_tot-original_error)/original_error;
% err = 100*err;
% 
% 
% title('keep 1 skip 1,2 or 3 points');
% bar([1,2,3],err,'FaceColor',[0.3,0.3,0.3]);
% xticks([1,2,3]);
% xticklabels({'8','10','12'});
% axis([0,4,0,200]);
% disp('press enter');
% pause;clc;clear err;
%% Figure 4 Row 3 Right
% load parameters_skip2_best.mat;
% figure();clf;hold all;
% vis_sene_traj(result,state_num,fit,data);
% disp('press enter');
% pause;clc;clear err;
%% Figure 4 Row 4 Left
% Visualize reoptimization as a function of omitted middle passages.
% We omit the middle 2,4,6,8 points and reoptimize.

% figure();clf;hold all;
% load('parameters_final_best.mat');
% original_error = Error_tot;
% 
% 
% load parameters_mpr2_best.mat;
% err(1) = (Error_tot-original_error)/original_error;
% load parameters_mpr4_best.mat;
% err(2) = (Error_tot-original_error)/original_error;
% load parameters_mpr6_best.mat;
% err(3) = (Error_tot-original_error)/original_error;
% load parameters_mpr8_best.mat;
% err(4) = (Error_tot-original_error)/original_error;
% err = 100*err;
% 
% title('middle points omitted');
% bar([1,2,3,4],err,'FaceColor',[0.3,0.3,0.3]);
% xticks([1,2,3,4]);
% xticklabels({'2','4','6','8'});
% axis([0,5,0,200]);
% disp('press enter');
% pause;clc;clear err;
%% Figure 4 Panel 3 right
% load parameters_mpr4_best.mat;
% figure();clf;hold all;
% vis_sene_traj(result,state_num,fit,data);
% disp('press enter');
% pause;clc;clear err;
%% Figure 5 - Sensitivity Analysis
% vis_sens2D;
% disp('press enter');
% pause;clc;
%% Supplemental Figure 1 - Vis Traj with G -> S transition equal 0
% figure();clf;hold all;
% % import
% input_file = 'parameters_QS0_best.mat';
% load(input_file)
% % Plot the model trajectories and the dataset
% vis_traj(result,state_num,fit,data);
% disp('press enter');
% pause;clc;
%% Supplemental Figure 2 - Trajectory Features (Supplemental Figure 2 comes from here)
% vis_curvs2D(7); % 1-6 give other features!!!
% disp('press enter');
% pause;clc;
