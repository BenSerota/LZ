function [] = SaveUnique(root_name)
% if ~isstring(root_name) && ~ischar(root_name)
%     error('input must be of class char or string')
% end
cl = fix(clock);
stamp = strrep(mat2str(cl),' ','_');
stamp = strrep(stamp,'[','');
stamp = strrep(stamp,']','');
UniqueName = [root_name '_' stamp];
% save (UniqueName)

evalin('base', sprintf('save ("%s");', UniqueName));

