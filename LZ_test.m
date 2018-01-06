
%test LZ complexity

clear
clc
% profile on

for i = 1:100
    
    % generate random binray data
    % enter amount of sqrt of length of data                                   % small BUG: below 5 digits depends on 1
    l = 20; %randi([1 20]);
    lengths(i) = l^2;
    
    % generating data : some more some less random
    data = randi([0 1], l,l);
    pattern = randi([0 1], 1,l);
    reps(i) = randi([0 l]);     % chosses how many reps
    pos = randi([1 l]);         % chosses location of rows
    data(pos,:) = pattern;
    
    % compress data
    try
        [DataComp, d, dims] = LZ(data);
    catch
        failed_Comps{i} = sprintf('lottery %s, length = %g',i,l);
    end
    
    % restore  data
    try
        DataRestored = deLZ(DataComp,d, dims);
    catch
        failed_DeComps{i} = sprintf('lottery %s, length = %g',i,l);
    end
    
    
    % making sure
    try
        if ~isequal(DataRestored,data)
            Data_Not_Equal(end+1) = i;
        end
    catch
    end
    
    LZ_size(i) = length(DataComp);
    
    rel_comps(i) = 1-(reps(i) / l);     % complexity relative to l
    
end


figure()
plot (rel_comps,LZ_size,'r*')
xlabel('relative complexity')
ylabel('LZ size')
hold on

corrcoef(rel_comps,LZ_size)
[linear] = polyfit(rel_comps,LZ_size,1);
x = linspace(0,1);
y = x.^linear(1) + linear(2);
plot(x,y)

% figure()
% plot (lengths,LZ_size,'*')
% xlabel('length of data')
% ylabel('LZ size')
% 
% profile viewer