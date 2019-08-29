%=========================================================================%
% Routine check_traj.m
% Created By: Danny Galvis, Darren Walsh, James Rankin
% This routine allows for changing some of the parameters of an
% optimization and compare the different trajectories and Error_tot values
%=========================================================================%
%% Initialize
clear;clc;restoredefaultpath;
addpath('result_files');addpath('functions');
load('parameters_final_best.mat');
load('comparison_data.mat');

%% CHANGE THESE VALUES
change_me = [5,10];
vals = [10*result(5),10*result(10)];
%% Plot Trajectories and see Error_tot


figure(1);clf;
vis_traj(result,state_num,fit,data);

res_new = result;
idx = 1;
for i = change_me
    res_new(i) = vals(idx);
    idx = idx + 1;
end

figure(1);
vis_traj(res_new, state_num, fit, data);