% Sanity-checking the LZC complexity measure
% Comparing 3 different implementations :
% 1. Chained electrodes
% 2. Per electrode
% 3. Per Timepoint (data')

function [] = SanityCheck_complexity (randbyrow,reps)
% randbyrow = flag for randomizing matrices by copying ROWS or COLUMNS

DOC_basic
rows = 2e2; % channels
cols = 385; % timepoints
[copies,C_chained,C_channels,C_timepoints] = deal(nan(1,reps));

for i = 1:reps
    % generating data : some more some less random
    data = randi([0 1], rows,cols);
    
    if randbyrow
        pattern = randi([0 1], 1,cols);                                           % pattern to be repeated
    elseif ~randbyrow
        [rows, cols] = deal(cols, rows);
        pattern = randi([0 1], cols,1);                                           % pattern to be repeated
    elseif randbyrow ~= 0 && randbyrow ~= 1
        error ('randbyrow must be 0/1')
    end
    copies(i) = randi([0 rows]);                                                 % how many reps
    pos = randperm(rows);
    pos = pos(1:copies(i));                                                 % location of rows / columns
    
    if randbyrow
        for j = pos                                                             % assign pattern.
            data(j,:) = pattern;
        end
    else
        for j = pos                                                             % assign pattern.
            data(:,j) = pattern;
        end
    end
    
    % compress data
    C_chained(i) = LZC_Chain(data);
    C_channels(i) = LZC_Rows(data,0);
    C_timepoints(i) = LZC_Rows(data,1);
    % COMPARE the 3
end

%% saving Worksapce
cd(WS_path)
if randbyrow
    extra = ' RandRow';
else
    extra = ' RandCol';
end
SaveUnique(['Sanitycheck_Complexity' extra]);
%% plotting
cd(mom_Fig_path)
Cs = {C_chained,C_channels,C_timepoints};
names = {['Chained Electrodes' extra],['Single Channels' extra],['Timepoints' extra]};

for i = 1:3
    PlotSanityCheck (Cs{i},copies,rows,0,names{i});
    savefig(['sanitycheck ' names{i}])
    close
end

