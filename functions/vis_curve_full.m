%=========================================================================%
% function vis_curve_full(curve, labels)
% Created By: Danny Galvis, Darren Walsh, James Rankin
% This function creates the subplots for the different features wrt to
% changes in individual parameters. Chart of relative change in the feature 
% for the new parameter set vs. the original
% Calls vis_curve to actually plot each bar plot
% (4) slope of the senescent population
% (5) slope of the proliferative population
% (6) Growth arrest peak
% (7) Time to growth arrest peak
% (8) Apoptotis peak
% (9) Time to apoptosis peak
% (10) Time to 85% Senescent

%=========================================================================%
function vis_curve_full(curve,labels)


    subplot 421;hold all;
    vis_curve(curve,4,labels);
    title('Slope of the Senescent Population');
    ylabel('% change in slope steepness');
    
    
    subplot 422;hold all;
    vis_curve(curve,5,labels);
    title('Slope of the Proliferative Population');
    ylabel('% change in slope steepness');

    
    
    subplot 423;hold all;
    vis_curve(curve,6,labels);
    title('Growth Arrest Peak');
    ylabel('% change in peak');
    
    
    subplot 424;hold all;
    vis_curve(curve,7,labels);
    title('Growth Arrest Time to Peak');
    ylabel('% change in time to peak');

    
    
    subplot 425;hold all;
    vis_curve(curve,8,labels);
    title('Apoptotic Peak');
    ylabel('% change in peak');

    
    
    subplot 426;hold all;
    vis_curve(curve,9,labels);
    title('Apoptotic Time to Peak');
    ylabel('% change in time to peak');
    
    subplot 414;hold all;
    vis_curve(curve,10,labels);
    title('Time to 85% senescent');
    ylabel('% change in time to 85%');
    

end