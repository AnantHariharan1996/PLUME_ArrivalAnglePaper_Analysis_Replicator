clear; clc; close all;

% Plot the three global models used for predicting structure through Hawaii.
% 
load coastlines
xpts = [-172:0.5:-138];
ypts = [3:0.5:37];
[XGRD,YGRD] = meshgrid(xpts,ypts);
PLUMESTNSINFO = readtable('PLUMESTNS.txt');

%% First Plot GDM52

GDM52Fname = [ '/Users/ananthariharan/Documents/GitHub/PLUME_ArrivalAnglePaper_Analysis_Replicator/Fig7_Comparisons_Global_Models/R050_1_GDM52.pix'];
GDM52Info = readtable(GDM52Fname,'FileType','text');
REF_PVELO= 3.95140;
GDM_LATS = GDM52Info.Var1(3:end);
GDM_LONS = GDM52Info.Var2(3:end);
GDM_C = GDM52Info.Var4(3:end);
GDM_C_GRID = griddata(GDM_LONS,GDM_LATS,GDM_C,XGRD,YGRD);
GDM_C_GRID = REF_PVELO+GDM_C_GRID.*REF_PVELO./100;


%% Now Process S362ANI

S362ANI_VSV_75_INFO = load('S362ANI.vsv.75.txt');
S362ANI_VSV_75 = S362ANI_VSV_75_INFO(:,3);
S362ANI_VSH_75_INFO = load('S362ANI.vsh.75.txt');
S362ANI_VSH_75 = S362ANI_VSH_75_INFO(:,3);
 [S362ANI_Vs_vt ] = voigtav( S362ANI_VSH_75,S362ANI_VSV_75);
S362ANI_GRD = griddata(S362ANI_VSH_75_INFO(:,1),S362ANI_VSH_75_INFO(:,2),...
    S362ANI_Vs_vt,XGRD,YGRD);
axlims= [4.45 4.65]

%% Now Process GLADM25
gladdep= 74;
GLADFNAME = ('glad-m25-vs-0.0-n4.nc');
lon = ncread(GLADFNAME,'longitude');
lat = ncread(GLADFNAME,'latitude');
depths = ncread(GLADFNAME,'depth');
vsv = ncread(GLADFNAME,'vsv');
vsh = ncread(GLADFNAME,'vsh');
 [GLAD_Vs_vt ] = voigtav( vsh,vsv);

depthdx = find(depths == gladdep);
VSATDEPTH = double(GLAD_Vs_vt(:,:,depthdx));
[LATGRD,LONGRD] = meshgrid(lat,lon);
LATGRD2PLT=double(LATGRD);
LONGRD2PLT = double(LONGRD);

GLAD_GRD = griddata(LONGRD2PLT,LATGRD2PLT,VSATDEPTH,XGRD,YGRD);


%%%% PLOTTING BELOW HERE

figure()
tiledlayout(3,1,"TileSpacing","compact")

nexttile
contourf(XGRD,YGRD,GDM_C_GRID,200,'EdgeColor','none')
hold on
plot(coastlon,coastlat,'linewidth',2,'Color','k')
xlim([min(xpts) max(xpts)])
ylim([min(ypts) max(ypts)])
axis square
box on
set(gca,'fontsize',16,'FontWeight','bold','linewidth',2)
title('GDM52 Rayleigh Wave Phase Velocities: 50 s Period')
barbar=colorbar;
ylabel(barbar,'Phase Velocity (km/s)')
scatter(PLUMESTNSINFO.Longitude,PLUMESTNSINFO.Latitude,10,[0.5 0.5 0.5],'^')

nexttile

contourf(XGRD,YGRD,S362ANI_GRD,200,'EdgeColor','none')
hold on
plot(coastlon,coastlat,'linewidth',2,'Color','k')
xlim([min(xpts) max(xpts)])
ylim([min(ypts) max(ypts)])
axis square
box on
set(gca,'fontsize',16,'FontWeight','bold','linewidth',2)
title('S362ANI Voigt Average Shear Velocities: 75 km Depth')
barbar=colorbar;
ylabel(barbar,'Shear Wave Velocity (km/s)')
caxis(axlims)
scatter(PLUMESTNSINFO.Longitude,PLUMESTNSINFO.Latitude,10,[0.5 0.5 0.5],'^')

nexttile 


contourf(XGRD,YGRD,GLAD_GRD,200,'EdgeColor','none')
hold on
plot(coastlon,coastlat,'linewidth',2,'Color','k')
xlim([min(xpts) max(xpts)])
ylim([min(ypts) max(ypts)])
axis square
box on
set(gca,'fontsize',16,'FontWeight','bold','linewidth',2)
title(['GLAD-M25 Voigt Average Shear Velocities: ' num2str(gladdep) ' km Depth'])
barbar=colorbar;
ylabel(barbar,'Shear Wave Velocity (km/s)')
caxis(axlims)
colormap(flipud(turbo(50)))

scatter(PLUMESTNSINFO.Longitude,PLUMESTNSINFO.Latitude,10,[0.5 0.5 0.5],'^')


set(gcf,'Position', [2016 -97 674 976])

saveas(gcf,'SupplementFigure_GlobalModelComparisonForSims.png')
