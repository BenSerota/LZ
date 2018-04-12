function [] = violin_fig(data,kind) %,save_flag,out_path)

DOC_basic
colors = {'g';'y';'m';'b'};
figure();
distributionPlot (data,'xNames',conds,'showMM',6,'histOpt',1,'globalNorm',0,...
    'color',colors) % norm,1, hist,0 , 'variableWidth','false'
switch kind
    case 1
        title('Distribution of Datasets Sizes','fontsize',14)
        ylabel('samples in dataset')
    case 2
        title('LZC Disribution per Condition','fontsize',14)
        ylabel('LZC scores')
end


% ylabel('Percent of data rejected')

%saving figure
% if save_flag
%     cd(out_path)
%     savefig(violin_fig,['violin_LZC' date])
% end

