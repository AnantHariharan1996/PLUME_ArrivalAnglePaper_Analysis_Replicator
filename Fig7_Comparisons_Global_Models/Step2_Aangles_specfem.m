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
for evnm = 2:length(EventFiles)

 [ evt ] = Read_SpecFemCMTSOLFile( EventFiles(evnm).name );
EVLAT  = evt.lat;
EVLON = evt.lon;
EVDEP = evt.depth;
EVID = extractBefore(EventFiles(evnm).name,'_CMTSOLUTION');
EVID

currfname = [foldn9 'dtpamp_' num2str(Period) 's_' EVID];
if exist(currfname)==2
    [ evla,evlo,StaLatList,StaLonList,TTimeList,nsamp,amp ] = Read_dtpamp_file( currfname );



  Ref_X_Grid = [min(StaLonList) - 2:0.1:max(StaLonList) + 2];
Ref_Y_Grid = [min(StaLatList) - 2:0.1:max(StaLatList) + 2];
[XGRD,YGRD] = meshgrid(Ref_X_Grid,Ref_Y_Grid);
dist2grd_km = deg2km(distance(EVLAT(1),EVLON(1),YGRD,XGRD));
TT_Pred  = dist2grd_km./phvel;
[ fx,fy,angle,xgrid,ygrid,tgrid2 ] = Get_arrival_angle( EVLAT(1),EVLON(1),YGRD(:),XGRD(:),TT_Pred(:),0.15 );


              [ArrivalAngleList,Best_LocalPhVelList,ArrivalAngle_LowBound,ArrivalAngle_HighBound] = ...
    GetArrivalAngles_Event_MiniArray(StaLonList,StaLatList,TTimeList,L_TOL,EVLAT(1),EVLON(1),Min_N_Stations);

Foster_Angle_Resid = ArrivalAngleList' - griddata(xgrid,ygrid,angle,StaLonList,StaLatList);
% 
 zzz(:,1) = StaLonList;
 zzz(:,2) = StaLatList;
 zzz(:,3) = EVLON*ones(size(StaLonList));
 zzz(:,4) = EVLAT*ones(size(StaLonList));
 zzz(:,5) = TTimeList;
 zzz(:,6) = nsamp;
zzz(:,7) = ArrivalAngleList;
zzz(:,8) = ArrivalAngle_LowBound;
zzz(:,9) = ArrivalAngle_HighBound;
zzz(:,10) = Best_LocalPhVelList;
zzz(:,11) = Foster_Angle_Resid;

dlmwrite([foldn9 EVID '_SLON_SLAT_ELON_ELAT_TTIME_PATHC_GDM52_' ...
    num2str(Period) 's_AA_Lo_Hi_Nm_AAResid'],zzz,'delimiter','\t','precision','%.6f');
clear zzz
end
end

end