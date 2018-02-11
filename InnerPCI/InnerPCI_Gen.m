%InnerPCI General Framework
clear
clc
close 
%% parameters
Jaco_flag = 0; % 1;

switch Jaco_flag
    case 1
    DATA = rand(206,385,3);
    case 0
    DATA = rand(100,1000);
end

ZTHRESH1 = 1.6; %2.1; 
ZTHRESH2 = 1; % .5; 
TIME_W = 300;
LZC_flag = 2; % 0 = rows, 1 = transpose, 2 = both rows + transpose
[LZC_e, LZC_t] = InnerPCI (DATA,Jaco_flag,ZTHRESH1,ZTHRESH2,TIME_W,2);

