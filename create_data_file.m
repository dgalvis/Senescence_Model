%=========================================================================%
% Routine create_data_file.m
% Created by Daniel Galvis, Darren Walsh, James Rankin
% This routine takes the following dataset and puts it into a struct called
% data
% Output: A file called comparison_data.mat with struct data.
%=========================================================================%
restoredefaultpath;clear;clc;

% Number of hours for each passage
pass_hours = [96,100,96,96,100,120,120,144,144,168,168,240,240,240,240,240];
% Number of population doublings
pass_PD = [4.993293794,4.639315618,0.679905171,0.471037541,0.453381914,...
           1.170623482,0.287422211,1.837168158,0.691670928,2.264236077,...
           0.251945388,1.47405804,0.642656024,0.535622859,1.007921222,...
           0.115381878];
%Percent of cells expressing Beta_gal     
pass_b_gal= [5.796666667,12.10666667,14.78,19.8501,...
             21.36073,23.90333333,30.54280288,29.00333333,32.44333333,36.72,...
             37.7,45.36411784,60.14598928,66.7262809,69.76345611,73.24407115];
% Percent of cells expressing Ki_67
pass_ki_67 = [87.41535081,79.35617497,80.12315436,77.44497608,72.55634562,...
             67.80056201,61.95670996,66.31289081,56.77588523,58.56601732,...
             52.82037686,47.2664554,37.75,37.40334897,20.82796216,20.02797247];
% Percent of cells expressing H2AX
pass_H2Ax = [37.97321154,31.80531506,40.22083935,50.87001595,53.31457491,...
             57.61363636,68.18382235,67.63352479,76.56124641,76.63113355,...
             71.08888092,84.58069419,82.83730159,85.3697214,87.40302973,...
             98.28643579];
% Percent of cells expressing TUNEL
pass_tunel = [6.94938,4.576376,5.812636,11.69348,6.851392,14.98786,8.75118,...
              8.186994,8.272053,9.297292,8.302617,13.019333,15.86661,9.225962,...
              9.398567,6.038771];
          

%cumulative hours at which the passages were taken
for i = 1:size(pass_hours,2)
   cum_hours(i) = sum(pass_hours(1:i)); 
end
%cumulative population doublings at each passage
for i = 1:size(pass_hours,2)
   cum_PD(i) = sum(pass_PD(1:i)); 
end

% Fractions of cells expressing these markers
pass_b_gal = pass_b_gal/100;
pass_ki_67 = pass_ki_67/100;
pass_H2Ax = pass_H2Ax/100;
pass_tunel = pass_tunel/100;

% Create data structure
data.pass_b_gal = pass_b_gal;
data.pass_ki_67 = pass_ki_67;
data.pass_H2Ax = pass_H2Ax;
data.pass_tunel = pass_tunel;
data.cum_hours = cum_hours;
data.cum_PD = cum_PD;

%save function. The first input is the .mat file to be created or updated
save('comparison_data.mat','data');

clear;

