function Run_opts_kfold(input)
    %=====================================================================%
    % Routine Run_opts_kfold(input)
    
    % Created By: Danny Galvis, Darren Walsh, James Rankin
    % This routine performs the global optimization of the holdout method
    % The input is the index of a parameter that is to be fixed 

    % INPUTS
    % input: 1-13 will fix one of the 13 parameters/14 will not fix any parameters

    % Choose your optimizer
    % alg_type = 'ga', 'so', 'both'


    % Note state num is the number of proliferative state Pi
    % Warning: These simulations take a long time
    %=====================================================================%
    %% Initialize the routine.
    restoredefaultpath;%clear;clc;
    % Add paths to auxillary functions and parameter files
    addpath('functions');addpath('result_files');
    % If this file doesn't exist, run data_stuff.m
    load parameters_final_best.mat;
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

    if(max(size(range_lb))>=input)
        range_lb(input) = result(input);
        range_ub(input) = result(input);
        disp(range_lb);
        disp(range_ub);
    else
        disp(range_lb);
        disp(range_ub);
    end
    %% Choose which data points to actually optimize
    % Choose the data points to optimize (here this is all of them)
    fw_pts.init_ind = 1;                                       %First passage included in optimiser (default value = 1)    
    fw_pts.int_ind = 1;                                        %Interval between passages included in optimiser (default value = 1)
    end_sub = 0;                                               %Number of end passages to exclude from optimiser (default value of 0 = no exclusion)
    fw_pts.end_ind = length(data.cum_hours) - end_sub;         %Last passage included in optimiser
    fw_pts.int_add = 20;                                       %>=8 all points inc, 1-7 removes 14-2 pts
    fit = data_subset(data, fw_pts); 
    %% Holdout Cross-Validation
    rng(100);
    tot_it = 10;
    tot_K  = 20;
    aux_perm = zeros(tot_K,length(fit.cum_PD));
    for ii = 1:tot_K
        aux_perm(ii,:) = randperm(length(fit.cum_PD));
    end
    
    rng('shuffle');

    for ii = 1:tot_K
        clear keep fit_aux;    
        keep = aux_perm(ii,:);
        keep = keep(1:round(length(keep)*0.8));
        keep = sort(keep); 
        fn = fieldnames(fit);
        for k=1:numel(fn)
            if( isnumeric(fit.(fn{k})))
                pts = fit.(fn{k});
                pts = pts(keep);
                fit_aux.(fn{k})=pts;
            end
        end

        for jj = 1:tot_it
            disp(['kfold ',num2str(ii),' ',num2str(jj)]);
            run_optimization_leaveout(input,fit_aux,data,range_lb,range_ub,state_num,...
                    alg_type , randi(1e9), ['result_files/parameters_kfold',num2str(ii),'_it',num2str(jj),'_parex',num2str(input)]);
        end
    end
end
