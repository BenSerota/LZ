function [nums, positions] = checkHBcomps()
% this function:
% 1. takes INPUT ratio of jaco data and removes its HB component.
% 2. calculates Lempel Ziv Complexity, Zhang implementaiton.
% * task_flag = take into consideration LDGD / LDGS etc. tasks.

global out_paths subconds conds %#ok<NUSED>


%% prepare

DOC_Basic2;

%% go
[nums, positions] = deal(cell(1,length(conds)));
while ~finito
    [nums{cnd}(subj,:), positions{cnd}(subj,:)] = check1Sbj(NAMES, cnd, subj); % allocate lengths and nums of comps
    [cnd, subj, finito] = JacoClock(amnt_sbjcts, cnd, subj);    % advaning us in Jaco clock
end



%% assisting functions
function [nums, positions] = check1Sbj(NAMES, cnd, subj) % NOTE: consider making task_flag an input
global out_paths subconds 
cd(out_paths{cnd})
name = char(NAMES{cnd}(subj));
name_I = [ name '_HBICs'];

% load each set of ICs per subj
load(name_I);                                                              % load HB info

nums = nan(1,length(subconds));
positions = cell(1,length(subconds));

for i  = 1:length(subconds)
    positions{i} = Comps2Reject.(subconds{i});
    nums(i) = length(positions{i});
end


function [cnd,subj, finito] = JacoClock(amnt_sbjcts, cnd, subj)

subj = subj + 1;
if subj > amnt_sbjcts(cnd)
    cnd = cnd + 1;
    subj = 1;
end

finito = 0;

if cnd > 4
    finito = 1;
end
