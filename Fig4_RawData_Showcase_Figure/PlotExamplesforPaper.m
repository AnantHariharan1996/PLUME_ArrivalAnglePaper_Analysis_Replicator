%% Make subplots showing 6 subplots, each of which has a different example
% of raw data

clear; clc; close all;

clear; clc; close all;
countmeup=0;
scattererlat=20
scattererlon=-157
Period = 50;
DatFolder =     '/Users/ananthariharan/Documents/GitHub/PLUME_ArrivalAnglePaper_Analysis_Replicator/RawData/';
PeriodDatFolder =[DatFolder num2str(Period) 's/'];
flist = dir([PeriodDatFolder '*Slon_Slat_Stt_Evlon_Evlat_EvDep_EVID_*_AA_Lo_Hi_C_AAResid']);

EVID2SHOWLIST = {'200702251500','200703130259','200605221112','200607082040','200610131347','200509090726'};
for fnum = 1:length(flist)

    fname = [PeriodDatFolder flist(fnum).name];
    Info = load(fname,'-ascii');
    

    NewEv1ID = extractBetween(fname,'50s/','Slon_Slat_Stt')
    NewEv1ID=NewEv1ID{1}


checkers =  strcmp(NewEv1ID,EVID2SHOWLIST);
if max(checkers) == 1
countmeup = countmeup+1;
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
    if countmeup < 4
    subplot(2,4,countmeup)
    else
            subplot(2,4,countmeup+1)

    end
    scatter(Current_AA_Slon,Current_AA_Slat,200,Current_AA,'filled','MarkerEdgeColor','k','LineWidth',2,'MarkerFaceAlpha',0.8)
hold on; box on;
  
   plot(coastlon,coastlat,'linewidth',2,'color',[0.5 0.5 0.5])
   colormap(flipud(turbo))
   caxis([-4.5 4.5])
   ylim([14 26])
   xlim([-165 -150])
   set(gca,'XTick',-165:5:-150,'YTick',15:5:25)

   set(gca,'fontsize',20,'linewidth',2,'fontweight','bold')
   NewEv1IDStr = ['Event: ' NewEv1ID(1:4) '-' NewEv1ID(5:6) '-' NewEv1ID(7:8) '-' NewEv1ID(9:10)];
   title(NewEv1IDStr)



   % Get the arrows to indicate the event azimuth
   IntermediatePt = track2(curr_ELAT,curr_ELON,mean(Current_AA_Slat),mean(Current_AA_Slon),100);
IntermediatePts2Use = IntermediatePt(70,:);

quiver(IntermediatePts2Use(2),IntermediatePts2Use(1),mean(Current_AA_Slon)-(IntermediatePts2Use(2)),mean(Current_AA_Slat)-IntermediatePts2Use(1),'linewidth',4,'MaxHeadSize',0.2,'Color',[0.1 0.3 0.8],'LineWidth',2)

else


end


    if countmeup == 1

set(gca,'XTickLabel',{})
    elseif countmeup == 2
                set(gca,'XTickLabel',{},'YTickLabel',{})

    elseif countmeup == 3
        set(gca,'XTickLabel',{},'YTickLabel',{})
    elseif countmeup == 4

            elseif countmeup == 5
                        set(gca,'YTickLabel',{})

            elseif countmeup == 6
        set(gca,'YTickLabel',{})


    end

    axis square
    end



% Now add a colorbar
subplot(2,4,[4 8])
barbar=colorbar('location','west');
ylabel(barbar,'Arrival Angle deviation (degree)')
   colormap(flipud(turbo))
caxis([-5 5])
set(gca,'fontsize',18,'fontweight','bold')
axis off
set(gcf,'position',[-81 125 1203 540])
saveas(gcf,'RawDataExampleFigure.png')