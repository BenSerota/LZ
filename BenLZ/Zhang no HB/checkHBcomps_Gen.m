
global conds out_paths subconds %#ok<NUSED>
clear 
clc
start_ben
DOC_basic

[nums, positions] = checkHBcomps();

%% saving
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