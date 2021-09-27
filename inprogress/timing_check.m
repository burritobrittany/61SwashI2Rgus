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
plot((RBR(n).t-tmat(1)).*24*3600+72.8430,RBR(n).d+RBR(n).z)
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
plot((RBR(n).t-tmat(1)).*24*3600+72.8430-1.064,RBR(n).d+RBR(n).z)
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
plot((RBR(n).t-tmat(1)).*24*3600+72.8430-1.064,RBR(n).d+RBR(n).z)
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
 
[eta_tide IB setup swash swashIN swashIG R2 R2_dissipative]=waterLevelPredictTHREDDs(tmat(1),'waverider-26m','DUCK.tideConst.mat')






return

























%% Plot Vectrino Data
figure
n=1;
plot((vect(1).t-tmat(1))*24*3600,vect(1).xraw)

%% Plot A Transect
% 
% figure
% 
% hold on
% for k=20:1:30
% scatter(g.X(400,:),squeeze(g.Z(400,:,k)),10,squeeze(g.Z(400,:,k))*0+k,'filled')
% end


%% Reproject Grid Onto Image
figure(f1)
p=squeeze(g.Z(:,:,k));
[UVd] = xyz2DistUVmod(intrinsics,[xc(k) yc(k) zc(k)],(RR{k}),[g.E(:) g.N(:) p(:)]);
UVd = reshape(UVd,[],2);
scatter(UVd(:,1), UVd(:,2),10,p(:),'filled')
h=colorbar
caxis([1 2])
 h.Label.String='NAVD88 [m]';

figure
imshow(I);
hold on
UVd = reshape(UVd,[],2);
s=size(X);
Ud=(reshape(UVd(:,1),s(1),s(2)));
Vd=(reshape(UVd(:,2),s(1),s(2)));

% pcolor(Ud, Vd,p)
[M,c]=contour(Ud,Vd,p,[    .57 .89 1.23 1.62],'linewidth',2,'ShowText','on')
h=colorbar
shading flat
 h.Label.String='NAVD88 [m]';


% %% Do TIme Average
bind=find(g.Z>5);
g.Z(bind)=nan;
p2=nanmean(g.Z,3);
figure
imshow(I);
hold on
p=squeeze(g.Z(:,:,k));
[UVd] = xyz2DistUVmod(intrinsics,[xc(k) yc(k) zc(k)],(RR{k}),[g.E(:) g.N(:) p2(:)]);
UVd = reshape(UVd,[],2);
scatter(UVd(:,1), UVd(:,2),10,p2(:),'filled')
h=colorbar
shading flat
 h.Label.String='NAVD88 [m]';
[M,c]=contour(Ud,Vd,p2,[    0 1.1 1.2 1.3 1.62],'linewidth',2,'ShowText','on','color','k')
caxis([1  2])

% 
figure
imshow(I);
hold on
UVd = reshape(UVd,[],2);
s=size(X);
Ud=(reshape(UVd(:,1),s(1),s(2)));
Vd=(reshape(UVd(:,2),s(1),s(2)));

% pcolor(Ud, Vd,p)
[M,c]=contour(Ud,Vd,p2,[0   1.62],'linewidth',2,'ShowText','on')
colorbar
shading flat
% 
colorbar
shading flat
 h.Label.String='NAVD88 [m]';


return
for j=1:3
[UVd] = xyz2DistUVmod(intrinsics,[xc(k) yc(k) zc(k)],(RR{k}),[RBR(j).e RBR(j).n RBR(j).z]);
plot(UVd(1), UVd(2),'r*')
end

return

figure
a1=subplot(121)
imshow(I);
a2=subplot(122)
imshow(I);
hold on
scatter(UVd(:,1), UVd(:,2),10,p(:),'filled')
linkaxes([a1 a2],'xy')
caxis([1 2])



%% Pull Lidar DEM Dune
tad='https://chlthredds.erdc.dren.mil/thredds/dodsC/frf/';



%% Thredds Address
tad='https://chlthredds.erdc.dren.mil/thredds/dodsC/frf/';

% Get Year Month for File Names
tvec=datevec(tmat(1));
tyear=num2str(tvec(1));
tmon=num2str(tvec(2));
if length(tmon)==1
    tmon=['0' tmon];
end
tdmon=[num2str(tvec(1)) tmon];
ts=(t-datenum(1970,1,1))*24*3600;


%%
%% Waves
bad=[ 'geomorphology/DEMs/duneLidarDEM//']; 
fbase=['FRF-geomorphology_DEMs_duneLidarDEM_'];
fname=[fbase tdmon '.nc'];
ts=(tmat(1)-datenum(1970,1,1))*24*3600;

try

tt=ncread([tad bad '/' tyear '/' fname],'time');
xFRF=ncread([tad bad '/' tyear '/' fname],'xFRF');
yFRF=ncread([tad bad '/' tyear '/' fname],'yFRF');
[XFRF YFRF]=meshgrid(xFRF,yFRF);
[m i]=min(abs(ts-tt));
tti=ncread([tad bad '/' tyear '/' fname],'time',i,1);
Zdune=ncread([tad bad '/' tyear '/' fname],'elevation',[1 1 i],[ Inf Inf 1]);

end
figure
pcolor(XFRF',YFRF',Zdune)
shading flat