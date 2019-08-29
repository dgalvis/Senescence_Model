clear;close all;clc;restoredefaultpath;

% Load the baseline Error_tot from the best total optimization 
load('comparison_data.mat');
load('result_files/parameters_final_best.mat');
baseline = result;

% 1-13 are parameters that are fixed/14 is no parameter fixed
% 20 sets of holdouts
err = zeros(14,20);

% Load in the error of held out points for the optimizations fit with held out points
% and sometimes individual parameters held fixed at best value.
for idx = 1:14
    name = ['parex',num2str(idx)];
    restoredefaultpath;addpath(['result_files/holdout_keep/',name]);addpath('functions');
    for k = 1:20,
        try
            load(['result_files/holdout_keep/',name,'/parameters_best_kfold',num2str(k),'_',name,'_ga.mat']);
        catch
            continue
        end
        aidx = ~ismember(data.cum_PD,fit.cum_PD);
        aux.pass_b_gal = data.pass_b_gal(aidx);
        aux.pass_ki_67 = data.pass_ki_67(aidx);
        aux.pass_H2Ax = data.pass_H2Ax(aidx);
        aux.pass_tunel = data.pass_tunel(aidx);
        aux.cum_hours = data.cum_hours(aidx);
        aux.cum_PD = data.cum_PD(aidx);   
        bl = opt_fun(baseline,50,aux);
        
        % Find the percent increase in the error of held out points over the baseline.
        err(idx,k) = 100*(opt_fun(result,state_num,aux) - bl)/bl;
    end  
end

disp('order of parameters fixed at best value');
order = {'LeftPP','RightPP', 'LeftPG','RightPG',...
         'GS', 'LeftPA','RightPA', 'LeftPS','RightPS',...
          'AD','P_in_H2AX', 'G_in_Ki67', 'G_in_H2AX','baseline'}
% Calculate statistics
stats = zeros(14,3);
for i = 1:14
    stats(i,1) = median(nonzeros(err(i,:)));
    stats(i,2) = mean(nonzeros(err(i,:)));
    stats(i,3) = std(nonzeros(err(i,:)));
end
stats

% Plot results
figure(1);clf;hold all;
for i = 1:14
    for j = 1:20
        if err(i,j) ~= 0
            scatter(i,err(i,j),'k');
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

% Evaluate significance decreases in error of held out points
% when a single parameter is fixed vs. when all parameters are free 
for i = 1:13,

    [haux,paux] = ttest2(nonzeros(err(14,:)),nonzeros(err(i,:)),'tail','right');
    [paux2,haux2] = ranksum(nonzeros(err(14,:)),nonzeros(err(i,:)),'tail','right');
    p = [p,paux];h = [h,haux];p2 = [p2,paux2];h2 = [h2,haux2];

end
p
h
p2
h2
p0
h0
