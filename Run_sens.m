%=========================================================================%
% Routine: Run_sens.m
% Creators: Daniel Galvis, Darren Walsh, James Rankin
% This routine extracts relative changes in error with respect to changes
% in paramters (sensitivity analysis)
% Types of changes in parameters:
%   INTERCEPT
%   The transitions for proliferative states Pi -> X i = 1...N are defined
%   by a line using endpoints. In this case, we increase and decrease those
%   lines without changing the slope.
%   SLOPE
%   The transitions for proliferative states Pi -> X i = 1...N are defined
%   by a line using endpoints. In this case, change the slopes of those
%   lines (where possible) without changing the middle value of the line.
% Output: Two .mat files
% sensitive_intersept.mat
%   - result, input_file - the name of the input file and the parameter set
%     contained in the file. This is just to track the information used as
%     a baseline for the analysis.
%   - sensitive - an array with useful information about the changes in
%     features and which parameters were adjusted.
%       sensitive = [(1)ParamLeft,(2)ParamRight, (3)percent change ParamLeft/ParamRight,
%                 (4) new_error, (5) relative change in error];
% sensitive_slope.mat
%   - result, input_file - the name of the input file and the parameter set
%     contained in the file. This is just to track the information used as
%     a baseline for the analysis.
%   - sensitive - an array with useful information about the changes in
%     features and which parameters were adjusted.
%       sensitive = [(1)ParamLeft,(2)ParamRight, (3)change in slope ratio,
%                 (4) new_error, (5) relative change in error];
%
% Note: sensitive contains these values for multiple changes in slope/intercept
% Note: sensitive has a (6) which is a bool
%                                      True - new parameters are not sensible
%                                      False - new parameters are useable
%=========================================================================% 
%% Initialize the routine. Change inputs here
restoredefaultpath;clear;clc;
% Add paths to auxillary functions and parameter files
addpath('functions');addpath('result_files');

% Choose one of the optimized parameter sets
input_file = 'parameters_final_best.mat';
load(input_file);
load comparison_data.mat
%% Produce sensitive_intercept.mat

% Baseline Error
original_error = Error_tot;
n_con = length(result);

count = 1;
clear sensitive
% These are the parameters that can be increased or decreased (intercept)
% [1,2] - Pi -> Pi+1
% [3,4] - Pi -> GA
% [5,5] - GA -> S
% [6,7] - Pi -> A
% [8,9] - Pi -> S
% [10,10]- A -> D (dead)
% [11,11] - P in H2AX
% [12,12] - G in Ki67
% [13,13] - G in H2AX
for pars = {[1,2],[3,4],[5,5],[6,7],[8,9],[10,10],[11,11],[12,12],[13,13]}
    % Fractional increases/decreases in the parameters
    for percent_change = [-0.4,-0.3,-0.2,-0.1,0.1,0.2,0.3,0.4]
        if percent_change == 0
            continue;
        end
        % Define new_result as the altered result
        new_result = result;
        mean_val = mean([result(pars{1}(1)),result(pars{1}(2))]);
        new_result(pars{1}(1)) = result(pars{1}(1)) + percent_change*mean_val;
        new_result(pars{1}(2)) = result(pars{1}(2)) + percent_change*mean_val;            
        
        % Calculate the errors
        new_error = opt_fun(new_result,state_num,data);
        rel_error = (new_error - original_error)/(original_error);
        
        % Make sure that there are no unsensible parameters
        check = 0;
        if pars{1}(1) == 11 || pars{1}(1) == 12 || pars{1}(1) == 13
            if new_result(pars{1}(1)) > 1 || new_result(pars{1}(1)) < 0
                check = 1;
            end
        end
        if ismember(pars{1}(1),linspace(1,10,10))
            if new_result(pars{1}(1)) <0 || new_result(pars{1}(2)) <0
                check = 1;
            end
        end
        
        % Add the results to the sensitive array
        sensitive(count,:) = [pars{1}(1),pars{1}(2),100*percent_change,new_error,100*rel_error,check];
        count = count + 1;
    end
end
% Save result
save('result_files/sensitive_intercept.mat','result','sensitive','input_file');  
        
%% Produce sensitive_slope.mat
count = 1;
clear sensitive;
% These are the parameters that can be increased or decreased (slope)
% [1,2] - Pi -> Pi+1
% [3,4] - Pi -> GA
% [6,7] - Pi -> A
% [8,9] - Pi -> S
for pars = {[1,2],[3,4],[6,7],[8,9]}
    % Find the original mean and slope of the parameters
    mean = (result(pars{1}(1))+result(pars{1}(2)))/2;
    slope = (result(pars{1}(2)) - result(pars{1}(1))); 

    % ratio change in the parameter slope
    for idx = linspace(-0.5,2.5,7)
        if idx == 1
            continue;
        end
        new_slope = idx*slope;
        % Redefine the endpoints for the new slope, keeping the original
        % mean
        new_result = result;
        new_result(pars{1}(2)) = mean + new_slope/2;
        new_result(pars{1}(1)) = new_result(pars{1}(2)) - new_slope;   
        
        % Calculate the errors
        new_error = opt_fun(new_result,state_num,data);
        rel_error = (new_error - original_error)/original_error;
        
        check = 0;
        if sum(new_result<0) > 0 
            check = 1;
        end
        
        % Add the results to the sensitive array        
        sensitive(count,:) = [pars{1}(1),pars{1}(2),idx,new_error,100*rel_error,check];
        count = count + 1;
    end
end
% This is because sometimes the unplausible parameter changes result in
% imaginary errors. These parameter sets are track by a value in the curve
% array and are ignored
sensitive = real(sensitive);
% Save results
save('result_files/sensitive_slope.mat','result','sensitive','input_file');     
    
    