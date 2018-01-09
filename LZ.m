function [COMP, D, Dims] = LZ(UNCOMP)
% This function compresses a binary time-series using the Lempel Ziv Welch Algorithm.

%% beggining
Dims = size(UNCOMP);
data = string(UNCOMP(:));
D = num2cell(unique(data)');
l = length(data);
cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));

COMP = cell(0);

%% starting
% first digit is necessarily a member of D, next
% for next flop:
one = {data(1)};
two = {data(2)};

for i = 2:l-1
    
    comb = {strcat(one{1},two{1})};
    
    % checking if comb is member of D
    izmember = nnz(cellfun(cellfind(comb{1}),D));
    
    if izmember
        
        % for next flop:
        one = comb;
        two = {data(i+1)};
        
    else
        % aadd to dictionary
        D{end+1} = comb{1};
        
        % write to output
        COMP{end+1} = find(cellfun(cellfind(one{1}),D));
        
        % for next flop:
        one = two;
        two = {data(i+1)};
    end
end


%% for final digit:
comb = {strcat(one{1},two{1})};
% checking if comb is member of D
izmember = nnz(cellfun(cellfind(comb{1}),D));
if izmember
    one = comb;
    COMP{end+1} = find(cellfun(cellfind(one{1}),D));
else
    D{end+1} = comb{1};
    
    % write to output
    COMP{end+1} = find(cellfun(cellfind(comb{1}),D));
    
    if COMP{end} ~= length(D)
        i
    end
end

