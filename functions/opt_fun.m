%=========================================================================%
% Function: Error_tot = opt_fun(guess,state_num,fit)
% Created by: Daniel Galvis, Darren Walsh, James Rankin
% Takes in parameters, number of proliferative states, and points to fit
% Returns the error of the optimizer. This function is used by the global
% optimizers
% Inputs:
%   - guess - guess parameters
%   - state_num - the number of proliferative states, also derived from the
%     parameter files (parameters_etc.mat)
%   - fit - subset of data to use for optimization
%
% Outpus:
%   - Error_tot - error of the cost function
%
% Note: See the cost function below
%=========================================================================%
function Error_tot = opt_fun(guess,state_num,fit)
%=========================================================================%
% Initiate parameters for optimiser
%=========================================================================%


    % End point in hours                        
    end_time = fit.cum_hours(end); 
    P_in_H2AX = guess(11);
    G_in_Ki67 = guess(12);
    G_in_H2AX = guess(13);        

    [prol, grar, sene, apop, times, PD] = model_fun(guess,state_num,end_time);


%=========================================================================%
% Interpolate the trajectories at the time points in the dataset
%=========================================================================%

    % Linear interpolation to get model total population doublings at the same
    % points we have actual total population doublings
    model_PD = interp1(times,PD,fit.cum_hours,'linear');

    %Model senescence
    model_b_gal = interp1(times,sene,fit.cum_hours,'linear');

    %Model ki67
    model_ki_67 = interp1(times,(prol+ G_in_Ki67*grar),fit.cum_hours,'linear');

    %Model H2Ax
    model_H2Ax = interp1(times,(sene + apop + P_in_H2AX*prol + G_in_H2AX*grar),fit.cum_hours,'linear');

    %model tunel
    model_tunel = interp1(times,apop,fit.cum_hours,'linear');

%=========================================================================%
% Cost Function  
%=========================================================================%        


    Error(1,1) = nansum(((fit.cum_PD-model_PD)).^2)/nanmax(fit.cum_PD)^2;
    Error(1,2) = nansum(((model_b_gal-fit.pass_b_gal)).^2)/nanmax(fit.pass_b_gal)^2;
    Error(1,3) = nansum(((model_ki_67-fit.pass_ki_67)).^2)/nanmax(fit.pass_ki_67)^2;
    Error(1,4) = nansum(((model_H2Ax-fit.pass_H2Ax)).^2)/nanmax(fit.pass_H2Ax)^2;
    Error(1,5) = nansum(((model_tunel -fit.pass_tunel)).^2)/nanmax(fit.pass_tunel)^2;

    Error_tot = sqrt(Error(1,1) + Error(1,2) + Error(1,3) + Error(1,4) + Error(1,5));

        

end
      
