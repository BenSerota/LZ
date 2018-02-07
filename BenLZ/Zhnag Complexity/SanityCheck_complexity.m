% Sanity-checking the LZC complexity measure
% Comparing 3 different implementations :
% 1. Chained electrodes
% 2. Per electrode
% 3. Per Timepoint (data')

clear
clc
DOC_basic
s1 = 2e2; % channels
s2 = 385; % timepoints
reps = 5e2; % repetitions
[C,copies,C_chained,C_channels,C_timepoints] = deal(nan(1,reps));

for i = 1:reps
    
    % generating data : some more some less random
    data = randi([0 1], s1,s2);
    pattern = randi([0 1], 1,s2);                                           % pattern to be repeated
    copies(i) = randi([0 s1]);                                                 % how many reps
    pos = randi([1 s1], 1,copies(i));                                          % location of rows
    for j = pos                                                             % assign pattern.
        data(j,:) = pattern;
    end
    
    % compress data
    C_chained(i) = LZC_Chain(data);
    C_channels(i) = LZC_Rows(data,0);
    C_timepoints(i) = LZC_Rows(data,1);
    % COMPARE the 3
end

%% saving Worksapce
cd(WS_path)
SaveUnique('Sanitycheck_Complexity');
%% plotting
cd(Fig_path)
Cs = {C_chained,C_channels,C_timepoints};
names = {'Chained Electrodes','Single Channels','Timepoints'};
for i = 1:3
    PlotSanityCheck (Cs{i},copies,s1,0,names{i})
    savefig(sprintf('sanitycheck_%s',names{i}))
end
