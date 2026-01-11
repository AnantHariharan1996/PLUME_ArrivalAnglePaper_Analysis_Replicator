%% Get all PLUME Stations in the Dataset

ObsFolder =  '/Users/ananthariharan/Documents/GitHub/ArrivalAngle_Hawaii_Imaging/Raw_ArrivalAngleDeviations/50s/'
addpath(genpath(   '/Users/ananthariharan/Documents/GitHub/ArrivalAngle_Hawaii_Imaging/UsefulFunctions'))
junktmpflist = dir([ObsFolder '*slon_slat_stt']);
MegaSlon = [];
MegaSlat =[];
for tmpnum = 1:length(junktmpflist)
fname = [ObsFolder junktmpflist(tmpnum).name];
tmpjunk =load(fname,'-ASCII');
tmpslon = tmpjunk(:,1);
tmpslat = tmpjunk(:,2);
MegaSlon = [MegaSlon; tmpslon];
MegaSlat =[MegaSlat; tmpslat];
end
tmpMeg(:,1) = MegaSlon;
tmpMeg(:,2) = MegaSlat;
[unoqievals,uniquedx] = unique(tmpMeg,'rows');
PLUMESLONS = MegaSlon(uniquedx);
PLUMESLATS = MegaSlat(uniquedx);


OHANA_STANFO = readtable('OHANA_StationInfo.txt');
OHANASLONS = OHANA_STANFO.Var4;
OHANASLATS = OHANA_STANFO.Var3;
OHANA_SNAMES = OHANA_STANFO.Var2;