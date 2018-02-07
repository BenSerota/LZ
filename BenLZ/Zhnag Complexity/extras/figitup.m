function [] = figitup(C,Title,save_flag)
% inputs are : (accumulated complexity Data,Title for plot, save_flag)
% E.g.: (C, 'per Electrode', 1)
DOC_basic
descrip = Title;
C_fig = figure('name','Complexity grades per cond');
y_ave = nan(1,4);
y_std = nan(1,4);
for i = 1:4
    y = C{i};
    n = numel(y);
    x = repmat(i,n,1);
    y_ave(i) = mean(y); 
    y_std(i) = std(y);
    scatter(x,y)
    hold on
end
errorbar(y_ave,y_std,'-s','MarkerSize',5,...
    'MarkerEdgeColor','green','MarkerFaceColor','green','Color','k')
title(['Complexity grades per cond (' descrip ')'])
ylabel('LZ complexity grade')
xticks(1:4)
xlim([0.5 4.5])
ylim([0 1])
set(gca,'xticklabel',conds)
xlabel('Level of Consciousness')

%saving
if save_flag
    cd('E:\Dropbox\Ben Serota\momentary\Figs')
    savefig(C_fig,['LZC_ondata_' descrip date])
end