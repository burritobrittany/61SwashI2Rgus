close all
clear all
load 202012171500_grid10cm_1Hz_partial
idr='G:/ORTHOS/';
L=ls(idr);
L=L(3:end,:);


%% Pull Coordinate
[y i]=min(abs(X(1,:)-105));

%% Pull Stack
for k=1:1:length(L(:,1))
    
   I=flipud(imread([idr L(k,:)])); 
   ts(:,k,:)=I(:,i,:);
   k
end

%% COnvert + plot
figure
tsg=rgb2gray(ts);
[Tp,Yp]=meshgrid(0:(k-1),Y(:,1));
pcolor(Tp,Yp,tsg)
shading flat
xlabel('Time [s]')
ylabel('Y [m]')
title('Sensor 1')
hold on
plot(get(gca,'xlim'),[625 625],'r')