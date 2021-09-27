%% HouseKeeping
close all
clear all

%% User Input
fname='new_power_test_2021_08_03_0900.dat';
%% Vectrino
% Time Input
% to=datenum(2021,07,13,13,00,00);
% te=datenum(2021,07,22,13,00,00);

% Open File
F=fopen(fname);
A=textscan(F,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s','headerlines',4,'delimiter',',');

% Find Time period
t=A{1};
t=erase(t,'"');
t=string(t);
cind=1:length(t); % 9000 is 30m*60s*5hz
tchk=datenum(t(cind))+4/24; % Sarah added this to code

% [m i]=min(abs(to-tchk))
% ind0=cind(i);
% ind=(ind0-1000):(ind0+10000);

% Load Vectrino Data
count=0;
for k=cind
%     
tchk=datenum(t(k))+4/24;
% if tchk<=te & tchk>=to
     count=count+1;
     for j=1:9
     vect(j).t(count)=tchk;
     end
     
     %If Nan
     nchk=strcmp('"NAN"',A{3}{k});
     if nchk==1
         for j=1:9
         vect(j).xraw(count)=nan;
         vect(j).yraw(count)=nan;
         vect(j).zraw(count)=nan;
         end
     end
      if nchk==0
         for j=1:9
         vect(j).xraw(count)=str2num(A{2+j*3-2}{k});
         vect(j).yraw(count)=str2num(A{2+j*3-1}{k});
         vect(j).zraw(count)=str2num(A{2+j*3}{k});
         end
      end
      count
% end
end
disp('Vectrino Done')


%% Save
% save(fullfile(odir,'Datasets',fname,'INSITU',[fname '_vectRAW.mat']),'vect')

f1=figure
hold on
for k=1:9
    plot(vect(k).t,vect(k).xraw)
end
datetick
title('xraw')

f1=figure
hold on
for k=1:9
    plot(vect(k).t,vect(k).yraw)
end
datetick
title('yraw')


f1=figure
hold on
for k=1:9
    plot(vect(k).t,vect(k).zraw)
end
datetick
title('zraw')
