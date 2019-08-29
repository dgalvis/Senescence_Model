%=========================================================================%
% function fit = data_subset(data, fw_pts)
% Created By: Danny Galvis, Darren Walsh, James Rankin
% This function takes the full data set and returns the subset of points
% that will be optimized
% Inputs:
%   - data - structure of the full data
%   - fw_pts - structure with the choice of points to omit
% Outputs:
%   - fit - structure of the subset of the data
%=========================================================================%

function fit = data_subset(data, fw_pts)


    fit.pass_b_gal = data_subset_single(data.pass_b_gal,fw_pts);
    fit.pass_ki_67 = data_subset_single(data.pass_ki_67,fw_pts);
    fit.pass_H2Ax = data_subset_single(data.pass_H2Ax,fw_pts);
    fit.pass_tunel = data_subset_single(data.pass_tunel,fw_pts);
    fit.cum_hours = data_subset_single(data.cum_hours,fw_pts);
    fit.cum_PD = data_subset_single(data.cum_PD,fw_pts);



end