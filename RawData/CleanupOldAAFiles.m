%% Clean up old AA files

%% Generate files containing final arrival angles

clear; clc; close all;

%PeriodList = [50 66.6667 80];
PeriodList = [28.5714];

NewDatFolder =        '/Users/ananthariharan/Documents/GitHub/PLUME_ArrivalAnglePaper_Analysis_Replicator/RawData/';



for Period = PeriodList

    NewDatFolder_at_Period = [NewDatFolder num2str(Period) 's/' ]
    NewFlist = dir([NewDatFolder_at_Period '*AAResid'])

    for evnum = 1:length(NewFlist)

currfullfname = [NewDatFolder_at_Period NewFlist(evnum).name];
delete(currfullfname)
    end

end