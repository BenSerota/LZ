function [y_ste] = figLZC(C,kind,Title, task_flag, save_flag, outpath)
% inputs are : (accumulated complexity Data,Title for plot, save_flag)
% E.g.: (C, 'per Electrode', 1)
DOC_basic

% if not interested in Task seperation
if ~task_flag
    C = cellfun(@(x) mean(x,2,'omitnan'),C,'UniformOutpu',false');
end

if size(C{1},2) == 4
    descrip = [Title '_per task'];
else
    descrip = Title;
end
C_fig = figure('name','Complexity grades per cond');
y_ave = cell(1,4);
y_std = cell(1,4);
y_ste = cell(1,4);

% scatter LSCz
for i = 1:length(conds)
    for ii = 1:size(C{i},2) % over tasks ( didn't use 'length(subconds)' cuz sometime we disregard task (task_flag = 0)
        y = C{i}(:,ii); % = 1 task
        n = numel(y);
        x = repmat(i,n,1); % places LZC scores on x axis, on their task tick mark (1:4)
        y_ave{i}(ii) = mean(y,'omitnan');
        y_std{i}(ii) = std(y);
        y_ste{i}(ii) = y_std{i}(ii) / sqrt(n);
        % determing color by task
        if ii == 1
            col = 'g';
        elseif ii == 2
            col = 'b';
        elseif ii == 3
            col = 'r';
        else
            col = 'c';
        end
        scatter(x,y,col)
        hold on
        
    end
end

% plot means + errorbars
for ii = 1:size(C{i},2)
    for i = 1:length(conds)
        % determing color by task
        if ii == 1
            col = 'g';
        elseif ii == 2
            col = 'b';
        elseif ii == 3
            col = 'r';
        else
            col = 'c';
        end
        errorbar(i,y_ave{i}(ii),y_ste{i}(ii),'-s','MarkerSize',5,...
            'MarkerEdgeColor',col,'MarkerFaceColor',col,'Color',col)
        hold on
        ya(i) = y_ave{i}(ii);
    end
    
    plot(1:4,ya,col)
    
    % for no task -discriminaiton, mak mean line black
    if size(C{1},2) == 1
        col = 'black';
    
    scatter(1:4,ya,'h',col)
    plot(1:4,ya,'color',col)
    txt = cell(1,length(ya));
    for j = 1:length(ya)
        txt{j} = num2str(round(ya(j),2));
        text(j,ya(j)-.01,txt{j},'fontsize',14)
    end
    end
end

switch kind
    case 1
        title(['Complexity grades per cond (' descrip ')'],'fontsize',16)
    case 2
        title(['BAD DATASETS Complexity grades per cond (' descrip ')'],'fontsize',16)
end
ylabel('LZ complexity grade')
xticks(1:4)
xlim([0.5 4.5])
ylim([0 1])
set(gca,'xticklabel',conds)
xlabel('Level of Consciousness')
legend(subconds,'location','best');

%saving figure
if save_flag
    cd(outpath)
    savefig(C_fig,['LZC_nohb_' descrip date])
end


