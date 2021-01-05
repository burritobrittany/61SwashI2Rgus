close all
clear all


%% Load Oblique
Io=imread('G:\1608217202014\Camera2_1608217207467.tiff');
%% Load Ortho
Ir=imread('G:\ORTHOS\C2_10cmOrtho_1608217207467.tif');
%% Load RBR
load RBR_1608217202014

%% Load Grid
load 202012171500_grid10cm_1Hz_partial


%% Plot ORTHO
f1=figure;
Ir=flipud(Ir);
imagesc(X(1,:),Y(:,1),Ir);
set(gca,'ydir','normal')
xlabel('X [m]')
ylabel('Y [m]')
axis equal
hold on

for k=1:3
[ALat, ALon, spN, spE, RBR(k).y, RBR(k).x] = frfCoord(RBR(k).e, RBR(k).n)
plot(RBR(k).x,RBR(k).y,'rs','markerfacecolor','r','markersize',10)
end




%% Plot PColor
f2=figure;
pcolor(X,Y,Z(:,:,1))
shading flat
colorbar
xlabel('X [m]')
ylabel('Y [m]')
title('NAVD88')
hold on
for k=1:3
plot(RBR(k).x,RBR(k).y,'rs','markerfacecolor','r','markersize',10)
end
caxis([0 3])



%% Plot Rectification
figure
[r c cc]=size(Io);
imagesc(1:c,1:r,Io)
hold on
%% Load Extrinsic FIle
edir='E:\1608217202014_Processing\CAMEO\';
L=ls(edir);
Ef=L(3:end,:);
load c1c2IO
% Sort Ef
for k=1:length(Ef(:,1))
 n=strtok(Ef(k,:),'.');   
 n=strsplit(n,'out');
 N(k)=str2num(n{2});
end
[i n]=sort(N);
Ef=Ef(n,:);

for k=1
    F=fopen([edir Ef(k,:)]);
    A=textscan(F,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','delimiter','\t','headerlines',2);
  
    xc=A{2}(4);
    yc=A{3}(4);
    zc=A{4}(4);
    
    R(1,1)= A{8}(4);
    R(1,2)= A{9}(4);
    R(1,3)= A{10}(4);
    R(2,1)= A{11}(4);
    R(2,2)= A{12}(4);
    R(2,3)= A{13}(4);
    R(3,1)= A{14}(4);
    R(3,2)= A{15}(4);
    R(3,3)= A{16}(4);   
end    
for j=1:3
[UVd] = xyz2DistUVmod(intrinsics1,[xc yc zc],(R),[RBR(j).e RBR(j).n RBR(j).z]);
plot(UVd(1), UVd(2),'r*')
end
    
    %     UVd = reshape(UVd,[],2);
% % scatter(UVd(1:by:end,1),UVd(1:by:end,2),10, zp(1:by:end),'filled')
% s=size(X);
% Ud=(reshape(UVd(:,1),s(1),s(2)));
% Vd=(reshape(UVd(:,2),s(1),s(2)));    
% h=pcolor(Ud,Vd,(Zlas))
% shading flat
% h.FaceAlpha=.5;
% colormap jet
% m=colorbar
% m.Label.String='[Z [NAVD-88 m]'
% caxis([0 2])
% set(gca,'xticklabel','')
% set(gca,'yticklabel','')
% f=getframe(f1)