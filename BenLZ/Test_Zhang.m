% Zhang Test
clear
clc
% data = randi([0 1],2e2,35e3);
% C = LZ_C_Zhang(data);

%%
s1 = 200; % channels
s2 = 35e2; % timepoints
rep = 1e2;
reps = nan(1,rep);

for i = 1:rep
       
    % generating data : some more some less random
    data = randi([0 1], s1,s2);
    pattern = randi([0 1], 1,s2);                                           % pattern to be repeated
    reps(i) = randi([0 l]);                                                 % how many reps
    pos = randi([1 l], 1,reps(i));                                          % location of rows
    for j = pos                                                             % assign pattern.
        data(j,:) = pattern;
    end
    
    % compress data
    C(i) = LZ_C_Zhang(data);
    
end

%% saving
if ismac
    cd('/Users/admin/Dropbox/Ben Serota/momentary')
elseif ispc
    cd('E:\DOC\WorkSpaces')
end

save ('LZ_Zhang_WS')

%% plotting 

X = 1-reps./s1; %% HERE
dSizes = cellfun(@(x) length(x),d);
DataCompSizes = cellfun(@(x) length(x),DataComp);
y = dSizes./b;
% y = DataCompSizes./b;

%%
x = rel_complx;
% y = LZ_size;
figure('name', 'data');
scatter(x,y,'o')
hold on
title('Length of LZ compressed code by Randomness')
xlabel('Relative Randomeness')
ylabel('Size of LZ compressed code')

%% linear regression
p = polyfit(x,y,1);
yfit = polyval(p,x);
plot(x,yfit,'g')
hold on
yres = y - yfit;
locvar = yres.^2;
% slope = corrcoef(x,y); % wrong
r = corrcoef(y,yfit);
r = round(r(2),2); % (2) cuz diagonal is 1 and this is linear reg.
center_yfit = (max(yfit)+min(yfit))/2;
% text(0.6, center_yfit-2,sprintf('slope = %g',slope(2)),'fontsize',14,'color','blue')
text(0.8, center_yfit,sprintf('r = %g',r),'fontsize',14,'color','green')

%% non-linear regresion
p2 = polyfit(x,y,2);
yfit2 = polyval(p2,x);
plot(x,yfit2,'r*')
hold on
yres2 = y - yfit2;
locvar2 = yres2.^2;
r2 = corrcoef(y,yfit2);
r2 = round(r2(2),2); % (2) cuz diagonal is 1
center_yfit2 = (max(yfit2)+min(yfit2))/2;
text(0.8, center_yfit2,sprintf('r = %g',r2),'fontsize',14,'color','red')

%% Variance : linear and non-linear
%plotting deviations (variance?)
figure('name', 'variance linear reg')
scatter(x,locvar,'go')
hold on
p_var = polyfit(x,locvar,1);
yfit_var = polyval(p_var,x);
plot(x,yfit_var,'g-')
title('Variance by Randomness : linear and non linear regression')
xlabel('Relative Randomeness')
ylabel('Variance of LZ lengths of compressed codes')
r_var = corrcoef(yfit_var,locvar);
r_var = round(r_var(2),2); % (2) cuz diagonal is 1 and this is linear reg.
loc_yfit_var = 1.75*max(yfit_var);
text(0.3, loc_yfit_var ,sprintf('r = %g',r_var),'fontsize',14,'color','green')

%% Variance non linear
%plotting deviations (variance?)
% figure('name', 'variance non linear reg')
scatter(x,locvar2,'ro')
p2_var = polyfit(x,locvar2,2);
yfit2_var = polyval(p2_var,x);
plot(x,yfit2_var,'r*')
% title('Variance by Randomness : NON linear reg')
xlabel('Relative Randomeness')
ylabel('Variance of LZ lengths of compressed codes')
r2_var = corrcoef(yfit2_var,locvar2);
r2_var = round(r2_var(2),2); % (2) cuz diagonal is 1 and this is linear reg.
loc_yfit2_var = 1.75*max(yfit2_var);
text(0.3, loc_yfit2_var,sprintf('r = %g',r2_var),'fontsize',14,'color','red')

legend ('linear deviations','linear reg','non-linear deviations','non-linear reg')

tilefigs

