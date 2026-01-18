%% Step 1: Generate Predicted Traveltimes for GDM52

clear; clc; close all;

%
Stanfo =readtable('STATIONS')
StaLatList = Stanfo.Var3;
StaLonList = Stanfo.Var4;
EventFiles = dir('*_CMTSOLUTION');
Plist=[50 65 80];
for Pnum = 1:length(Plist) 
    Period = Plist(Pnum)
for evnm = 1:length(EventFiles)

 [ evt ] = Read_SpecFemCMTSOLFile( EventFiles(evnm).name );
EVLAT  = evt.lat;
EVLON = evt.lon;
EVDEP = evt.depth;
EVID = extractBefore(EventFiles(evnm).name,'_CMTSOLUTION');

[predicted_ttimelist,current_Clist] = Predict_GDM52_Ttime_at_StaLocs(Period,EVLON,EVLAT,...
  StaLonList,StaLatList  );

zzz(:,1) = StaLonList;
zzz(:,2) = StaLatList;
zzz(:,3) = EVLON*ones(size(StaLonList));
zzz(:,4) = EVLAT*ones(size(StaLonList));
zzz(:,5) = predicted_ttimelist;
zzz(:,6) = current_Clist;

dlmwrite(['GDM52TtimePredictions_GCRA/' EVID '_SLON_SLAT_ELON_ELAT_TTIME_PATHC_GDM52_' ...
    num2str(Period) 's'],zzz,'delimiter','\t','precision','%.7f')
clear zzz

end
end