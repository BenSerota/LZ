% LZ complx, following Shang Zhang
function [c_norm] = LZC_Chain (data)
tic
P = strrep((mat2str(data)),' ','');
P = strrep(P,'[','');
P =  strrep(P,']','');
P =  strrep(P,';','');
n = numel(P);
i = 2;
c = 0;
Q = string(P(i));
S = string(P(i-1));
SQ = join([S Q]);
SQpi = string(SQ{1}(1:end-2)); % -2 only because the space is included

while i < n
    while contains(SQpi,Q)
        if i == n
            break
        end
        i = i + 1;
        Q = join([Q P(i)]);
    end
    
    if i == n && ~contains(SQpi,Q)
        c = c + 1;
        break
    end
    
    if i == n
        break
    end
    c = c + 1;
    SQ = join([S,Q]);
    SQpi = string(SQ{1}(1:end-2));
    S = SQ;
    i = i + 1;
    Q = string(P(i));
end

toc

% sanitycheck = c <= n/log2(n);
% if sanitycheck
%     fprintf('c within bounds')
% else
%     fprintf('\n ALGORITHMIC ERROR? : c outside bounds')
% end

bound = n/log2(n);
c_norm = c / bound;

% 
% fprintf('\n data was %g bits long', n)
% fprintf('\n normalized LZ complexity is: %g \n \n', c_norm )

