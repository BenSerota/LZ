function [COMP, D] = LZ_simp(UNCOMP)
% This function compresses a binary time-series using the Lempel Ziv Welch Algorithm.

%% beg
data = string(UNCOMP);
D = num2cell(unique(data)');
% D = cellfun(@num2str,D,'UniformOutput',false);
i = 1;
one = [];
two = {data(i)}; 
COMP = [];
fin = 0;

%% starting

while ~fin
    
    comb = [one two];
%     comb = num2str([one two]); % THIS IS A PROBLEM : STRJOIN MIGHT HELP
    % eradicating spaces and joining numbers, in a cell, conv to double.
    comb = comb(~isspace(comb));
%         comb = {str2double(comb(~isspace(comb)))};

%% prep for "cell string is member"
cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
% logical_cells = find(cellfun(cellfind(one{1}),D));
izmember = nnz(cellfun(cellfind(one{1}),D));
%% t

    if izmember
        
        % for next flop:
        one = comb;
        i = i+1;
        
        if i ~= length(data)+1  % = not end of data series
            two = data(i);
        else
            COMP(end+1) = find(cellismember(one,D));
        end
        
        
    else
        % aadd to dictionary
        D(end+1) = comb;
        % write to output
        
        COMP(end+1) = find(D==one);
        
        % for next flop:
        one = two;
        i = i+1;
        two = data(i);
    end
    
    
    if i == length(data)+1
        fin = 1;
    end
end


%% etc
% %% identify data
% class = class(d);
% switch class
%     case 'double'
%
%     case 'char'
%
%     otherwise
%         disp('data of unknown class')
% end


% strcmp
one_str = one{1};
find(contains(D,sprintf(one_str)))

cellfun(@strcmp,comb,D,'UniformOutput',false)