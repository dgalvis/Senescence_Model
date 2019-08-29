%=========================================================================%
% function set = data_subset(set, fw_pts)
% Created By: Danny Galvis, Darren Walsh, James Rankin
% This function takes the full data for one marker and returns the subset
% of points that will be optimized 
% Inputs:
%   - set -  full data array
%   - fw_pts - structure with the choice of points to omit
% Outputs:
%   - set -  subset of the data array
%=========================================================================%
function set = data_subset_single(set,fw_pts)


% fw_pts.int_ind - number to skip
% fw_pts.init_ind - first point
% fw_pts.init_end - last point

% if you keep more than half of the beginning and more than half of the end
% points, thats the same as keeping them all.
if fw_pts.int_add >= length(set)/2
    set = set(fw_pts.init_ind:fw_pts.int_ind:fw_pts.end_ind);
else
    % fw_pts.int_add - number of points to keep from beginning 
    %                - number of points to keep at the end
    
    % concatenate keeping some points at the beginning and some points at
    % the end (omitting middle points)
    set = [set(fw_pts.init_ind:fw_pts.int_ind:fw_pts.init_ind +fw_pts.int_add - 1) set(fw_pts.end_ind - fw_pts.int_add + 1:fw_pts.int_ind:fw_pts.end_ind)];
end
    