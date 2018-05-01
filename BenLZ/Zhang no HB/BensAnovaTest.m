
function [P] = BensAnovaTest(data, alpha,param)
% calcs a single F test and returns p value

%remove task seperation
data = cellfun(@(x) mean(x,2), data, 'uniformoutput',false);

temp = cell(1,length(data));

for i = 1:length(data)
    temp{i} = i*ones(length(data{i}),1);
end
labels = cat(1,temp{:});

data = cat(1,data{1:4});

% P = group2fnt(data',labels);
[P,t,stats,~] = anovan(data',labels,'sstype',1,'model','full','varnames',{'condition'});

if P > alpha
    fprintf('\n Oh NO! Condition Effect not significant in %2 \n',params)
    return
else
    fprintf('\n YAY! %s paramater shows condition effect, significant at p = %g \n', upper(param),P)
end


