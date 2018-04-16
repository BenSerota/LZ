
function [P] = BensAnovaTest(data, alpha)
% calcs a single F test and returns p value

%remove task seperation
data = cellfun(@(x) mean(x,2), data, 'uniformoutput',false);

temp = cell(1,length(data));

for i = 1:length(data)
    temp{i} = i*ones(length(data{i}),1);
end
labels = cat(1,temp{:});

data = cat(1,data{1:4});

P = group2fnt(data',labels);

if P > alpha
    fprintf('\n Effect not significant \n')
    return
else
    fprintf('\n YAY! Effect is significant, at p = %g \n',P)
end


