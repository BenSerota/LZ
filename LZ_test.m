
%test LZ complexity
clear
clc
% profile on

% test parameters (Number of runs, sqrt of data length)
[n,l] = LZ_param (100,30);
% small BUG: below 5 digits depends on 1

reps = nan(1,n);
lengths = nan(1,n);
failed_Comps = cell(1,n);


for i = 1:n
    
    lengths(i) = l^2;                                                       % saving for later
    
    % generating data : some more some less random
    data = randi([0 1], l,l);
    pattern = randi([0 1], 1,l);                                            % pattern to be repeated 
    reps(i) = randi([0 l]);                                                 % how many reps
    pos = randi([1 l], 1,reps(i));                                          % location of rows
    for j = pos                                                             % assign pattern.
        data(j,:) = pattern;
    end
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


figure;
scatter(rel_comps,LZ_size,'*')
xlabel('relative complexity')
ylabel('LZ size')
lsline

% corrcoef(rel_comps,LZ_size)
% [linear] = polyfit(rel_comps,LZ_size,1);
% x = linspace(0,1);
% y = x.^linear(1) + linear(2);
% plot(x,y)

% figure()
% plot (lengths,LZ_size,'*')
% xlabel('length of data')
% ylabel('LZ size')
%
% profile viewer


function [n,l] = LZ_param (N,L)
n = N; l = L;
end
