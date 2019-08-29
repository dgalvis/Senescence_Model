%=========================================================================%
% function vis_sens(sensitive, labels)
% Created By: Danny Galvis, Darren Walsh, James Rankin
% This function creates a bar plot for the sensitivity analysis
% Inputs:
%   - sensitive - output of Run_sens.m Contains impormation about the
%     parameters that were changed, by how much, and relative change in
%     error over the original parameter set
%   - labels - the name labels for the parameters that were changed
% Output:
%   - Bar plot of the sensitivity analysis
%=========================================================================%
function vis_sens(sensitive,labels)

    % The number of increments that each parameter was changed
    incs = sum(sensitive(1,1) == sensitive(:,1));
    
    % Keep the relative errors
    rel_errs = sensitive(:,5);
    for i = 1:size(sensitive,1)
        if(sensitive(i,6) ~=0)
            rel_errs(i) = nan;
        end
    end
    % Reshape to increments of parameter x parameters changed
    rel_errs = reshape(rel_errs,[incs,size(sensitive,1)/incs]);
    params = linspace(1,size(sensitive,1)/incs,size(sensitive,1)/incs);

    
    % bar chart
    b = bar(params,rel_errs','grouped');
    % grayscale
    C = repmat(linspace(0.1,0.7,incs).',1,3);
    for k = 1:incs
        b(k).FaceColor = C(incs+1-k,:);
    end
    % apply labels
    xticks([linspace(1,length(params),length(params))]);
    xticklabels(labels);
    axis([0,length(params)+1,-1,max(rel_errs(:))]);

    % Legend of the increments of change (in percent)
    for i = 1:incs
        legend_labels{i} = [num2str(sensitive(i,3))];
    end
    legend(legend_labels);
    ylabel('%Change in Error');
end