function [UNCOMP] = deLZ(COMP, D, Dims)
% This function decompresses a LZW compressed series.
% necessary input is compressed file and dictionary.

l = length(COMP);
temp = cell(1,l);
for i = 1:l
    try
        temp{i} = D{COMP{i}};
    catch
        i
    end
end

% temp = cellfun(@string, UNCOMP,'UniformOutput',false);
temp = string(temp);
temp = strjoin(temp);
temp = char(temp);
temp = temp(~isspace(temp));

l = length(temp);
out = nan(l,1);

try
    c = eval(temp(1));
    c = 'numbers';
catch
    c = 'letters';
end

switch c
    case 'numbers'
        for i = 1:l
            if strcmp(temp(i), '1')
                out(i) = 1;
            else
                out(i) = 0;
            end
        end
        
        UNCOMP = reshape(out,Dims(1),Dims(2));
        
    case 'letters'
        %continue without translating string into numbers or reshaping
        UNCOMP = temp;
        
end