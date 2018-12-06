clear;
clc;
close all;

addpath(genpath('bfmatlab'));
%loci.common.DebugTools.enableLogging('INFO');

tblRandomized = readtable('randomTable.xlsx');
tblLabels = readtable('videoName-Control.xlsx');

newPath = table2cell(tblRandomized(:,2));

% label = tblLabels.Label;
pathLabel = tblLabels.Path;
videoIndexLabel = tblLabels.Label;

mkdir('randomized')

for i = 1:length(pathLabel)
    % active = strcmp(tblRandomized.newLabel, label{i});
    active = strcmp(tblRandomized.newPath, pathLabel{i});
    tmpNewName = {};
    existList = [];
    for j = find(active)'
       tmpNewName{end + 1} = ['randomized' filesep tblRandomized.newName{j} '.mat'];
       existList(end + 1) = exist(tmpNewName{end}, 'file');
    end
    
    if ~any(active) || all(existList)
        continue
    end
    
    % stack = readTiff(['Tif' filesep label{i} '.tif']);
    stack = readTiff([newPath{2+(i-1)*9} '\Scene1Interval01.tifBWStack.tif']);
    
    for j = 1:9
        if (j-1)*9+9 > size(stack, 3)
            continue
        end
        % newLabel = [label{i} '_' num2str(j)];
        newLabel = [videoIndexLabel{i} '_' num2str(j)];
        idx = find(strcmp(tblRandomized.newLabel2, newLabel));
        newName = [tblRandomized.newName{idx} '.mat'];
        video = stack(:,:,(j-1)*9+1:(j-1)*9+9);
        save(['randomized' filesep newName],'video');
    end
    
    disp([num2str(round(i / length(pathLabel) * 100)), '% done']);
end