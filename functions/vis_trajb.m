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
function vis_trajb(result,state_num,fit,data)
%=========================================================================%
% % Initialize Parameters and run DS
%=========================================================================%        

    end_time = 5000;
    P_in_H2AX = result(11);
    G_in_Ki67 = result(12);
    G_in_H2AX = result(13);    
 
    [prol, grar, sene, apop, times, PD] = model_fun(result,state_num,end_time);

%=========================================================================%
% Index data for plotting, parameters fit vs omitted by optimiser 
%=========================================================================%
    %parameters not fit by optimiser
    idx = ~ismember(data.pass_b_gal,fit.pass_b_gal);
    omitted.pass_b_gal = data.pass_b_gal(idx);
    omitted.pass_b_gal = omitted.pass_b_gal(~isnan(omitted.pass_b_gal));

    idx = ~ismember(data.pass_ki_67,fit.pass_ki_67);
    omitted.pass_ki_67 = data.pass_ki_67(idx);
    omitted.pass_ki_67 = omitted.pass_ki_67(~isnan(omitted.pass_ki_67));

    idx = ~ismember(data.pass_H2Ax,fit.pass_H2Ax);
    omitted.pass_H2Ax = data.pass_H2Ax(idx);
    omitted.pass_H2Ax = omitted.pass_H2Ax(~isnan(omitted.pass_H2Ax));

    idx = ~ismember(data.pass_tunel,fit.pass_tunel);
    omitted.pass_tunel = data.pass_tunel(idx);
    omitted.pass_tunel = omitted.pass_tunel(~isnan(omitted.pass_tunel));

    idx = ~ismember(data.cum_PD,fit.cum_PD);
    omitted.cum_PD = data.cum_PD(idx);
    omitted.cum_PD = omitted.cum_PD(~isnan(omitted.cum_PD));

    idx = ~ismember(data.cum_hours,fit.cum_hours);
    omitted.cum_hours = data.cum_hours(idx);
    omitted.cum_hours = omitted.cum_hours(~isnan(omitted.cum_hours));

    %=========================================================================%
    % Plots
    %=========================================================================%
    hold all;

    % Array of grayscale colors for the polts
    C = repmat(linspace(0.1,0.7,4).',1,3);

    % Plot the trajectories of the populations
    subplot(3,2,6);hold on;
    plot(times,prol,'color',C(1,:),'LineWidth',3);
    plot(times,sene,'color',C(2,:),'LineStyle','--','LineWidth',3);
    plot(times,grar,'color',C(3,:),'LineStyle','-.','LineWidth',3);
    plot(times,apop,'color',C(4,:),'LineStyle',':','LineWidth',3);
    legend('proliferative','senescent','growth-arrested','apoptotic');
    xlabel('Time (hours)');
    ylabel('Fraction of Total Population');
    title('Model Populations');
    axis([0,end_time,0,1]);
    
    

    % Total Population Doublings PLOT (model and data)
    subplot(3,2,1);hold on;
    plot(times,PD,'color',C(3,:),'LineWidth',3);
    scatter(fit.cum_hours,fit.cum_PD,'filled','ko','LineWidth',3);
    ylabel('Number of Doublins');
    xlabel('Time (hours)');
    title('Total Population Doublings');
    if ~isequal(data,fit)
        scatter(omitted.cum_hours,omitted.cum_PD,'ko','LineWidth',3);    
        legend('Model Total Doublings','Data Total Doublings Fit',...
               'Data Total Doublings omitted');   
    else
        legend('Model Total Doublings','Data Total Doublings Fit');
    end
    axis([0,end_time,0,40]);
    
    
    
    % Beta Gal and Senescence
    subplot(3,2,2);hold on;
    plot(times,100*sene,'color',C(3,:),'LineWidth',3);
    scatter(fit.cum_hours,100*fit.pass_b_gal,'filled','ko','LineWidth',3);
    ylabel('% Cells Expressing SA-\beta-gal');
    xlabel('Time (hours)');
    title('SA-\beta-gal vs (S) Population');
    
    if ~isequal(data,fit)
        scatter(omitted.cum_hours,100*omitted.pass_b_gal,'ko','LineWidth',3);    
        legend('Model Senescent','Data Beta Gal Fit','Data Beta Gal omitted');
    else
        legend('Model Senescent','Data Beta Gal Fit');
    end
    axis([0,end_time,0,100]);
    
    
    
    % Ki_67 and prolif
    subplot(3,2,3);hold on;
    plot(times,100*(prol+ G_in_Ki67*grar),'color',C(3,:),'LineWidth',3);
    scatter(fit.cum_hours,100*fit.pass_ki_67,'filled','ko','LineWidth',3);
    ylabel('% Cells Expressing Ki-67');
    xlabel('Time (hours)');   
    title(['Ki-67 vs (P) + ',num2str(result(end-1)),'(G) Populations']);
    if ~isequal(data,fit)
        scatter(omitted.cum_hours,100*omitted.pass_ki_67,'ko','LineWidth',3);    
        legend('Model Prolif/Quies','Data Ki67 Fit','Data Ki67 omitted'); 
    else
        legend('Model Prolif/Quies','Data Ki67 Fit'); 
    end
    axis([0,end_time,0,100]);
    
    
    
    % H2Ax and sen + dead cells + some % prolif
    subplot(3,2,4);hold on;
    plot(times,100*(sene + apop + P_in_H2AX*prol + G_in_H2AX*grar), 'color',C(3,:),'LineWidth',3);
    scatter(fit.cum_hours,100*fit.pass_H2Ax,'filled','ko','LineWidth',3);
    ylabel('% Cells Expressing \gammaH2AX');
    xlabel('Time (hours)');
    title(['\gammaH2AX vs (S) + (A) + ',num2str(result(end)),'(G) + ',num2str(result(end-2)),'(P) Populations']);
    
    if ~isequal(data,fit)    
        scatter(omitted.cum_hours,100*omitted.pass_H2Ax,'ko','LineWidth',3);    
        legend('Model Sen/Apop','Data H2Ax Fit','Data H2Ax omitted'); 
    else
        legend('Model Sen/Apop','Data H2Ax Fit');
    end
    axis([0,end_time,0,100]);
    
    
    
    %tunel and apoptotic cells
    subplot(3,2,5);hold on;
    plot(times,100*apop,'color',C(3,:),'LineWidth',3);
    scatter(fit.cum_hours,100*fit.pass_tunel,'filled','ko','LineWidth',3);
    ylabel('% Cells Expressing TUNEL');
    xlabel('Time (hours)');
    title('TUNEL vs (A) Population');
    
    if ~isequal(data,fit)      
        scatter(omitted.cum_hours,100*omitted.pass_tunel,'ko','LineWidth',3);    
        legend('Model Apop','Data Tunel Fit','Data Tunel omitted');
    else
        legend('Model Apop','Data Tunel Fit');
    end
    axis([0,end_time,0,100]);
    
    
    
    %%%% PRINT RESULT, SHOW THE ERROR
    Error_tot = opt_fun(result,state_num,data);
    disp(['error of the trajectories vs. the full dataset: ',num2str(Error_tot)]);

end