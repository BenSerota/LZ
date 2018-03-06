% LZC_noHB_param
%(data_ratio, rates, rate_flag, event_flag ,task_flag);
global task_flag plot_hb

%% direct inputs
% how much of data to take into consideration (~(0,1))?
data_ratio = 1; % (rate min = 0.042)

%determine event rates
rates = [5 10 20 30 40 50];

%use 5 different event rates(=1) or only one (first) (=0)?
rate_flag = 5;

%use zscore only(=0) or hilbert transform on zscore(=1)?
event_flag = 1; 

% should we also seperate LZC scores by task (0=no)?
task_flag = 1;

% alpha : significance
alpha = 0.05;

% reject outliers beyond X% from bottom and top 
outlier = 5;

%% globals
% r chooses how many of the first ICs to reject in each dataset:
num = 30;

% what's the component beyond which we don't care if there is HB (as
% components are organized hierarchically).
lim = 30;

% calc LZC by row (temporal; 0) or column (sptial; 1)
E_T_flag = 0;

% % plot HB EEG ?
plot_hb = 0;
