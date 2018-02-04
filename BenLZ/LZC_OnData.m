function [] = LZC_OnData (E_T_flag)
% LZC (Zhang)Test on our actual data
global conds subconds data_paths out_paths WS_path e N Zthresh % s

DOC_basic
if E_T_flag ~= 0 && E_T_flag ~= 1
    error('first inpur must be 1/0 to choose per electrode or per TP')
elseif E_T_flag
    descrip = 'Per_TP';
else
    descrip = 'Per_Electrode';
end

%% setting parameters
LZC_param
%% go
C_all_conds = allcondsLZC(conds,subconds);
SaveUniqueName(['LZC_ondata_' descrip])
%% preparing for plotting: 
%C_all_conds to mat
C = cell(1,N);
C_task = cell(1,numel(subconds));
for i = 1:N
    s = numel(C_all_conds{i});
    C_sub = cell(1,s);
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
figitup(C,descrip,1) 
end
%% daughter functions

function [C_all] = allcondsLZC(conds,subconds)
gentic = tic;
global out_paths N
C_all = cell(1,length(conds));
for i = 1:N                                                      % over conditions
    cd(out_paths{i})                                                        % changes conditions. out_paths becaus out of original script is now this in-path
    C_all{i} = onecondLZC(conds{i},subconds);
end
fprintf('\n overall time for ALL conditions: %g \n', toc(gentic))
end

function [C_cond,subconds] = onecondLZC(cond,subconds)
% receives one level-of-consc condition(VS/MC etc.), draws random sbj and
% returns LZC scores of that sbj
% global s
tic_cond = tic;
load([cond '_names'],'names');                                                      % loads name list
names = sortn(names);                                                       %#ok<NODEF> % for fun
n = length(names);
names = strrep(names,'.mat','');                                            % drops '.mat' ending
C_cond = cell(1,n);
% s = randi([1 n]);                                                         % draws RANDOM SINGLE subject
for i = 1:n
    name = [names{i} '_prep'];
    C_cond{i} = onesbjLZC(name,subconds);
end
fprintf('\n overall time per %s condition: %g \n', cond, toc(tic_cond))
end

function [C_sub] = onesbjLZC(name,subconds)
% calcs LZC scores across 4 tasks
tic_sub = tic;
load(name)
C_sub = cell(4,1);
for i = 1:numel(subconds)
    data = final.(subconds{i}).data;
    C_sub{i} = onetaskLZC(data);
    clear data
end
clear final
fprintf('\n overall time per %s subject: %g \n', name, toc(tic_sub))
end

function [C_task] = onetaskLZC(data)
% computes LZ Complexity for a single task (3 dim matrix)
global e E_T_flag  % e = instead of n (all) EPOCHS, FOR TEST
data_binary = onetaskLZCprep (data);
n = size(data_binary,3);
if n<e 
    e = n;
end
C_task = nan(1,e); %n !
for i = 1:e %n
    C_task(i) = LZC_Gen(data_binary(:,:,i),E_T_flag);
end
end

function [binary] = onetaskLZCprep (data)
% transforms data to binary according to set threshold
global Zthresh
data = reshape(data,206,385,[]);
data = abs(zscore(data,0,3));
binary = data>Zthresh;
binary = double(binary);
end

function [] = SaveUniqueName(root_name)
if ~isstring(root_name) && ~ischar(root_name)
    error('input must be of class char or string')
end
cl = fix(clock);
stamp = strrep(mat2str(cl),' ','_');
stamp = strrep(stamp,'[','');
stamp = strrep(stamp,']','');
UniqueName = [root_name '_' stamp];
cd ('E:\Dropbox\Ben Serota\momentary\WS')
save (UniqueName)
end
