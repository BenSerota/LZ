%Example of Lempel Ziv Welch algorhithm 

% generate random binary data
l = randi([5 10000]);           % small BUG: below 5 digits depends on 1
data = randi([0 1],1,l);

% compress data
[DataComp, d] = LZ(data);

% restore  data
DataRestored = deLZ(DataComp,d);

% test for data-restoraiton identity
temp = num2str(data);
temp = temp(~isspace(temp));

if strcmp(temp,DataRestored)
    fprintf('\n SUCCESS! Original data and restored data are IDENTICAL \n')
else
    fprintf('\n Failure! Original Data and restored data are NOT identical \n')
end