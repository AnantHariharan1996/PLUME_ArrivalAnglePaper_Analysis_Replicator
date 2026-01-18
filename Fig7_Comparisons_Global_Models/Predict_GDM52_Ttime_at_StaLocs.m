function [predicted_ttimelist,current_Clist] = Predict_GDM52_Ttime_at_StaLocs(Period,SourceLon,SourceLat,...
  StaLonList,StaLatList  )
%Wrapper for GDM52 codes; predicts traveltimes at a dense array of
%stations.

predicted_ttimelist = zeros(size(StaLonList));
current_Clist=predicted_ttimelist;

for stanum = 1:length(StaLonList)
    disp([num2str(100*stanum/length(StaLonList)) '% complete!'])
    StaLon=StaLonList(stanum);
    StaLat=StaLatList(stanum);
    
     [predicted_ttime,current_C,distance_km] = Predict_GDM52_Ttime(Period,SourceLon,...
         SourceLat,StaLon,StaLat);
    
     predicted_ttimelist(stanum) = predicted_ttime;
     current_Clist(stanum) = current_C;
end

end