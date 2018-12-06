tblLabels = readtable('videoName-Control.xlsx');
path = tblLabels.Path;
label = tblLabels.Label;

path([tblLabels.Ignore]) = [];
label([tblLabels.Ignore]) = [];

newLabel = {};
newLabel2 = {};
newPath = {};
newName = {};
newNum = [];

for i = 1:length(label)
    for j = 1:9
        newNum(end+1) = j;
        newPath{end+1} = path{i};
        newLabel{end+1} = label{i};
        newLabel2{end+1} = [label{i} '_' num2str(j)];
        newName{end+1} = [num2str(round(rand(1) * 1e10)) '_' num2str(round(rand(1) * 1e10))];
    end
end

newNum = newNum';
newPath = newPath';
newLabel = newLabel';
newLabel2 = newLabel2';
newName = newName';

tblOut = table(newNum, newPath, newLabel, newLabel2, newName);
writetable(tblOut, 'randomTable.xlsx');







