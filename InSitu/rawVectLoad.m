%% HouseKeeping
close all
clear all

%% User Input
% Foldername
fname='1608217202014';
odir='G:\2020Dec_JACKYPILOT\';


% Vectrino Locations
vect(1).e=901835.863;
vect(1).n=274717.014;% Right Now does not include horizontal offset
vect(1).z=2.257-1.47-.343;
vect(1).armlength=.377;
vect(1).alpha=351;

vect(2).e=901850.66;
vect(2).n=274722.262;% Right Now does not include horizontal offset
vect(2).z=1.314-1.19-.348;
vect(2).armlength=.366;
vect(2).alpha=337;

vect(3).e=901863.125;
vect(3).n=274726.631;% Right Now does not include horizontal offset
vect(3).z=1.32-1.48-.347;
vect(3).armlength=.366;
vect(3).alpha=318;
%% Vectrino
% Time Input
to=datenum(1970,1,1)+str2num(fname)/1000/24/3600;
te=to+30/60/24;

% Open File
F=fopen([fullfile(odir,'RawInsitu','Vectrino','Vectrino.dat')]);
A=textscan(F,'%s%s%s%s%s%s%s%s%s%s%s%s%s','headerlines',4,'delimiter',',');

% Find Time period
t=A{1};
t=erase(t,'"');
t=string(t);
cind=1:9000:length(t); % 9000 is 30m*60s*5hz
tchk=datenum(t(cind))+4/24; % Sarah added this to code

[m i]=min(abs(to-tchk))
ind0=cind(i);
ind=(ind0-1000):(ind0+10000);

% Load Vectrino Data
count=0;
for k=ind;
%     
tchk=datenum(t(k))+4/24;
if tchk<=te & tchk>=to
     count=count+1;
     vect(1).t(count)=tchk;
     vect(2).t(count)=tchk;
     vect(3).t(count)=tchk;
     
     %If Nan
     nchk=strcmp('"NAN"',A{3}{k});
     if nchk==1
         for j=1:3
         vect(j).xraw(count)=nan;
         vect(j).yraw(count)=nan;
         vect(j).zraw(count)=nan;
         end
     end
      if nchk==0
         for j=1:3
         vect(j).xraw(count)=str2num(A{2+j*3-2}{k});
         vect(j).yraw(count)=str2num(A{2+j*3-1}{k});
         vect(j).zraw(count)=str2num(A{2+j*3}{k});
         end
      end
      count
end
end
disp('Vectrino Done')


%% Save
save(fullfile(odir,'Datasets',fname,'INSITU',[fname '_vectRAW.mat']),'vect')



