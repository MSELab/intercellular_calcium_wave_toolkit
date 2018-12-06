S = subdir;
S = S';
tblOut = table(S);
writetable(tblOut, 'randomTable.xlsx');