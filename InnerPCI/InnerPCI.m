function [Ce, Ct] = InnerPCI (DATA,Jaco_flag,ZTHRESH1,ZTHRESH2,TIME_W,LZC_flag)
% Calculates Lempel-Ziv Complexity of a certain time window following
% naturally occuring internal events above threshold. Averaging over
% events.

%% handling output
Ce = [];
Ct = [];

%% handling input
if nargin ~= 6 % NOTE - be sure to change this according to final input structure
    error('InnerPCI must receive 6 inputs: data, threshold1,threshold2, time window and LZC_flag')
end

if size(DATA,1) >= size(DATA,2)
    fprintf('CAUTION: data appears to be sparse: InnerPCI treats data structure as [Channels X Timepoints]')
end

if Jaco_flag ~= 1 && Jaco_flag ~= 0
    error(['second input must be a (0/1) flag, indicating data is from' ...
        'Jaco or not (and is continuous)'])
end

if Jaco_flag
    fprintf('This is Jaco Data \n')
else
    fprintf('This is NOT Jaco Data, but a two dimansional matrix \n')
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

% OPTION 1: look for big events

%% find Events larger than ZTHRESH1
[big_events, data] = fndEvents(DATA,Jaco_flag,ZTHRESH1,TIME_W);
if numel(big_events) == 0
    return
end
clear DATA
%% binarize data according to ZTHRESH2
b_data = binarize(data,ZTHRESH2);

%% generate "big-events epochs"
[n_epochs] = big_events_epochs(big_events, TIME_W, data, b_data);

%% calc LZC
[Ce,Ct] = calc_LZC (n_epochs,LZC_flag);
fprintf('You done boy');

% OPTION 2: handle data with avalanche code so that now we have a single vector ?




%% Excessory functions
function [Events, data] = fndEvents (DATA,Jaco_flag,ZTHRESH1, TIME_W)
% finds events larger than the Z-threshold,
% returns their coordinates and values, hierarchically.
Events = [];
if Jaco_flag
    data = reshape(DATA,206,385,[]); % parsing, after ICA code cat epochs
    data = zscore(data,0,3); % first Zscoring per epoch
    data = abs(zscore(data,0,1)); % second Zscoring per electrode NOTE : is this z-scoring considering every epoch seperately, or not?
else
    data = abs(zscore(DATA,0,1)); % NOTE: Zscoring per electrode! (continuous data)
end

lgcl = data >= ZTHRESH1;
if nnz(lgcl) == 0
    fprintf('No Big Events Found! \n Consider lowering threshold1 \n')
    return
end
evnts = data(lgcl);
ind = find(lgcl);

% sanity check
t = unique(ind);
if numel(t) < numel(ind)
    error('some problem: identical indeces for big events')
end

% check which Events have enough data after them (TIME_W after them)
% and throw away events that do not comply
[ind1,ind2,ind3] = ind2sub(size(data), ind);
subs = [ind1,ind2,ind3];
clear ind1 ind2 ind3
cond = subs(:,2,:) <= ( size(data,2) - TIME_W );
if nnz(cond) == 0
    fprintf('No Good Events Found! \n Consider shortening timewindow or lowering threshold1 or both \n')
    return
end
subs = subs(cond,:);
evnts = evnts(cond,:);
% empties = nan(length(ind),1);
Events = [evnts,subs]; %,empties];
Events = sortrows(Events,-1); % '-1' =  'descend'


function [binary] = binarize (DATA,ZTHRESH2)
% transforms data to binary according to set threshold
% data is either epoched or continuous, shouldn't matter now

% data = abs(zscore(data,0,3)); % NOTE: Z scoring is now per epoch and NOT per ELECTRODE+per epoch. should be?
binary = DATA>ZTHRESH2;
binary = double(binary);

function [n_epochs] = big_events_epochs(big_events, TIME_W, data, b_data) 
% "new epchs" = TIME_W after good events
inds = big_events(:,3:4); % don't care about rows right now
start_ind = unique(inds,'rows');
end_ind  = start_ind(:,1) + (TIME_W - 1); % to get to TP
epochs = start_ind(:,2);

n_epochs = nan(size(data,1),TIME_W,length(end_ind));
for i = 1:length(end_ind)
    n_epochs(:,:,i) = b_data (:,start_ind(i,1):end_ind(i,1),epochs(i));
end

function [Ce,Ct] = calc_LZC (n_epochs,LZC_flag)
Ce = [];
Ct = [];
s = size(n_epochs,3);

switch LZC_flag
    case 0
        Ce = nan(1,s);
        for i = 1:s
            % per electrode
            Ce(i) = LZC_Rows (n_epochs(:,:,i),0);
        end
    case 1
        Ct = nan(1,s);
        for i = 1:s
            % per time point
            Ct(i) = LZC_Rows (n_epochs(:,:,i),1);
        end
        
    case 2
        Ce = nan(1,s);
        Ct = nan(1,s);
        for i = 1:s
            % per electrode
            Ce(i) = LZC_Rows (n_epochs(:,:,i),0);
            % per time point
            Ct(i) = LZC_Rows (n_epochs(:,:,i),1);
        end
        % per chained electrode? (unnecessary?)
end
