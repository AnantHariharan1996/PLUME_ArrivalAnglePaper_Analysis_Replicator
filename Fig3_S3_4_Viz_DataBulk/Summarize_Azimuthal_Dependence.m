%% Make Figure 3
% This figure shows histograms of the arrival angles themselves and the
% uncertainties, at different periods

clear; clc; close all;

clear; clc; close all;

x =[-155.0320
 -159.5096]


y =[ 19.6546
   21.7599]

[HawaiiDist,Hawaiiaz]= distance(y(1),x(1),y(2),x(2));



Periodlist = [50 66.6667 80];
Pcounter=0;
binvec = [0:10:360];
for Period = Periodlist
Pcounter=Pcounter+1;
    currfolder = ['../RawData/' num2str(Period) 's/'];
    AngleFnameList = dir([currfolder '2*AAResid']);
MegaResid = [];
MegaUncRange=[];
MegAz = [];
    for evnum = 1:length(AngleFnameList)
            currfname = [currfolder AngleFnameList(evnum).name];
            Info = load(currfname)

            Current_AA = Info(:,7);
            Current_AA_Low = Info(:,8);
            Current_AA_Hi = Info(:,9);
          %  Current_AA_C = Info(:,10);
            Current_AA_Resid = Info(:,11);

            Current_AA_Slon = Info(:,1);
           Current_AA_Slat = Info(:,2);
            Current_AA_Elon = Info(:,4);
           Current_AA_Elat = Info(:,5);

           [alen,az] = distance(Current_AA_Slat,Current_AA_Slon,Current_AA_Elat,Current_AA_Elon);
           MegAz=[MegAz; az]
Current_AA_UncRange = [Current_AA_Hi-Current_AA_Low];

MegaResid = [MegaResid; Current_AA_Resid];
MegaUncRange = [MegaUncRange; Current_AA_UncRange];



    end
MegaUncRange=MegaUncRange./2;
    figure(1)
subplot(1,3,Pcounter)
    [ Binned_Vector_Median,Binned_Vector_UpperQ,Binned_Vector_LowerQ,lenlist,Binned_Vector_Mean ] = ...
    Bin_Dataset(MegAz,MegaResid,binvec,20 )


     scatter(MegAz,MegaResid,25,[1 0 0],'filled','MarkerEdgeColor','k')
hold on
plot(binvec,Binned_Vector_Median,'linewidth',2,'color','k')
hold on
plot(binvec,Binned_Vector_UpperQ,'linewidth',2,'linestyle','--','color','m')
plot(binvec,Binned_Vector_LowerQ,'linewidth',2,'linestyle','--','color','b')
ylim([-6 6])
xlabel('Azimuth (degrees)')
if Pcounter == 1
ylabel('Arrival Angle (deg)')
end
title([num2str(Period)  ' s'],'fontsize',18,'fontweight','bold')
box on
set(gca,'fontsize',22,'fontweight','bold','linewidth',2)
xlim([0 360])
plot([Hawaiiaz Hawaiiaz],[-6 6],'linewidth',20,'Color',[1 1 0 0.5])
end
legend('Raw Data','Binned Median','Upper Quartile','Lower Quartile','Archipelago Azimuth','location','southwest')

set(gcf,'position',[1457 444 1976 435])
saveas(gcf,'Fig4_AzDep.png')