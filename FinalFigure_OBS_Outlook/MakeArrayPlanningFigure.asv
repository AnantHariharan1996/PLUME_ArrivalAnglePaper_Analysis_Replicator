% Make Array Planning Figure
clear; clc; close all;
LoadFullCMTCATALOG

load coastlines
HOTSPOT_INFO = readtable('hotspots_table_formatted.txt');
NetworkList = {'YS','8Q','XE','7B','ZA','YL','Z6','ZU','2A','8A','3H'}
NetworkList = {'XE','7B','3H',}
NetworkList = {'XE','7B','8Q'}
NetworkList = {'YS','8Q','XE','7B','ZA','YL','Z6','ZU','2A','8A','3H'}
NetworkList = {'XE','7B','3H','YL'}


colors_fullmap = jet(length(NetworkList));



GMAPinfo = readtable('gmap-stations (5).txt');
Ref_Nets = GMAPinfo.Var1;
Ref_StaName = GMAPinfo.Var2;
Ref_StaLat = GMAPinfo.Var3;
Ref_StaLon = GMAPinfo.Var4;

Ref_StartTimes = GMAPinfo.Var7;
Ref_EndTimes = GMAPinfo.Var8;
TimeDiffs = Ref_EndTimes-Ref_StartTimes;

Ref_StartTimes_Datenumver = datenum(Ref_StartTimes)
Ref_EndTimes_Datenumver = datenum(Ref_EndTimes)

%%%%%


Hotspot2PlotLonList = [-138 -140 -92 -170];
Hotspot2PlotLatList = [-10 -30 0 -14]; 

EQs2UseLonList = [-177.82 -105.24 -74.77 -115.45];
EQs2UseLatList = [-20.02 -35.41 -15.88 -16.34]; 

for ijk = 1:length(NetworkList)
curr_net2show = NetworkList{ijk};
idx = find(strcmp(Ref_Nets,NetworkList{ijk}) == 1);
figure(1)
hold on
scatter(wrapTo360(Ref_StaLon(idx)),Ref_StaLat(idx),50,colors_fullmap(ijk,:),'^','filled','MarkerEdgeColor','k');
hold on
currcenter_x(ijk) = mean(Ref_StaLon(idx));
currcenter_y(ijk) = mean(Ref_StaLat(idx));

current_starttimes = Ref_StartTimes_Datenumver(idx);
current_endtimes = Ref_EndTimes_Datenumver(idx);


min_starttime = min(current_starttimes);
max_endttime = max(current_endtimes);


dist_2_hotspots = distance(currcenter_y(ijk),currcenter_x(ijk),HOTSPOT_INFO.LAT,HOTSPOT_INFO.LON);

tempdx = find(dist_2_hotspots < 30);

for hotspotdx = tempdx'

[pathlat,pathlon] = track2(currcenter_y(ijk),currcenter_x(ijk),HOTSPOT_INFO.LAT(hotspotdx),HOTSPOT_INFO.LON(hotspotdx));
hold on
plot(wrapTo360(pathlon),pathlat,'linewidth',2,'LineStyle','--','Color','k')


[dist_2_hotspot,az2hotspot] = distance(HOTSPOT_INFO.LAT(hotspotdx),HOTSPOT_INFO.LON(hotspotdx),CMT_latlist,CMT_lonlist);
[dist_2_net,az2net] = distance(currcenter_y(ijk),currcenter_x(ijk),CMT_latlist,CMT_lonlist);
[dist_hotpost2_net,azhotspot2net] = distance(currcenter_y(ijk),currcenter_x(ijk),HOTSPOT_INFO.LAT(hotspotdx),HOTSPOT_INFO.LON(hotspotdx));

if ijk == 1
    current_quakedx = find(CMT_dnlist > min_starttime & CMT_dnlist < max_endttime & maglist > 5 & dist_2_hotspot < 50 );
else
current_quakedx = find(CMT_dnlist > min_starttime & CMT_dnlist < max_endttime & maglist > 5 & dist_2_hotspot < 50);
end
scatter(wrapTo360(CMT_lonlist(current_quakedx)),CMT_latlist(current_quakedx),150,colors_fullmap(ijk,:),'o','filled','MarkerEdgeColor','k');


for localnum = 1:length(current_quakedx)
current_CMTlat = CMT_latlist(current_quakedx(localnum));
current_CMTlon = CMT_lonlist(current_quakedx(localnum));
[az] = azimuth(HOTSPOT_INFO.LAT(hotspotdx),HOTSPOT_INFO.LON(hotspotdx),current_CMTlat,current_CMTlon);

[lat2,lon2] = reckon(HOTSPOT_INFO.LAT(hotspotdx),HOTSPOT_INFO.LON(hotspotdx),8,az);
plot(wrapTo360([HOTSPOT_INFO.LON(hotspotdx) lon2]),[HOTSPOT_INFO.LAT(hotspotdx) lat2],'linewidth',1,'Color',colors_fullmap(ijk,:))
end


end


figure(987)

subplot(2,2,ijk)

scatter((Ref_StaLon(idx)),Ref_StaLat(idx),50,colors_fullmap(ijk,:),'^','filled','MarkerEdgeColor','k');
hold on
%scatter(HOTSPOT_INFO.LON(tempdx),HOTSPOT_INFO.LAT(tempdx),500,'filled')
scatter(Hotspot2PlotLonList(ijk),Hotspot2PlotLatList(ijk),200,[1 0 0],'filled')
scatter(CMT_lonlist(current_quakedx),CMT_latlist(current_quakedx),200,'pentagram','filled')
title([curr_net2show ' Array'])
plot(coastlon,coastlat,'LineWidth',2,'color','k')
disp('lons')
HOTSPOT_INFO.LON(tempdx)
disp('lats')

HOTSPOT_INFO.LAT(tempdx)

scatter(EQs2UseLonList(ijk),EQs2UseLatList(ijk),500,'filled','pentagram')



% Run the forward model. Do the predictions. 






end


figure(1)
load coastlines
%plot(wrapTo360(coastlon),coastlat,'LineWidth',2,'Color','k')
scatter(wrapTo360(HOTSPOT_INFO.LON),HOTSPOT_INFO.LAT,250,[1 0 0],'linewidth',3)
title('Usable Event-Diffractor-Array Geometries')
set(gcf,'position',[174 21 747 772])
colormap(gray)
barbar=colorbar;
ylabel(barbar,'Elevation (m)')

saveas(gcf,'ArrayPlanning.png')
