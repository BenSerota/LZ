% Zhang Test on our actual data

clear
clc
start_ben
global conds subconds data_paths out_paths WS_path s e N
DOC_basic

%% setting parameters:
Zthresh = 3;
s = 12;  % # of subjects to check per cond
e = 50; % max # of epochs to check
N = numel(conds);
%% go

C_all_conds = allcondsLZC(conds,subconds,Zthresh);
cd('E:\Dropbox\Ben Serota\momentary\WS')
SaveUnique('LZC_ondata')

%% preparing plot
%C_all_conds to mat
C = cell(1,N);
C_sub = cell(1,s);
C_task = cell(1,numel(subconds));

for i = 1:N
    for j = 1:s
        for l = 1:numel(subconds)          
            tmp = C_all_conds{i}{j}{l};
            tmp = tmp(:);
            C_task{l} = tmp;
        end
        C_sub{j} = cat(1,C_task{1:l});
    end
    C{i} = cat(1,C_sub{1:s});
end

%% plotting
figitup(C,'_ChainElectrode',1)

%% functions

function [C_all] = allcondsLZC(conds,subconds,Zthresh)
global out_paths N
C_all = cell(1,length(conds));
for i = 1:N                                                      % over conditions
    cd(out_paths{i})                                                        % changes conditions. out_paths becaus out of original script is now this in-path
    C_all{i} = onecondLZC(conds{i},subconds,Zthresh);
end
end

function [C_cond,subconds] = onecondLZC(cond,subconds,Zthresh)
% receives one level-of-consc condition(VS/MC etc.), draws random sbj and
% returns LZC scores of that sbj
global s
tic_cond = tic;
load([cond '_names'],'names');                                                      % loads name list
names = sortn(names);                                                       %#ok<NODEF> % for fun
n = length(names);
names = strrep(names,'.mat','');                                            % drops '.mat' ending
C_cond = cell(1,n);
% s = randi([1 n]);                                                         % draws RANDOM SINGLE subject
% for i = 1:n
for i = 1:s
    name = [names{i} '_prep'];
    C_cond{i} = onesbjLZC(name,subconds,Zthresh);
end
fprintf('\n overall time per %s condition: %g \n', cond, toc(tic_cond))
end

function [C_sub] = onesbjLZC(name,subconds,Zthresh)
% calcs LZC scores across 4 tasks
tic_sub = tic;
load(name)
C_sub = cell(4,1);
for i = 1:numel(subconds)
    data = final.(subconds{i}).data;
    C_sub{i} = onetaskLZC(data,Zthresh);
    clear data
end
clear final
fprintf('\n overall time per %s subject: %g \n', name, toc(tic_sub))
end

function [C_task] = onetaskLZC(data,Zthresh)
% computes LZ Complexity for a single task (3 dim matrix)
global e  % e = instead of n (all) EPOCHS, FOR TEST
data_binary = onetaskLZCprep (data,Zthresh);
n = size(data_binary,3);
if n<e 
    e = n;
end
C_task = nan(1,e); %n !
for i = 1:e %n
    C_task(i) = LZC_Chain(data_binary(:,:,i)); %% NOTICE HERE: LZC_CHAIN : not rows
end
end

function [binary] = onetaskLZCprep (data,Zthresh)
% transforms data to binary according to set threshold
data = reshape(data,206,385,[]);
data = abs(zscore(data,0,3));
binary = data>Zthresh;
binary = double(binary);
end

% function [] = SaveUniqueName(root_name)
% if ~isstring(root_name) && ~ischar(root_name)
%     error('input must be of class char or string')
% end
% cl = fix(clock);
% stamp = strrep(mat2str(cl),' ','_');
% stamp = strrep(stamp,'[','');
% stamp = strrep(stamp,']','');
% UniqueName = [root_name '_' stamp];
% evalin('base', sprintf('save ("%s")', UniqueName));
% end
% 


