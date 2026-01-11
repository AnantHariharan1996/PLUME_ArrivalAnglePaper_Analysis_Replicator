%% Quick Benchmark

clear; clc; 
Period=50;
[phvel]=prem_dispersion(1/Period);
cglb = phvel;

spacing = 0.2;
xlist = [-164:spacing/2:-152];
ylist = [15:spacing/2:27];
[Ref_XGrid,Ref_YGrid] = meshgrid(xlist,ylist);


EvLat = 45
EvLon=  -156
scattererlat=22
scattererlon=-157
current_timelag =4
current_width=55;

tic 
% 1) Get phase delay with and without the scatterer
% [ttime_field_perturbed,tau2,ttime_field_noscatter,R_forgrid,x_forgrid,Q] = ...
%     Spedup_NOMAP_Get_GaussianBeam_Phase_Delay(Period,EvLat,EvLon,...
%     scattererlat,scattererlon,current_timelag,current_width,    Ref_YGrid(:),Ref_XGrid(:),cglb);
% 
 [delta2,xgrid,ygrid,ttime_field_perturbed,tau,ttime_field_noscatter,angle] ...
    = Spedup_Get_Arrival_Angle_Residual_GaussianBeam(Period,EvLat,EvLon,...
    scattererlat,scattererlon,current_timelag,current_width,Ref_YGrid(:),Ref_XGrid(:),cglb,spacing);

        
        toc 




            figure()
        scatter( xgrid(:), ygrid(:),50,delta2(:),'filled')
        colorbar
        caxis([-6 6])
colormap(flipud(turbo(100)))

        title('Sped up Fac 4')