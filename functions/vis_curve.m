%=========================================================================%
% function vis_curve(curve, idx, labels)
% Created By: Danny Galvis, Darren Walsh, James Rankin
% This function creates a bar plot for the sensitivity analysis
% Inputs:
%   - curve - output of Run_curv.m Contains impormation about the
%     parameters that were changed, by how much, and relative change in
%     trajectory features over the original parameter set
%   - labels - the name labels for the parameters that were changed
%   - idx - which of the features to take from the curve array
% Output:
%   - Bar plot of the trajectory feature analysis
%=========================================================================%
function vis_curve(curve,idx,labels)

    % The number of increments that each parameter was changed
    incs = sum(curve(1,1) == curve(:,1));
    
    % Keep the particular feature   
    look_at_me = curve(:,idx);
    look_at_me = reshape(look_at_me,[incs,size(curve,1)/incs]);
    for i = 1:size(curve,1)
        if(curve(i,end) ~=0)
            look_at_me(i) = nan;
        end
    end
    
    
    
    params = linspace(1,size(curve,1)/incs,size(curve,1)/incs);
    % bar chart
    b = bar(params,look_at_me','grouped');
    % grayscale
    C = repmat(linspace(0.1,0.7,incs).',1,3);
    for k = 1:incs
        b(k).FaceColor = C(incs+1-k,:);
    end    
    % pick axes
    bottom = min(look_at_me(:));
    bottom = min(bottom,0);
    top = max(look_at_me(:));
    top = max(0,top);
    axis([0,length(params)+1,bottom,top]);    
    % apply labels
    xlabel('parameter changed');
    xticks(linspace(1,length(labels),length(labels)));
    xticklabels(labels);

    for i = 1:incs
        legend_labels{i} = [num2str(curve(i,3))];
    end
    legend(legend_labels);



end