function [UNCOMP] = deLZ(COMP, D, Dims)
% This function decompresses a LZW compressed series.
% necessary input is compressed file and dictionary.

l = length(COMP);
temp1 = cell(1,l);
for i = 1:l
    temp1{i} = D{COMP{i}};
end


% temp = cellfun(@string, UNCOMP,'UniformOutput',false);
temp = string(temp1);
temp = strjoin(temp);
temp = char(temp);
temp = temp(~isspace(temp));

out = nan(length(temp),1);

for i = 1:length(temp)
    if strcmp(temp(i), '1')
        out(i) = 1;
    else
        out(i) = 0;
    end
end

UNCOMP = reshape(out,Dims(1),Dims(2));