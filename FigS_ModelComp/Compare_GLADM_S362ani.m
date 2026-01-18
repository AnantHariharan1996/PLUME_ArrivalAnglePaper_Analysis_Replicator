%%% Compare S362ANI and GLADM25

clear; clc; close all;
addpath((    '/Users/ananthariharan/Documents/GitHub/ArrivalAngle_Hawaii_Imaging'))

addpath(genpath('/Users/ananthariharan/Documents/GitHub/avni-wavelets/'))
initialize_avni_wavelets
ncdisp('glad-m25-vs-0.0-n4.nc');
GLADFNAME = ('glad-m25-vs-0.0-n4.nc');
lon = ncread(GLADFNAME,'longitude');
lat = ncread(GLADFNAME,'latitude');
depths = ncread(GLADFNAME,'depth');
vs = ncread(GLADFNAME,'vsv');

depth2plt = 74;

depthdx = find(depths == depth2plt);
VSATDEPTH = double(vs(:,:,depthdx));
[LATGRD,LONGRD] = meshgrid(lat,lon);
LATGRD2PLT=double(LATGRD);
LONGRD2PLT = double(LONGRD);


%%% Now Load S362ANI
depth2plt = 75;

S362ANIFNAME = ('S362ANI_kmps.nc');
S_lon = ncread(S362ANIFNAME,'longitude');
S_lat = ncread(S362ANIFNAME,'latitude');
S_depths = ncread(S362ANIFNAME,'depth');
S_vs = ncread(S362ANIFNAME,'vsv');


S_depthdx = find(S_depths == depth2plt);
S_VSATDEPTH = double(S_vs(:,:,S_depthdx));
[S_LATGRD,S_LONGRD] = meshgrid(S_lat,S_lon);
S_LATGRD2PLT=double(S_LATGRD);
S_LONGRD2PLT = double(S_LONGRD);
% 
%  [ChimeraonGrid] = Plot_Global_Model_labelver(S_LONGRD2PLT(:),S_LATGRD2PLT(:),S_VSATDEPTH(:),[4.1 4.8],'S362ANI: Vs (km/s)')
% saveas(gcf,'S362ani.png')
% close all
% 
%   [ChimeraonGrid] = Plot_Global_Model_labelver(LONGRD2PLT(:),LATGRD2PLT(:),VSATDEPTH(:),[4.1 4.8],'GLADM25: Vs (km/s)')
%   saveas(gcf,'GLADM25.png')


        lmcosi = xyz2plm(S_VSATDEPTH(:),40,'im',S_LATGRD2PLT(:),S_LONGRD2PLT(:));
        G_lmcosi = xyz2plm(VSATDEPTH(:),40,'im',LATGRD2PLT(:),LONGRD2PLT(:));

        [spec,lspec,slope] = plm2spec(lmcosi,3);
        [Gspec,Gllspecspec,Gslope] = plm2spec(G_lmcosi,3);

     
figure()
subplot(1,2,1)
s100plt=semilogy(lspec,spec,'linewidth',3,'color','r')
hold on
s300plt=semilogy(Gllspecspec,Gspec,'linewidth',3,'color','b')
xlim([1 40])
xlabel('Degree l','interpreter','latex'); ylabel('Power per Degree l','interpreter','latex')
hlegend = legend([s100plt s300plt],'S362ANI','GLADM25')
grid on; grid minor; box on; set(gca,'fontsize',20)


% Now, get the correlation coefficient as a function of degree. 
subplot(1,2,2)

LMAX = 30;
for tmpL = 1:LMAX;
tmpL

    % truncate 
        ldx1 = find(lmcosi(:,1) == tmpL);
      ldx2 = find(G_lmcosi(:,1) == tmpL);



    [ Smodel,longrid,latgrid,plm_loop1] = plm2xyz(lmcosi(ldx1,:),LATGRD2PLT(:),LONGRD2PLT(:),tmpL);
   [ gladmodel,longrid,latgrid,plm_loop1] = plm2xyz(G_lmcosi(ldx2,:),LATGRD2PLT(:),LONGRD2PLT(:),tmpL);

           
            corrmat_lmax2 = corrcoef(Smodel,gladmodel);

            corrlist(tmpL) =corrmat_lmax2(1,2)

end

plot([1:LMAX],corrlist,'-ro','linewidth',2)
xlabel('Spherical Harmonic Degree l','interpreter','latex')
ylabel('Correlation Between Models','interpreter','latex')

grid on; grid minor; box on; set(gca,'fontsize',20)
grid on; box on;
set(gcf,'position',[45 367 1076 459])
saveas(gcf,'CorrelationBothModel.png')