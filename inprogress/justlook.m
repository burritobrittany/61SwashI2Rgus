close all
clear all


%% Load Files
load('G:\2020Dec_JACKYPILOT\Datasets\1608217202014\INSITU\1608217202014_rbrRAW')
load('G:\2020Dec_JACKYPILOT\Datasets\1608217202014\INSITU\1608217202014_vectRAW')
% load G:\2020Dec_JACKYPILOT\Datasets\1608217202014\STEREOGRIDS\202012171500_grid10cm_1Hz_partial


%% Sensor 1
k=3;
f1=figure
a1=subplot(5,1,1)
hold on
plot( (RBR(k).t-RBR(k).t(1))*24*3600, RBR(k).d+RBR(k).z);
ylabel('Water Surface Elevation NAVD88 [m]')
xlabel('Seconds [s]')
grid on
plot(get(gca,'xlim'),[RBR(k).z RBR(k).z])

a2=subplot(4,1,2)
hold on
plot( (vect(k).t-RBR(k).t(1))*24*3600, vect(k).xraw);
ylabel('Vectrino X Velocity [m]')
xlabel('Seconds [s]')
grid on

a3=subplot(4,1,3)
hold on
plot( (vect(k).t-RBR(k).t(1))*24*3600, vect(k).yraw);
ylabel('Vectrino Y Velocity [m]')
xlabel('Seconds [s]')
grid on

a4=subplot(4,1,4)
hold on
plot( (vect(k).t-RBR(k).t(1))*24*3600, vect(k).zraw);
ylabel('Vectrino Z Velocity [m]')
xlabel('Seconds [s]')
grid on

linkaxes([a1 a2 a3 a4],'x')
linkaxes([ a2 a3 a4],'y')
ylim([-2 2])



figure
hold on
grid on
yyaxis left
plot((vect(k).t-RBR(k).t(1))*24*3600, vect(k).xraw)
ylabel('Cross Shore Velocity')
yyaxis right
plot((RBR(k).t-RBR(k).t(1))*24*3600, RBR(k).d+RBR(k).z)
xlabel('Collection Time [s]')
ylabel('Water Surface Elevation [m]')
title('Station 3')
% %% Load Stereo
% [ALat, ALon, spN, spE, ry, rx] = frfCoord(RBR(k).e, RBR(k).n);
% 
% [m xi]=min(abs( X(1,:)-rx));
% [m yi]=min(abs( Y(:,1)-ry));
% 
% Zs=squeeze(Z(yi,xi,:));
% axes(a1)
% plot((t-RBR(k).t(1))*24*3600,Zs(1:316))