clear;
clc;
close all;

Path = subdir';
tblOut = table(Path);
newTblOut = array2table(zeros(0,1), 'VariableNames', {'Path'});

count = size(tblOut);
for i = 1:count(1)
    if contains(tblOut{i, 1}, 'Beacon')
        newTblOut = [newTblOut; tblOut{i,1}];   
    end
end        
writetable(newTblOut, 'videoName-Control.xlsx');