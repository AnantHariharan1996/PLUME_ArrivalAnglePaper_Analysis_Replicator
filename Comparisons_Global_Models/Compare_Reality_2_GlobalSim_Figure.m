% Compare Arrival Angle Measurements
clear; clc; close all;

CMTFLIST = dir('*CMTSOLUTION');
for evnum = 1:length(CMTFLIST)

currfname = CMTFLIST(evnum).name;

[ evt ] = Read_SpecFemCMTSOLFile(  currfname );

ID = extractBefore(currname,'_CMTSOLUTION');

% load the observations, the gdm52 predictions, the s362ani preds and the gladm25 preds

OBSFNAME = [''];
GLADFNAME=[''];
GDMFNAME = [''];
S362ANIFNAME = [''];

end