function [LZC] = InnerPCI (DATA,Jaco_flag,ZTHRESH1,ZTHRESH2,TIME_W)
% Calculates Lempel-Ziv Complexity of a certain time window following
% naturally occuring internal events above threshold. Averaging over
% events.


%% handling input
if nargin ~= 5 % NOTE - be sure to change this according to final input structure
    error('InnerPCI must receive 4 inputs: data, threshold1,threshold2 and time window')
end

if Jaco_flag ~= 1 && Jaco_flag ~= 0
    error(['second input must be a (0/1) flag, indicating data is from' ...
        'Jaco or not (and is continuous)'])
end

% if size (DATA,3) ~= 1
%     error('Data must be a 2 dimensional matrix')
% end

if size(DATA,1) >= size(DATA,2)
    fprintf('CAUTION: data appears to be sparse: InnerPCI treats data structure as [Channels X Timepoints]')
end

if ZTHRESH1 > 10 || ZTHRESH1 < 0
    error('Threshold1 input is expected to be in STDs, current threshold1 is either too large (>10) or negative')
end

if ZTHRESH2 > 10 || ZTHRESH2 < 0
    error('Threshold2 input is expected to be in STDs, current threshold2 is either too large (>10) or negative')
end

if TIME_W < 100
    error('Time Window must be greater than 100')
end

if ZTHRESH1 <= ZTHRESH2
    fprintf('CAUTION: thresh2 is greater than thresh1 or thresholds are equal')
end


%% go

% find Events larger than ZTHRESH1
[big_events data] = fndEvents(DATA,Jaco_flag,ZTHRESH1);

%binarize data according to ZTHRESH2
b_data = binarize(data,ZTHRESH2);

% handle data with avalanche code so that now we have a single vector;


% check which Events have enough data after them (TIME_W after them)
% and throw away events that do not comply
c = 0;
for i = 1:length(big_events) 
    if big_events(i,2) + TIME_W  <= size(data,2)
        c = c + 1; 
        good_events (c,:) = big_events(i,1:2);
        big_events(i,3) = 1;
    else
        big_events(i,3) = 0;
    end
end
% TODO: finished here, and should continue to mark the indeces of good
% events

% Throw away events that do not comply
% eventss(:,) = events(:,2)(events(:,3) ==1);
% eventss = big_events(big_events(:,3) ==1);
%% Excessory functions
function [Events, data] = fndEvents (DATA,Jaco_flag,ZTHRESH1)
% finds events larger than the Z-threshold,
% returns their coordinates and values, hierarchically.
if Jaco_flag
    data = reshape(DATA,206,385,[]);
    data = zscore(data,0,3); % first Zscoring per epoch
    data = abs(zscore(data,0,1)); % second Zscoring per electrode NOTE : is this z-scoring considering every epoch seperately, or not?
else
    data = abs(zscore(DATA,0,1)); % NOTE: Zscoring per electrode! (continuous data)
end

lgcl = data >= ZTHRESH1;
evnts = data(lgcl);
ind = find(lgcl);

% "normaizing" indeces to account for epochs (to be checked against TIME_W
% afterwards)
if Jaco_flag
    mod_ind = mod(ind,385);
end

empties = nan(length(ind),1);
Events = [evnts,mod_ind,empties];
Events = sortrows(Events,-1); % '-1' =  'descend'

function [binary] = binarize (DATA,ZTHRESH2)
% transforms data to binary according to set threshold
% data is either epoched or continuous, shouldn't matter now

% data = abs(zscore(data,0,3)); % NOTE: Z scoring is now per epoch and NOT per ELECTRODE+per epoch. should be?
binary = DATA>ZTHRESH2;
binary = double(binary);

