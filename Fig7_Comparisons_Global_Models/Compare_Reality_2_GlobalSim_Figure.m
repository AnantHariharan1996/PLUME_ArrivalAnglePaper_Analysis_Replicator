% Compare Arrival Angle Measurements
clear; clc; close all;
Period = 50;
CMTFLIST = dir('*CMTSOLUTION');
evcounter=0;
load coastlines
Mega_Obs = [];
Mega_GDM = [];
Mega_S362= [];
Mega_GLAD = [];
caxmeaquestion = [-6 6];

figh = figure(95);
ax = subplot_custom_make(figh,4,5,0.1,0.2,[0.1 0.9],[0.1 0.9]);
for evnum = 2:length(CMTFLIST)

currfname = CMTFLIST(evnum).name;

[ evt ] = Read_SpecFemCMTSOLFile(  currfname );
curr_ELAT = evt.lat;
curr_ELON = evt.lon;
ID = extractBefore(currfname,'_CMTSOLUTION');

% load the observations, the gdm52 predictions, the s362ani preds and the gladm25 preds
obsdir = dir([ID 'Slon_Slat_Stt_Evlon_Evlat_EvDep_*']);


OBSFNAME =obsdir(1).name;
GLADFNAME=['SPECFEM_Measurements_GLADM/' ID '_SLON_SLAT_ELON_ELAT_TTIME_PATHC_GDM52_' num2str(Period) 's_AA_Lo_Hi_Nm_AAResid'];
 GDMFNAME = ['GDM52TtimePredictions_GCRA/' ID '_SLON_SLAT_ELON_ELAT_TTIME_PATHC_GDM52_' num2str(Period) 's_AA_Lo_Hi_C_AAResid'];
 S362ANIFNAME = ['SPECFEM_Measurements_S362ANI/' ID '_SLON_SLAT_ELON_ELAT_TTIME_PATHC_GDM52_' num2str(Period) 's_AA_Lo_Hi_Nm_AAResid'];
% 


if exist(OBSFNAME) == 2 & exist(GLADFNAME) == 2 & exist(GDMFNAME) == 2 & exist(S362ANIFNAME) == 2 
evcounter=evcounter+1;
% Then we have prediction files from all approaches. 

ObsINFO = load(OBSFNAME);

Current_AA = ObsINFO(:,11);
Current_AA_abs = ObsINFO(:,7);

Current_AA_Low = ObsINFO(:,8)-Current_AA_abs;
Current_AA_Hi = ObsINFO(:,9)-Current_AA_abs;
Current_AA_C = ObsINFO(:,10);
Current_AA_Resid = ObsINFO(:,11);
Current_AA_ELAT= ObsINFO(:,5);
Current_AA_ELON= ObsINFO(:,4);
curr_ELON = Current_AA_ELON(1);
curr_ELAT = Current_AA_ELAT(1);
Current_AA_Slon = ObsINFO(:,1);
Current_AA_Slat = ObsINFO(:,2);


   % Get the arrows to indicate the event azimuth
   IntermediatePt = track2(curr_ELAT,curr_ELON,mean(Current_AA_Slat),mean(Current_AA_Slon),100);
IntermediatePts2Use = IntermediatePt(70,:);



GLADINFO = load(GLADFNAME);
GLADSLON = GLADINFO(:,1);
GLADSLAT = GLADINFO(:,2);
GLADAADEC = GLADINFO(:,11);

GDMINFO = load(GDMFNAME);
GDMSLON = GDMINFO(:,1);
GDMSLAT = GDMINFO(:,2);
GDMAADEC = GDMINFO(:,11);

S362ANIINFO = load(S362ANIFNAME);
S362ANISLON = S362ANIINFO(:,1);
S362ANISLAT = S362ANIINFO(:,2);
S362ANIAADEC = S362ANIINFO(:,11);

% Interpolate the three predictions onto the observation locations here. 

GDM_Interped = griddata(GDMSLON,GDMSLAT,GDMAADEC,Current_AA_Slon,Current_AA_Slat,'nearest');

GLAD_Interped = griddata(GLADSLON,GLADSLAT,GLADAADEC,Current_AA_Slon,Current_AA_Slat,'nearest');

S362ANI_Interped = griddata(S362ANISLON,S362ANISLAT,S362ANIAADEC,Current_AA_Slon,Current_AA_Slat,'nearest');

Mega_Obs = [Mega_Obs; Current_AA];
Mega_GDM = [Mega_GDM; GDM_Interped];
Mega_S362= [Mega_S362; S362ANI_Interped];
Mega_GLAD = [Mega_GLAD; GLAD_Interped];

curraxnum = (evcounter)+1
%subplot(5,4,(evcounter)*4+1)
scatter(ax(curraxnum),Current_AA_Slon,Current_AA_Slat,150,Current_AA,'filled','MarkerEdgeColor','k','linewidth',2)
clim(ax(curraxnum),caxmeaquestion)
colormap(ax(curraxnum),flipud(turbo))
hold(ax(curraxnum),'on')
quiver(ax(curraxnum),IntermediatePts2Use(2),IntermediatePts2Use(1),mean(Current_AA_Slon)-(IntermediatePts2Use(2)),mean(Current_AA_Slat)-IntermediatePts2Use(1),'linewidth',4,'MaxHeadSize',0.3,'Color',[0.1 0.3 0.8],'LineWidth',2)

%title(['Observations: ' ID])
box(ax(curraxnum),'on')
set(ax(curraxnum),'fontsize',15,'fontweight','bold','linewidth',2)

hold(ax(curraxnum),'on')
plot(ax(curraxnum),coastlon,coastlat,'LineWidth',2,'color',[0.5 0.5 0.5])
   ylim(ax(curraxnum),[14 26])
   xlim(ax(curraxnum),[-165 -150])

colormap(ax(curraxnum),flipud(turbo))


   if evcounter < 4
set(ax(curraxnum),'XTickLabels',{})
else
xticks(ax(curraxnum),[-162 -157 -152])
end

colormap(ax(curraxnum),flipud(turbo))


%subplot(5,4,(evcounter)*4+2)
curraxnum = (evcounter)+6
scatter(ax(curraxnum),Current_AA_Slon,Current_AA_Slat,150,GDM_Interped,'filled','MarkerEdgeColor','k','linewidth',2)
clim(ax(curraxnum),caxmeaquestion)
%title(['GDM52 Predictions: ' ID])
box(ax(curraxnum),'on')
set(ax(curraxnum),'YTickLabels',{})
set(ax(curraxnum),'fontsize',15,'fontweight','bold','linewidth',2)
hold(ax(curraxnum),'on')
plot(ax(curraxnum),coastlon,coastlat,'LineWidth',2,'color',[0.5 0.5 0.5])
colormap(ax(curraxnum),flipud(turbo))
hold(ax(curraxnum),'on')
quiver(ax(curraxnum),IntermediatePts2Use(2),IntermediatePts2Use(1),mean(Current_AA_Slon)-(IntermediatePts2Use(2)),mean(Current_AA_Slat)-IntermediatePts2Use(1),'linewidth',4,'MaxHeadSize',0.3,'Color',[0.1 0.3 0.8],'LineWidth',2)

   ylim(ax(curraxnum),[14 26])
   xlim(ax(curraxnum),[-165 -150])

   if evcounter < 4
set(ax(curraxnum),'XTickLabels',{})
else
xticks(ax(curraxnum),[-162 -157 -152])
end

colormap(ax(curraxnum),flipud(turbo))


curraxnum = (evcounter)+11

scatter(ax(curraxnum),Current_AA_Slon,Current_AA_Slat,150,S362ANI_Interped,'filled','MarkerEdgeColor','k','linewidth',2)
clim(ax(curraxnum),caxmeaquestion)
%title(['S362ANI Predictions: ' ID])
box(ax(curraxnum),'on')
set(ax(curraxnum),'YTickLabels',{})
set(ax(curraxnum),'fontsize',15,'fontweight','bold','linewidth',2)
hold(ax(curraxnum),'on')
plot(ax(curraxnum),coastlon,coastlat,'LineWidth',2,'color',[0.5 0.5 0.5])
   ylim(ax(curraxnum),[14 26])
   xlim(ax(curraxnum),[-165 -150])
colormap(ax(curraxnum),flipud(turbo))
hold(ax(curraxnum),'on')
quiver(ax(curraxnum),IntermediatePts2Use(2),IntermediatePts2Use(1),mean(Current_AA_Slon)-(IntermediatePts2Use(2)),mean(Current_AA_Slat)-IntermediatePts2Use(1),'linewidth',4,'MaxHeadSize',0.3,'Color',[0.1 0.3 0.8],'LineWidth',2)

   if evcounter < 4
set(ax(curraxnum),'XTickLabels',{})
else
xticks(ax(curraxnum),[-162 -157 -152])
end

colormap(ax(curraxnum),flipud(turbo))

%subplot(5,4,(evcounter)*4+4)
curraxnum = (evcounter)+16
scatter(ax(curraxnum),Current_AA_Slon,Current_AA_Slat,150,GLAD_Interped,'filled','linewidth',2,'MarkerEdgeColor','k')
clim(ax(curraxnum),caxmeaquestion)
colormap(ax(curraxnum),flipud(turbo))
%title(['GLADM25 Predictions: ' ID])

box(ax(curraxnum),'on'); 
set(ax(curraxnum),'fontsize',15,'fontweight','bold','linewidth',2)
set(ax(curraxnum),'YTickLabels',{})
hold(ax(curraxnum),'on')
plot(ax(curraxnum),coastlon,coastlat,'LineWidth',2,'color',[0.5 0.5 0.5])
colormap(ax(curraxnum),flipud(turbo))

   ylim(ax(curraxnum),[14 26])
   xlim(ax(curraxnum),[-165 -150])

text(ax(curraxnum),-149,14.15,ID,'fontsize',18,'rotation',90,'FontWeight','bold')
colormap(ax(curraxnum),flipud(turbo))
hold(ax(curraxnum),'on')
quiver(ax(curraxnum),IntermediatePts2Use(2),IntermediatePts2Use(1),mean(Current_AA_Slon)-(IntermediatePts2Use(2)),mean(Current_AA_Slat)-IntermediatePts2Use(1),'linewidth',4,'MaxHeadSize',0.3,'Color',[0.1 0.3 0.8],'LineWidth',2)

%%%% Draw Arrow. 







if evcounter < 4
set(ax(curraxnum),'XTickLabels',{})
else
xticks(ax(curraxnum),[-162 -157 -152])
end

end

end




axnum2use = 1;

h=histogram(ax(axnum2use),Mega_Obs,[-7:1:7]);
h.FaceColor = [0.2 0.4 0.7];
h.EdgeColor =  [0.3 0.3 0.3]
h.FaceAlpha = 0.8;
title(ax(axnum2use),{'\textbf{Real Data:}','\textbf{PLUME Observations}'},'fontsize',18,'fontweight','bold','interpreter','latex')
box(ax(axnum2use),'on')
set(ax(axnum2use),'linewidth',2,'FontWeight','bold','fontsize',15)
ylim(ax(axnum2use),[0 30])
%xlabel(ax(axnum2use),'Arrival Angle Deviation (deg)')

axnum2use = 6;

h=histogram(ax(axnum2use),Mega_GDM,[-7:1:7])
h.FaceColor = [0.2 0.4 0.7];
h.EdgeColor =  [0.3 0.3 0.3]
h.FaceAlpha = 0.8;
title(ax(axnum2use),{'\textbf{GDM52}','\textbf{Predictions}','$l < \sim 38$'},'fontsize',18,'fontweight','bold','interpreter','latex')
box(ax(axnum2use),'on')
set(ax(axnum2use),'linewidth',2,'FontWeight','bold','YTickLabels',{},'fontsize',15)
ylim(ax(axnum2use),[0 30])
%xlabel(ax(axnum2use),'Arrival Angle Deviation (deg)')

axnum2use = 11

h = histogram(ax(axnum2use),Mega_S362,[-7:1:7])
h.FaceColor = [0.2 0.4 0.7];
h.EdgeColor = [0.3 0.3 0.3]
h.FaceAlpha = 0.8;
title(ax(axnum2use),{'\textbf{S362ANI}','\textbf{Predictions}','$l < 19$'},'fontsize',18,'fontweight','bold','interpreter','latex')
box(ax(axnum2use),'on')
set(ax(axnum2use),'linewidth',2,'FontWeight','bold','YTickLabels',{},'fontsize',15)
ylim(ax(axnum2use),[0 30])
%xlabel(ax(axnum2use),'Arrival Angle Deviation (deg)')

axnum2use = 16;

h = histogram(ax(axnum2use),Mega_GLAD,[-7:1:7]);
h.FaceColor = [0.2 0.4 0.7];
h.EdgeColor =  [0.3 0.3 0.3]
h.FaceAlpha = 0.8;
title(ax(axnum2use),{'\textbf{GLADM25}','\textbf{Predictions}','Short-Wavelength Structure'},'fontsize',18,'fontweight','bold','interpreter','latex')
box(ax(axnum2use),'on')
set(ax(axnum2use),'linewidth',2,'FontWeight','bold','YTickLabels',{},'fontsize',15)
ylim(ax(axnum2use),[0 30])
%xlabel(ax(axnum2use),'Arrival Angle Deviation (deg)')

colormap(flipud(turbo))
set(figh,'Position',[1734 -97 858 976])

barbar=colorbar(ax(curraxnum),'Location','southoutside','position',[0.2141 0.05 0.60 0.02]);
ylabel(barbar,'Arrival Angle Deviation (degrees)','fontsize',20)

saveas(figh,'Comparison_ObsVsGlobalPredictions.png')
