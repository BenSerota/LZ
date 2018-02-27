function [LZC] = LZC_noHB(data_ratio, rates, rate_flag , event_flag)
% this function:
% 1. takes INPUT ratio of jaco data and removes its HB component.
% 2. calculates Lempel Ziv Complexity, Zhang implementaiton.
% * task_flag = take into consideration LDGD / LDGS etc. tasks.

global out_paths subconds num lim E_T_flag task_flag %#ok<NUSED>

%% handle input
if data_ratio <= 0 || data_ratio > 1 
    error('data ratio must be between 0 and 1')
end

if event_flag ~= 0 && event_flag ~= 1 
    error('event_flag must be either 0 or 1, correspondig to pure Z score or Hilbert Transform')
end

if rate_flag ~= 0 && rate_flag ~= 1 
    error('rate_flag must be either 1 or 0, indicating calculate 5 different event rates, or only the first')
end

if task_flag ~= 0 && task_flag ~= 1 
    error('task_flag must be either 1 or 0, i.e., taking into consideration experiment task or not')
end

%% prepare

DOC_Basic2;

%% handle data_ratio < 1
if data_ratio < 1
    small_amnt_sbjcts = round(data_ratio * amnt_sbjcts); %#ok
    % handle case where # subj is 0 due to low data_ratio
    if nnz(small_amnt_sbjcts==0)>0
        error('data_ratio appears to be too low, number of subjects in some conditions is 0')
    end
    amnt_sbjcts = num2cell(amnt_sbjcts);
    small_amnt_sbjcts = num2cell(small_amnt_sbjcts);    % moving to cell structure for @cellfun only
    names_inds = cellfun(@(x,y) randperm(x,y), amnt_sbjcts, small_amnt_sbjcts,'UniformOutput' ,false);
   
% choosing subjects
temp = cell(1,length(names_inds));
    for i = 1:length(names_inds)
        temp{i} = NAMES{i}(names_inds{i}); %#ok
    end
    
    NAMES = temp; clear temp;
    small_amnt_sbjcts = cell2mat(small_amnt_sbjcts); % returning to mat structure
    amnt_sbjcts = small_amnt_sbjcts; % giving back to amnt_sbjcts for JacoClock !
end

if ~rate_flag
    rates = rates(1);
end

%% go 
LZC = cell(1,length(conds));
for rate = rates
    while ~finito
        LZC{cnd}(subj,:) = Do1Sbj(NAMES, cnd, subj, rate, event_flag); % allocate LZC scores (1 grade or 4... egal)
        [cnd, subj, finito] = JacoClock(amnt_sbjcts, cnd, subj);    % advaning us in Jaco clock
    end
end

%% assisting functions


function [LZCsOneSubj] = Do1Sbj(NAMES, cnd, subj, rate, event_flag) % NOTE: consider making task_flag an input
global out_paths subconds num lim task_flag
cd(out_paths{cnd})
name = char(NAMES{cnd}(subj));
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
    
    DATAnhb = remove_HB(DATAwhb, rejcomps, num, lim);
    try
    LZCsOneSubj(i) = onetaskLZC(DATAnhb, rate, event_flag); % NOTE: double check . error ful.
    catch
        'fail stop';
    end
    clear DATAwhb DATAnhb rejcomps
end

if ~task_flag   % if not taking into consideration tasks, average.
    LZCsOneSubj = mean(LZCsOneSubj);
end


function [DATAnhb] = remove_HB(DATAwhb, rejcomps, num, lim)
% This code is meant to remove a number of hb ICs form our data.

% ICA activation matrix  = W * Sph * Raw:
ICAact = DATAwhb.w * DATAwhb.sph * DATAwhb.data;

% choosing #num comps from all hb cmps
if isempty(rejcomps)
    DATAnhb = DATAwhb.data; % no need to eliminate any comps
    return
elseif num > length(rejcomps)   % in case there are too few comps
    num = length(rejcomps);     % num = number of hb comps
end

% treating only comps below limit
rejcomps(rejcomps>lim) = [];
if isempty(rejcomps)    % if we are left with no comps, stop
    DATAnhb = DATAwhb.data;
    return
elseif num > length(rejcomps) % in case we are asking for too many comps than there are left (after >lim elimination)
    num = length(rejcomps); 
end

rejcomps = rejcomps(1:num); % take first 'num comps

% if plothb
%     HB_ICs(1:num,:) = ICAact(rejcomps,:);
%     plot(HB_ICs)
% end

%elimninating hb
ICAact(rejcomps,:) = [];
w_inv = pinv(DATAwhb.w*DATAwhb.sph);
w_inv(:,rejcomps) = [];  % rejecting corresponding colomns
DATAnhb = w_inv * ICAact;


function [C_task] = onetaskLZC(data, rate, event_flag)
% computes LZ Complexity for a single task (3 dim matrix)
global E_T_flag % onetaskLZCprep

try
    binary = onetaskLZCprep(data, rate, event_flag);
catch
    'fail stop';
end
binary = reshape(binary,206,385,[]); 
n = size(binary,3);
C_task = nan(1,n);

for i = 1:n
    C_task(i) = LZC_Rows(binary(:,:,i),E_T_flag);
end
C_task = mean(C_task);


function [binary] = onetaskLZCprep(data, rate, event_flag)
% transforms data to binary according to zscore only
data = zscore(data,0,2); % !! zscoring by row, automatically per epoch
if event_flag
    data = abs(hilbert(data)); % HILBERT. calcs per row as far as I understand 
end
thresh = rate/2;
% determining thresholds per row
lowprc = prctile(data,thresh,2); % returns a 206x1 vec
upprc = prctile(data,100-thresh,2);
binary = nan(size(data));

% if in lowest or highest prcntiles, mark as event.
binary = bsxfun(@lt,data,lowprc) | bsxfun(@gt,data,upprc);
binary = double(binary);
% nnz(binary)/numel(binary)

% function [binary] = onetaskLZCprep1(data,rate)
% % transforms data to binary according to zscore and hilbert transform
% data = zscore(data,0,2); % !! zscoring by row, automatically per epoch
% data = abs(hilbert(data)); % HILBERT. calcs per row as far as I understand 
% thresh = rate/2;
% % determining thresholds per row
% lowprc = prctile(data,thresh,2); % returns a 206x1 vec
% upprc = prctile(data,100-thresh,2);
% binary = nan(size(data));
% % per each row(! slowing us down!)
% % if in lowest or highest prcntiles, mark as event.
% for i = 1:size(data,1)
%     binary(i,:) = data(i,:) < lowprc(i) |  data(i,:) > upprc(i);
% end
% 
% binary = double(binary);
% % nnz(binary)/numel(binary)


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
