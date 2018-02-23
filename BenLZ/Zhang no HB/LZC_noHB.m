function [LZCs_per_cond] = LZC_noHB(data_ratio, rates, event_flag, rate_flag ,task_flag)
% this function:
% 1. takes INPUT ratio of jaco data and removes its HB component.
% 2. calculates Lempel Ziv Complexity, Zhang implementaiton.
% * task_flag = take into consideration LDGD / LDGS etc. tasks.

%% handle input
if data_ratio <= 0 || data_ratio > 1 
    error('ration of data must be between 0 and 1')
end

if event_flag ~= 0 && event_flag ~= 1 
    error('event_flag must be either 0 or 1, correspondig to pure Z score or Hilbert Transform')
end

if rate_flag ~= 0 && rate_flag ~= 1 
    error('rate_flag must be either 1 or 0, indicating calculate 5 different event rates, or only the first')
end

if task_flag ~= 0 && task_flag ~= 1 
    error('task_flag must be either 1 or 0, taking into consideration experiment task or not')
end

%% prepare

DOC_basic
[NAMES,subjects,cond,subj] = DOC_Basic2(conds);
finito = 0;

% handle data_ratio < 1
if data_ratio < 1
    subjects = round(data_ratio * subjects);
    % handle case where # subj is 0 due to low data_ratio
    if nnz(subjects==0)>0
        error('data_ratio appears to be too low, number of subjects in some conditions is 0')
    end
    amount_sbjs = mat2cell(subjects);
    NAMES = cellfun(randperm, NAMES);
    temp = cellfun(@(x,y) x(1:y),NAMES,amount_sbjs);
    clear NAMES
    NAMES = temp;
end

if ~event_flag
    onetaskLZCprep = @onetaskLZCprep0;
else 
    onetaskLZCprep = @onetaskLZCprep1;
end

if ~rate_flag
    rates = rates(1);
end

%% go 
for i = rates
    while ~finito
        [DATAwhb, rejcomps] = Do1Sbj(NAMES,cond,subj);
        DATAnhb = remove_HB(DATAwhb, rejcomps, num, lim, plothb);
        [cond,subj, finito] = JacoClock(data_ratio, cond, subj);
    end
end

%% assisting functions

function [NAMES,subjects,cond,subj] = DOC_Basic2(conds)
global out_paths
subjects = nan (1,length(conds));
NAMES = cell(1,length(conds));
for i = 1:length(conds)                                                     % over conditions
    cd(out_paths{i})                                                        % changes conditions. out_paths becaus out of original script is now this in-path
    load(sprintf('%s_names',conds{i}));                                     % loads name list
    names = sortn(names);                                                   % for fun
    NAMES{i} = strrep(names,'.mat','');
    subjects(i) = length(names);
end
cond = 1;
subj = 1;


function [LZCsOneSubj] = Do1Sbj(NAMES,cond,subj)
global out_paths subconds num lim plothb task_flag
cd(out_paths{cond})
name = NAMES{cond}(subj);
name_p = [ name '_prep'];
name_I = [ name '_HBICs'];
% load each set of ICs per subj
load(name_p);                                                              % load subject
load(name_I);                                                              % load HB info

LZCsOneSubj = nan(1,length(subconds));
for i  = 1:length(subconds)
    DATAwhb.data = final.(subconds{i}).data;
    DATAwhb.w = final.(subconds{i}).w;
    DATAwhb.sph = final.(subconds{i}).sph;
    rejcomps = Comps2Reject.(subconds{i});
    
    DATAnhb = remove_HB(DATAwhb, rejcomps, num, lim, plothb);
    LZCsOneSubj(i) = onetaskLZC(DATAnhb);
    clear DATAwhb DATAnhb
end

if ~task_flag
    LZCsOneSubj = mean(LZCsOneSubj);
end


function [cond,subj, finito] = JacoClock(subjects, cond, subj)
    
subj = subj + 1;
if subj > subjects(cond)
    cond = cond + 1;
end

if cond > 4
    finito = 1;
end


function [DATAnhb] = remove_HB(DATAwhb, rejcomps, num, lim, plothb)
% This code is meant to remove a number of hb ICs form our data.

% ICA activation matrix  = W * Sph * Raw:
ICAact = DATAwhb.w * DATAwhb.sph * DATAwhb.data;

% choosing #num comps from all hb cmps
if isempty(rejcomps)
    return % no need to eliminate any comp
elseif num > length(rejcomps)   % in case there are too few comps
    num = length(rejcomps);     % num = number of hb comps
end

% treating only comps below limit
rejcomps(rejcomps>lim) = [];
if isempty(rejcomps)
    return
else
    rejcomps = rejcomps(1:num);
end

if plothb
    HB_ICs(1:num,:) = ICAact(rejcomps,:);
    plot(HB_ICs)
end

%elimninating hb
ICAact(rejcomps,:) = [];
w_inv = pinv(DATAwhb.w*DATAwhb.sph);
w_inv(:,rejcomps) = [];  % rejecting corresponding colomns
DATAnhb = w_inv * ICAact;
DATAnhb = reshape(DATAnhb,206,385,[]);


function [C_task] = onetaskLZC(data)
% computes LZ Complexity for a single task (3 dim matrix)
global E_T_flag
data_binary = onetaskLZCprep (data);
n = size(data_binary,3);
C_task = nan(1,n);

for i = 1:n
    C_task(i) = LZC_Rows(data_binary(:,:,i),E_T_flag);
end


% function [binary] = onetaskLZCprep0(data)
% % transforms data to binary according to pure Z-score 
% 
% data = abs(zscore(data,0,3));
% binary = data>Zthresh;
% binary = double(binary);

function [binary] = onetaskLZCprep1(data)
% transforms data to binary according to hilbert transform
data = zscore(data,0,3);
data = hilbert(data);
binary = data>Zthresh;
binary = double(binary);


% function [] = SaveUniqueName(root_name)
% if ~isstring(root_name) && ~ischar(root_name)
%     error('input must be of class char or string')
% end
% cl = fix(clock);
% stamp = strrep(mat2str(cl),' ','_');
% stamp = strrep(stamp,'[','');
% stamp = strrep(stamp,']','');
% UniqueName = [root_name '_' stamp];
% cd ('E:\Dropbox\Ben Serota\momentary\WS')
% save (UniqueName)
