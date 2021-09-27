close all
clear all


%% User Input

fname='1608217202014';
odir='G:\2020Dec_JACKYPILOT\';
camnum=2;
efile='IOEO_Camera2';
gfile='202012171500_grid10cm_1Hz_partial';
k=120;


%% Load Files
load(fullfile(odir,'Datasets',fname,'METASHAPE',[efile, '.mat'])); % Extriniscs
I=imread(fullfile(odir,'Datasets',fname,'RAW',iname{k})); % Image List
load(fullfile(odir,'Datasets',fname,'INSITU',[fname '_rbrRAW.mat']))
load(fullfile(odir,'Datasets',fname,'INSITU',[fname '_vectRAW.mat']))
g=load(fullfile(odir,'Datasets',fname,'STEREOGRIDS',[ gfile '.mat']))


ts=(t(:)-t(1))/1000;

%% Plot Image and Instruments In Space
f1=figure;
imshow(I)
hold on
title(['t=' num2str(ts(k)) 's']);

for j=1:3
[UVd] = xyz2DistUVmod(intrinsics,[xc(k) yc(k) zc(k)],(RR{k}),[RBR(j).e RBR(j).n RBR(j).z]);
plot(UVd(1), UVd(2),'r*')
end


%% Add Offsets
toff=[71.7790 71.7790 72.8430];
for j=1:3
    RBR(j).t=RBR(j).t+toff(j)/24/3600;
end




%% Plot Extrinsics
f2=figure;
plot(ts,zc)
hold on
plot(ts(k),zc(k),'r*')
ylabel('Camera Elevation [m]')
xlabel('TIme [s]')



%% Plot RBR Data
f3=figure;
a1=axes;
n=3;
plot((RBR(n).t-tmat(1)).*24*3600,RBR(n).d+RBR(n).z)
xlabel('Time [s]')
ylabel('Elevation [m]')
xlim([-100 1900])
title('RBR 3')
hold on

% FInd Grid FIle
[ALat, ALon, g.N, g.E, Y, X] = frfCoord(g.X, g.Y);
Idx = knnsearch([g.E(:) g.N(:)],[RBR(n).e, RBR(n).n-.5]);
[row,col] = ind2sub(size(g.X),Idx)
bind=find(squeeze(g.Z(row,col,1:length(g.t)))>5);
g.Z(row,col,bind)=nan;
plot((g.t-tmat(1)).*24*3600,squeeze(g.Z(row,col,1:length(g.t))))
nanmean(squeeze(g.Z(row,col,1:length(g.t))))
xlim([0 350])
legend('RBR 3','Stereo')

nanmean(squeeze(g.Z(row,col,1:length(g.t))))-nanmean(RBR(n).d+RBR(n).z)





%% Plot RBR Data
f3=figure;
a1=axes;
n=2;
plot((RBR(n).t-tmat(1)).*24*3600,RBR(n).d+RBR(n).z)
xlabel('Time [s]')
ylabel('Elevation [m]')
xlim([-100 1900])
title('RBR 2')
hold on

% FInd Grid FIle
[ALat, ALon, g.N, g.E, Y, X] = frfCoord(g.X, g.Y);
Idx = knnsearch([g.E(:) g.N(:)],[RBR(n).e, RBR(n).n-.5]);
[row,col] = ind2sub(size(g.X),Idx)
bind=find(squeeze(g.Z(row,col,1:length(g.t)))>5);
g.Z(row,col,bind)=nan;
plot((g.t-tmat(1)).*24*3600,squeeze(g.Z(row,col,1:length(g.t))))
nanmean(squeeze(g.Z(row,col,1:length(g.t))))
xlim([0 350])
legend('RBR 2','Stereo')

nanmean(squeeze(g.Z(row,col,1:length(g.t))))-nanmean(RBR(n).d+RBR(n).z)


%-77.03+1.563    +2.88-.13-.13

%% Plot RBR Data
%% Plot RBR Data
f3=figure;
a1=axes;
n=1;
plot((RBR(n).t-tmat(1)).*24*3600,RBR(n).d+RBR(n).z)
xlabel('Time [s]')
ylabel('Elevation [m]')
xlim([-100 1900])
title('RBR 1')
hold on
nanmean(RBR(n).d+RBR(n).z)

% FInd Grid FIle
[ALat, ALon, g.N, g.E, Y, X] = frfCoord(g.X, g.Y);
Idx = knnsearch([g.E(:) g.N(:)],[RBR(n).e, RBR(n).n-.5]);
[row,col] = ind2sub(size(g.X),Idx)
bind=find(squeeze(g.Z(row,col,1:length(g.t)))>5);
g.Z(row,col,bind)=nan;
plot((g.t-tmat(1)).*24*3600,squeeze(g.Z(row,col,1:length(g.t))))
nanmean(squeeze(g.Z(row,col,1:length(g.t))))
xlim([0 350])
legend('RBR 1','Stereo')
nanmean(squeeze(g.Z(row,col,1:length(g.t))))-nanmean(RBR(n).d+RBR(n).z)



%% Pull Tidal and Runup Data
 
% [eta_tide IB setup swash swashIN swashIG R2 R2_dissipative]=waterLevelPredictTHREDDs(tmat(1),'waverider-26m','DUCK.tideConst.mat')



%% Look At Vectrino Data
n=3;

figure
hold on
yyaxis left
plot((vect(n).t-tmat(1)).*24*3600+toff(j)-2.4620,vect(n).xraw)
xlabel('Time [s]')
ylabel('Vectrino Xraw [m/s]')
yyaxis right
plot((RBR(n).t-tmat(1)).*24*3600,RBR(n).d+RBR(n).z)
ylabel('RBR [m]')
title('Station 3')


n=2;

figure
hold on
yyaxis left
plot((vect(n).t-tmat(1)).*24*3600+toff(j)-2.4620,vect(n).xraw)
xlabel('Time [s]')
ylabel('Vectrino Xraw [m/s]')
yyaxis right
plot((RBR(n).t-tmat(1)).*24*3600,RBR(n).d+RBR(n).z)
ylabel('RBR [m]')
title('Station 2')



n=1;

figure
hold on
yyaxis left
plot((vect(n).t-tmat(1)).*24*3600+toff(j)-2.4620,vect(n).xraw)
xlabel('Time [s]')
ylabel('Vectrino Xraw [m/s]')
yyaxis right
plot((RBR(n).t-tmat(1)).*24*3600,RBR(n).d+RBR(n).z)
ylabel('RBR [m]')
title('Station 1')


%% Y axes

figure
hold on
for n=1:3
plot((vect(n).t-tmat(1)).*24*3600+toff(j)-2.4620,vect(n).yraw)
end
xlabel('Time [s]')
ylabel('Vectrino yraw [m/s]')

figure
hold on
for n=1:3
plot((vect(n).t-tmat(1)).*24*3600+toff(j)-2.4620,vect(n).xraw)
end
xlabel('Time [s]')
ylabel('Vectrino yraw [m/s]')









%% X TimeStack
