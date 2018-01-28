%testing matlab lz
clc
clear
data = randi([0 1],200,5e2);
x = reshape(data,1,[]);
strInput = strrep((mat2str(x)),' ','');
strInput = strrep(strInput,'[','');
strInput =  strrep(strInput,']','');

codeBook = cellstr(['0';'1']);
%% lempel-ziv calculation

[value codeBook NumRep NumRepBin ] = lempelzivEnc(strInput,codeBook);

%%

outputLength = length( NumRepBin{1})*length(NumRepBin)-length(NumRepBin);
inputLength = length(strInput);
compRatio = outputLength/inputLength*100;
str = sprintf('========================\nInput length is %d and output length is %d\nCompression ratio is %f',inputLength,outputLength,compRatio);

disp(str);