function [LZC] = InnerPCI (DATA,THRESH,TIME_W)
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

if THRESH > 10 || THRESH < 0
    error('Threshold input is expected to be STD, current threshold is either too large (>10) or negative')
end

if TIME_W < 100
    error('Time Window must be greater than 100')
end


%% go

