%% Make subplots showing 6 subplots, each of which has a different example
% of raw data

clear; clc; close all;

clear; clc; close all;
scattererlat=20
scattererlon=-157
Period = 50;
DatFolder =     '/Users/ananthariharan/Documents/GitHub/PLUME_ArrivalAnglePaper_Analysis_Replicator/RawData/';
PeriodDatFolder =[DatFolder num2str(Period) 's/'];
flist = dir([PeriodDatFolder '*Slon_Slat_Stt_Evlon_Evlat_EvDep_EVID_*_AA_Lo_Hi_C_AAResid']);

for fnum = 1:length(flist)

    fname = [PeriodDatFolder flist(fnum).name];
    Info = load(fname,'-ascii');
    

    NewEv1ID = extractBetween(fname,'50s/','Slon_Slat_Stt')
    NewEv1ID=NewEv1ID{1}





    Current_AA = Info(:,11);
        Current_AA_abs = Info(:,7);

    Current_AA_Low = Info(:,8)-Current_AA_abs;
    Current_AA_Hi = Info(:,9)-Current_AA_abs;
    Current_AA_C = Info(:,10);
    Current_AA_Resid = Info(:,11);
    Current_AA_ELAT= Info(:,5);
    Current_AA_ELON= Info(:,4);
    curr_ELON = Current_AA_ELON(1);
    curr_ELAT = Current_AA_ELAT(1);
    Current_AA_Slon = Info(:,1);
    Current_AA_Slat = Info(:,2);

load coastlines
    figure(1)
    subplot(6,7,fnum)
    scatter(Current_AA_Slon,Current_AA_Slat,200,Current_AA,'filled','MarkerEdgeColor','k','LineWidth',2)
hold on; box on;
   % barbar=colorbar;
   % ylabel(barbar,'Arrival Angle Deviation (deg)')
   plot(coastlon,coastlat,'linewidth',2)
   colormap(flipud(turbo))
   caxis([-5 5])
   ylim([14 26])
   xlim([-165 -150])
   set(gca,'fontsize',20,'linewidth',2,'fontweight','bold')
   title(NewEv1ID)



   % Get the arrows to indicate the event azimuth
   IntermediatePt = track2(curr_ELAT,curr_ELON,mean(Current_AA_Slat),mean(Current_AA_Slon),100);
IntermediatePts2Use = IntermediatePt(70,:);

quiver(IntermediatePts2Use(2),IntermediatePts2Use(1),mean(Current_AA_Slon)-(IntermediatePts2Use(2)),mean(Current_AA_Slat)-IntermediatePts2Use(1),'linewidth',4,'MaxHeadSize',0.2,'color','blue')



end