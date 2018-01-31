% Zhang Test on our actual data

clear
clc
if ispc
    start_ben
end
global conds subconds data_paths out_paths

if isequal(date,'31-Jan-2018')
    DOC_Basic2
else
    DOC_basic
end

Zthresh = 2.5;

C_all = allcondsLZC(conds,Zthresh);
% SaveUniqueName('LZC_ondata')



function [C_all] = allcondsLZC(conds,Zthresh)
global out_paths
for i = length(conds):-1:1                                                  % over conditions
    %     cd(out_paths{i})                                                        % changes conditions. out_paths becaus out of original script is now this in-path
    % %~!~!~ MOMENTARYYY!! %~!~!~ :
    cd(out_paths{i}) % %~!~!~ MOMENTARYYY!! %~!~!~
    C_all = cell(1,length(conds));
    C_all{i} = onecondLZC(conds{i},Zthresh);
end
end

function [C_cond] = onecondLZC(cond,Zthresh)
% receives one level-of-consc condition(VS/MC etc.), draws random sbj and
% returns LZC scores of that sbj
load([cond '_names']);                                             % loads name list
names = sortn(names);                                                       % for fun
n = length(names);
names = strrep(names,'.mat','');                                            % drops '.mat' ending

s = randi([1 n]);                                                           % draws RANDOM SINGLE subject
n = length(s);
C_cond = cell(1,n);
for i = 1:s
    % CHANGE HERE !!
    if isequal(date,'31-Jan-2018')
        name = names{i};
        C_cond{i} = onesbjLZC(name,Zthresh);
    else
        name = names{i};
        C_cond{i} = onesbjLZC(name,Zthresh);
    end
end
end


function [Cs] = onesbjLZC(name,Zthresh)
% saves LZC scores across 4 tasks
global subconds
load(name)
Cs = cell(4,1);
for i = 1:4
    data = final.(subconds{i}).data;
    Cs{i} = onetaskLZC(data,Zthresh);
    clear data
end
clear final
end


function [C_task] = onetaskLZC(data,Zthresh)
% computes LZ Complexity for a single task (3 dim matrix)

data_binary = onetaskLZCprep (data,Zthresh);
n = size(data_binary,3);
C_task = nan(1,n);
for i = 1:n
    C_task(i) = LZ_C_Zhang(data_binary(:,:,i));
end

end


function [binary] = onetaskLZCprep (data,Zthresh)
% transforms data to binary according to set threshold
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
% if now at home
if isequal(date,'30-Jan-2018')
    cd('/Users/admin/Desktop/DACOBO_h/mock')
end
save (UniqueName)
end

%
% for i = length(conds):-1:1                                                  % over conditions
%     cd(out_paths{i})                                                        % changes conditions. out_paths becaus out of original script is now this in-path
%     load(sprintf('%s_names',conds{i}));                                     % loads name list
%     names = sortn(names);                                                   % for fun
%     for q = 1:length(names)                                                 % drops '.mat' ending
%         names{q,1} = names{q,1}(1,1:end-4);
%     end
%     %     for ii = randi([0 length(names)],1,1) %1:length(names)                % over subjects
%     ii = randi([0 length(names)],1,1);                                  % draws random subject
%     name_p = sprintf('%s_prep',names{ii});
%
%     %% load each set of ICs per subj per task
%     load(name_p);                                                         % load subject
%
%     for j = length(subconds):-1:1                                       % treating each subcondition seperately
%         DATA = final.(subconds{j});
%
%         % ICA activation matrix  = W * Sph * Raw:
%         workdata = reshape(DATA.data,[],385,[]);
%         s1 = size(workdata,1);                                              % channels, 206
%         s2 = size(workdata,2);                                              % timepoints, 385
%         epochs = size(workdata,3);
%
%         [C] = deal(nan(1,epochs));
%         % compress data
%         for jj = 1:epochs
%             C(i) = LZ_C_Zhang(data);
%         end
%
%     end
%     %% saving
%     if ismac
%         cd('/Users/admin/Dropbox/Ben Serota/momentary')
%     elseif ispc
%         cd('E:\DOC\WorkSpaces')
%     end
%
% end
% % SaveUniqueName('LZ_Zhang_WS');
% %% plotting
%
% x = 1-reps/s1; %% HERE
% y = C;
% % dSizes = cellfun(@(x) length(x),d);
% % DataCompSizes = cellfun(@(x) length(x),DataComp);
% % y = dSizes./b;
% % y = DataCompSizes./b;
%
% %%
% % x = rel_complx;
% % y = LZ_size;
% figure('name', 'data');
% scatter(x,y,'o')
% hold on
% title('Length of LZ compressed code by Randomness')
% xlabel('Relative Randomeness')
% ylabel('normalised LZ complexity')
%
% %% linear regression
% p = polyfit(x,y,1);
% yfit = polyval(p,x);
% plot(x,yfit,'g')
% hold on
% yres = y - yfit;
% locvar = yres.^2;
% % slope = corrcoef(x,y); % wrong
% r = corrcoef(y,yfit);
% r = round(r(2),2); % (2) cuz diagonal is 1 and this is linear reg.
% center_yfit = (max(yfit)+min(yfit))/2;
% % text(0.6, center_yfit-2,sprintf('slope = %g',slope(2)),'fontsize',14,'color','blue')
% text(0.8, center_yfit,sprintf('r = %g',r),'fontsize',14,'color','green')
%
% %% non-linear regresion
% p2 = polyfit(x,y,2);
% yfit2 = polyval(p2,x);
% plot(x,yfit2,'r*')
% hold on
% yres2 = y - yfit2;
% locvar2 = yres2.^2;
% r2 = corrcoef(y,yfit2);
% r2 = round(r2(2),2); % (2) cuz diagonal is 1
% center_yfit2 = (max(yfit2)+min(yfit2))/2;
% text(0.8, center_yfit2,sprintf('r = %g',r2),'fontsize',14,'color','red')
%
% %% Variance : linear and non-linear
% %plotting deviations (variance?)
% figure('name', 'variance linear reg')
% scatter(x,locvar,'go')
% hold on
% p_var = polyfit(x,locvar,1);
% yfit_var = polyval(p_var,x);
% plot(x,yfit_var,'g-')
% title('Variance by Randomness : linear and non linear regression')
% xlabel('Relative Randomeness')
% ylabel('Variance of normalized LZ complexity grades')
% r_var = corrcoef(yfit_var,locvar);
% r_var = round(r_var(2),2); % (2) cuz diagonal is 1 and this is linear reg.
% loc_yfit_var = 1.75*max(yfit_var);
% text(0.3, loc_yfit_var ,sprintf('r = %g',r_var),'fontsize',14,'color','green')
%
% %% Variance non linear
% %plotting deviations (variance?)
% % figure('name', 'variance non linear reg')
% scatter(x,locvar2,'ro')
% p2_var = polyfit(x,locvar2,2);
% yfit2_var = polyval(p2_var,x);
% plot(x,yfit2_var,'r*')
% % title('Variance by Randomness : NON linear reg')
% xlabel('Relative Randomeness')
% ylabel('Variance of normalized LZ complexity grades')
% r2_var = corrcoef(yfit2_var,locvar2);
% r2_var = round(r2_var(2),2); % (2) cuz diagonal is 1 and this is linear reg.
% loc_yfit2_var = 1.75*max(yfit2_var);
% text(0.3, loc_yfit2_var,sprintf('r = %g',r2_var),'fontsize',14,'color','red')
%
% legend ('linear deviations','linear reg','non-linear deviations','non-linear reg')
%
% tilefigs

% assisting functions


