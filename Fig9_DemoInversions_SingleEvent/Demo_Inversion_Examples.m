%% DemoInversions_SingleEvent

clear; clc; close all;
load coastlines
addpath(genpath(pwd))
Cmap2Use= '/Users/ananthariharan/Documents/GitHub/ArrivalAngle_Hawaii_Imaging/UsefulFunctions/lajolla.cpt';  

% What is the purpose of this script? To demonstrate successful inversions
% at a site. Layout of output Figure:
% 1 Plot: Best-Fitting Model as semiopaque surface; observations overlain on
% best-fitting predictions. 2 Plot: Misfit surface as a function of
% position. 3 Plot: Histogram of best-fitting time values. 4 Plot Histogram
% of best-fitting widths. 
Period=50;
[phvel]=prem_dispersion(1/Period);cglb = phvel;


RawDataFolder =     '/Users/ananthariharan/Documents/GitHub/PLUME_ArrivalAnglePaper_Analysis_Replicator/RawData/';
  RawDataFolderatPeriod = [RawDataFolder  num2str(Period) 's/'];
MisfitSurfaceFolder = ['/Users/ananthariharan/Documents/GitHub/PLUME_ArrivalAnglePaper_Analysis_Replicator/SummaryMisfitStore/'];
MisfitSurfaceFname = [MisfitSurfaceFolder 'MisfitSurfaces_' num2str(Period) 's'];
% Do this for, maybe 2 or 3 different observations. 
figure(43110)
tiledlayout(3,3,"TileSpacing","compact")
% nexttile
% scatter(1,1)
run('../ParameterSetup.m')
addpath(genpath('../Helper_Functions/'))
OBSIDs =[200605221112 200702251500 200610131347];
load(MisfitSurfaceFname)




for evnum = 1:length(OBSIDs)

    currID = OBSIDs(evnum);
    currIDstr = num2str(currID);
    
    currentid_flist = dir([RawDataFolderatPeriod currIDstr '*Resid'])
    
    if length(currentid_flist) ~= 1
    error('Did not match the observation file sucesfully! Check file directory.')
    end
    
    current_full_fname = [RawDataFolderatPeriod currentid_flist(1).name];
    % Load RawDatInfo 
Info = load(current_full_fname,'-ascii');
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



    % Get EVID
    EVID = extractBetween(currentid_flist(1).name,'EVID_','_AA_Lo_Hi');
    EVID=EVID{1};
    
    
    EVIDList_MisfitSurface = MisfitSurfaceSummary.EVIDLIST;
    
    logical_indices = strcmp(EVIDList_MisfitSurface, EVID);
    DX2Query = find(logical_indices == 1);
    
    if length(DX2Query) ~= 1
    error('Did not match the observation file sucesfully! Check file directory.')
    end

    Current_Misfit_Manifold_L2_Wt = MisfitSurfaceSummary.StoreAllMisfits_L2_Weighted(:,DX2Query);
    Current_Misfit_Manifold_L1_Wt = MisfitSurfaceSummary.StoreAllMisfits_L1_Weighted(:,DX2Query);
    Current_Misfit_Manifold_L2_SUM = MisfitSurfaceSummary.StoreAllMisfits_L2_SUM(:,DX2Query);
    Current_Misfit_Manifold_L1 = MisfitSurfaceSummary.StoreAllMisfits_L1(:,DX2Query);
    Current_Misfit_Manifold_L2 = MisfitSurfaceSummary.StoreAllMisfits_L2(:,DX2Query);
    Current_VR_Wt = MisfitSurfaceSummary.StoreAllVarReduc_Wt(:,DX2Query);
    Current_VR = MisfitSurfaceSummary.StoreAllVarReduc(:,DX2Query);

    
   Surf2Plt = Current_Misfit_Manifold_L1;
   [minval,mindx] = min(Surf2Plt);


    Lonstore = Ngrid_X;
Latstore=  Ngrid_Y;
Widthstore= Ngrid_L;
 Taustore= Ngrid_Tau;

     % get the model params corresponding to this misfit 
    BestLon = Lonstore(mindx) 
    BestLat = Latstore(mindx)
    BestWidth = Widthstore(mindx); BestTau = Taustore(mindx);
    

    VaryingWidth_Indices = find(Lonstore == BestLon & ...
        Taustore == BestTau & Latstore == BestLat);
    VaryingWidths_BestSection = Widthstore(VaryingWidth_Indices);


    VaryingTau_Indices =  find(Lonstore == BestLon & ...
        Widthstore == BestWidth & Latstore == BestLat);
    VaryingTaus_BestSection = Taustore(VaryingTau_Indices);


        % Get the 'surfaces' corresponding to this misfit
    VaryingLonLat_Indices = find(Widthstore == BestWidth & ...
        Taustore == BestTau);
    VaryingLons_BestSection = Lonstore(VaryingLonLat_Indices);
    VaryingLats_BestSection = Latstore(VaryingLonLat_Indices);
    MisfitVaryingPos= Surf2Plt(VaryingLonLat_Indices);
     MisfitVaryingTaus = Surf2Plt(VaryingTau_Indices);
     MisfitVaryingWidths = Surf2Plt(VaryingWidth_Indices);



 X_GridForGeogMisfitSurface = [min(Lonstore)-0.5:0.2:max(Lonstore)+0.5];
Y_GridForGeogMisfitSurface = [min(Latstore)-0.5:0.2:max(Latstore)+0.5];
[XXGRD,YYGRD] = meshgrid(X_GridForGeogMisfitSurface,Y_GridForGeogMisfitSurface);
MisfitVaryingPos_gridded = griddata(VaryingLons_BestSection,VaryingLats_BestSection,MisfitVaryingPos,XXGRD,YYGRD);

% Generate predictions for a good model. 

PrefLon = -157;
PrefLat = 20.5;
PrefWidth = 450;
PrefTau = 5; 

BestWidthList(evnum) = BestWidth;
BestTauList(evnum) = BestTau;

%%%% Plot the diffractors @ scattererlon,scattererlat
    [sourcelen,sourceaz] = distance(PrefLat,PrefLon,curr_ELAT,curr_ELON);
perpaz = sourceaz+90;

     [scatlatend,scatlonend] = reckon(PrefLat,PrefLon,km2deg(PrefWidth),perpaz);
     [scatlatstart,scatlonstart] = reckon(PrefLat,PrefLon,km2deg(PrefWidth),perpaz+180);


% Run the forward model

xlist = [-167:spacing:-147];
ylist = [13:spacing:27];
[Ref_XGrid,Ref_YGrid] = meshgrid(xlist,ylist);

 [delta2,xgrid,ygrid,ttime_field_perturbed,tau,ttime_field_noscatter,angle,angle_nodiff] ...
    = Spedup_Get_Arrival_Angle_Residual_GaussianBeam(Period,curr_ELAT,curr_ELON,...
    PrefLat,PrefLon,PrefTau,PrefWidth,Ref_YGrid(:),Ref_XGrid(:),cglb,spacing);

 interped_delta = griddata(xgrid,ygrid,delta2,Ref_XGrid,Ref_YGrid);
 

%%%%%%% PLOTTING BELOW HERE
axlist(3*(evnum-1)+1) = nexttile;

contourf(axlist(3*(evnum-1)+1),Ref_XGrid,Ref_YGrid,interped_delta,[-25:0.2:25],'EdgeColor','none',FaceAlpha=0.5)

hold on
scatter(axlist(3*(evnum-1)+1),Current_AA_Slon,Current_AA_Slat,150,Current_AA,'filled','LineWidth',2,'MarkerEdgeColor','k')

plot(axlist(3*(evnum-1)+1),[scatlonstart scatlonend],[scatlatstart scatlatend],'linewidth',6,'Color','c','MarkerEdgeColor','k')
scatter(axlist(3*(evnum-1)+1) ,PrefLon,PrefLat,200,[1 0 1],'pentagram','filled','MarkerEdgeColor','k','linewidth',2)


IntermediatePt = track2(curr_ELAT,curr_ELON,PrefLat,PrefLon,100);
IntermediatePts2Use = IntermediatePt(70,:);

quiver(axlist(3*(evnum-1)+1) ,IntermediatePts2Use(2),IntermediatePts2Use(1),PrefLon-(IntermediatePts2Use(2)),PrefLat-IntermediatePts2Use(1),'linewidth',4,'MaxHeadSize',0.2,'color','blue')

plot(axlist(3*(evnum-1)+1) ,coastlon,coastlat,'color',[0.5 0.5 0.5],'LineWidth',2)



colormap(axlist(3*(evnum-1)+1) ,flipud(turbo))
caxis([-5   5])
plot(coastlon,coastlat,'linewidth',2,'Color','k')
box on
set(gca,'FontSize',18,'FontWeight','bold','LineWidth',2)
   ylim([14 26])
   xlim([-165 -150])
   xticks([-162 -157 -152])
yticks([15:2:25])
axis square

if evnum==3
barbar=colorbar;
barbar.Location = 'southoutside';
ylabel(barbar,'Arrival Angle Deviation (deg)');
else
    set(gca,'XTickLabels',{})
end

axlist(3*(evnum-1)+2) = nexttile;
contourf(XXGRD,YYGRD,MisfitVaryingPos_gridded,500,'EdgeColor','none')
hold on
plot(coastlon,coastlat,'linewidth',2,'Color','k')
   ylim([14 26])
   xlim([-165 -150])
caxis([0.8 4])
box on
xticks([-162 -157 -152])
set(gca,'FontSize',18,'FontWeight','bold','LineWidth',2,'YTickLabels',{})
axis square
 cptcmap( Cmap2Use,axlist(3*(evnum-1)+2),'ncol',50,'flip',true);
scatter(axlist(3*(evnum-1)+2) ,PrefLon,PrefLat,200,[1 0 1],'pentagram','filled','MarkerEdgeColor','k','linewidth',2)

if evnum==3
barbar=colorbar;
barbar.Location = 'southoutside';
ylabel(barbar,'Arrival Angle L1 Misfit (deg)');
else
    set(axlist(3*(evnum-1)+2) ,'XTickLabels',{})
end



axlist(3*(evnum-1)+3) =nexttile
plot(Taustore(VaryingTau_Indices),MisfitVaryingTaus,'linewidth',3,'color',[0 0 1])

if evnum == 1
text(10,5.4,'\delta c/ c_0 (%)','fontweight','bold','fontsize',18)

[newc,dcc] = Getdcoverc(10,2*PrefWidth,cglb)
text(7.5,4.75,num2str(round(dcc,2)),'fontweight','bold','fontsize',18)

[newc,dcc] = Getdcoverc(20,2*PrefWidth,cglb)
text(17.5,4.75,num2str(round(dcc,2)),'fontweight','bold','fontsize',18)



end
if evnum==3
xlabel('\tau_{max} (s)')
else
    set(axlist(3*(evnum-1)+3) ,'XTickLabels',{})
end
ylabel('L1 Misfit (deg)')
xlim([0 25])
box on
set(gca,'FontSize',18,'FontWeight','bold','LineWidth',2)
ylim([0 5])

text(axlist(3*(evnum-1)+3),27,0.5,currIDstr,'fontsize',24,'fontweight','bold', 'Rotation',90)


end

set(gcf,'position',[1661 14 903 865])

saveas(gcf,'DemoInversionFig.png')