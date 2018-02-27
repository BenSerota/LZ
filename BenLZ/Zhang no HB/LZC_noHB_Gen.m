%LZC_noHB_Gen

clear
clc
start_ben
global out_paths conds subconds num lim plothb E_T_flag task_flag  %#ok<NUSED>
DOC_basic
LZC_noHB_param

[LZCs_per_cond] = LZC_noHB(data_ratio, rates, rate_flag, event_flag);

save('2ndLZCnohb');

%% plotting



 if ~task_flag
     LZCs_per_cond = cellfun(@(x) mean(x,2),LZCs_per_cond,'UniformOutpu',false');
 end
%  
%  LZCs_per_cond = cell2mat(LZCs_per_cond);
%  plot(1:length(conds),LZCs_per_cond)
%  num2cell(LZCs_per_cond)
 figitup(LZCs_per_cond,'LZC per condition',0)
 
 