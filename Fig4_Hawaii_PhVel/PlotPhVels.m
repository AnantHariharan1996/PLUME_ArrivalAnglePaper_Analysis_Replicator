%% Make Figure 3
% This figure shows histograms of the arrival angles themselves and the
% uncertainties, at different periods

clear; clc; close all;
x =[-155.2736 -158.0152];
addpath(genpath(pwd))

y =[ 19.5270 21.4226];

[HawaiiDist,Hawaiiaz]= distance(y(1),x(1),y(2),x(2))

Periodlist = [50 66.6667 ];
Pcounter=0;
for Period = Periodlist
Pcounter=Pcounter+1;
    currfolder = ['../RawData/' num2str(Period) 's/'];
    AngleFnameList = dir([currfolder '2*AAResid']);
MegaSlon= [];
MegaC = [];
MegaSlat = [];
    for evnum = 1:length(AngleFnameList)
            currfname = [currfolder AngleFnameList(evnum).name];
            Info = load(currfname)

            Current_AA = Info(:,7);
            Current_AA_Low = Info(:,8);
            Current_AA_Hi = Info(:,9);
            Current_AA_C = Info(:,10);
            Current_AA_Resid = Info(:,11);

            Current_AA_Slon = Info(:,1);
           Current_AA_Slat = Info(:,2);


           MegaSlon= [MegaSlon; Current_AA_Slon];
MegaC = [MegaC; Current_AA_C];
MegaSlat = [MegaSlat; Current_AA_Slat];


    end

zzz(:,1) = MegaSlon;
zzz(:,2) = MegaSlat;
[uniquevals,uniquedx] = unique(zzz,'rows');

UniqueSLONS = MegaSlon(uniquedx);
UniqueSLATS = MegaSlat(uniquedx);
meanclist = [];
medianclist=[];
for stanum = 1:length(UniqueSLONS)

currslon = UniqueSLONS(stanum);
currslat = UniqueSLATS(stanum);
idx = find(MegaSlon ==currslon &  MegaSlat ==  currslat);
currc = MegaC(idx);
meanclist(stanum) = nanmean(currc);
medianclist(stanum) = nanmedian(currc);

end


load coastlines
     figure(1)
     subplot(1,2,Pcounter)
     plot(coastlon,coastlat,'linewidth',2)
     hold on
       scatter(UniqueSLONS,UniqueSLATS,200,medianclist,'filled','MarkerEdgeColor','k','linewidth',2)


 cptcmap('roma.cpt','ncol',20)
       
barbar=colorbar;
ylabel(barbar,'Phase Velocity (km/s)')
     xlim([-164 -148])
     ylim([13 27])
          plot(coastlon,coastlat,'linewidth',2,'color','k')
box on
     set(gca,'fontsize',20,'fontweight','bold','linewidth',2)
%     histogram(MegaResid,[-10:0.5:10])
%     xlim([-10 10])
%     set(gca,'fontsize',16,'fontweight','bold','linewidth',2)
%     box on; 
%     xlabel('Arrival Angle Deviation (degrees)')
%     ylabel('N')
    title(['Period: ' num2str(Period) ' s'])
%     text(3.5,80,['RMS = ' num2str(    round(sqrt(nanmean(MegaResid.^2)),2 )    ) '^\circ'],'fontsize',18,'fontweight','bold')
% 
% ylim([0 120])

clear zzz

% WriteOut

WriteOut(:,1) = UniqueSLONS;
WriteOut(:,2) = UniqueSLATS;
WriteOut(:,3) = medianclist;
dlmwrite(['SuppData_LocalPhVels/Period_' num2str(Period) 's_Lon_Lat_LocalPhVel'],WriteOut,'precision','%.7f','delimiter','\t')

clear WriteOut

caxis([3.9 4.15])
axis square

end
title('Period: \approx 67 s')
caxis([3.9 4.15])
axis square

 set(gcf,'position',[1513 387 1671 359])
 saveas(gcf,'Fig4_HawaiiPhVel.png')