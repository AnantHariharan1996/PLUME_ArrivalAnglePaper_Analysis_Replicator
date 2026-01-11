function [predicted_ttime,current_C,distance_km] = Predict_GDM52_Ttime(Period,SourceLon,SourceLat,...
    StaLon,StaLat)
% This function is a wrapper for Goran ekstrom's GDM52codes; it 
% predicts dispersion along a path, then predicts traveltimes by
% multiplying the-path integrated slowness by total distance traveled. 
% Inputs: Period,SourceLon,SourceLat...
% StaLon,StaLa. 
% Note: Obvsiouly, we're assumng anisotropic GDM52

% Step 1: Call the codes
% generate the filename for the GDM52 codes
fid = fopen('RunGDM52.sh','w');
fprintf(fid,'#!/bin/csh');
fprintf(fid,'\n');
fprintf(fid,'/Users/ananthariharan/Documents/GitHub/GroupVelocity_OvertoneInterference/RealData/GDM52_dispersion <<!')
fprintf(fid,'\n');
fprintf(fid,'77');
fprintf(fid,'\n');
fprintf(fid,'6');
fprintf(fid,'\n');
fprintf(fid,[num2str(SourceLat) ' ' num2str(SourceLon) '']);
fprintf(fid,'\n');
fprintf(fid,[num2str(StaLat) ' ' num2str(StaLon) '']);
fprintf(fid,'\n');
fprintf(fid,'99');
fprintf(fid,'\n');
fprintf(fid,'!');
fclose(fid)
system('chmod 777 RunGDM52.sh');
system('./RunGDM52.sh');

data = read_dispersion_data('GDM52_dispersion.out');
periodlist = 1000./(data(:,1));
Clist = data(:,3);
% get ph vel at the exact period we are analyzing
current_C = interp1(periodlist,Clist,Period); 

wgs84 = wgs84Ellipsoid("m");


distance_m = distance(SourceLat,SourceLon,StaLat,StaLon,wgs84);
distance_km=distance_m/1000;
predicted_ttime = distance_km./current_C;


end