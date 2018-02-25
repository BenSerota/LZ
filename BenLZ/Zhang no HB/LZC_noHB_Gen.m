%LZC_noHB_Gen

clear
clc
start_ben
global out_paths subconds num lim plothb E_T_flag %#ok<NUSED>
DOC_basic
LZC_noHB_param

[LZCs_per_cond] = LZC_noHB(data_ratio, rates, rate_flag, event_flag ,task_flag);

%% plotting
