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