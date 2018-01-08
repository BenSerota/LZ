%Example of Lempel Ziv Welch algorhithm 

clear 
clc
% profile on

% generate random binray data
% enter amount of sqrt of length of data                                   % small BUG: below 5 digits depends on 1
l = 20;
data = randi([0 1], l,l);

% compress data
[DataComp, d, dims] = LZ(data);

% restore  data
DataRestored = deLZ(DataComp,d, dims);

if isequal(DataRestored,data)
    fprintf('\n SUCCESS! Original data and restored data are IDENTICAL \n')
else
    fprintf('\n Failure! Original Data and restored data are NOT identical \n')
end


LZ_size = length(DataComp)

% profile viewer


% DataRestored = DataRestored';
% 
% % test for data-restoraiton identity
% temp = num2str(data(:));
% temp = temp(~isspace(temp));
% 
% if strcmp(temp,DataRestored)
%     fprintf('\n SUCCESS! Original data and restored data are IDENTICAL \n')
% else
%     fprintf('\n Failure! Original Data and restored data are NOT identical \n')
% end