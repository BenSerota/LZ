%LZC_noHB_Gen

clear
clc
start_ben
global out_paths subconds task_flag num lim plothb E_T_flag %#ok<NUSED>

LZC_noHB_param

[LZCs_per_cond] = LZC_noHB(ratio_data, rates, event_flag, rate_flag ,task_flag);