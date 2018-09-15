T = cellfun(@(x) reshape(x',[],1), LZC,'uniformoutput',0);
ALL_LZCs = [T{1};T{2};T{3};T{4}];
Good_LZCs = ALL_LZCs;
Good_LZCs (bads) = [];