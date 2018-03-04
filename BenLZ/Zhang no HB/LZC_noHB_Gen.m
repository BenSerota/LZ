%LZC_noHB_Gen

clear
clc
start_ben
global out_paths conds subconds num lim plothb E_T_flag task_flag  %#ok<NUSED>
DOC_basic
LZC_noHB_param

[LZCs_per_cond] = LZC_noHB(data_ratio, rates, rate_flag, event_flag);

% save WS
SaveUniqueName('LZC_nohb', LZC_nohb_outpath)

%% plotting

% if not interested in Task seperation
if ~task_flag
    LZCs_to_plot = cellfun(@(x) mean(x,2),LZCs_per_cond,'UniformOutpu',false');
else
    LZCs_to_plot = LZCs_per_cond; % in order not to erase data
end

save_plot = 0;
STEs = figLZC(LZCs_to_plot,'LZC per condition', save_plot, LZC_nohb_outpath);

%% Variance tests & bar plot
%convert LZC scores to mat

[H, P] = BensVarTest(LZCs_per_cond);
LZCs_to_bar = cellfun(@(x) mean(mean(x)),LZCs_per_cond,'UniformOutpu',false');
LZCs_to_bar = cell2mat(LZCs_to_bar);
save_bar = 1;
E = cellfun(@(x) mean(x,2), STEs);
Pbar = prepP(P{5}); % P{5} are the Ps of the MEAN (over tasks)

BensSuperbar(LZCs_to_bar,Pbar,E,save_bar,Fig_path)


%% Excessory Funcs

function [] = SaveUniqueName(root_name,location)
if ~isstring(root_name) && ~ischar(root_name)
    error('1st input (file name) must be of class char or string')
end

if ~isstring(location) && ~ischar(location)
    error('2nd input (file directory) must be of class char or string')
end

cl = fix(clock);
cl(end) = [];
stamp = strrep(mat2str(cl),' ','_');
stamp = strrep(stamp,'[','');
stamp = strrep(stamp,']','');
UniqueName = [root_name '_' stamp];
cd (location)
evalin('base', sprintf('save ("%s");', UniqueName));
end

function Pbar = prepP(chosen_P)
ind1 = ~isnan(chosen_P); 
Pbar = chosen_P;  
Pbar(~ind1)=0;
Pbar = Pbar + Pbar';
Pbar(Pbar==0) = 1;
end
