% LZC_noHB_param

% r chooses how many of the first ICs to reject in each dataset:
num = 1;
% r chooses IC position, above which hb ICs are NOT rejected:
lim = 20;

% plot HB EEG ?
plothb = 0;

% how much of data to take into consideration (~(0,1))?
ratio_data = 0.1;

% should we also seperate LZC scores by task?
task_flag = 0;

% calc LZC by row (temporal; 0) or column (sptial; 1)
E_T_flag = 0;

% what's the component beyond which we don't care if there is HB (as
% components are organized hierarchically).
lim = inf;



