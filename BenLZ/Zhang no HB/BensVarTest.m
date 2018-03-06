
function [H, P] = BensVarTest(data)
%checking if dtaa is task-seperated or not
f = 0;
if size(data{1},2) == 1
    l = 1;
else
    l = 5; % 5 because of 4 tasks + 1 AVERAGE
end

H = cell(1,l);
P = cell(1,l);

for ii = 1:l
    if ii == 5
        data = cellfun(@(x) mean(x,2), data, 'UniformOutput', false);
        f = 1; % flagging ii is actually 5 to end run.
        ii = 1;
    end
    
    h = nan(4);
    p = nan(4);
    
    for i = 2:4
        [h(1,i),p(1,i)] = vartest2(data{1}(:,ii),data{i}(:,ii));
    end
    
    for i = 3:4
        [h(2,i),p(2,i)] = vartest2(data{2}(:,ii),data{i}(:,ii));
    end
    
    [h(3,4),p(3,4)] = vartest2(data{3}(:,ii),data{4}(:,ii));
    
    if f
        ii = 5;
    end
    
    H{ii} = h;
    P{ii} = p;
end




% Tomer's input:
% 1. anovan(
% 2. individual t-tests
% 3. corrected for mult comp
