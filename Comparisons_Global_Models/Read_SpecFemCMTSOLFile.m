function [ evt ] = Read_SpecFemCMTSOLFile( EvtFile )
% Parses Specfem input evt file for event parameters

fid = fopen(EvtFile,'r');
B = textscan(fid, '%s %f','Headerlines',4); fclose(fid);
Info = B{2};

evt.lat = Info(1);
evt.lon =Info(2);
evt.depth = Info(3);

fclose('all');
end

