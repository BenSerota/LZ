function [c] = PCI_C_LZ (mat)
[c,r,q,k] = deal(1);
i = 2;
[L1 L2] = size(mat);

if q == r
    a = i + k - 2;
else
    a = L1;
end
   
strfind  (mat(i-1,i-1+k,r),mat(1:a,q))