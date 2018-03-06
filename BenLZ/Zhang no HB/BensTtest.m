
function [H,P,inds] = BensTtest(data, alpha)
% calcs a single F test and returns p value
[H,P] = deal(nan(length(data)));

data = cellfun(@(x) mean(x,2), data, 'uniformoutput',false);

for i = 2:4
    [H(1,i), P(1,i)] = ttest2(data{1},data{i},'Vartype','unequal','Alpha',alpha);
end

for i = 3:4
    [H(2,i),P(2,i)] = ttest2(data{2},data{i},'Vartype','unequal','Alpha',alpha);
end

[H(3,4),P(3,4)] = ttest2(data{3},data{4},'Vartype','unequal','Alpha',alpha);

inds = find(~isnan(P));
P = P(~isnan(P));
H = H(~isnan(H));