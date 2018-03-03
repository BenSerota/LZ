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

 if ~task_flag
     LZCs_per_cond = cellfun(@(x) mean(x,2),LZCs_per_cond,'UniformOutpu',false');
 else
     error('task_flag is 1, but I have not set up a plotting scheme for this yet');
 end


 figitup(LZCs_per_cond,'LZC per condition',0)

%% Variance tests
%convert LZC scores to mat
h = nan(4);
p = nan(4);

for i = 2:4 
    [h(1,i),p(1,i)] = vartest2(LZCs_per_cond{1},LZCs_per_cond{i});
end

for i = 3:4 
    [h(2,i),p(2,i)] = vartest2(LZCs_per_cond{2},LZCs_per_cond{i});
end
    [h(3,4),p(3,4)] = vartest2(LZCs_per_cond{3},LZCs_per_cond{4});


 
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
save (UniqueName)
end
 