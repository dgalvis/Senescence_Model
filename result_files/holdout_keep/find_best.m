
clear;close all;clc;restoredefaultpath;
 

for idx = 1:14
    name = ['parex',num2str(idx)];
    restoredefaultpath;addpath(name);
    for k = 1:20,
        err = [];
        for it = 1:10,
            try
                load(['parameters_kfold',num2str(k),'_it',num2str(it),'_',name,'_ga.mat']);
                err = [err,Error_tot];                
            catch
                err = [err, 1e13];
                continue
            end


            
        end
        try
        [~,it] = min(err);
            load(['parameters_kfold',num2str(k),'_it',num2str(it),'_',name,'_ga.mat']);
            save([name,'/parameters_best_kfold',num2str(k),'_',name,'_ga.mat'],...
                  'Error_sub','Error_tot','fit','options_fmincon','options_ga',...
                  'range_lb','range_lb_final','range_ub','range_ub_final','result',...
                  'result_mid','seed','state_num');
        catch
            continue
        end
    end  
end

