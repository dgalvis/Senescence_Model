clear;close all;clc;restoredefaultpath;
load('comparison_data.mat');
load('parameters_final_best.mat');
baseline = result;

err = zeros(14,20);


for idx = 1:14
    name = ['parex',num2str(idx)];
    restoredefaultpath;addpath(name);addpath('../../functions');
    for k = 1:20,
        try
            load([name,'/parameters_best_kfold',num2str(k),'_',name,'_ga.mat']);
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
        err(idx,k) = 100*(opt_fun(result,state_num,aux) - bl)/bl;
    end  
end

stats = zeros(14,3);
for i = 1:14
    stats(i,1) = median(nonzeros(err(i,:)));
    stats(i,2) = mean(nonzeros(err(i,:)));
    stats(i,3) = std(nonzeros(err(i,:)));
end
stats


figure(1);clf;hold all;
for i = 1:14
    for j = 1:20
        if err(i,j) ~= 0
            scatter(i,err(i,j),'k');
        end
    end
end


p = [];h = [];
p2 = [];h2 = [];
p0 = [];h0 = [];
for i = 1:14
    err_aux = nonzeros(err(i,:));
    [haux0,paux0] = kstest((err_aux - mean(err_aux))/std(err_aux));
    p0 = [p0,paux0];h0 = [h0,haux0];  
end
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
