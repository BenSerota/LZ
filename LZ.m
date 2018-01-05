function [COMP, D] = LZ_simp(UNCOMP)
% This function compresses a binary time-series using the Lempel Ziv Welch Algorithm.

%% beg
data = string(UNCOMP);
D = num2cell(unique(data)');
cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));

i = 1;
one = [];
two = {data(i)};
COMP = [];
fin = 0;

%% starting

while ~fin
    
    if i == 1
        comb = two;
    else
        comb = {strcat(one{1},two{1})};
    end
    
    % eradicating spaces and joining numbers, in a cell, conv to double.
    
    % checking if comb is member of D
    izmember = nnz(cellfun(cellfind(comb{1}),D));
    
    if izmember
        
        % for next flop:
        one = comb;
        i = i+1;
        
        if i ~= length(data)+1  % = not end of data series
            two = data(i);
        else
            COMP{end+1} = find(cellfun(cellfind(one{1}),D));
        end
        
        
    else
        % aadd to dictionary
        D{end+1} = comb{1};
        % write to output
        
        COMP{end+1} = find(cellfun(cellfind(one{1}),D));
        
        % for next flop:
        one = two;
        i = i+1;
        two = {data(i)};
    end
    
    
    if i == length(data)+1
        fin = 1;
    end
end

