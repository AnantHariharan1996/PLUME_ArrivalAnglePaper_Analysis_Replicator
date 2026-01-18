function [WtList] = Get_Az_Weights_45DegBin(AzList)
% Weight any measurement based on number of occurences
% in a given 60 deg azimuthal bin
% Weights are inversely proportional to number of occurences in a given
% bin,
% 
% 
%
binedge_list = [0:90:360]
WtList = zeros(size(AzList));
for bin_num= 1:length(binedge_list)-1

    lo_bin =binedge_list(bin_num);
    hi_bin = binedge_list(bin_num+1);

    bindx = find(AzList >= lo_bin & AzList < hi_bin );

    WtList(bindx) = 1/length(bindx);

end

end