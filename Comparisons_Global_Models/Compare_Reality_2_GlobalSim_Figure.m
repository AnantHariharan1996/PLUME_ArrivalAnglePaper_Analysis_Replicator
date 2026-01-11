% Compare Arrival Angle Measurements
clear; clc; close all;

CMTFLIST = dir('*CMTSOLUTION');
for evnum = 1:length(CMTFLIST)

currfname = CMTFLIST(evnum).name;

[ evt ] = Read_SpecFemCMTSOLFile(  currfname );

ID = extractBefore(currname,'_CMTSOLUTION');

% load the observations, the gdm52 predictions, the s362ani preds and the gladm25 preds
obsdir = dir([200703130259Slon_Slat_Stt_Evlon_Evlat_EvDep_]);

OBSFNAME = [''];
GLADFNAME=[''];
GDMFNAME = [''];
S362ANIFNAME = [''];


figure(954)


end

saveas(gcf,'comparisonglobalpred.png')