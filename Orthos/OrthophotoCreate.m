close all
clear all

%% User Input

% Foldername
fname='1608217202014';
odir='G:\2020Dec_JACKYPILOT\';

% GridFile
gfile='202012171500_grid10cm_1Hz_partial.mat';

% Camera
camnum=2;

%% Load Files
load(fullfile(odir,'Datasets',fname,'STEREOGRIDS',gfile)) %grid
edir=fullfile(odir,'Datasets',fname,'METASHAPE','CAMEO'); % Extriniscs
idir=fullfile(odir,'Datasets',fname,'RAW'); % Image List
load(fullfile(odir,'Datasets',fname,'METASHAPE','c1c2IO.mat')) % Intrinsics


%% Convert Local Grid to SPE/SPN
[ALat, ALon, spN, spE, Y, X] = frfCoord(X, Y);

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
    intrinsics=intrinsics1;
else
    intrinsics=intrinsics2;
end

%% Make Orthos
% Make Directory
gname=strsplit(gfile,'.');
gname=gname(1);
mkdir(string(fullfile(odir,'Datasets',fname,'ORTHOS',gname)))

for k=1:length(Ef(:,1))
    
    %% Load Extrinsics
    F=fopen(fullfile(edir, Ef(k,:)));
    A=textscan(F,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','delimiter','\t','headerlines',2);
  
    xc=A{2}(cind);
    yc=A{3}(cind);
    zc=A{4}(cind);
    
    R(1,1)= A{8}(cind);
    R(1,2)= A{9}(cind);
    R(1,3)= A{10}(cind);
    R(2,1)= A{11}(cind);
    R(2,2)= A{12}(cind);
    R(2,3)= A{13}(cind);
    R(3,1)= A{14}(cind);
    R(3,2)= A{15}(cind);
    R(3,3)= A{16}(cind);
    
    tstr=A{1}{cind};
    tstr=strsplit(tstr,'_');
    tstr=tstr{2};
    t=str2num(tstr);
    
    %% Load Image
    cnam=fullfile(idir,[ cname tstr '.tiff']);
    I=imread(cnam);
    [Ir]= imageRectificationmod(I,intrinsics,[xc yc zc],R,spE,spN,Z(:,:,k),0);
    
    
    %% Save Image
    
    imwrite(flipud(Ir),string(fullfile(odir,'Datasets',fname,'ORTHOS',gname,[cname tstr '.tif'])))

k
end
