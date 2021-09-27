function [eta_tide IB setup swash swashIN swashIG R2 R2_dissipative]=waterLevelPredictTHREDDs(t,wfile,tcfile)

%% Thredds Address
tad='https://chlthredds.erdc.dren.mil/thredds/dodsC/frf/';

% Get Year Month for File Names
tvec=datevec(t);
tyear=num2str(tvec(1));
tmon=num2str(tvec(2));
if length(tmon)==1
    tmon=['0' tmon];
end
tdmon=[num2str(tvec(1)) tmon];
ts=(t-datenum(1970,1,1))*24*3600;
%% Water Level

bad='oceanography/waterlevel/eopNoaaTide/';
fbase='FRF-ocean_waterlevel_eopNoaaTide_';
fname=[fbase tdmon '.nc'];


try
eta_tide=ncread([tad bad '/' tyear '/' fname],'waterLevel');
tt=ncread([tad bad '/' tyear '/' fname],'time');
[m i]=min(abs(ts-tt));
eta_tide=abs(eta_tide(i));
catch
    % Pull Constituent File
    load(tcfile)
    [eta_tide]= predictTide(cSpeed,consts,t,mval,datconv);
end
    
    


%%
%% Waves
bad=[ 'oceanography/waves/' wfile '/']; 
fbase=['FRF-ocean_waves_' wfile '_'];
fname=[fbase tdmon '.nc'];

try
Ho=ncread([tad bad '/' tyear '/' fname],'waveHs');
Tp=ncread([tad bad '/' tyear '/' fname],'waveTp');
tt=ncread([tad bad '/' tyear '/' fname],'time');
[m i]=min(abs(ts-tt));
Ho=abs(Ho(i));
Tp=abs(Tp(i));
catch
    Ho=nan;
    Tp=nan;
end
ts
tt(1)
ts-tt(i)
%% Slope
bad='geomorphology/elevationTransects/duneLidarTransect/';
fbase='FRF-geomorphology_elevationTransects_duneLidarTransect_';
fname=[fbase tdmon '.nc'];
try
Bf=ncread([tad bad '/' tyear '/' fname],'beachForeshoreSlope');
tt=ncread([tad bad '/' tyear '/' fname],'time');

[m i]=min(abs(ts-tt));
Bf=abs(Bf(i));
catch
    Bf=nan;
end
%% Runup Calculation
[IB setup swash swashIN swashIG R2 R2_dissipative]=stockdonrunup(Ho,Tp,Bf);




