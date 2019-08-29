%=========================================================================%
% Function [MS,MP,MG,LG,MA,LA,S85] = feature_finder(result,state_num)
% Created by Daniel Galvis, Darren Walsh, James Rankin
% This function takes in a parameter array and the number of proliferative
% states and returns features of the model trajectories
% Features:
%  -Senescence - Slope of the senescence curve when the population is 50%
%   of the total population
%  -Proliferative - Slope of the proliferative curve when the population is
%   50% of the total population
%  -Growth-arrested - Maximum fraction of the population and time to maximum
%  -Apoptotic - Maximum fraction of the population and time to maximum
%
% Inputs:
%  - result: parameter array, normally extracted from a parameter_etc.mat
%    file
%  - state_num: The number of proliferative states, this should be
%    extracted from the same parameter_etc.mat file
%
% Outputs:
%  - MS - slope of the senescence trajectory at 50% (midpoint)
%  - MP - slope of the proliferative trajectory at 50% (midpoint)
%  - MG - peak value of the growth-arrested population
%  - LG - time of peak value of the growth-arrested population
%  - MA - peak value of the apoptotic population
%  - LA - time of peak value of the apoptotic population
%  - S85- Time to 85% senescence
%=========================================================================%

function [MS,MP,MG,LG,MA,LA,S85] = feature_finder(result,state_num)
    % End time (in hours) to run the DS
    end_time = 5000;
    % Run the model with the input parameters
    [prol, grar, sene, apop, times] = model_fun(result,state_num,end_time);

    options = statset('MaxIter',10000,'DerivStep',1e-5);
    % Fit a sigmoid to the senescent population (using normalized time)
    time_fit = linspace(0,1,length(times));
    sene_sig = nlinfit(time_fit,sene, @(ins,t)sigmoid(ins,t), [0.5,1],options);
    error_sene = fit_sigmoid(sene_sig,time_fit,sene);
%     %disp(['error_sene: ',num2str(error_sene)]); 
%     plot(time_fit,sene,'b',time_fit,sigmoid(sene_sig,time_fit),'k');
%     pause;
    % Fit a sigmoid to the proliferative population (using normalized time)
    prol_sig = nlinfit(time_fit,prol, @(ins,t)sigmoid(ins,t), [0.5,-1],options);
    error_prol = fit_sigmoid(prol_sig,time_fit,prol);
%     %disp(['error_prol: ',num2str(error_prol)]); 
%     plot(time_fit,prol,'b',time_fit,sigmoid(prol_sig,time_fit),'k');
%     pause;    

    
    
    % Extract the midpoint slope.
    % The slope at the midpoint of a sigmoid is K/4 where K is the slope
    % parameter
    % Divide by the total runtime of the DS to unnormalize
    MS = sene_sig(2)/(4*end_time);
    MP = prol_sig(2)/(4*end_time);
    % Time to 85% senescent
    S85 = interp1(sene,times,0.85);
    
    % Extract Max and Time to Max for Growth-Arrested and Apoptotic
    % populations
    MG = max(grar);
    LG = times(find(grar==max(grar)));
    LG = LG(1);
    
    MA = max(apop);
    LA = times(find(apop==max(apop)));
    LA = LA(1);



end