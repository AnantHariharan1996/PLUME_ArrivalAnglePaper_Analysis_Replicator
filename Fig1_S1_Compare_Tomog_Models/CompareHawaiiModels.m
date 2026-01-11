%% Load and plot tomog models at Hawaii. 

clear; clc; close all;
addpath(genpath(pwd))
ModelList = readtable('ListofModels.txt','Delimiter','|');
Citations = ModelList.Citation;
ModelList = ModelList.Model_Name;
PLUMESTNS = readtable('PLUMESTNS.txt');
PLUMESTNS_LONG = PLUMESTNS.Longitude;
PLUMESTNS_LAT =  PLUMESTNS.Latitude;

load coastlines
% Load reference 1D model for TX2019slab model
TNAModel = load('TNAModel');
TNA_RAD = TNAModel(:,1);
TNA_VS = TNAModel(:,2);
TNA_DEP = 6371-TNA_RAD;
%%% Native Hawaii Grid for Plotting Tomog. Models. 
LonGrid = [-162.5:0.3:-147.5];
LatGrid = [12.5:0.3:27.5];
[HLONGRD,HLATGRD] = meshgrid(LonGrid,LatGrid);
%%%
for Depth2Plot = [100] % [50:25:150];
figure(101)

for ModelNum = 1:8
    clear Vs
    CurrentModelName = ModelList{ModelNum}
    NC_Fname = [CurrentModelName '.nc'];

    if ModelNum == 6
 lon = ncread(NC_Fname,'lon');
    lat = ncread(NC_Fname,'lat');
    depths = ncread(NC_Fname,'depth');
    ncdisp(NC_Fname)
dVs_percent =  ncread(NC_Fname,'dVs_percent');
% Get absolute Vs. 
AbsoluteVsAtDepths = interp1(TNA_DEP,TNA_VS,depths);

        for ijk = 1:length(depths)
            Vs(:,:,ijk) = AbsoluteVsAtDepths(ijk) + AbsoluteVsAtDepths(ijk)*0.01*dVs_percent(:,:,ijk);

        end

    elseif ModelNum == 7

        Fname = ['CF2024/CF2024_Hawaii_thk10km_3D-Vs'];
        CF2024Info = load(Fname,'-ascii');
         Alldepths = CF2024Info(:,3);
        AllLon = CF2024Info(:,1);
          AllLat= CF2024Info(:,2);
      
        uniqueCFdepths = unique(CF2024Info(:,3));
        AllVs  = CF2024Info(:,5);
        for ijk = 1:length(uniqueCFdepths)
            currdx = find(Alldepths == uniqueCFdepths(ijk));
            Vs(:,ijk) = AllVs(currdx);

        end

    elseif ModelNum == 8

        Fname = ['3-D_Vs_model.d'];
        Y2022Info = load(Fname,'-ascii');

% # The 3-D Vs model beneath Hawaii, obtained by Ye, Liu, Zhao & Zhao (2022), GRL
% # Depth(km)  Longithude(degree)  Latitude(degree)  Vs(km/s)  dVs(%)  Ray_Number
         Alldepths = Y2022Info(:,1);
        AllLon = Y2022Info(:,2);
          AllLat= Y2022Info(:,3);
        AllVs  = Y2022Info(:,4);
        RayNumber  = Y2022Info(:,6);

        uniqueYdepths = unique(Alldepths);

        for ijk = 1:length(uniqueYdepths)
            currdx = find(Alldepths == uniqueYdepths(ijk));
            Vs(:,ijk) = AllVs(currdx);

        end


    else

    CurrentModelName = ModelList{ModelNum}

    NC_Fname = [CurrentModelName '.nc'];
    lon = ncread(NC_Fname,'longitude');
    lat = ncread(NC_Fname,'latitude');
    depths = ncread(NC_Fname,'depth');
    ncdisp(NC_Fname)
    
    % get voigt average
    if ModelNum == 1 || ModelNum == 2 || ModelNum == 4
    vsh = ncread(NC_Fname,'vsh');
    vsv = ncread(NC_Fname,'vsv');
    
    Vs = sqrt( (vsh.^2 + 2*(vsv.^2))/3 );
    
    elseif ModelNum == 3 || ModelNum == 5 || ModelNum == 6
    
    Vs = ncread(NC_Fname,'vs');
    
    end
    end
    
    if ModelNum == 7 
    DiffwrtModelDepths = abs(uniqueCFdepths - Depth2Plot);
    [mindiff,DepthDx] = min(DiffwrtModelDepths);
    RealDepth = uniqueCFdepths(DepthDx);

    RealDepthDx = find(Alldepths == RealDepth );
    Current_all_lon = (AllLon(RealDepthDx));
    Current_all_lat = (AllLat(RealDepthDx));
    Current_Vs = AllVs(RealDepthDx);
    Hawaii_VS = griddata(Current_all_lon,Current_all_lat,Current_Vs,HLONGRD,HLATGRD);
    
        if ModelNum == 7 

% MASK OUT USING KAI'S POLYGON

GoodPolyGon = load('hawaii_outside.bd.v2')
GoodPolyGon_LON = GoodPolyGon(:,1);
GoodPolyGon_LAT = GoodPolyGon(:,2);
[idx] = Get_Idx_In_Polygon(HLONGRD,HLATGRD,GoodPolyGon_LON,GoodPolyGon_LAT);

DecoyHawaii_VS = NaN.*Hawaii_VS;
DecoyHawaii_VS(idx) = Hawaii_VS(idx);
Hawaii_VS = DecoyHawaii_VS;
        end




    elseif ModelNum == 8
    DiffwrtModelDepths = abs(uniqueYdepths - Depth2Plot);
    [mindiff,DepthDx] = min(DiffwrtModelDepths);
    RealDepth = uniqueYdepths(DepthDx);

    RealDepthDx = find(Alldepths == RealDepth );
    Current_all_lon = (AllLon(RealDepthDx));
    Current_all_lat = (AllLat(RealDepthDx));
    Current_Vs = AllVs(RealDepthDx);
    Current_RayNum= RayNumber(RealDepthDx);
Current_Vs(find(Current_RayNum == 0)) = NaN;


    Hawaii_VS = griddata(Current_all_lon,Current_all_lat,Current_Vs,HLONGRD,HLATGRD);
    

    else
    % Generate grid and interpolate, etc. 
    [ModelLatGrid,ModelLonGrid] = meshgrid(lat,lon);
    
    % Get index that we want the model at. 
    DiffwrtModelDepths = abs(depths - Depth2Plot);
    [mindiff,DepthDx] = min(DiffwrtModelDepths);
    RealDepth = depths(DepthDx);

    Current_Vs = Vs(:,:,DepthDx);
    Current_Vs = double(Current_Vs(:));
    Current_all_lon = double(ModelLonGrid(:));
    Current_all_lat = double(ModelLatGrid(:));
    Hawaii_VS = griddata(Current_all_lon,Current_all_lat,Current_Vs,HLONGRD,HLATGRD);
   
    end
    

    %%% Make Plots of Model Here %%%
    if ModelNum > 4
   subplot(2,5,ModelNum+1)

    else
    subplot(2,5,ModelNum)
    end
    contourf(HLONGRD,HLATGRD,Hawaii_VS,50,'EdgeColor','none')


    if Depth2Plot == 50
caxis([4.3 4.7])
    elseif Depth2Plot == 100
        caxis([4.2 4.6])
    elseif Depth2Plot == 150
            caxis([4.1 4.5])
    
    elseif Depth2Plot == 200
            caxis([4.2 4.6])

    end

    if ModelNum > 6
        
    end
    title({[CurrentModelName],[Citations{ModelNum} ': ' num2str(RealDepth) ' km']})
    box on

    if ModelNum > 6
            set(gca,'fontsize',16,'linewidth',3,'XColor','red','YColor','red')

    else
    set(gca,'fontsize',16,'linewidth',3)
    end
    hold on
    plot(coastlon,coastlat,'LineWidth',2,'color','k')
    xlim( [min(HLONGRD(:)) max(HLONGRD(:))] )
    ylim( [min(HLATGRD(:)) max(HLATGRD(:))] )
    

scatter(PLUMESTNS_LONG,PLUMESTNS_LAT,50,[1 0 1],'^','MarkerEdgeColor','magenta','LineWidth',1)

    clear Vs 
clear Current_Vs
clear Current_all_lon
clear Current_all_lat
clear Hawaii_VS


end


subplot(2,5,[5 10])
colormap(flipud(turbo(30)))

    if Depth2Plot == 50
caxis([4.2 4.6])
    elseif Depth2Plot == 100
        caxis([4.2 4.6])
    elseif Depth2Plot == 150
            caxis([4.1 4.5])
    
    elseif Depth2Plot == 200
            caxis([4.2 4.6])

    end


barbar=colorbar('location','westoutside');
ylabel(barbar,'V_s (km/s)','fontsize',20,'fontweight','bold')
set(gca,'fontsize',18)
axis off
set(gcf,'position', [1535 167 1898 712])

saveas(gcf,['Figures/MapView_' num2str(Depth2Plot) 'km.png'])

if Depth2Plot == 100
    saveas(gcf,'Fig1_ModelComparison.png')
end


if Depth2Plot == 50
    saveas(gcf,'FigS1_50km_ModelComparison.png')
end

if Depth2Plot == 150
    saveas(gcf,'FigS1_150km_ModelComparison.png')
end

end