function [p,F,df] = group2fnt(y,class)
%GROUP2FNT one way ANOVA/ttest 2 via multiple regression
%   p = GROUP2FNT(y,group)
%   y is a matrix features x subjects
%   group: a numeric label vector
groups = unique(class);
if length(groups) == 2
    class = logical(class-min(class));
    [~,p,~,stats] = ttest2(y(:,class)',y(:,~class)',0.05,'both','unequal');
    F = stats.tstat;
    df = mean(stats.df(p<0.001));
    return
end
y = y';
X = group2designmat(class,groups);
[n,p] = size(X);
C = inv(X'*X);
b = C*X'*y;%#ok
bXy = sum((X*b).*y)';%diag(b'*X'*y);
SSres = sum(y.*y)'- bXy;
SSr = bXy - (sum(y).^2)'/n;
F = (SSr/(p-1))./(SSres/(n-p));
df = [p-1 n-p];
p = 1-fcdf(F,p-1,n-p);

function X = group2designmat(class,groups)
%The last group average will actually be the first column and the rest of the
% averages will be the difference mu_k - mu_0
if nargin == 1
    groups = unique(class);
end
groupN = length(groups);
n = length(class);
X = [ones(n,1) zeros(n,groupN-1)];
for k = 1 : groupN - 1
    X(class==groups(k),k+1) = 1;
end



