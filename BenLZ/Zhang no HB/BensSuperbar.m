% testsing
function [] = BensSuperbar (data,kind,P,E,save_flag,outpath) 
DOC_basic
bar_fig = figure();
colors = {'g';'r';'m';'b'};
txts = cell(1,length(data));
for i = 1:length(data)
    txts{i} = num2str(round(data(i),2));
end
superbar(1:4,data,'P',P,'E',E,'BarWidth',.5,'BarFaceColor',colors)
hold on
text(1:4,data-0.1,txts,'fontsize',14,'fontweight','bold')

switch kind
    case 1
        title('Complexity grades per condition (Means)','fontsize',16)
    case 2
        title('BAD DATASETS Complexity grades per cond (Means)','fontsize',16)
end

ylabel('LZ complexity grade')
xticks(1:4)
xlim([0.5 4.5])
ylim([0 1.1])
set(gca,'xticklabel',conds)
xlabel('Level of Consciousness')

if save_flag
    cd(outpath)
    savefig(bar_fig,['Bar_LZC_nohb' date])
end


