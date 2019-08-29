%% Initialize the routine. Change inputs here
restoredefaultpath;clear;clc;
% Add paths to auxillary functions and parameter files
addpath('functions');addpath('result_files');

% Choose one of the optimized parameter sets
input_file = 'parameters_final_best.mat';
load comparison_data.mat;
%% Extract features for the baseline trajectories
load(input_file);
[midpoint_orig_sene,midpoint_orig_prol,max_orig_grar,loc_orig_grar,max_orig_apop,loc_orig_apop,orig_S85] = feature_finder(result,state_num);

pts = 400;
max_par = [0.05,0.05,0.01,0.01,0.05];%2*max(result(1:10));
%% Produce Curve Figure 1 - 7
curve2D = 100*ones(4,pts,pts,7);
count_pars = 1;
disp('I take a minute to run (but Im worth the wait)');

count = 1;
for pars = {[1,2],[3,4],[6,7],[8,9]}
    
    mp = max_par(count);
    
    disp([num2str(count_pars),' of ',num2str(size(curve2D,1))]);
    count_val1 = 1;
    for val1 = linspace(0,mp,pts)
        count_val2 = 1;
        for val2 = linspace(0,mp,pts)
            new_result = result;
            new_result(pars{1}(1)) = val1;
            new_result(pars{1}(2)) = val2;
            
            % Find the features for the new parameters
            [midpoint_slope_sene,midpoint_slope_prol,max_grar,loc_grar,max_apop,loc_apop,S85] = feature_finder(new_result,state_num);

            % Find the percent change in each feature
            rel_slope_sene = max([-100,min([100,100*(midpoint_slope_sene-midpoint_orig_sene)/midpoint_orig_sene])]);
            rel_slope_prol = max([-100,min([100,100*(midpoint_slope_prol-midpoint_orig_prol)/midpoint_orig_prol])]);        
            rel_max_grar = max([-100,min([100,100*(max_grar - max_orig_grar)/max_orig_grar])]);
            rel_loc_grar = max([-100,min([100,100*(loc_grar - loc_orig_grar)/loc_orig_grar])]);
            rel_max_apop = max([-100,min([100,100*(max_apop - max_orig_apop)/max_orig_apop])]);
            rel_loc_apop = max([-100,min([100,100*(loc_apop - loc_orig_apop)/loc_orig_apop])]);
            rel_S85 = max([-100,min([100,100*(S85 - orig_S85)/orig_S85])]);          

            curve2D(count_pars,count_val1,count_val2,:) = [rel_slope_sene,rel_slope_prol,rel_max_grar,rel_loc_grar,rel_max_apop,rel_loc_apop,rel_S85];
            count_val2 = count_val2 + 1;
        end
        count_val1 = count_val1 + 1;
    end
    count_pars = count_pars + 1;
    
    count = count + 1;
end



%% Produce Curve Figure 8 - 14
curve_flats = zeros(2,pts,7);
count_pars = 1;
for pars = [5,10]
    disp([num2str(count_pars),' of ',num2str(size(curve2D,1))]);
    count_val1 = 1;
    for val1 = linspace(0,max_par(5),pts)
        new_result = result;
        new_result(pars) = val1;
        % Find the features for the new parameters
        [midpoint_slope_sene,midpoint_slope_prol,max_grar,loc_grar,max_apop,loc_apop,S85] = feature_finder(new_result,state_num);

        % Find the percent change in each feature
        rel_slope_sene = max([-100,min([100,100*(midpoint_slope_sene-midpoint_orig_sene)/midpoint_orig_sene])]);
        rel_slope_prol = max([-100,min([100,100*(midpoint_slope_prol-midpoint_orig_prol)/midpoint_orig_prol])]);        
        rel_max_grar = max([-100,min([100,100*(max_grar - max_orig_grar)/max_orig_grar])]);
        rel_loc_grar = max([-100,min([100,100*(loc_grar - loc_orig_grar)/loc_orig_grar])]);
        rel_max_apop = max([-100,min([100,100*(max_apop - max_orig_apop)/max_orig_apop])]);
        rel_loc_apop = max([-100,min([100,100*(loc_apop - loc_orig_apop)/loc_orig_apop])]);
        rel_S85 = max([-100,min([100,100*(S85 - orig_S85)/orig_S85])]);          

        curve_flats(count_pars,count_val1,:) = [rel_slope_sene,rel_slope_prol,rel_max_grar,rel_loc_grar,rel_max_apop,rel_loc_apop,rel_S85];


        count_val1 = count_val1 + 1;
    end
    count_pars = count_pars + 1;
end
%Save results
save('result_files/curves2D.mat','curve2D','curve_flats','input_file','max_par');

