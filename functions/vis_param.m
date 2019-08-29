%=========================================================================%
% Function vis_param(result,state_num,data)
% Created by: Danny Galvis, Darren Walsh, James Rankin
% This function prints the parameters for the proliferative exit rates
% Pi -> X for i = 1...N
% Inputs:
%   - result = parameters that result from the optimization (usually
%     contained in parameters_etc.mat
%   - state_num = number of proliferative states (also in
%     parameters_etc.mat)
%   - data = the values of the true dataset
% Outputs:
%   - image of the parameter changes
%   - the total error of this parameter set (display)
%=========================================================================%
function vis_param(result,state_num,data)

    % Hold all output plots
    hold all;
    
    % Create lines based on the changing rates of Pi -> other pops
    states = linspace(0,1,state_num);
    PP = linspace(result(1),result(2),state_num);
    PG = linspace(result(3),result(4),state_num);
    PA = linspace(result(6),result(7),state_num);
    PS = linspace(result(8),result(9),state_num);
    
    % Plot
    plot(states,PP,'color','k','LineWidth',6);
    plot(states,PG,':','color','k','LineWidth',6);
    plot(states,PA,':','color',[0.6,0.6,0.6],'LineWidth',6);
    plot(states,PS','color',[0.6,0.6,0.6],'LineWidth',6);
    legend('proliferation','growth arrest','apoptosis','senescence');
    title('exit rates for Pi vs. i');
    xticks([0,1]);
    xticklabels({'i=1','i=n'});
    yticks([0,0.024]);
    %yticklabels([]);
    box on;
    
    % error for this parameter set
    Error_tot = opt_fun(result,state_num,data);
    disp(['error of the trajectories vs. the full dataset: ',num2str(Error_tot)]);   
    
end