clear; clc; close all;

% Generate misfit surfaces
homedir=     '/Users/ananthariharan/Documents/GitHub/PLUME_ArrivalAnglePaper_Analysis_Replicator/';
PredictionsDir=[homedir 'Stored_ModelSpacePredictions/'];
SummaryMisfitDir = [homedir 'SummaryMisfitStore/'];
mkdir(SummaryMisfitDir)

Period =50;
RawDataDir=[homedir 'RawData/'];
RawDataDir_ThisPeriod = [RawDataDir num2str(Period) 's/'];
ParameterSetup

% Now find all the .mat files corresponding to this Period
FolderName = [PredictionsDir num2str(Period) 's/' ];
Predictions_List = dir([FolderName 'ModelSpaceSearch_Store_EVID*'])

StoreAllMisfits_L1 = zeros(N_MODELS,length(Predictions_List));
StoreAllMisfits_L2 = zeros(N_MODELS,length(Predictions_List));
PhVelList = zeros(1,length(Predictions_List));
RMSList = zeros(1,length(Predictions_List));
StoreAllVarReduc = zeros(N_MODELS,length(Predictions_List));
StoreAllMisfits_L1_Weighted = zeros(N_MODELS,length(Predictions_List));
StoreAllMisfits_L2_Weighted = zeros(N_MODELS,length(Predictions_List));
StoreAllMisfits_L2_SUM=StoreAllMisfits_L2_Weighted;
        for PredCounter = 1:length(Predictions_List)
   disp(['Loaded  ' num2str(100*PredCounter/length(Predictions_List)) '%'])
        currfname = Predictions_List(PredCounter).name
        full_pred_name = [FolderName currfname];
        load(full_pred_name)

         EVID = [extractBetween(currfname,'EVID','.mat')];
        EVID=EVID{1};


       EVIDFileList = dir([RawDataDir_ThisPeriod '*' EVID '_AA_Lo_Hi_C_AAResid']);
       if length(EVIDFileList) ~= 1
           error('Something is wrong. No observations for this EVID??')
       end

       ObsFName = [RawDataDir_ThisPeriod EVIDFileList(1).name];
       Info=load(ObsFName,'-ascii');
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
    Current_AA_Unct = Current_AA_Hi-Current_AA_Low;
    Current_AA_Wt = 1./Current_AA_Unct;
          Lonstore = Output_Store.Lonstore;
          Latstore = Output_Store.Latstore;
          Widthstore = Output_Store.Widthstore;
          Taustore = Output_Store.Taustore;



             xgrid =Output_Store.xgrid;
           ygrid =Output_Store.ygrid;
           
           L1_MisfitStore = 999999.*ones(size(Taustore)); 
           L2_MisfitStore = L1_MisfitStore;
           
           L1_MisfitStore_Weighted = L2_MisfitStore;
           L2_MisfitStore_Weighted= L2_MisfitStore;
        L2_MisfitStoreNoMean = L1_MisfitStore;
           Var_Reduc_List = L1_MisfitStore;
Var_Reduc_List_wt=Var_Reduc_List;


   for modelspace_num = 1:length(Taustore)

              current_predictions = Output_Store.ModelSpaceSearch_Store(modelspace_num,:);

              %  interpolate the predictions on the observations' locations. 

              Interped_AA = griddata(xgrid,ygrid,current_predictions,Current_AA_Slon,Current_AA_Slat,'nearest');
               
                Difference = Current_AA-Interped_AA;
                Mean_L1Misfit = nanmean(abs(Difference)); % currently unweighted (but still avg) misfit
                Mean_L2Misfit = nanmean(abs(Difference.^2)); % currently unweighted (but still avg) misfit
                L2Misfit = nansum(Difference.^2);
                % Now do weighted calculations
                AbsDiff = abs(Difference); absDiffsquared = abs(Difference.^2);
                WmeanL1  = nansum(AbsDiff.*Current_AA_Wt)./nansum(Current_AA_Wt);
                WmeanL2  = nansum(absDiffsquared.*Current_AA_Wt)./nansum(Current_AA_Wt);

                L1_MisfitStore(modelspace_num) = Mean_L1Misfit;
                L2_MisfitStore(modelspace_num) = Mean_L2Misfit;
                L2_MisfitStoreNoMean(modelspace_num) = L2Misfit;
                
                L1_MisfitStore_Weighted(modelspace_num) = WmeanL1;
                L2_MisfitStore_Weighted(modelspace_num)= WmeanL2;
          
                good_dx = find(isnan(Current_AA) == 0);
                % Get Variance Reduction
                Var_Reduc_List(modelspace_num) =  variance_reduction( Current_AA(good_dx)',Interped_AA(good_dx)');
                Var_Reduc_List_wt(modelspace_num) =  variance_reduction( Current_AA(good_dx)',Interped_AA(good_dx)',Current_AA_Wt(good_dx));

                
   end

   % Store Misfit values in vectors. 

         StoreAllMisfits_L1(:,PredCounter) = L1_MisfitStore;
         StoreAllMisfits_L2(:,PredCounter) = L2_MisfitStore;
         StoreAllMisfits_L2_SUM(:,PredCounter) = L2_MisfitStoreNoMean;

         StoreAllMisfits_L1_Weighted(:,PredCounter) = L1_MisfitStore_Weighted;
         StoreAllMisfits_L2_Weighted(:,PredCounter) = L2_MisfitStore_Weighted;

         StoreAllVarReduc(:,PredCounter) = Var_Reduc_List;
         StoreAllVarReduc_Wt(:,PredCounter) = Var_Reduc_List_wt;
        EVIDLIST{PredCounter} = EVID;


        end

Lonstore = Output_Store.Lonstore;
Latstore = Output_Store.Latstore;
Widthstore = Output_Store.Widthstore;
Taustore = Output_Store.Taustore;

 MisfitSurfaceSummary.StoreAllMisfits_L1=StoreAllMisfits_L1;
  MisfitSurfaceSummary.StoreAllMisfits_L2=StoreAllMisfits_L2;
 MisfitSurfaceSummary.StoreAllMisfits_L2_SUM=StoreAllMisfits_L2_SUM;
 MisfitSurfaceSummary.StoreAllMisfits_L1_Weighted=StoreAllMisfits_L1_Weighted;
 MisfitSurfaceSummary.StoreAllMisfits_L2_Weighted=StoreAllMisfits_L2_Weighted;
 MisfitSurfaceSummary.StoreAllVarReduc=StoreAllVarReduc;
 MisfitSurfaceSummary.StoreAllVarReduc_Wt=StoreAllVarReduc_Wt;
 MisfitSurfaceSummary.EVIDLIST=EVIDLIST;

save([SummaryMisfitDir 'MisfitSurfaces_' num2str(Period) 's.mat'],'MisfitSurfaceSummary') 
