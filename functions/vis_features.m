%=========================================================================%
% Function vis_features(result, state_num)
% Created by: Danny Galvis, Darren Walsh, James Rankin
% Inputs:
%   - result = parameters that result from the optimization (usually
%     contained in parameters_etc.mat
%   - state_num = number of proliferative states (also in
%     parameters_etc.mat)
% Outputs:
%   - best fit sigmoid to the senescent and proliferative populations
%   - max and time to max for the growth-arrested and apoptotic populations
%=========================================================================%

function vis_features(result, state_num)
%=========================================================================%
% % Initialize Parameters and run DS
%=========================================================================%        

    end_time = 5000;

    [prol, grar, sene, apop, times,~] = model_fun(result,state_num,end_time);

%=========================================================================%
% % Calculate best fit sigmoids
%=========================================================================%            

    time_fit = linspace(0,1,length(times));
    options = statset('MaxIter',10000,'DerivStep',1e-5);
    sene_sig = nlinfit(time_fit,sene, @(ins,t)sigmoid(ins,t), [0.5,1],options);
    error_sene = fit_sigmoid(sene_sig,time_fit,sene);


    prol_sig = nlinfit(time_fit,prol, @(ins,t)sigmoid(ins,t), [0.5,-1],options);
    error_prol = fit_sigmoid(prol_sig,time_fit,prol);
 
    % Extract sigmoid features
    shift_sene = sene_sig(1);
    slope_sene = sene_sig(2);
    shift_prol = prol_sig(1);
    slope_prol = prol_sig(2);
 
%=========================================================================%
% % Fnd max and time to max
%=========================================================================%      
   
    MG = max(grar);
    LG = times(find(grar==max(grar)));
    LG = LG(1);
    MA = max(apop);
    LA = times(find(apop==max(apop)));
    LA = LA(1);
    
    S85 = interp1(sene,times,0.85);

%=========================================================================%
% % Plot all results
%=========================================================================%  
    
    subplot 221;hold all;
    plot(times,sigmoid([shift_sene,slope_sene],time_fit),'k');
    plot(times, sene,'b');
    plot([0,S85],[0.85,0.85],'g');
    plot([S85,S85],[0,0.85],'g');
    legend('sigmoid','senescent pop','time to 85%');
    title(['senescent error: ',num2str(error_sene)]);
    axis([0,end_time,0,1]);    
    subplot 222;hold all;
    plot(times,sigmoid([shift_prol,slope_prol],time_fit),'k');
    plot(times, prol,'b');
    legend('sigmoid','proliferative pop');
    title(['proliferative error: ',num2str(error_prol)]);
    axis([0,end_time,0,1]);    
    subplot 223;hold all;
    plot(times,grar,'b');
    plot([0,LG],[MG,MG],'k');
    plot([LG,LG],[0,MG],'k');
    legend('growth arrested');
    title(['max growth arrested is ',num2str(MG),'at t = ',num2str(LG),' hours']);
    axis([0,end_time,0,1]);
    subplot 224;hold all;
    plot(times,apop,'b');
    plot([0,LA],[MA,MA],'k');
    plot([LA,LA],[0,MA],'k');
    legend('growth arrested');
    title(['max growth arrested is ',num2str(MA),'at t = ',num2str(MA),' hours']);    
    axis([0,end_time,0,1]);
    
    
    
    
    

end