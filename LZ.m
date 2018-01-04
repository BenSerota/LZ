function [COMP] = LZ(UNCOMP)
% This function compresses a binary time-series using the Lempel Ziv Welch Algorithm.

%% beg
data = UNCOMP;
D = num2cell(unique(data)');
% D = cellfun(@num2str,D,'UniformOutput',false);
i = 1;
one = [];
two = data(i);
COMP = [];
fin = 0;

%% starting

while ~fin
    
    %     comb = num2str([one two]);
    comb = [one two];
    % eradicating spaces and joining numbers, in a cell, conv to double.
    comb = {comb(~isspace(comb))};
%         comb = {str2double(comb(~isspace(comb)))};

    if cellismember(comb, D)
        
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
        COMP(end+1) = find(cellismember(one,D));
        
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
