function [idx] = Get_Idx_In_Polygon(inputlon,inputlat,polylon,polylat)
[in,on] = inpolygon( inputlon,inputlat,polylon,polylat);   % Logical Matrix
inon = in | on;     % Combine ?in? And ?on?
idx = find(inon(:));  
end

