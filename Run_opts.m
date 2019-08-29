%=========================================================================%
% Routine Run_opts.m
% Created By: Danny Galvis, Darren Walsh, James Rankin
% This routine performs the global optimization multiple times for various
% subsets of the full dataset

% Choose your optimizer
% alg_type = 'ga', 'so', 'both'

% Optimization
% (1) Full dataset, state_num = 50
% (2) Full dataset, state_num = 40,50,60,100,150
% (3) Subsets of the data keep 1 skip 1,2,or 3
% (4) Subsets of the data omitting beginning, middle, end points
% (5) Full dataset, state_num = 50, G -> S = 0
% (6) Holdout cross-validation method

% Note state num is the number of proliferative state Pi
% Warning: These simulations take a long time
%=========================================================================%
%% Initialize the routine.
restoredefaultpath;clear;clc;
% Add paths to auxillary functions and parameter files
addpath('functions');addpath('result_files');
% If this file doesn't exist, run data_stuff.m
load comparison_data.mat;
% Type of global optimizer
alg_type = 'ga'; % can be 'so' or 'ga' or 'both'
rng('shuffle');
%% Set the bounds for the optimization
% Parameter choices and ranges
state_num = 50;
range_lb = 0*ones(1,10);
range_ub = 0.05*ones(1,10);
range_lb = [range_lb,0,0,0];
range_ub = [range_ub,1,1,1];
% 13 parameters
% left division rate (1), right division rate (2)
% left prol -> quiescent (3), right prol -> quiescent (4)
% quie -> senesce (5)
% left prol -> apop (6), right prol -> apop (7)
% left prol -> senesce (8), right prol -> senesce (9)
% apop -> death (10)
% %prol in H2Ax (11) %quiescent in Ki67 (12) %quiescent in H2Ax (13)

%% Choose which data points to actually optimize
% Choose the data points to optimize (here this is all of them)
fw_pts.init_ind = 1;                                       %First passage included in optimiser (default value = 1)    
fw_pts.int_ind = 1;                                        %Interval between passages included in optimiser (default value = 1)
end_sub = 0;                                               %Number of end passages to exclude from optimiser (default value of 0 = no exclusion)
fw_pts.end_ind = length(data.cum_hours) - end_sub;         %Last passage included in optimiser
fw_pts.int_add = 20;                                       %>=8 all points inc, 1-7 removes 14-2 pts
fit = data_subset(data, fw_pts);


%% Run Optimizations
% % Full Dataset
% tot_its = 10;
% seeds = randi(1e9,[tot_its,1]);
% for i = 1:tot_its
%     disp(num2str(i));
%     run_optimization(fit, data, range_lb, range_ub, state_num, ...
%                     alg_type , seeds(i),['result_files/parameters_final',num2str(i)]);
% end    
% 
% % Vary State Number
% it_num= [linspace(1,tot_its,tot_its),linspace(1,tot_its,tot_its),...
%          linspace(1,tot_its,tot_its),linspace(1,tot_its,tot_its)];
% init  = [linspace(40,40,tot_its),linspace(60,60,tot_its),...
%          linspace(100,100,tot_its),linspace(150,150,tot_its)];
% seeds = randi(1e9,[length(init),1]);
% for i = 1:length(init)
%     disp(['state_num: ',num2str(init(i)),'//it: ',num2str(it_num(i))]);
%     sn = init(i);
%     run_optimization(fit, data, range_lb, range_ub, sn, ...
%                     alg_type , seeds(i), ['result_files/parameters_stnum',num2str(sn),'_it',num2str(it_num(i))]);
% end

%% Run optimization adjusting which data points get fit
% Vary First Passage Optimized (2 - 8)
% tot_its = 10;
% 
% it_num = [linspace(1,tot_its,tot_its),linspace(1,tot_its,tot_its),...
%           linspace(1,tot_its,tot_its),linspace(1,tot_its,tot_its),...
%           linspace(1,tot_its,tot_its),linspace(1,tot_its,tot_its),...
%           linspace(1,tot_its,tot_its)];
% init   = [linspace(1,1,tot_its),linspace(2,2,tot_its),linspace(3,3,tot_its),...
%           linspace(4,4,tot_its),linspace(5,5,tot_its),linspace(6,6,tot_its),...
%           linspace(7,7,tot_its)];
      
% seeds = randi(1e9,[length(init),1]);
% for jj = 1:length(init)  
%     disp(['fpo ',num2str(init(jj)),' ',num2str(it_num(jj))]);
%     fw_pts_aux = fw_pts;
%     fw_pts_aux.init_ind = init(jj)+1;
%     fit_aux = data_subset(data, fw_pts_aux);
%     run_optimization(fit_aux,data,range_lb,range_ub,state_num,...
%            alg_type , seeds(jj), ['result_files/parameters_fpo',num2str(init(jj)),'_it',num2str(it_num(jj))]);
% end
% %Vary Last Passage Optimized(end - 1 to end - 7)
% seeds = randi(1e9,[length(init),1]);
% for jj = 1:length(init)    
%     disp(['lpo ',num2str(init(jj)),' ',num2str(it_num(jj))]);
%     fw_pts_aux = fw_pts;
%     fw_pts_aux.end_ind = fw_pts_aux.end_ind - init(jj);
%     fit_aux = data_subset(data, fw_pts_aux);
%     run_optimization(fit_aux,data,range_lb,range_ub,state_num,...
%            alg_type , seeds(jj), ['result_files/parameters_lpo',num2str(init(jj)),'_it',num2str(it_num(jj))]);
% end
% %Intervals between optimized passages (skip 1,2,3)
% it_num = [linspace(1,tot_its,tot_its),linspace(1,tot_its,tot_its),linspace(1,tot_its,tot_its)];
% init   = [linspace(1,1,tot_its),linspace(2,2,tot_its),linspace(3,3,tot_its)];
% seeds = randi(1e9,[length(init),1]);
% for jj = 1:length(init)
%     disp(['skip ',num2str(init(jj)),' ',num2str(it_num(jj))]);
%     fw_pts_aux = fw_pts;
%     fw_pts_aux.int_ind = init(jj)+1; 
%     fit_aux = data_subset(data, fw_pts_aux);
%     run_optimization(fit_aux,data,range_lb,range_ub,state_num,...
%             alg_type , seeds(jj),['result_files/parameters_skip',num2str(init(jj)),'_it',num2str(it_num(jj))]);
% 
% end

% % Removing 2,4,6,8 pts from the middle (middle passage removed)
% it_num = [linspace(1,tot_its,tot_its),linspace(1,tot_its,tot_its),...
%           linspace(1,tot_its,tot_its),linspace(1,tot_its,tot_its)];
% init   = [linspace(4,4,tot_its),linspace(5,5,tot_its),...
%           linspace(6,6,tot_its),linspace(7,7,tot_its)];
% seeds = randi(1e9,[length(init),1]);
% for jj = 1:length(init)
%     disp(['mpr ',num2str(16-2*init(jj)),' ',num2str(it_num(jj))]);
%     fw_pts_aux = fw_pts;
%     fw_pts_aux.int_add = init(jj);
%     fit_aux = data_subset(data, fw_pts_aux);
%     run_optimization(fit_aux,data,range_lb,range_ub,state_num,...
%             alg_type , seeds(jj), ['result_files/parameters_mpr',num2str(16 - 2*init(jj)),'_it',num2str(it_num(jj))]);
% 
% end

%% Run with GA -> S always 0
% Parameter choices and ranges
% tot_its = 10;
% 
% state_num2 = 50;
% range_lb2 = 0*ones(1,10);
% range_ub2 = 0.05*ones(1,10);
% range_lb2 = [range_lb2,0,0,0];
% range_ub2 = [range_ub2,1,1,1];
% range_ub2(5) = 0;
% 
% % Full Dataset
% seeds = randi(1e9,[12,1]);
% for i = 1:tot_its
%     disp(num2str(i));
%     run_optimization(fit, data, range_lb2, range_ub2, state_num2, ...
%                     alg_type , seeds(i),['result_files/parameters_QS0_it',num2str(i)]);
% end   
%% Holdout Cross-Validation
% tot_it = 10;
% tot_K  = 20;
% 
% for ii = 1:tot_K
%     clear keep fit_aux;    
%     keep = randperm(length(fit.cum_PD));
%     keep = keep(1:round(length(keep)*0.8));
%     keep = sort(keep); 
%     fn = fieldnames(fit);
%     for k=1:numel(fn)
%         if( isnumeric(fit.(fn{k})))
%             pts = fit.(fn{k});
%             pts = pts(keep);
%             fit_aux.(fn{k})=pts;
%         end
%     end
%     
%     for jj = 1:tot_it
%         disp(['kfold ',num2str(ii),' ',num2str(jj)]);
%         run_optimization(fit_aux,data,range_lb,range_ub,state_num,...
%                 alg_type , randi(1e9), ['result_files/parameters_kfold',num2str(ii),'_it',num2str(jj)]);
%     end
% end














