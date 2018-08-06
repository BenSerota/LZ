
function [P] = BensAnovaTest(data, alpha, param)
global grp LZC_flag
% calcs a single F test and returns p value

if LZC_flag
    %remove task seperation
    data = cellfun(@(x) mean(x,2), data, 'uniformoutput',false);
    
    
    temp = cell(1,length(data));
    
    for i = 1:length(data)
        temp{i} = i*ones(length(data{i}),1);
    end
    labels = cat(1,temp{:});
    
    data = cat(1,data{1:4});

[P,t,stats,~] = anovan(data',labels,'sstype',1,'model','full','varnames',{'condition'},'display','off');

else
    [P,t,stats,~] = anovan(data',grp','sstype',1,'model','full','varnames',{'condition'},'display','off');
end    

if P > alpha
    fprintf('\n Oh NO! Condition Effect not significant in %s \n',param)
    return
else
    fprintf('\n YAY! %s paramater shows condition effect, F = %g, significant at p = %g \n', upper(param),t{2,6},P)
end


