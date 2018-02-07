function [LZC] = InnerPCI (DATA,ZTHRESH,TIME_W)
% Calculates Lempel-Ziv Complexity of a certain time window following
% naturally occuring internal events above threshold. Averaging over
% events.


%% handling input
if nargin ~= 3
    error('InnerPCI must receive 3 inputs: data, threshold and time window')
end

if size (DATA,3) ~= 1
    error('Data must be a 2 dimensional matrix')
end

if size(DATA,1) >= size(DATA,2)
    fprintf('CAUTION: data appears to be sparse: InnerPCI treats data structure as [Channels X Timepoints]')
end

if ZTHRESH > 10 || ZTHRESH < 0
    error('Threshold input is expected to be STD, current threshold is either too large (>10) or negative')
end

if TIME_W < 100
    error('Time Window must be greater than 100')
end


%% go
% find Events larger than ZTHRESH
events = fndEvents(DATA,ZTHRESH);

%binarize data according to DIFFERENT threshold
b_data = binarize(DATA,THRESH2);

% handle data with avalanche code so that now wa have a single vector;

%% Excessory functions
function [Events] = fndEvents (DATA,ZTHRESH)
% finds events larger than the Z-threshold,
% returns their coordinates and values, hierarchically.
data = reshape(DATA,206,385,[]);
data = abs(zscore(data,0,3));
lgcl = data >= ZTHRESH;
evnts = data(lgcl);
ind = find(lgcl);
Events = [evnts,ind];
Events = sortrows(Events,1,'descend');

function [binary] = binarize (DATA,ZTHRESH)
% transforms data to binary according to set threshold
data = reshape(DATA,206,385,[]);
data = abs(zscore(data,0,3));
binary = data>ZTHRESH;
binary = double(binary);

