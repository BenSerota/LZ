clear 
clc
global conds out_paths subconds 
start_ben
DOC_basic

% reject outliers beyond X% from bottom and top 
outlier_prcnt = 5;

[nums, positions,names,elements] = checkHBcomps();

%% saving
cd(LZC_nohb_outpath)
save('HBCompsCount')

%% calc outliers

%% OPTION 1 : by # of components rejected
sumnum = cellfun(@(x) sum(x,2), nums,'UniformOutput', false);
prc_high = nan(1,4);
prc_low = nan(1,4);
keep_inds = cell(1,4);
throw_inds = cell(1,4);
throw_names = cell(1,4);

for i = 1:length(sumnum)
%     subplot(1,4,i)
%     plot(1:length(sumnum{i}),sumnum{i})
    prc_high(i) = prctile(sumnum{i},100-outlier_prcnt);
    prc_low(i) = prctile(sumnum{i},outlier_prcnt);
    throw_inds{i} = sumnum{i}>prc_high(i) | sumnum{i}<prc_low(i);
    keep_inds{i} = ~keep_inds{i};
    throw_names{i} = names{i}(throw_inds{i});
end

%resaving
cd(LZC_nohb_outpath)
save('HBCompsCount')

%% OPTION 2 :  by # of data points%% by # of data points

vec_elements = cellfun(@(x) x(:), elements,'UniformOutput', false);
% LZCs2keep_inds{i} = bsxfun(@lt WHAT?

for i = 1:length(sumnum)    
    subplot(4,1,i)
    histogram(vec_elements{i})
end

low = 2e4;

for i = 1:length(conds)
    LZCs2keep_inds{i} = bsxfun(@lt,elements{i},low);
end
% testing how many scores we are throwing away
% cellfun(@(x) nnz(x), LZCs2keep_inds)

% resaving
cd(LZC_nohb_outpath)
save('HBCompsCount')


%% plotting
for i = 1:4 % over conds
    subplot(4,1,i)
    for j = 1:4 % over tasks
        histogram(nums{1,i}(:,j))
        hold on
    end
    legend
end