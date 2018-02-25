global out_paths conds
amnt_sbjcts = nan(1,length(conds));
NAMES = cell(1,length(conds));
for i = 1:length(conds)                                                     % over conditions
    cd(out_paths{i})                                                        % changes conditions. out_paths becaus out of original script is now this in-path
    load([conds{i} '%s_names']);                                            % loads name list
    names = sortn(names);                                                   % for fun
    NAMES{i} = strrep(names,'.mat','');
    amnt_sbjcts(i) = length(names);
end
clear names
cond = 1;
subj = 1;
finito = 0;