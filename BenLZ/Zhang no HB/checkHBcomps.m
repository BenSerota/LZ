function [nums, positions,NAMES,elements] = checkHBcomps()
% this function:


%% prepare
global conds
DOC_Basic2; % inside there is NAMES, elements, etc...

%% go
[nums, positions] = deal(cell(1,length(conds)));
while ~finito
    [nums{cnd}(subj,:), positions{cnd}(subj,:), elements{cnd}(subj,:)] = check1Sbj(NAMES, cnd, subj); % allocate lengths and nums of comps
    [cnd, subj, finito] = JacoClock(amnt_sbjcts, cnd, subj);    % advaning us in Jaco clock
end



%% assisting functions
function [nums, positions, elements] = check1Sbj(NAMES, cnd, subj) % NOTE: consider making task_flag an input
global out_paths subconds 
cd(out_paths{cnd})
name = char(NAMES{cnd}(subj));
name_I = [ name '_HBICs'];
name_P = [ name '_prep'];

% load each set of ICs per subj
load(name_I);                                                              % load HB info

nums = nan(1,length(subconds));
positions = cell(1,length(subconds));

for i  = 1:length(subconds)
    positions{i} = Comps2Reject.(subconds{i});
    nums(i) = length(positions{i});
end


load(name_P)
elements = nan(1,length(subconds));
for i = length(subconds):-1:1                                       % treating each subcondition seperately
    DATA = final.(subconds{i}).data;
    elements(i) = size(DATA,2);
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
