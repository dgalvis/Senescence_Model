%% Initialize the routine. Change inputs here
restoredefaultpath;clear;clc;
% Add paths to auxillary functions and parameter files
addpath('functions');addpath('result_files');

% Choose one of the optimized parameter sets
input_file = 'parameters_final_best.mat';
load comparison_data.mat;
%% Extract features for the baseline trajectories
load(input_file);
original_error = opt_fun(result,state_num,data);
pts = 400;
max_par = [0.05,0.05,0.01,0.01,0.05];%2*max(result(1:10));


%% Create Results for 2D sensitivity Pi -> X
sensitive2D = zeros(4,pts,pts);
count_pars = 1;
disp('I take a minute to run (but Im worth the wait)');
disp('This is an alternative way of looking at sensitivity')
disp('Could replace the bar charts?? This takes slope/intercept at the same time');

count = 1;
for pars = {[1,2],[3,4],[6,7],[8,9]}
    
    mp = max_par(count);
    
    disp([num2str(count_pars),' of ',num2str(size(sensitive2D,1))]);
    count_val1 = 1;
    for val1 = linspace(0,mp,pts)
        count_val2 = 1;
        for val2 = linspace(0,mp,pts)
            new_result = result;
            new_result(pars{1}(1)) = val1;
            new_result(pars{1}(2)) = val2;
             % Calculate the errors
            new_error = opt_fun(new_result,state_num,data);
            rel_error = 100*(new_error - original_error)/(original_error);           
            if rel_error > 100
                rel_error = 100;
            end
            sensitive2D(count_pars,count_val1,count_val2) = rel_error;
            count_val2 = count_val2 + 1;
        end
        count_val1 = count_val1 + 1;
    end
    count_pars = count_pars + 1;
    
    count = count + 1;
end

%% Produce Sensitive Flats A->D, Q->S,
sensitive_flats = zeros(2,pts);
count_pars = 1;
for pars = [5,10]
    disp([num2str(count_pars),' of ',num2str(size(sensitive_flats,1))]);
    count_val1 = 1;
    for val1 = linspace(0,max_par(count),pts)
        new_result = result;
        new_result(pars) = val1;
         % Calculate the errors
        new_error = opt_fun(new_result,state_num,data);
        rel_error = 100*(new_error - original_error)/(original_error);           

        sensitive_flats(count_pars,count_val1) = rel_error;

        count_val1 = count_val1 + 1;
    end
    count_pars = count_pars + 1;
end

%% Produce Sensitive Fracts P -> H2AX, Q->Ki67, Q -> H2AX
sensitive_fracs = zeros(3,pts);
count_pars = 1;

for pars = [11,12,13]
    disp([num2str(count_pars),' of ',num2str(size(sensitive_fracs,1))]);
    count_val1 = 1;
    for val1 = linspace(0,1,pts)
        new_result = result;
        new_result(pars) = val1;
         % Calculate the errors
        new_error = opt_fun(new_result,state_num,data);
        rel_error = 100*(new_error - original_error)/(original_error);           

        sensitive_fracs(count_pars,count_val1) = rel_error;

        count_val1 = count_val1 + 1;
    end
    count_pars = count_pars + 1;
end


%Save results
save('result_files/sensitive2D.mat','sensitive2D','sensitive_flats','sensitive_fracs','input_file','max_par');

 