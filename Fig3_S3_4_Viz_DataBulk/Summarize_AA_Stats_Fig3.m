%% Make Figure 3
% This figure shows histograms of the arrival angles themselves and the
% uncertainties, at different periods

clear; clc; close all;
x =[-155.2736 -158.0152];


y =[ 19.5270 21.4226];

[HawaiiDist,Hawaiiaz]= distance(y(1),x(1),y(2),x(2))

Periodlist = [50 66.6667 80];
Pcounter=0;
for Period = Periodlist
Pcounter=Pcounter+1;
    currfolder = ['../RawData/' num2str(Period) 's/'];
    AngleFnameList = dir([currfolder '2*AAResid']);
MegaResid = [];
MegaUncRange=[];
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
Current_AA_UncRange = [Current_AA_Hi-Current_AA_Low];

MegaResid = [MegaResid; Current_AA_Resid];
MegaUncRange = [MegaUncRange; Current_AA_UncRange];

    end
MegaUncRange=MegaUncRange./2;
    figure(1)
    subplot(2,3,Pcounter)
    histogram(MegaResid,[-10:0.5:10])
    xlim([-10 10])
    set(gca,'fontsize',22,'fontweight','bold','linewidth',2)
    box on; 
    xlabel('Arrival Angle Deviation (degrees)')
    ylabel('N')
    title(['Period: ' num2str(Period) ' s'])
    text(2.8,80,['RMS = ' num2str(    round(sqrt(nanmean(MegaResid.^2)),2 )    ) '^\circ'],'fontsize',20,'fontweight','bold')

ylim([0 120])

        figure(1)
    subplot(2,3,3+Pcounter)
    histogram(MegaUncRange,[-5:0.25:5])
    xlim([0 5])
    set(gca,'fontsize',20,'fontweight','bold','linewidth',2)
    box on; 
    xlabel('Arrival Angle Uncertainty (degrees)')
    ylabel('N')
    title(['Period: ' num2str(Period) ' s'])
    text(3,100,['RMS = ' num2str(round(   sqrt(nanmean(MegaUncRange.^2)),2)     ) '^\circ'],'fontsize',20,'fontweight','bold')
    ylim([0 300])
end
set(gcf,'position',[1 87 1512 776])
saveas(gcf,'Fig3.png')