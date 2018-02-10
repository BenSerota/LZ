%InnerPCI General Framework
clear
clc
close 
%% parameters
% DATA = rand(100,1000);
DATA = rand(206,385,3);
Jaco_flag = 1;
ZTHRESH1 = 1.6; %2.1; 
ZTHRESH2 = 1; % .5; 
TIME_W = 300;
%% go
[LZC_e, LZC_t] = InnerPCI (DATA,Jaco_flag,ZTHRESH1,ZTHRESH2,TIME_W);

