%InnerPCI General Framework

%% parameters
% DATA = rand(100,1000);
DATA = rand(206,385,3);
Jaco_flag = 1;
ZTHRESH1 = 1.5 %2.1; 
ZTHRESH2 = 1 % .5; 
TIME_W = 300;
%% go
LZC = InnerPCI (DATA,Jaco_flag,ZTHRESH1,ZTHRESH2,TIME_W);

