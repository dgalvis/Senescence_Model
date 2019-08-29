%=========================================================================%
% function run_optimization(fit, data, range_lb, range_ub, state_num, type, name)
% Created By: Danny Galvis, Darren Walsh, James Rankin
% This function runs the optimization
% Inputs:
%    - fit - data that are actually fit by the optimizer
%    - data - full dataset
%    - range_lb - lower bound constraints
%    - range_ub - upper bound constraints
%    - state_num - number of proliferative states
%    - type - 'ga' or 'so' or 'both' (genetic alg, surrogate opt, both)
%    - name - string of the result file name

%=========================================================================%
function run_optimization(fit, data, range_lb, range_ub, state_num, type, seed_in, output_file)

    % Genetic Algorithm + FMINCON
    if strcmp(type, 'ga')|| strcmp(type, 'both')
        % Choose the seed for the random number generator, record 
        rng(seed_in);
        x = rng();
        seed = x.Seed;
        
        % number of constraints
        n_con = length(range_lb);
        % options and run genetic algorithm
        options_ga = optimoptions(@ga,'UseParallel',true,'Display','iter',...
                            'PopulationSize',2000,'MaxGenerations',1300);%,...
                            %'PlotFcn',{'gaplotrange'});

        [result_mid,Fval_ga] = ga(@(results)opt_fun(results,state_num,fit),...
                    n_con,[],[],[],[],range_lb,range_ub,[],[],options_ga);


        % tighten the constraints to run another optimization with fmincon
        range_lb_final = 0.5*result_mid;
        range_ub_final = min(1.5*result_mid,1);
        
        % Run fmincon
        options_fmincon = optimoptions(@fmincon,'Display','iter','UseParallel',true,'MaxFunctionEvaluations',10000);     
        [result,Fval_fmc] = fmincon(@(results)opt_fun(results,state_num,fit),result_mid,[],[],[],[],...
         range_lb_final,range_ub_final,[],options_fmincon); 

     
        % Choose the better of the two optimizations
         if Fval_fmc > Fval_ga
            result = result_mid;
         end
        % Error against the subset and against the full dataset
        Error_sub = opt_fun(result,state_num,fit);
        Error_tot = opt_fun(result,state_num,data);
        
        % Save results
        save([output_file,'_ga.mat'],'result','result_mid','range_lb','range_ub',...
             'range_lb_final','range_ub_final','seed','options_ga','options_fmincon','fit',...
             'state_num','Error_sub','Error_tot');
    end
    % Surrogate Optimization Algorithm + FMINCON
    if strcmp(type, 'so') || strcmp(type, 'both')
        % Choose the seed for the random number generator, record 
        rng('shuffle');
        x = rng();
        seed = x.Seed;
        
         
        % options and run surrogate optimization
        options_so = optimoptions('surrogateopt','UseParallel',true,...
            'Display','iter',...%'PlotFcn','surrogateoptplot',...
            'MaxFunctionEvaluations',2e4,'MaxTime',Inf,...
            'MinSurrogatePoints',200,'MinSampleDistance',5e-4);
        [result_mid,Fval_so] = surrogateopt(@(results)opt_fun(results,state_num,fit),...
            range_lb,range_ub,options_so);

        % tighten the constraints to run another optimization with fmincon
        range_lb_final = 0.5*result_mid;
        range_ub_final = min(1.5*result_mid,1);

        % Run fmincon
        options_fmincon = optimoptions(@fmincon,'Display','iter','UseParallel',true,'MaxFunctionEvaluations',10000);     
        [result,Fval_fmc] = fmincon(@(results)opt_fun(results,state_num,fit),result_mid,[],[],[],[],...
             range_lb_final,range_ub_final,[],options_fmincon); 
        
        % Keep the better of the optimization results
        if Fval_fmc > Fval_so
            result = result_mid;
        end
        % Error against the subset and against the full dataset
        Error_sub = opt_fun(result,state_num,fit);
        Error_tot = opt_fun(result,state_num,data);

        % save results
        save([output_file,'_so.mat'],'result','result_mid','range_lb','range_ub',...
             'range_lb_final','range_ub_final','seed','options_so','options_fmincon','fit',...
             'state_num','Error_sub','Error_tot');     
    end



