function c = eeg2lzc(eeg,k,style,thresh,dt)

if ~exist('k','var') || isempty(k)
    k = 2560;
end
if ~exist('style','var') || isempty(style)
    style = 2;
end
if ~exist('thresh','var')
    thresh = 0.8;
end
if ~exist('dt','var')
    dt = 1;
end

if dt > 1
    [elctrd,smpls] = size(eeg);
    N = floor(smpls/dt);
    eeg = reshape(eeg(:,1:N*dt),[elctrd dt N ]);
    eeg = squeeze(mean(eeg,2));
end
l = floor(length(eeg)/k);
eeg = eeg(:,1:l*k);
c = nan(1,l);
if style == 1
    parfor n = 1 : l
        [~,c(n)] = opt2LZcomplx(e2s(eeg(:,(1:k)+(n-1)*k),thresh));
    end
elseif style == 2
    parfor n = 1 : l
        [~,c(n)] = opt2LZcomplx(e2s2(eeg(:,(1:k)+(n-1)*k)));
    end
elseif style == 3
    eeg = e2s3(eeg);
    parfor n = 1 : l
        [~,c(n)] = opt2LZcomplx(eeg(:,(1:k)+(n-1)*k));
    end
end

function s = e2s(x,thresh)

x = zscore(x,[],2);
if thresh > .5
    thresh = (1 - thresh)/2;
end
dstrb = sort(x(:));
l = length(dstrb);
k = round(l*(1-thresh));
up = dstrb(k);
s = x > up;
k = round(l*thresh);
low = dstrb(k);
s = s + (x < low);

function s = e2s2(x)

[elctrd,smpls] = size(x);
x = mat2cell(x,ones(1,elctrd),smpls);
x = cellfun(@(y) abs(hilbert(y)),x,'uniformoutput',0);
x = cat(1,x{:});
s = bsxfun(@gt,x,mean(x,2));

function msk = e2s3(ts)

ts = zscore(ts');
dstrb = sort(ts(:));
l = length(dstrb);
k = round(l*0.995);
thresh = dstrb(k);
msk = ts > thresh;
k2 = round(l*0.005);
thresh2 = dstrb(k2);
msk = msk | (ts < thresh2);
smpls = size(msk,1);
msk = col([msk;zeros(1,size(ts,2))]);
ts = col([ts;zeros(1,size(ts,2))]);
[s,e] = enpoints2find(msk);
if isempty(s)
    msk = msk';
    return
end
mx = max(e-s+1);
inds = round(linspacen(s,e,mx));
vals = ts(inds);
[~,inds2] = max(abs(vals));
inds2 = sub2ind(size(vals),inds2,1:size(vals,2));
inds = inds(inds2);
msk = msk*0;
msk(inds) = 1;
msk = reshape(msk,[smpls+1 length(msk)/(smpls+1)]);
msk(end,:) = '';
msk = msk';

function [s,e] = enpoints2find(msk)
%msk is assumed to be a column binary vector
dm = diff(msk);
e = find(dm==-1);
s = find(dm==1)+1;
if msk(1)
    s = [1;s];
end
if msk(end)
    e(end+1) = length(msk);
end

function [c,C] = opt2LZcomplx(opt)
%opt has to be x x t
[c,r,q,k] = deal(1);
i = 2;
[R,C] = size(opt);
while 1
    if q == r
        a = i - 1;
    else
        a = C;
    end
%     disp([a i k])
    %     h = patrn2find(opt(q,1:a),opt(r,i:i+k));
    h = ~isempty(strfind(opt(q,1:a),opt(r,i:i+k-1)));
    if h
        k = k + 1;
        if i+k-1 > C
            r = r + 1;%we finished current row move to next
            if r > R
                break %rows finished
            else
                i = 1;
                q = r - 1;
                k = 1;
            end
        end
    else
        q = q - 1;
        if q < 1%all rows exhusted => complexity increased current index advanced
            c = c + 1;
            i = i + max(k - 1,1);
            if i + 1 > C
                r = r + 1;%we finished current row move to next
                if r > R
                    break %rows finished
                else
                    i = 1;
                    q = r - 1;
                    k = 1;
                end
            else
               q = r;%we reset reference column and relative offset
               k = 1;
            end
        end
    end
end
c = c + 1;
p = diff([0;find(diff(sort(opt(:))));C*R])/C/R;
h = -log2(p)'*p;
if isnan(h)
    h = inf;
end
L = C*R;
C = c*log2(L)/L/h;
