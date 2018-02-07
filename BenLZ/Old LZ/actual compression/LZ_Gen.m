%Example of Lempel Ziv Welch algorhithm 

clear 
clc
profile on

%% generate random binray data
    % enter amount of sqrt of length of data
l = 300;
data = randi([0 1], l,l);

%% compress data
[DataComp, d, dims] = LZ(data);

%% restore  data
DataRestored = deLZ(DataComp,d, dims);

%% check is lossless
if isequal(DataRestored,data)
    fprintf('\n SUCCESS! Original data and restored data are IDENTICAL \n')
else
    fprintf('\n Failure! Original Data and restored data are NOT identical \n')
end

%%
LZ_size = length(DataComp)

profile viewer
