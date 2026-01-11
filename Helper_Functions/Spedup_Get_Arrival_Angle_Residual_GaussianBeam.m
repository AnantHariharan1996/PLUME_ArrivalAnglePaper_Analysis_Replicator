function [delta,xgrid,ygrid,ttime_field_perturbed,tau,ttime_field_noscatter,angle,angle_nodiff] ...
    = Spedup_Get_Arrival_Angle_Residual_GaussianBeam(Period,evla,evlo,...
    scatterlat,scattererlon,taumax,L,GridLat,GridLon,cglb,spacing)

% 1) Get phase delay with and without the scatterer

 [ttime_field_perturbed,tau,ttime_field_noscatter,R_forgrid,x_forgrid,Q] = ...
    Spedup_NOMAP_Get_GaussianBeam_Phase_Delay(Period,evla,evlo,...
    scatterlat,scattererlon,taumax,L,GridLat,GridLon,cglb);
%disp('Calculated Phase traveltime fields')


% 2) Get arrival angles with and without the scatterer
[ fx,fy,angle,xgrid,ygrid,tgrid2 ] = Get_arrival_angle( evla,evlo,...
    GridLat,GridLon,ttime_field_perturbed,spacing);% 

[ fx,fy,angle_nodiff,xgrid,ygrid,tgrid2 ] = Get_arrival_angle( evla,evlo,...
    GridLat,GridLon,ttime_field_noscatter,spacing );%
%disp('Calculated Arrival Angles')

% 3) get difference between angles
delta = angdiff(deg2rad(angle_nodiff),deg2rad(angle));
delta=rad2deg(delta);
%disp('Differenced Arrival Angles')
% Now, ensure the arrival angles are only defined at epicentral distances
% past the scatterer. 

[epidist_2_grid,az2grid] = distance(evla,evlo,ygrid,xgrid); 
[epidist_2_scatterer,az2scatterer] = distance(evla,evlo,scatterlat,scattererlon); 

% There should be no arrivl angle perturbations at epi. distances before
% the scatterer. 
acausal_dx = find(epidist_2_grid <= epidist_2_scatterer);
delta(acausal_dx) = 0;

end