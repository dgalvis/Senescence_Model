%=========================================================================%
% Functions: error = fit_sigmoid(ins,times,series)
% Created by: Daniel Galvis, Darren Walsh, James Rankin
% This function calculates the mean absolute error between an input
% trajectory and a sigmoid
% Inputs:
%   - ins = [shift, slope] parameters of the sigmoid
%   - times = times points for the trajectory
%   - series = time series to compare
%=========================================================================%
function error = fit_sigmoid(ins,times, series)
    % Extract shift and slope
    shift = ins(1);
    slope = ins(2);
    
    % Calculate the sigmoid at the given times
    sig = sigmoid([shift,slope],times);
    
    % Calculate the error
    error = mean(abs(sig - series));

end

