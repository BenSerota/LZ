% testsing
function [] = BensSuperbar (data,kind,P,E,save_flag,outpath,prm_name,alph)
%checking if values are negetive or not:
data = data;
if data(1) < 0 % if negative values. taking 1 for simplicity.
    data = -data;
end

DOC_basic
bar_fig = figure();
colors = {'g';'r';'m';'b'};
txts = cell(1,length(data));
for i = 1:length(data)
    txts{i} = num2str(round(data(i),2));
end
superbar(1:4,data,'P',P,'PStarThreshold',alph,'E',E,'BarWidth',.5,'BarFaceColor',colors)
hold on
text(1:4,data-0.1,txts,'fontsize',14,'fontweight','bold')

switch kind
    case 1
        title('Complexity grades per condition (Means)','fontsize',16)
        ylabel('LZ complexity grade')
        xticks(1:4)
%         xlim([0.5 4.5])
%         ylim([0 1.1])
        
        set(gca,'xticklabel',conds)
        xlabel('Level of Consciousness')
        
    case 2
        title('BAD DATASETS Complexity grades per cond (Means)','fontsize',16)
        ylabel('LZ complexity grade')
        xticks(1:4)
%         xlim([0.5 4.5])
%         ylim([0 1.1])
        set(gca,'xticklabel',conds)
        xlabel('Level of Consciousness')
        
    case 3
        title(['Avalanche Parameter:' upper(prm_name) ', per condition (Means)'],'fontsize',16)
        ylabel([prm_name 'value'])
        xticks(1:4)
%         xlim([0.5 4.5])
        % setting graph height
        mn = .5*min(data);
        mx = 1.7*max(data);
        ylim([mn mx])
        set(gca,'xticklabel',conds)
        xlabel('Level of Consciousness')
        
end

if save_flag
    cd(outpath)
    savefig(bar_fig,['Bar_LZC_nohb' date])
end


