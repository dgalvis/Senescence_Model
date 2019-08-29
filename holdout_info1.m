clear;close all;clc;restoredefaultpath;

% Load the baseline Error_tot from the best total optimization 
load('result_files/parameters_final_best.mat');
baseline = Error_tot;

% 1-13 are parameters that are fixed/14 is no parameter fixed
% 20 sets of holdouts
err = zeros(14,20);

% Load in the Error_tot, the error over all points (including held out
% points), for the optimizations fit with held out points and sometimes
% individual parameters held fixed at best value.
for idx = 1:14
    name = ['parex',num2str(idx)];
    restoredefaultpath;addpath(['result_files/holdout_keep/',name]);
    for k = 1:20,
        try
        load(['result_files/holdout_keep/',name,'/parameters_best_kfold',num2str(k),'_',name,'_ga.mat']);
        err(idx,k) = Error_tot;
        catch
            continue
        end
    end  
end

% Find the percent increase in the Error_tot over the baseline.
err2 = zeros(14,20);
for i = 1:14
    for j = 1:20
        if err(i,j) ~=0
            err2(i,j) = 100*(err(i,j)-baseline)/baseline;
        else
            err2(i,j) = 0;
        end
    end
end

disp('order of parameters fixed at best value');
order = {'LeftPP','RightPP', 'LeftPG','RightPG',...
         'GS', 'LeftPA','RightPA', 'LeftPS','RightPS',...
          'AD','P_in_H2AX', 'G_in_Ki67', 'G_in_H2AX','baseline'}
% Calculate statistics
stats = zeros(14,3);
for i = 1:14
    stats(i,1) = median(nonzeros(err2(i,:)));
    stats(i,2) = mean(nonzeros(err2(i,:)));
    stats(i,3) = std(nonzeros(err2(i,:)));
end
stats

% Plot results
figure(1);clf;hold all;
for i = 1:14
    for j = 1:20
        if err2(i,j) ~= 0
            scatter(i,err2(i,j),'k');
        end
    end
end

% Are the error distributions for each of the fixed parameters and the case
% where all parameters are not fixed gaussian??
p = [];h = [];
p2 = [];h2 = [];
p0 = [];h0 = [];
for i = 1:14
    err_aux = nonzeros(err(i,:));
    [haux0,paux0] = kstest((err_aux - mean(err_aux))/std(err_aux)); 
    p0 = [p0,paux0];h0 = [h0,haux0];
end
% Evaluate significance decreases in Error_tot when a single parameter is
% fixed vs. when all parameters are free 
for i = 1:13,
   
    [haux,paux] = ttest2(nonzeros(err2(14,:)),nonzeros(err2(i,:)),'tail','right');
    [paux2,haux2] = ranksum(nonzeros(err2(14,:)),nonzeros(err2(i,:)),'tail','right');
    p = [p,paux];h = [h,haux];p2 = [p2,paux2];h2 = [h2,haux2];
end
p
h
p2
h2
p0
h0
