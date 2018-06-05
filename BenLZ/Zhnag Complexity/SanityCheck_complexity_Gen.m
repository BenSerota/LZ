
%sanity Chack general framework
clear
clc
reps = 2;
randomization = [0,1];
for i = 1:2
    SanityCheck_complexity (randomization(i),reps)
end