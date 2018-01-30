%Test_Quang

clear
clc
s1 = 100; % channels
s2 = 1e3; % timepoints
data = randi([0 1],s1,s2);
data = data(:);

%%


[c] = calc_lz_complexity(data,'primitive',1)