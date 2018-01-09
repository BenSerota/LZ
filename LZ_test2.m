% random test
%% digits
t = randi([0 1], 10,100);
[comp d dims] = LZ(t);
recon = deLZ(comp,d,dims);

if isequal(recon,t)
    fprintf('\n SUCCESS! Original data and restored data are IDENTICAL \n')
else
    fprintf('\n Failure! Original Data and restored data are NOT identical \n')
end


%% chars
t = 'OrenIsTalkingToMeTightRightRightNow'; %totosmaymakemenmeasurerealtotos'; %yesterdayiwenttothedoctor'; %'wakkawakka';
[uncomp d dims] = LZ(t);
recon = deLZ(uncomp,d,dims)
if isequal(recon,t)
    fprintf('\n SUCCESS! Original data and restored data are IDENTICAL \n')
else
    fprintf('\n Failure! Original Data and restored data are NOT identical \n')
end

%% long data set

% cd('/Users/admin/Dropbox/Ben Serota/momentary')
cd('E:\Dropbox\Ben Serota\momentary')

t = randi([0 1], 200,100);
tUncomp{1} = t;
save tUncomp
[uncomp d dims] = LZ(t);
tComp{1} = uncomp;
tComp{2} = d;
tComp{3} = dims;
save tComp
recon = deLZ(uncomp,d,dims);
if isequal(recon,t)
    fprintf('\n SUCCESS! Original data and restored data are IDENTICAL \n')
else
    fprintf('\n Failure! Original Data and restored data are NOT identical \n')
end