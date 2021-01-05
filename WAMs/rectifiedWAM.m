%% Function Description
%  Makes WAMs for i2Rgus Camera Dec2020 Set Up


%% Housekeeping
close all
clear all
odir=cd;


%% User Input

% Foldername
fname='1608217202014';
odir='G:\2020Dec_JACKYPILOT\';


% OrthoSet to Use
oset='202012171500_grid10cm_1Hz_partial';


% Averaging Window (seconds)
awin=30;

% Overlap (seconds)
ovr=15;

% CamNum
cnum=2;

% AVI Flag
aflag=1;


%% Load File Names + Times
L=string(ls(fullfile(odir,'Datasets',fname,'ORTHOS',oset)));
L=L(3:end,:);
chk=contains(L,['Camera' num2str(cnum)]);
gind=find(chk==1);
L=L(gind);


% Pull Times
[A T]=strtok(L,'_');
[T A]=strtok(T,'_');
[T A]=strtok(T,'.tiff');
t=str2num(char(T))/1000; % From ms to s
dt=mode(diff(t));
tdate=t/24/3600+datenum(1970,1,1);
ts=t-t(1);


%% Create Time Stamps and Windows

Tbin= (awin/2):ovr: (ts(end)-awin/2); % Centered On
Tlow=Tbin-awin/2; % Upper Limit
Thigh=Tbin+awin/2; % Lower Limit


%% Create Structure to Hold Images
Io=imread(fullfile(odir,'Datasets',fname,'ORTHOS',oset,L(1)));
[r c co]=size(Io);
Iwam=zeros(r,c,length(Tbin));
Ncounter=zeros(1,length(Tbin));
clear('Io')


%% Load Images

for k=1:length(L)
    
% Load Image (Gray- Matlab cannot handle RGB array size)
I=double(rgb2gray(imread(fullfile(odir,'Datasets',fname,'ORTHOS',oset,L(k)))));

% Find Bins Image Belongs into
tcheck=ts(k);    
lcheck=Tlow-tcheck;
hcheck=Thigh-tcheck;
ind=find(lcheck<=0 & hcheck>0);

% Add Image to Average
Iwam(:,:,ind)=Iwam(:,:,ind)+I;

% Add Counter for average at end
Ncounter(ind)=Ncounter(ind)+1;

k
end

disp('Loaded Images')

%% Take Average
for k=1:length(Tbin)
    Iwam(:,:,k)=Iwam(:,:,k)./Ncounter(k);
end
Iwam=uint8(Iwam);

TbinS=Tbin;
Tbin=Tbin+t(1);
disp('Averaged Images')

%% Save File (MAT)
oname=[num2str(t(1)*1000) '_' oset '_win' num2str(awin) '_ovr' num2str(ovr)];
save(fullfile(odir,'Datasets',fname,'WAMS',[oname 'R.mat']),'Iwam','Ncounter','TbinS','awin','ovr','TbinS')
disp('saved Mat File')

%% Make A Movie
if aflag==1
    
v = VideoWriter(fullfile(odir,'Datasets',fname,'WAMS',[oname,'R.avi']));
v.FrameRate=10;
open(v)

for k=1:length(Tbin)
writeVideo(v,Iwam(:,:,k))

k
end  
   close(v) 
   disp('saved movie')
end
    
    
    
    
    
    



















