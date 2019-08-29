%=========================================================================%
% Routine: Run_curv.m
% Creators: Daniel Galvis, Darren Walsh, James Rankin
% This routine extracts features for the model trajectories. It also
% assesses the effects of changes to the parameters on those features
% Features:
%  -Senescence (S) - Slope of the senescence curve when the population is 50%
%   of the total population
%  -Proliferative (P) - Slope of the proliferative curve when the population is
%   50% of the total population
%  -Growth-arrested (G) - Maximum fraction of the population and time to maximum
%  -Apoptotic (A) - Maximum fraction of the population and time to maximum
% Definitions:
%  - MS - slope of the senescence trajectory at 50% (midpoint)
%  - MP - slope of the proliferative trajectory at 50% (midpoint)
%  - MG - peak value of the growth-arrested population
%  - LG - time of peak value of the growth-arrested population
%  - MA - peak value of the apoptotic population
%  - LA - time of peak value of the apoptotic population
%  - S85- Time to 85% senescent
% Output: Two .mat files
% curves_intersept.mat
%   The transitions for proliferative states Pi -> X i = 1...N are defined
%   by a line using endpoints. In this case, we increase and decrease those
%   lines without changing the slope.
%   - result, input_file - the name of the input file and the parameter set
%     contained in the file. This is just to track the information used as
%     a baseline for the analysis.
%   - curve - an array with useful information about the changes in
%     features and which parameters were adjusted.
%       curve = [(1)ParamLeft,(2)ParamRight, (3)percent change ParamLeft/ParamRight,
%                 and rel. change in (4)MS, (5)MP,(6)MG,(7)LG,(8)MA,(9)LA];
% curves_slope.mat
%   The transitions for proliferative states Pi -> X i = 1...N are defined
%   by a line using endpoints. In this case, change the slopes of those
%   lines (where possible) without changing the middle value of the line.
%   - result, input_file - the name of the input file and the parameter set
%     contained in the file. This is just to track the information used as
%     a baseline for the analysis.
%   - curve - an array with useful information about the changes in
%     features and which parameters were adjusted.
%       curve = [(1)ParamLeft,(2)ParamRight, (3)change in slope ratio,
%                 and rel. change in (4)MS, (5)MP,(6)MG,(7)LG,(8)MA,(9)LA (10) S85];
%
%
% Note: curve contains these values for multiple changes in slope/intercept
% Note: curve has a (11) which is a bool
%                                      True - new parameters are not sensible
%                                      False - new parameters are useable
%=========================================================================% 
%% Initialize the routine. Change inputs here
restoredefaultpath;clear;clc;
% Add paths to auxillary functions and parameter files
addpath('functions');addpath('result_files');

% Choose one of the optimized parameter sets
input_file = 'parameters_final_best.mat';
%% Extract features for the baseline trajectories
load(input_file);
[midpoint_orig_sene,midpoint_orig_prol,max_orig_grar,loc_orig_grar,max_orig_apop,loc_orig_apop,orig_S85] = feature_finder(result,state_num);

%% Produce curves_intercept.mat
count = 1;
clear curve;

% These are the parameters that can be increased or decreased (intercept)
% [1,2] - Pi -> Pi+1
% [3,4] - Pi -> GA
% [5,5] - Q -> S
% [6,7] - Pi -> A
% [8,9] - Pi -> S
% [10,10]- A -> D (dead)
for pars = {[1,2],[3,4],[5,5],[6,7],[8,9],[10,10]}
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
        check = 0;
        if new_result(pars{1}(1)) <0 || new_result(pars{1}(2)) <0
                check = 1;
        end
        % Find the features for the new parameters
        [midpoint_slope_sene,midpoint_slope_prol,max_grar,loc_grar,max_apop,loc_apop,S85] = feature_finder(new_result,state_num);
        
        % Find the percent change in each feature
        rel_slope_sene = 100*(midpoint_slope_sene-midpoint_orig_sene)/midpoint_orig_sene;
        rel_slope_prol = 100*(midpoint_slope_prol-midpoint_orig_prol)/midpoint_orig_prol;        
        rel_max_grar = 100*(max_grar - max_orig_grar)/max_orig_grar;
        rel_loc_grar = 100*(loc_grar - loc_orig_grar)/loc_orig_grar;
        rel_max_apop = 100*(max_apop - max_orig_apop)/max_orig_apop;
        rel_loc_apop = 100*(loc_apop - loc_orig_apop)/loc_orig_apop;
        rel_S85 = 100*(S85 - orig_S85)/orig_S85;
                
        % Add the results to the curve array
        curve(count,:) = [pars{1}(1),pars{1}(2),100*percent_change,rel_slope_sene,rel_slope_prol,rel_max_grar,rel_loc_grar,rel_max_apop,rel_loc_apop,rel_S85,check];
        count = count + 1;
    end
end
% Save result
save('result_files/curves_intercept.mat','result','curve','input_file'); 

%% Produce curve_slope.mat
count = 1;
clear curve;

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
        
        % Find the features for the new parameters
        [midpoint_slope_sene,midpoint_slope_prol,max_grar,loc_grar,max_apop,loc_apop,S85] = feature_finder(new_result,state_num);

        % Find the percent change in each feature
        rel_slope_sene = 100*(midpoint_slope_sene-midpoint_orig_sene)/midpoint_orig_sene;
        rel_slope_prol = 100*(midpoint_slope_prol-midpoint_orig_prol)/midpoint_orig_prol;       
        rel_max_grar = 100*(max_grar - max_orig_grar)/max_orig_grar;
        rel_loc_grar = 100*(loc_grar - loc_orig_grar)/loc_orig_grar;
        rel_max_apop = 100*(max_apop - max_orig_apop)/max_orig_apop;
        rel_loc_apop = 100*(loc_apop - loc_orig_apop)/loc_orig_apop;
        rel_S85 = 100*(S85 - orig_S85)/orig_S85;        
        check = 0;
        if sum(new_result<0) > 0
            check = 1;
        end
        
        % Add the results to the curve array
        curve(count,:) = [pars{1}(1),pars{1}(2),idx,rel_slope_sene,rel_slope_prol,rel_max_grar,rel_loc_grar,rel_max_apop,rel_loc_apop,rel_S85,check];
        count = count + 1;
    end
end

% This is because sometimes the unplausible parameter changes result in
% imaginary errors. These parameter sets are track by a value in the curve
% array and are ignored
curve = real(curve);
% Save results
save('result_files/curves_slope.mat','result','curve','input_file');     
    



