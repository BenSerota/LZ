function [UNCOMP] = deLZ(COMP, D)
d = length(D);
UNCOMP = cell(1,d);
for i = 1:d
   UNCOMP{i} = COMP{i};
end

UNCOMP = cell2mat(UNCOMP);
