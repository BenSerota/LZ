% LZC_noHB_Gen
% 
% clear
% clc
close all
start_ben
global out_paths conds subconds num lim plothb E_T_flag task_flag  %#ok<NUSED>
DOC_basic
LZC_noHB_param

% [LZCs_per_cond] = LZC_noHB(data_ratio, rates, rate_flag, event_flag);
% 
% save WS
% SaveUniqueName('LZC_nohb', LZC_nohb_outpath)

% cd(LZC_nohb_outpath)
% load('LZC_nohb_2018_3_5_6_32');
load('/Users/admin/Desktop/secure draft/LZCnoHB_partial_WS.mat') %% this is the heart of our data, allowing us no to run again
LZCs_per_cond = LZC;

%% loading lengths of mtrices
load('HBCompsCount','elements')
thresh = mean(cell2mat(cellfun(@(x) prctile(x,25), m_el,'UniformOutput' , false))); % NOTE: decide if this is reasonable

for i = 1:length(conds)
    LZCs2keep_inds{i} = bsxfun(@lt,elements{i},thresh);
end
%% reject LZC scores from data that was too meagre
% notice! works only on 100% of the data !!
% because LZCs2keep_inds is indexed on entire data set.

LZCs2keep = cell(1,length(conds));
inds = cellfun(@(x) find(x), LZCs2keep_inds,'UniformOutput' ,false);
LZCs2keep = LZCs_per_cond;
for i = 1:length(conds)
    LZCs2keep{i}(inds{i}) = nan;
    means{i} = mean(LZCs2keep{i},2,'omitnan');
    % there will be no task in which all subj are nan, only possibly a subj
    % which is nan in all tasks. therefore:
    % truncating amount of LZC scores. should work well with cellfuns.

    means{i}(isnan(means{i})) = [];
end

% testing: removing columns 2 and 4: which are almost entirely NaNs!
LZCsno2n4 = LZCs2keep;
    LZCs1 = cellfun(@(x) x(:,1), LZCs2keep,'UniformOutput' ,false);
%     LZCs3 = cellfun(@(x) x(:,3), LZCs2keep,'UniformOutput' ,false);
% LZCsno2n4 = cellfun(@(x,y) cat(2,x,y),LZCs1,LZCs3,'UniformOutput' ,false);
LZCsno2n4 = LZCs1;
meanno2n4 = cellfun(@(x) mean(x,2,'omitnan'), LZCsno2n4,'UniformOutput' , false);
meanno2n4  = LZCs1;
for i = 1:length(conds)    
    meanno2n4 {i}(isnan(meanno2n4 {i})) = [];
end
    
%% line plot
save_plot = 0;
STEs = figLZC(LZCs2keep,'LZC per condition',task_flag, save_plot, LZC_nohb_outpath);
STEs = figLZC(LZCsno2n4,'LZC per condition',task_flag, save_plot, LZC_nohb_outpath);
STEs = figLZC(means,'LZC per condition',task_flag, save_plot, LZC_nohb_outpath);
% used to be :
% STEs = figLZC(LZCs_per_cond,'LZC per condition',task_flag, save_plot, LZC_nohb_outpath);

%% Significance tests & bar plot : old.

% 1. run F test
% LZCs_to_plot = cellfun(@(x) mean(x,2),LZCs_per_cond,'UniformOutpu',false');
% P = BensAnovaTest(LZCs_per_cond,alpha);
P = BensAnovaTest(means,alpha);
% P = BensAnovaTest(meanno2n4,alpha); means = meanno2n4;
% 2. run paired t-tests
if P <= alpha
    [H, Pt, inds] = BensTtest(means,alpha);
    
    % 3. correct for mult comp
    [Pt_cor, crit_p, h] = fdr_bh(Pt,alpha);
    
    % 4. prepare P values for Bar graph
    Ps4bar = prepP(Pt_cor,inds);
    
    LZCs_to_bar = cellfun(@(x) mean(x),means,'UniformOutpu',false');
    LZCs_to_bar = cell2mat(LZCs_to_bar);
    save_bar = 0;
%     E = cellfun(@(x) mean(x,2), STEs);
    E = cell2mat(STEs);
    
    BensSuperbar(LZCs_to_bar,Ps4bar,E,save_bar,LZC_nohb_outpath )
end


%% LZC distribution (violin plots)
save_violin = 0;
violin_fig(LZCs_to_plot,save_violin,LZC_nohb_outpath );
violin_fig(LZCs2keep,save_violin,LZC_nohb_outpath ); % TODO: change ytitle

%% save WS again , and finish
SaveUniqueName('LZC_nohb', LZC_nohb_outpath)
save('last_importantWS')

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

function Ps4bar = prepP(Pt_cor,inds)
global conds
Ps4bar = zeros(length(conds));
Ps4bar(inds) = Pt_cor;
Ps4bar = Ps4bar + Ps4bar';
Ps4bar(Ps4bar==0) = 1;
end
