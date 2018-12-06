clear;
clc;

tblResults = readtable('randomTable - Adjusted3.xlsx');
category = tblResults.newLabel;
for i = 1:length(category)
    category{i} = category{i}(1:end-4);
end
annotation = categorical(tblResults.annotation);
category = categorical(category);

remove = annotation == categorical({'empty'}) | annotation == categorical({'unusable'}) | annotation == categorical({'unknown'});
annotation(remove) = [];
category(remove) = [];

catList = unique(category);
classes = {'none', 'transient', 'spikes', 'waves', 'fluttering'};
classes = categorical(classes);

for i = 1:length(catList)
    for j = 1:length(classes)
        fraction(i,j) = sum(category == catList(i) & annotation == classes(j)) / sum(category == catList(i));
    end
end

for ii = 1:length(catList)
    sampleSize(ii) = nnz(count(cellstr(category), cellstr(catList(ii))));
end
sampleSize = sampleSize';
sampleSizeTable = table(catList, sampleSize);
fractionTable = table(catList, fraction);

% idx5Day = count(cellstr(category), 'Control_5day');
% idx6Day = count(cellstr(category), 'Control_6day');
% idx7Day = count(cellstr(category), 'Control_7day');
% idx8Day = count(cellstr(category), 'Control_8day');

idx5Day = count(cellstr(category), 'AkhR_5day');
idx6Day = count(cellstr(category), 'AkhR_6day');
idx7Day = count(cellstr(category), 'AkhR_7day');
idx8Day = count(cellstr(category), 'AkhR_8day');

minSample = 63;
sample5Day = datasample(find(idx5Day),minSample,'Replace',true);
sample6Day = datasample(find(idx6Day),minSample,'Replace',true);
sample7Day = datasample(find(idx7Day),minSample,'Replace',true);
sample8Day = datasample(find(idx8Day),minSample,'Replace',true);

randomSample = annotation(sample5Day);
randomSample = [randomSample, annotation(sample6Day)];
randomSample = [randomSample, annotation(sample7Day)];
randomSample = [randomSample, annotation(sample8Day)];

noneCount = nnz(count(cellstr(randomSample), 'none'));
transientCount = nnz(count(cellstr(randomSample), 'transient'));
waveCount = nnz(count(cellstr(randomSample), 'waves'));
spikeCount = nnz(count(cellstr(randomSample), 'spikes'));
flutteringCount = nnz(count(cellstr(randomSample), 'fluttering'));
disp(['none count: ' num2str(noneCount)]);
disp(['transient count: ' num2str(transientCount)]);
disp(['wave count: ' num2str(waveCount)]);
disp(['spike count: ' num2str(spikeCount)]);
disp(['fluttering count: ' num2str(flutteringCount)]);
disp(['total count: ' num2str(noneCount+transientCount+waveCount+spikeCount+flutteringCount)]);