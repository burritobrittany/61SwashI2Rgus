%% HouseKeeping
close all
clear all

%% User Input
% Foldername
fname='1608217202014';
odir='G:\2020Dec_JACKYPILOT\';

% File for atmospheric Pressure
atmname='FRF-met_barometer_derivedBarom_202012.nc';

% RBR Files
rfiles{1}='204511_20211228_1535_RBR1_data.txt';
rfiles{2}='204510_20211228_1607_RBR2_data.txt';
rfiles{3}='204512_20211228_1638_RBR3_data.txt';


% Location
RBR(1).e=901835.863;
RBR(1).n=274717.014; % Right Now does not include horizontal offset
RBR(1).z=2.257-1.47-.343;

RBR(2).e=901850.66;
RBR(2).n=274722.262	; % Right Now does not include horizontal offset
RBR(2).z=1.314-1.19-.347;

RBR(3).e=901863.125;
RBR(3).n=274726.631; % Right Now does not include horizontal offset
RBR(3).z=1.32-1.48-.347;

% Density (kg/m^3)
RBR(1).rho=1025;
RBR(2).rho=1025;
RBR(3).rho=1025;

% Any time offset
toff=0;

%% Load Atmospheric Pressure
tp=ncread(fullfile(odir,'FRFConditions',atmname),'time');
tp=datenum(1970,1,1)+tp/24/3600;
adb=ncread(fullfile(odir,'FRFConditions',atmname),'airPressure')/100; %mb to db

%% Timing
to=datenum(1970,1,1)+str2num(fname)/1000/24/3600;
te=to+30/60/24; % Collection Length of Vectrino/Stereo



%% Load RBRs
for j=1:length(rfiles)
F=fopen(fullfile(odir,'RawInsitu','RBR',rfiles{j}));
A=textscan(F,'%s%f%f%f','delimiter',',','headerlines',1);

% Find Time Period
ro=datenum(A{1}{1})+toff;
rdt=1/16; %16Hz dt

istart=round(24*3600*(to-ro-60/24/3600)./rdt); % Assuming Both Camera and RBR in GMT
iend=round(24*3600*(te-ro+60/24/3600)./rdt); % Give a 1 minute buffer for timesyncing

% Pull Values

for k=istart:iend
    RBR(j).t(k-istart+1)=datenum(A{1}{k})+toff;
    RBR(j).db(k-istart+1)=A{2}(k);
    
    [m i]=min(abs( RBR(j).t(k-istart+1)-tp));
    RBR(j).adb(k-istart+1)=adb(i);
end

% Determine Depth
RBR(j).d= (RBR(j).db-RBR(j).adb)*10000./(9.81*RBR(j).rho);
j
end

save(fullfile(odir,'Datasets',fname,'INSITU',[fname '_rbrRAW.mat']),'RBR')

