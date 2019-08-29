%=========================================================================%
% Function vis_param_supp(result,state_num,data,flag)
% Created by: Danny Galvis, Darren Walsh, James Rankin
% This function prints the parameters for the proliferative exit rates
% Pi -> X for i = 1...N
% Inputs:
%   - result = parameters that result from the optimization (usually
%     contained in parameters_etc.mat
%   - state_num = number of proliferative states (also in
%     parameters_etc.mat)
%   - data = the values of the true dataset
%   - flag = good (black plots), bad (green plots)
% Outputs:
%   - images of the parameter changes. Since this is usually used to plot
%     overlapping trajectories, we use subplots
%   - the total error of this parameter set (display)
%=========================================================================%

function vis_param_supp(result,state_num,data,flag)

    
    % Create lines based on the changing rates of Pi -> other pops
    states = linspace(0,1,state_num);
    PP = linspace(result(1),result(2),state_num);
    PG = linspace(result(3),result(4),state_num);
    PA = linspace(result(6),result(7),state_num);
    PS = linspace(result(8),result(9),state_num);
    
    % Plot
    subplot 321;hold all;
    title('Pi->Pi+1, black-good fit/green-worse fit');
    if strcmp(flag,'good')
        plot(states,PP,'color','k','LineWidth',6);       
    elseif strcmp(flag,'bad')
        plot(states,PP,'color','g','LineWidth',3); 
    end

    xticks([0,1]);
    xticklabels({'i=1','i=n'});
    yticks([0,0.024]);
    %yticklabels([]);
    %axis([0,1,0,0.024]);
    box on;
    
    subplot 322;hold all;
    title('Pi->GA, black-good fit/green-worse fit');
    if strcmp(flag,'good')    
        plot(states,PG,':','color','k','LineWidth',6);
    elseif strcmp(flag,'bad')
        plot(states,PG,'color','g','LineWidth',3); 
    end        

    xticks([0,1]);
    xticklabels({'i=1','i=n'});
    yticks([0,0.024]);
    %yticklabels([]);   
    %axis([0,1,0,0.024]);
    box on;
    
    subplot 323;hold all;
    title('Pi->A, black-good fit/green-worse fit');
    if strcmp(flag,'good') 
        plot(states,PA,':','color','k','LineWidth',6);
    elseif strcmp(flag,'bad')
        plot(states,PA,'color','g','LineWidth',3); 
    end         
        
    xticks([0,1]);
    xticklabels({'i=1','i=n'});
    yticks([0,0.024]);
    %yticklabels([]);
    %axis([0,1,0,0.024]);
    box on;
    
    subplot 324;hold all;
    title('Pi->S, black-good fit/green-worse fit');
    if strcmp(flag,'good') 
        plot(states,PS,'color','k','LineWidth',6);
    elseif strcmp(flag,'bad')
        plot(states,PS,'color','g','LineWidth',3); 
    end              

    xticks([0,1]);
    xticklabels({'i=1','i=n'});
    yticks([0,0.024]);
    %yticklabels([]);
    %axis([0,1,0,0.024]);
    box on;
    
    subplot 313;hold all;
    title('Other Parameters');
    if strcmp(flag,'good') 
        scatter(1,result(5),'filled','ko');
        scatter(2,result(10),'filled','ko');
        scatter(3,result(11),'filled','ko');
        scatter(4,result(12),'filled','ko');
        scatter(5,result(13),'filled','ko');
    elseif strcmp(flag,'bad')
        scatter(1,result(5),'filled','go');
        scatter(2,result(10),'filled','go');
        scatter(3,result(11),'filled','go');
        scatter(4,result(12),'filled','go');
        scatter(5,result(13),'filled','go');
    end
    axis([0,6,0,1]);
    xticks([1,2,3,4,5]);
    xticklabels({'Q->S','A->D','PinH2AX','QinKi67','QinH2AX'});
    
    
    
    
    
    % error for this parameter set
    Error_tot = opt_fun(result,state_num,data);
    disp(['error of the trajectories vs. the full dataset: ',num2str(Error_tot)]);
end