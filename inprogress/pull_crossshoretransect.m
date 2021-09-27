close all
clear all




%% Pull Cross Shore Transect
% Foldername
fname='1608217202014';
odir='G:\2020Dec_JACKYPILOT\';
efile='IOEO_Camera2';
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

%% Change RBR Locations Into FRF Coord To Get Locations

for n=1:length([RBR(:).e])
    [ALat, ALon, spN, spE, RBR(n).Y, RBR(n).X] = frfCoord( RBR(n).e, RBR(n).n)
end

% Pick Alongshore/Crossshore Position of Interest
yin=624;
xin=RBR(3).X+1;


%% Find Bad Rectification Points
Idx = knnsearch([ g.X(:) g.Y(:)],[ xin yin]);
[row,col] = ind2sub(size(g.X),Idx)
% f1=figure
% plot(g.t,squeeze(g.Z(row,col,1:length(g.t))))
bind=find(squeeze(g.Z(row,col,1:length(g.t)))>5);
g.Z(:,:,bind)=nan;
% hold on
% plot(g.t,squeeze(g.Z(row,col,1:length(g.t))))


%% Pull From Ortho Imagery
for k=1:length(g.t)
    I=imread(fullfile(odir,'Datasets',fname,'ORTHOS',gfile,iname{k}(1:(end-1)))); % Image List
    Ixt(:,k,:)=I(row,:,:);
    Iyt(:,k,:)=I(:,col,:);
    k./length(g.t)
    Zxt(:,k)=g.Z(row,:,k);
    Zyt(:,k)=g.Z(:,col,k);
end


% Plot
g.ts=(g.t-g.t(1)).*24*3600;
Ixtg=rgb2gray(Ixt)';    
figure
[ixx itx]=meshgrid(g.X(1,:),g.ts);
pcolor(ixx,itx,Ixtg)
shading flat
colormap gray
xlabel('X [m]')
ylabel('Time [s]')
title(['Y=' num2str(yin) 'm']) 

Iytg=rgb2gray(Iyt)';    

figure
[iyy ity]=meshgrid(g.Y(:,1),g.ts);
pcolor(ity,iyy,Iytg)
shading flat
colormap gray
ylabel('Y [m]')
xlabel('Time [s]')
title(['X=' num2str(xin) 'm']) 



figure
pcolor(ixx,itx,Zxt')
shading flat
xlabel('X [m]')
ylabel('Time [s]')
title(['Y=' num2str(yin) 'm']) 
h=colorbar
h.Label.String='NAVD88 [m]';


figure
pcolor(ity,iyy,Zyt')
shading flat
ylabel('Y [m]')
xlabel('Time [s]')
title(['X=' num2str(xin) 'm']) 
h=colorbar
h.Label.String='NAVD88 [m]';



%% Plot Vectrino
f1=figure;
vect(n).ts=(vect(n).t-g.t(1))*24*3600;
n=3;
plot(vect(n).xraw,vect(n).ts)
grid on
set(gca,'xdir','reverse')
xlim([-1 1])
ylim([0 300])

%% Plot Vectrino
f1=figure;
n=3;
plot(vect(n).ts,vect(n).yraw)
grid on
ylim([-1 1])
xlim([0 300])