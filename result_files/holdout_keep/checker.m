clear;close all;clc;restoredefaultpath;

for idx = 1:14
    name = ['parex',num2str(idx)];
    restoredefaultpath;addpath(name);

    keep = [];
    keep3= [];
    for k = 1:20,
        
        keep2 = [];
        for it = 1:10,
            try
                load(['parameters_kfold',num2str(k),'_it',num2str(it),'_',name,'_ga.mat']);
            catch
%                disp([num2str(idx),' ',num2str(k),' ',num2str(it)]);
                continue
            end
            if it == 1
                keep3 = [keep3;fit.cum_PD];
            end
            
             try
                 if range_lb(idx) ~= range_ub(idx)
                     disp('problem');
                 end
             catch
                 if sum(range_lb == range_ub) ~= 0
                     disp('problem');
                 end
             end
            keep = [keep,Error_tot];
            keep2= [keep2;fit.cum_PD];   
        end
        if(sum(size(unique(keep2))) ~= 14)
            disp('problem3');
        end
    end
    if( sum(size(keep) == size(unique(keep))) ~= 2)
        disp('problem2');
    end
    keep4 = [];
    if(sum(size(unique(keep3)))~=17)
        disp('problem4');
    else
        
        for i = 1:size(keep3,1)
            keep4=[keep4;ismember(unique(keep3)',keep3(i,:))];
        end
    end
    %keep4

    
end