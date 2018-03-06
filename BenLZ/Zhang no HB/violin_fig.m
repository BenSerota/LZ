function [] = violin_fig(data,save_flag,out_path)
DOC_basic
colors = {'g';'r';'m';'b'};
violin_fig = figure();
title('LZC Disribution per Condition','fontsize',14)
distributionPlot (data,'xNames',conds,'showMM',4,'histOpt',1,'globalNorm',0,...
    'color',colors) % norm,1, hist,0 , 'variableWidth','false'
ylabel('Percent of data rejected')

%saving figure
if save_flag
    cd(out_path)
    savefig(violin_fig,['violin_LZC' date])
end

