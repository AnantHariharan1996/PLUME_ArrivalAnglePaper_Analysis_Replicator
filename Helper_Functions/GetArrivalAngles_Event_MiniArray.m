function [ArrivalAngleList,Best_LocalPhVelList,ArrivalAngle_LowBound,ArrivalAngle_HighBound,MisfitStruc] = ...
    GetArrivalAngles_Event_MiniArray(Sta_Lons,Sta_Lats,TTime,L_Tol,EvLat,EvLon,Min_N_Stations)
% Uses the Foster 2014 method for every station with a traveltime
% measurement for an earthquake to measure arrival angles

distlist=distance(EvLat,EvLon,Sta_Lats,Sta_Lons);
distlist_km=deg2km(distlist);


for ijk = 1:length(Sta_Lats)
100*ijk/length(Sta_Lats)
curr_stalat=  Sta_Lats(ijk);
curr_stalon=  Sta_Lons(ijk);
% Get arrival angle assuming plane wave as 
% a starting estimate. 
[alen,azimuthstart] = distance(EvLat,EvLon,curr_stalat,curr_stalon);
searchaz=azimuthstart-80:0.1:azimuthstart+80;
% Get mini-array;
dists2otherstns = distance(curr_stalat,curr_stalon,Sta_Lats,Sta_Lons);
idx=find(dists2otherstns<L_Tol);
if length(idx) > Min_N_Stations

arraylats=Sta_Lats(idx);
arraylons=Sta_Lons(idx);
arrayttimes=TTime(idx);

% [Best_Angle,Best_LocalPhVelList(ijk),Misfitlist] = ...
%     GetArrivalAngle_MiniArraySingleStation(arraylons,arraylats,...
%     curr_stalon,curr_stalat,arrayttimes,searchaz,alen);

[Best_Angle,Best_LocalPhVelList(ijk),Misfitlist,min_angle,max_angle] = ...
    GetArrivalAngle_MiniArraySingleStation_WERROR(arraylons,arraylats,...
    curr_stalon,curr_stalat,arrayttimes,searchaz,alen);

MisfitStruc(ijk).Misfitlist = Misfitlist;
MisfitStruc(ijk).searchaz = searchaz;
MisfitStruc(ijk).azimuthstart = azimuthstart;
% [Best_Angle,Best_LocalPhVel,Misfitlist,min_angle,max_angle] = ...
%     GetArrivalAngle_MiniArraySingleStation_WERROR(lonlist,latlist,stalon,stalat,ttimes,searchaz,Epidist_deg)

ArrivalAngleList(ijk) = Best_Angle;
ArrivalAngle_LowBound(ijk) = min_angle;
ArrivalAngle_HighBound(ijk) = max_angle;

else
ArrivalAngleList(ijk) = NaN;
Best_LocalPhVelList(ijk) = NaN;
ArrivalAngle_LowBound(ijk) = NaN;
ArrivalAngle_HighBound(ijk) = NaN;
MisfitStruc(ijk).Misfitlist = NaN;
MisfitStruc(ijk).searchaz = NaN;
MisfitStruc(ijk).azimuthstart = NaN;

end

end




end