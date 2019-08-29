%=========================================================================%
% Function: s = sigmoid(ins, times)
% Creators: Danny Galvis, Darren Walsh, James Rankin
% Inputs:
%  ins = [shift, slope]
%  times = array of values to evaluate the sigmoid
%=========================================================================%
function s = sigmoid(ins,times)
    % Extract the shift/slope values
    shift = ins(1);
    slope = ins(2);
    
    % Evaluate the sigmoid
    s = 1./(1 + exp(-slope*(times - shift)));
end