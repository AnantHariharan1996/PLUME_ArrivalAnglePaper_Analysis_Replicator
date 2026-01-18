%% Load CMT Catalog.
clear
flist = dir('MATFILES/C20*A.mat')

for ijk = 1:length(flist)
100*ijk/length(flist)
%tmp = load(['MATFILES/' flist(ijk).name]);
try tmp = load(['MATFILES/' flist(ijk).name]);
catch
tmp = load(['MATFILES/' flist(ijk).name],'-ascii');
end
fields = fieldnames(tmp);
EQinfo =  getfield(tmp,fields{1});
Datetimelist{ijk} = EQinfo.DateTime;
Datetimelist{ijk} = regexprep(Datetimelist{ijk}, ':60\.0$', ':59.999');  % only adjusts if ends with :60.0


CMT_lonlist(ijk) = EQinfo.Lon;
CMT_latlist(ijk) = EQinfo.Lat;
dt = datetime(Datetimelist{ijk}, 'InputFormat', 'yyyy/MM/dd HH:mm:ss.S');
dn = datenum(dt);
CMT_dnlist(ijk) = dn;
maglist(ijk) = EQinfo.Mw;
end