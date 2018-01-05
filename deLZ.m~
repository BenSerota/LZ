function [UNCOMP2] = deLZ(COMP, D)
l = length(COMP);
UNCOMP2 = cell(1,l);
for i = 1:l
   UNCOMP2{i} = D{COMP{i}};
end


temp = cellfun(@string, UNCOMP2,'UniformOutput',false);
temp = string(temp);
UNCOMP2 = strjoin(temp);
UNCOMP2 = str2mat(UNCOMP2);
UNCOMP2 = UNCOMP2(~isspace(UNCOMP2));
