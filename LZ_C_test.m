
%test LZ complexity
clear
clc
profile on

% test parameters (Number of runs, sqrt of data length)
[n,l] = LZ_param (10,30);

reps = nan(1,n);
lengths = nan(1,n);
failed_DeComps = cell(0);
failed_Comps = cell(0);
c = 0;
bad = [];

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
        failed_Comps{end+1} = sprintf('lottery %g',i);
        jj(end+1)= i;                                                       
    end
    
    % restore  data
    try
        DataRestored = deLZ(DataComp,d, dims);
    catch
        failed_DeComps{end+1,1} = sprintf('lottery %g',i);
        ii(end+1)= i;
    end
    
    
    % making sure
    try
        if ~isequal(DataRestored,data)
            Data_Not_Equal(end+1) = i;
        else
        c = c+1;
        end
    catch
        bad(end+1) = i;
    end
    
    LZ_size(i) = length(DataComp);
    
    rel_comps(i) = 1-(reps(i) / l);     % complexity relative to l
    
end

% sanity check
if isequal(c,n)
    fprintf('\n SUCCESS! All data sets were equal')
else
    fprintf('\n ERROR! NOT all data sets were equal')
    fprintf('\n error in Compression in datasets: %s', num2str(jj))
    fprintf('\n error in DeCompression in datasets: %s', num2str(ii))

end


figure;
scatter(rel_comps,LZ_size,'*')
xlabel('relative complexity')
ylabel('LZ size')
lsline


profile viewer

%% inner functions

function [n,l] = LZ_param (N,L)
n = N; l = L;
end

