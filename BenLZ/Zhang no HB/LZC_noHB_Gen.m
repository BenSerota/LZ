% LZC_noHB_Gen
%
clear
clc
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
% load('/Users/admin/Desktop/secure draft/LZCnoHB_partial_WS.mat') %% this is the heart of our data, allowing us no to run again
% LZCs_per_cond = LZC;
cd('/Users/admin/Dropbox/Ben Serota/eeg ANALYSES/results/LZC')
load('last_importantWS')

%% loading lengths of mtrices
load('HBCompsCount','elements');
elements_toplot = cellfun(@(x) x(:), elements,'uniformoutput',false); % vectorizing

% elements_toplot = cellfun(@(x) x', elements,'uniformoutput',false); % transposing for correct indexing
% elements_toplot = cellfun(@(x) x(:), elements_toplot,'uniformoutput',false); % vectorizing

%% Important!!
% violin_fig(elements_toplot,1);


% for i = 1:4
%     for ii = 1:4
%         scatter(i*ones(length(elements{i}),1),elements{i}(:,ii))
%         hold on
%     end
% end

%% marking outliers
alldata = cat(1,elements_toplot{:});
min_minutes = 1.5;
min_time = min_minutes*60*250; % min * sec * sample rate
cutoff = invprctile(alldata,min_time); %  cutoff is in prctile .
% or alternatively:
% percentile = 25;
cutoff = prctile(alldata,cutoff); % cutoff is in sameples.

LZCs2throw_marks  = cellfun(@(x) bsxfun(@lt,x,cutoff), elements_toplot, 'uniformoutput', false); % marking
LZC4work = cellfun(@(x) x(:), LZC, 'uniformoutput', false); % vectorizing
LZCs2throw = cellfun(@(x,y) x(y), LZC4work,LZCs2throw_marks,'uniformoutput', false);
LZCs2keep = cellfun(@(x,y) x(~y), LZC4work,LZCs2throw_marks,'uniformoutput', false);
% sanity check
lent = cell2mat(cellfun(@(x) length(x), LZCs2throw,'uniformoutput', false));
lenk = cell2mat(cellfun(@(x) length(x), LZCs2keep,'uniformoutput', false));
isequal(lent+lenk,[308 280 96 48])
% LZC4work = cellfun(@(x) sort(x), LZC4work, 'uniformoutput', false); %sorting, for fun
%% reject LZC scores from data that was too meagre
% notice! works only on 100% of the data !!
% because LZCs2keep_inds is indexed on entire data set.
%
% [ means , badmeans ] = deal (cell(1,length(conds)));
%
% for i = 1:length(conds)
%     LZCs2keep{i}(badinds{i}) = nan;
%     means{i} = mean(LZCs2keep{i},2,'omitnan');
%     % there will be no task in which all subj are nan, only possibly a subj
%     % which is nan in all tasks. therefore:
%     % truncating amount of LZC scores. should work well with cellfuns.
%
%     means{i}(isnan(means{i})) = [];
%
%     badmeans{i} = LZC{i}(badinds{i});
%
% end



% testing: removing columns 2 and 4: which are almost entirely NaNs!
% LZCsno2n4 = LZCs2keep;
%     LZCs1 = cellfun(@(x) x(:,1), LZCs2keep,'UniformOutput' ,false);
% %     LZCs3 = cellfun(@(x) x(:,3), LZCs2keep,'UniformOutput' ,false);
% % LZCsno2n4 = cellfun(@(x,y) cat(2,x,y),LZCs1,LZCs3,'UniformOutput' ,false);
% LZCsno2n4 = LZCs1;
% meanno2n4 = cellfun(@(x) mean(x,2,'omitnan'), LZCsno2n4,'UniformOutput' , false);
% meanno2n4  = LZCs1;
% for i = 1:length(conds)
%     meanno2n4 {i}(isnan(meanno2n4 {i})) = [];
% end

%% line plot

for i = 1:2
    switch i
        case 1
            data = LZCs2keep;
        case 2
            data = LZCs2throw;
    end
    
    save_plot = 0;task_flag = 0;
    STEs = figLZC(data,i,'LZC per condition',task_flag, save_plot, LZC_nohb_outpath);
    %% adding suspect "bad" LZCs
    
    % hold on
    % for i = 1:4
    %     for ii = 1:4
    %         scatter(i*ones(length(LZC{i}(badinds{i})),1),LZC{i}(badinds{i}), 'bd')
    %         hold on
    %     end
    % end
    
    % STEs = figLZC(LZCsno2n4,'LZC per condition',task_flag, save_plot, LZC_nohb_outpath);
    % STEs = figLZC(means,'LZC per condition',task_flag, save_plot, LZC_nohb_outpath);
    % used to be :
    % STEs = figLZC(LZCs_per_cond,'LZC per condition',task_flag, save_plot, LZC_nohb_outpath);
    
    %% Significance tests & bar plot : old.
    
    
    % 1. run F test
    P = BensAnovaTest(data,alpha);
    
    % 2. run paired t-tests
%     if P <= alpha
        [H, Pt, p_inds] = BensTtest(data,alpha);
        
        % 3. correct for mult comp
        [Pt_cor, crit_p, h] = fdr_bh(Pt,alpha);
        
        % 4. prepare P values for Bar graph
        Ps4bar = prepP(Pt_cor,p_inds);
        
        LZCs_to_bar = cellfun(@(x) mean(x),data,'UniformOutpu',false');
        LZCs_to_bar = cell2mat(LZCs_to_bar);
        save_bar = 0;
        %     E = cellfun(@(x) mean(x,2), STEs);
        E = cell2mat(STEs);
        
        BensSuperbar(LZCs_to_bar,i,Ps4bar,E,save_bar,LZC_nohb_outpath )
%     end
end
tilefigs
%% LZC distribution (violin plots)
save_violin = 0;
violin_fig(LZCs_to_plot,save_violin,LZC_nohb_outpath );
violin_fig(LZCs2keep,2) %,save_violin,LZC_nohb_outpath );

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
