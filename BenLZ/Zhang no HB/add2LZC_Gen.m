% main sections to add to LZCs_nohb_gen
%% erase:
LZCs_per_cond = rand(50,4);
log = randi([0,1],50,4);
log = logical(log);
%% keep
inds = find(log);
LZCs2keep = LZCs_per_cond;
LZCs2keep(inds) = nan;
means1 = mean(LZCs2keep,'omitnan');
means2 = mean(LZCs2keep,2,'omitnan');

% there will be no task in which all subj are nan, only possibly a subj
% which is nan in all tasks. therefore:
% truncating amount of LZC scores. should work well with cellfuns.
means2 (isnan(means2 ) ) = [];




