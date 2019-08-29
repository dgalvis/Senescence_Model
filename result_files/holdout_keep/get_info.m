clear;close all;clc;restoredefaultpath;

load('parameters_final_best.mat');
baseline = Error_tot;

err = zeros(14,20);

for idx = 1:14
    name = ['parex',num2str(idx)];
    restoredefaultpath;addpath(name);
    for k = 1:20,
        try
        load([name,'/parameters_best_kfold',num2str(k),'_',name,'_ga.mat']);
        err(idx,k) = Error_tot;
        catch
            continue
        end
    end  
end

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




stats = zeros(14,3);
for i = 1:14
    stats(i,1) = median(nonzeros(err2(i,:)));
    stats(i,2) = mean(nonzeros(err2(i,:)));
    stats(i,3) = std(nonzeros(err2(i,:)));
end
stats

figure(1);clf;hold all;
for i = 1:14
    for j = 1:20
        if err2(i,j) ~= 0
            scatter(i,err2(i,j),'k');
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
