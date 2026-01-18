%  get aamgles for specfem

%% Step 2: Generate Predicted AAngles for specfem

clear; clc; close all;
addpath(genpath('../Helper_Functions/'))
%
Stanfo =readtable('STATIONS')
StaLatList = Stanfo.Var3;
StaLonList = Stanfo.Var4;
Periodlist=[50];
EventFiles = dir('*_CMTSOLUTION');
L_TOL  = 3.2;
Min_N_Stations=3;
Model='S362ANI';

 Model='GLADM';

foldn9=['SPECFEM_Measurements_' Model '/'];
for Pnum = 1:length(Periodlist)
    Period = Periodlist(Pnum)
    freq = 1/Period;
 [phvel]=prem_dispersion(freq);
for evnm = 1:length(EventFiles)

 [ evt ] = Read_SpecFemCMTSOLFile( EventFiles(evnm).name );
EVLAT  = evt.lat;
EVLON = evt.lon;
EVDEP = evt.depth;
EVID = extractBefore(EventFiles(evnm).name,'_CMTSOLUTION');
EVID

currfname = [foldn9 'dtpamp_' num2str(Period) 's_' EVID];
if exist(currfname)==2
    [ evla,evlo,StaLatList,StaLonList,TTimeList,nsamp,amp ] = Read_dtpamp_file( currfname );

figure(1)
subplot(3,2,evnm)
scatter(StaLonList,StaLatList,100,TTimeList,'filled')
colorbar
title(EVID)

end
end

end