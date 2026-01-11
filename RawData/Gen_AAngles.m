%% Generate files containing final arrival angles

CleanupOldAAFiles

clear; clc; close all;

%PeriodList = [50 66.6667 80];
PeriodList = [50 66.6667 80];

NewDatFolder =        '/Users/ananthariharan/Documents/GitHub/PLUME_ArrivalAnglePaper_Analysis_Replicator/RawData/';

Min_N_Stations = 3;
load coastlines
L_TOL  = 3.2;


for Period = PeriodList
    freq = 1/Period;
 [phvel]=prem_dispersion(freq)
    NewDatFolder_at_Period = [NewDatFolder num2str(Period) 's/' ]
    NewFlist = dir([NewDatFolder_at_Period '200*'])

    for evnum = 1:length(NewFlist)

        fname = NewFlist(evnum).name;
        Dat = load([NewDatFolder_at_Period fname],'-ascii');
        Slon = Dat(:,1);
        Slat = Dat(:,2);
        Stt = Dat(:,3);
        Evlon=Dat(:,4);
        Evlat=Dat(:,5);
        % get AAs

  Ref_X_Grid = [min(Slon) - 2:0.1:max(Slon) + 2];
Ref_Y_Grid = [min(Slat) - 2:0.1:max(Slat) + 2];
[XGRD,YGRD] = meshgrid(Ref_X_Grid,Ref_Y_Grid);
dist2grd_km = deg2km(distance(Evlat(1),Evlon(1),YGRD,XGRD));
TT_Pred  = dist2grd_km./phvel;
[ fx,fy,angle,xgrid,ygrid,tgrid2 ] = Get_arrival_angle( Evlat(1),Evlon(1),YGRD(:),XGRD(:),TT_Pred(:),0.15 );

                [ArrivalAngleList,Best_LocalPhVelList,ArrivalAngle_LowBound,ArrivalAngle_HighBound] = ...
    GetArrivalAngles_Event_MiniArray(Slon,Slat,Stt,L_TOL,Evlat(1),Evlon(1),Min_N_Stations);

Foster_Angle_Resid = ArrivalAngleList' - griddata(xgrid,ygrid,angle,Slon,Slat);

Dat(:,7) = ArrivalAngleList;
Dat(:,8) = ArrivalAngle_LowBound;
Dat(:,9) = ArrivalAngle_HighBound;
Dat(:,10) = Best_LocalPhVelList;

% Get the GC angle resid
Dat(:,11) = Foster_Angle_Resid;




dlmwrite([NewDatFolder_at_Period  fname '_AA_Lo_Hi_C_AAResid'],Dat,'precision','%.6f','delimiter','\t');


    end
end