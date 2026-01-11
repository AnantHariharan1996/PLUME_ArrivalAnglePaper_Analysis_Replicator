% Make Fig S2

clear; clc; close all
load coastlines
TTfname = ['1363150s_slon_slat_stt'];
TT_info = load(TTfname);
EvtFile='200702251500_CMTSOLUTION';
 [ evt ,EVID] = Read_SpecFemCMTSOLFile( EvtFile )

TTLon = TT_info(:,1);
TTLat = TT_info(:,2);
TTtt = TT_info(:,3);


% Plot the tts
%ttdx = find(slon < -150 & slon > -156 & slat > 15 & slat < 20);
ttdx = find(TTLon < -156 & TTLon > -159 & TTLat > 15.5 & TTLat < 18);

tts2plt = TTtt(ttdx);
slons2plt = TTLon(ttdx);
slats2plt = TTLat(ttdx);

elat=evt.lat
elon=evt.lon
[alen,azwwedssd]=distance(elat,elon,slats2plt(3),slons2plt(3))
searchaz = [azwwedssd-100:0.1:azwwedssd+60];
[Best_Angle,Best_LocalPhVel,Misfitlist,min_angle,max_angle] = ...
    GetArrivalAngle_MiniArraySingleStation_WERROR(slons2plt,slats2plt,slons2plt(3),slats2plt(3),tts2plt,searchaz,alen)
[minval,mindx] = min(Misfitlist)
searchaz(mindx)

% Get error bars. right through!
 M= length(tts2plt);
N = 1; % 2 model parameters; phase velocity & arr. angle, right?
InputMinMis = minval;
ConfLevel = 90;
 [misfit_threshold_90] = GetMisfitThreshold_FunctionVer(M,N,InputMinMis,ConfLevel)

ConfLevel = 95;
 [misfit_threshold_95] = GetMisfitThreshold_FunctionVer(M,N,InputMinMis,ConfLevel)

 ConfLevel = 99;
 [misfit_threshold_99] = GetMisfitThreshold_FunctionVer(M,N,InputMinMis,ConfLevel)


 L_Tol = 3;

 [ArrivalAngleList,Best_LocalPhVelList,ArrivalAngle_LowBound,ArrivalAngle_HighBound,MisfitStruc] = ...
    GetArrivalAngles_Event_MiniArray(TTLon,TTLat,TTtt,L_Tol,elat,elon,3)



 figure(43)

 ax1=subplot(2,2,1);

plot(coastlon,coastlat,'linewidth',2,'Color','k')
hold on
scatter(TTLon,TTLat,300,TTtt,'filled','LineWidth', 2,'MarkerEdgeColor','k')
xlim([-163 -148])
ylim([14 26])
scatter(slons2plt,slats2plt,400,tts2plt,'filled','LineWidth', 4,'MarkerEdgeColor','r')
scatter(slons2plt(3),slats2plt(3),1000,[0 0 0],'+','LineWidth', 4)
text(-162,15,'a)','fontsize',24,'fontweight','bold')


for junk = 1:length(slons2plt)

plot([slons2plt(3) slons2plt(junk)],[slats2plt(3) slats2plt(junk)],'Color','k','linewidth',2)

end



box on
set(gca,'fontsize',18,'fontweight','bold','linewidth',2)
barbar=colorbar;
ylabel(barbar,'Traveltime (s)')
colormap(flipud(parula))
title({'50 s Rayleigh wave Observations:',['Event ' EVID]})

 subplot(2,2,2)

plot(searchaz,Misfitlist,'linewidth',3)
hold on
plot([searchaz(mindx)-30 searchaz(mindx)+30],[InputMinMis InputMinMis],'linewidth',2,'linestyle','--')
plot([searchaz(mindx)-30 searchaz(mindx)+30],[misfit_threshold_90 misfit_threshold_90],'linewidth',2,'linestyle','--')
plot([searchaz(mindx)-30 searchaz(mindx)+30],[misfit_threshold_95 misfit_threshold_95],'linewidth',2,'linestyle','--')
plot([searchaz(mindx)-30 searchaz(mindx)+30],[misfit_threshold_99 misfit_threshold_99],'linewidth',2,'linestyle','--')
legend('Grid Search for Arrival Angle','Minimum Misfit','90% confidence Level','95% confidence Level','99% confidence Level','location','northwest')
xlabel('Arrival Angle (degrees)')
ylabel('L2 Misfit')
box on
set(gca,'fontsize',18,'linewidth',2,'fontweight','bold')
ylim([0 30])
title(['Best-Fitting Arrival Angle: ' num2str(Best_Angle) '^\circ'])
xlim([searchaz(mindx)-20 searchaz(mindx)+20])


[distlist,arrangle] = distance(TTLat,TTLon,evt.lat,evt.lon);
arrangle = arrangle+180;
xlim([250.0954 254.9185])
ylim([0.0579 0.7290])

text(254.5,0.55,'b)','fontsize',24,'fontweight','bold')


  ax3=subplot(2,2,3);

plot(coastlon,coastlat,'linewidth',2,'Color','k')

hold on
hold on
scatter(TTLon,TTLat,300,ArrivalAngleList,'filled','LineWidth', 2,'MarkerEdgeColor','k')
xlim([-163 -148])
ylim([14 26])


xlim([-163 -148])
ylim([14 26])

box on
set(gca,'fontsize',18,'fontweight','bold','linewidth',2)
barbar=colorbar;
ylabel(barbar,'Arrival Angle (degrees)')
colormap(ax3,flipud(turbo))
scatter(slons2plt(3),slats2plt(3),1000,[0 0 0],'+','LineWidth', 4)
text(-162,15,'c)','fontsize',24,'fontweight','bold')

  ax4=subplot(2,2,4);

plot(coastlon,coastlat,'linewidth',2,'Color','k')

hold on
hold on
scatter(TTLon,TTLat,300,ArrivalAngleList-arrangle','filled','LineWidth', 2,'MarkerEdgeColor','k')
xlim([-163 -148])
ylim([14 26])


xlim([-163 -148])
ylim([14 26])
caxis([-5 5]);

box on
set(gca,'fontsize',18,'fontweight','bold','linewidth',2)
barbar=colorbar;
ylabel(barbar,'Arrival Angle Deviation (degrees)')
colormap(ax4,(turbo))


scatter(slons2plt(3),slats2plt(3),1000,[0 0 0],'+','LineWidth', 4)
text(-162,15,'d)','fontsize',24,'fontweight','bold')
set(gcf,'Position', [45 17 1090 783])
saveas(gcf,'FigS2_MeasurementExample.png')