% close all
% clear all




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
n=2;  
% Pick Alongshore/Crossshore Position of Interest
yin=624;
xin=RBR(n).X+1;


%% Find Bad Rectification Points
Idx = knnsearch([ g.X(:) g.Y(:)],[ xin yin]);
[row,col] = ind2sub(size(g.X),Idx)
% f1=figure
% plot(g.t,squeeze(g.Z(row,col,1:length(g.t))))
bind=find(squeeze(g.Z(row,col,1:length(g.t)))>15);
g.Z(:,:,bind)=nan;
% hold on
% plot(g.t,squeeze(g.Z(row,col,1:length(g.t))))


%% Pull From Ortho Imagery
for k=1:length(g.t)
    I=(imread(fullfile(odir,'Datasets',fname,'RAW',iname{k}))); % Image List
    xxx=g.X(row,:);
    yyy=g.Y(row,:);
    zzz=xxx*0+0.89;
[ALat, ALon, spN, spE, Y, X] = frfCoord(xxx, yyy);
[IrX(k,:)]= rgb2gray(imageRectificationmod(I,intrinsics,[xc(k) yc(k) zc(k)],RR{k},spE,spN,zzz,0));
xxx=g.X(:,col);
    yyy=g.Y(:,col);
    zzz=xxx*0+0.89;
[ALat, ALon, spN, spE, Y, X] = frfCoord(xxx, yyy);
[IrY(:,k)]= rgb2gray(imageRectificationmod(I,intrinsics,[xc(k) yc(k) zc(k)],RR{k},spE,spN,zzz,0));

    
    
%     Ixt(:,k,:)=I(row,:,:);
%     Iyt(:,k,:)=I(:,col,:);
    k./length(g.t)
     Zxt(:,k)=g.Z(row,:,k);
    Zyt(:,k)=g.Z(:,col,k);
end
return
%% Adjust Vectrino TIming
toff=[71.7790 71.7790 72.8430];
    vect(3).t=vect(3).t+toff(3)/24/3600-2.4620/24/3600;
        vect(2).t=vect(2).t+toff(2)/24/3600-(2.4620-0.9870)/24/3600;
                vect(1).t=vect(1).t+toff(1)/24/3600-(2.4620-0.9870-.125)/24/3600;

for j=1:3


    vect(j).ts=(vect(j).t-g.t(1))*24*3600;
   RBR(j).t=RBR(j).t+toff(j)/24/3600;
   RBR(j).ts=(RBR(j).t-g.t(1))*24*3600;
end

%% Plot Xshore and Xaxis

f1=figure;
a1=subplot(1,3,1)
g.ts=(g.t-g.t(1)).*24*3600;
% Ixtg=rgb2gray(Ixt)';  
[ixx itx]=meshgrid(g.X(1,:),g.ts);
pcolor(ixx,itx,IrX)
shading flat
colormap gray
xlabel('X [m]')
ylabel('Time [s]')
title(['Y=' num2str(yin) 'm']) 
hold on
plot([RBR(n).X RBR(n).X],get(gca,'ylim'),'r','linewidth',2)

a2=subplot(1,3,3)
plot(vect(n).xraw,vect(n).ts,'linewidth',2)
grid on
xlim([-1.5 1.5])
ylim([0 300])
xlabel( 'Uxraw [m/s]')
title(['Sensor ' num2str(n)])


a3=subplot(1,3,2)
pcolor(ixx,itx,Zxt')
shading flat
xlabel('X [m]')
title(['Y=' num2str(yin) 'm']) 
h=colorbar
h.Label.String='NAVD88 [m]';
caxis([0 2])
linkaxes([a1 a2 a3],'y')
hold on

plot([RBR(n).X RBR(n).X],get(gca,'ylim'),'r','linewidth',2)


% Estimate Velocity using shallow water wave theory
axes(a2)
h=nanmean(squeeze(g.Z(row,col,1:length(g.t))));
h=nanmean(RBR(n).d)+.17;

gg=9.81;
eta=RBR(n).d-nanmean(RBR(n).d);
hold on
plot(-sqrt(gg./h)*eta,RBR(n).ts)
etas= squeeze(g.Z(row,col,1:length(g.t)))-nanmean(squeeze(g.Z(row,col,1:length(g.t))));
plot(-sqrt(gg./h)*etas,g.ts)
legend('vectrino','RBR','Stereo')



f2=figure
a4=subplot(3,1,1)
Iytg=rgb2gray(Iyt)';    
[iyy ity]=meshgrid(g.Y(:,1),g.ts);
pcolor(ity,iyy,Iytg)
shading flat
colormap gray
ylabel('Y [m]')
xlabel('Time [s]')
title(['X=' num2str(xin) 'm' ' Sensor ' num2str(n)]) 
hold on
plot(get(gca,'xlim'),[RBR(n).Y RBR(n).Y],'r','linewidth',.25)

a5=subplot(3,1,2)
pcolor(ity,iyy,Zyt')
shading flat
colormap gray
ylabel('Y [m]')
xlabel('Time [s]')
title(['X=' num2str(xin) 'm' ' Sensor ' num2str(n)]) 
hold on
plot(get(gca,'xlim'),[RBR(n).Y RBR(n).Y],'r','linewidth',.5)
h=colorbar
h.Label.String='NAVD88 [m]';
caxis([0 2])
linkaxes([a4 a5 ],'xy')

a6=subplot(3,1,3)
plot(vect(n).ts,vect(n).yraw,'linewidth',1.5)
grid on
ylabel( 'Vyraw [m/s]')
title(['Sensor ' num2str(n)])
linkaxes([a4 a5 a6 ],'x')
xlim([0 300])
gind=find(isnan(vect(n).yraw)==0);
xlabel('time [s]')
y = lowpass(vect(n).yraw(gind),.01,5);
hold on
plot(vect(n).ts(gind),y,'linewidth',2)
y2 = lowpass(vect(n).yraw(gind),.05,5,'steepness',.99);


return
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
n=3;
plot(vect(n).ts,vect(n).yraw)
grid on
ylim([-1 1])
xlim([0 300])
gind=find(isnan(vect(n).yraw)==0);

y = lowpass(vect(n).yraw(gind),.05,5);
hold on
plot(vect(n).ts(gind),y)
