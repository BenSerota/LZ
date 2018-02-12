%InnerPCI General Framework
clear
clc
close 
%% parameters
Jaco_flag = 1; % 1;
ZTHRESH1 = 1.5; %2.1; 
ZTHRESH2 = 1.3; % .5; 
TIME_W = 300;
LZC_flag = 2; % 0 = rows, 1 = transpose, 2 = both rows + transpose


switch Jaco_flag
    case 1
    DATA = rand(206,385,3);
    case 0
    DATA = rand(10,1000);
end

[LZC_e, LZC_t] = InnerPCI (DATA,Jaco_flag,ZTHRESH1,ZTHRESH2,TIME_W,2);


%% Polotting 
figure()
scatter (LZC_e,LZC_t)
hold on
lsline
xlabel('LZC by channel')
ylabel('LZC by electrode')
title(' comparing LZC scores')