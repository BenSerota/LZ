% random test
%% digits
t = randi([0 1], 1,5);
[uncomp d dims] = LZ(t);
recon = deLZ(uncomp,d,dims)

if isequal(recon,t)
    fprintf('\n SUCCESS! Original data and restored data are IDENTICAL \n')
else
    fprintf('\n Failure! Original Data and restored data are NOT identical \n')
end


%% chars
t = 'totosmaymakemenmeasurerealtotos'; %yesterdayiwenttothedoctor'; %'wakkawakka';
[uncomp d dims] = LZ(t);
recon = deLZ(uncomp,d,dims)
if isequal(recon,t)
    fprintf('\n SUCCESS! Original data and restored data are IDENTICAL \n')
else
    fprintf('\n Failure! Original Data and restored data are NOT identical \n')
end

%% long data set

% t = rand(1256,10000);