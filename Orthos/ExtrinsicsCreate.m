

%% Function Description
%  Create IOEO File for Data
close all
clear all


%% User Input

fname='1608217202014';
odir='G:\2020Dec_JACKYPILOT\';
camnum=2;

%% Load Files
edir=fullfile(odir,'Datasets',fname,'METASHAPE','CAMEO'); % Extriniscs
idir=fullfile(odir,'Datasets',fname,'RAW'); % Image List
load(fullfile(odir,'Datasets',fname,'METASHAPE','c1c2IO.mat')) % Intrinsics

%% Extrinsics
% Get List
L=ls(edir);
Ef=L(3:end,:);

% Sort Ef
for k=1:length(Ef(:,1))
 n=strtok(Ef(k,:),'.');   
 n=strsplit(n,'out');
 N(k)=str2num(n{2});
end
[i n]=sort(N);
Ef=Ef(n,:);

%% Set Camera
cname=['Camera' num2str(camnum) '_'];
cind=camnum*2;
if camnum==1
    intrinsics=intrinsics2;
else
    intrinsics=intrinsics1;
end


%% Load
for k=1:length(Ef(:,1))
    
    %% Load Extrinsics
    F=fopen(fullfile(edir, Ef(k,:)));
    A=textscan(F,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','delimiter','\t','headerlines',2);
  
    xc(k)=A{2}(cind);
    yc(k)=A{3}(cind);
    zc(k)=A{4}(cind);
    
    R(1,1)= A{8}(cind);
    R(1,2)= A{9}(cind);
    R(1,3)= A{10}(cind);
    R(2,1)= A{11}(cind);
    R(2,2)= A{12}(cind);
    R(2,3)= A{13}(cind);
    R(3,1)= A{14}(cind);
    R(3,2)= A{15}(cind);
    R(3,3)= A{16}(cind);
    RR{k}=R;
    
    tstr=A{1}{cind};
    tstr=strsplit(tstr,'_');
    tstr=tstr{2};
    t(k)=str2num(tstr);
    tmat(k)=t(k)./24./3600./1000+datenum(1970,1,1);
    %% Load Image
    iname{k}=[ cname tstr '.tiff'];
end

save(fullfile(odir,'Datasets',fname,'METASHAPE','IOEO_Camera2.mat'),'RR','intrinsics','t','xc','yc','zc','iname','tmat')