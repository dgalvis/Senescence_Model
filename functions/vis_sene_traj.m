% function vis_traj(result,state_num,fit,data)
% Created by: Danny Galvis, Darren Walsh, James Rankin
% This function prints the model trajectory and the dataset for a given
% parameter set
% Inputs:
%   - result = parameters that result from the optimization (usually
%     contained in parameters_etc.mat
%   - state_num = number of proliferative states (also in
%     parameters_etc.mat)
%   - data = the values of the true dataset
%   - fit  = the values that were actually used to optimize the parameters
% Outputs:
%   - image of the trajectories and dataset
%   - the total error of this parameter set (display)
%   - fit data points are filled/omitted data points are open
function vis_sene_traj(result,state_num,fit,data)
%=========================================================================%
% % Initialize Parameters and run DS
%=========================================================================%        

    end_time = 5000;   
    [~,~, sene, ~, times, ~] = model_fun(result,state_num,end_time);

%=========================================================================%
% Index data for plotting, parameters fit vs omitted by optimiser 
%=========================================================================%
    %parameters not fit by optimiser
    idx = ~ismember(data.pass_b_gal,fit.pass_b_gal);
    omitted.pass_b_gal = data.pass_b_gal(idx);
    omitted.pass_b_gal = omitted.pass_b_gal(~isnan(omitted.pass_b_gal));
   
    idx = ~ismember(data.cum_hours,fit.cum_hours);
    omitted.cum_hours = data.cum_hours(idx);
    omitted.cum_hours = omitted.cum_hours(~isnan(omitted.cum_hours));

    %=========================================================================%
    % Plots
    %=========================================================================%
    % Array of grayscale colors for the polts
    C = repmat(linspace(0.1,0.7,4).',1,3); 
    
    % Beta Gal and Senescence
    hold on;
    plot(times,100*sene,'color',C(3,:),'LineWidth',3);
    scatter(fit.cum_hours,100*fit.pass_b_gal,'filled','ko','LineWidth',3);
    ylabel('% Senescence and Beta Gal');
    xlabel('Time (hours)');
    
    if ~isequal(data,fit)
        scatter(omitted.cum_hours,100*omitted.pass_b_gal,'ko','LineWidth',3);    
        legend('Model Senescent','Data Beta Gal Fit','Data Beta Gal omitted');
    else
        legend('Model Senescent','Data Beta Gal Fit');
    end
    axis([0,end_time,0,100]);

    
    %%%% PRINT RESULT, SHOW THE ERROR
    Error_tot = opt_fun(result,state_num,data);
    disp(['error of the trajectories vs. the full dataset: ',num2str(Error_tot)]);

end