%% Make Figure 3
% This figure shows histograms of the arrival angles themselves and the
% uncertainties, at different periods

clear; clc; close all;
    addpath(genpath(pwd))

Periodlist = [50 66.6667 80];
Pcounter=0;
PLUMESTNS = readtable('PLUMESTNS.txt');
PLUMESTNS_LONG = PLUMESTNS.Longitude;
PLUMESTNS_LAT =  PLUMESTNS.Latitude;


for Period = Periodlist
Pcounter=Pcounter+1;
    currfolder = ['../RawData/' num2str(Period) 's/'];
    AngleFnameList = dir([currfolder '2*AAResid']);
MegaResid = [];
MegaUncRange=[];
MegaElat =[];
MegaElon  = [];
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
            Evlats  = Info(:,5);

            Evlons  = Info(:,4);

MegaElat= [MegaElat; Evlats];
MegaElon = [MegaElon; Evlons];
MegaResid = [MegaResid; Current_AA_Resid];
MegaUncRange = [MegaUncRange; Current_AA_UncRange];

    end
load coastlines
    figure(1)
    subplot(3,1,Pcounter)



ax = worldmap('World');
setm(ax, 'Origin', [0 180 0])
load coastlines
hold on
ridge=loadjson('ridge.json');
ridge_info = ridge{2};
plotm(coastlat,coastlon,'k','LineWidth',2,'color',[0 0 0])
plotm(ridge_info(:,2),ridge_info(:,1),'k','LineWidth',2,'color',[0.5  0.5 0.5  ])
trench=loadjson('trench.json');
trench_info = trench{2};
plotm(trench_info(:,2),trench_info(:,1),'k','LineWidth',2,'color',[0.5  0.5 0.5])
transform=loadjson('transform.json');
transform_info = transform{2};
plotm(transform_info(:,2),transform_info(:,1),'k','LineWidth',2,'color',[0.5  0.5 0.5])
set(gca,'fontsize',14)
setm(gca,'grid','off')
setm(gca,'meridianlabel','off')
setm(gca,'parallellabel','off')

          scatterm((MegaElat),MegaElon,200,'pentagram','filled','markeredgecolor','k')

hold on


scatterm(PLUMESTNS_LAT,PLUMESTNS_LONG,15,[1 0 0],'^','filled')
box on

set(gca,'fontsize',18,'fontweight','bold','linewidth',2,'XTickLabel',{},'YTickLabel',{})



title([num2str(Period) ' s; N_{EQs} = ' num2str(length(AngleFnameList))],'fontsize',18,'fontweight','bold')

    
end

set(gcf,'position', [1606 -74 752 953])
saveas(gcf,'FigS3_EvLoc.png')