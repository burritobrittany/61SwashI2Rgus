%% HouseKeeping
% close all
clear all

%% User Input
fname='SeabirdSBE50_FINALtestingGarage_2021_08_18_1500.dat';
% fname='SeabirdSBE50_Pressures_2021_07_16_1408.dat';

%% Vectrino
% Time Input
% to=datenum(2021,07,13,13,00,00);
% te=datenum(2021,07,22,13,00,00);

% Open File
F=fopen(fname);
A=textscan(F,'%s%s%s%s%s%s%s%s%s%s%s','headerlines',4,'delimiter',',');

% Find Time period
t=A{1};
t=erase(t,'"');
t=string(t);
cind=1:length(t); % 9000 is 30m*60s*5hz
tchk=datenum(t(cind)); % Sarah added this to code

% [m i]=min(abs(to-tchk))
% ind0=cind(i);
% ind=(ind0-1000):(ind0+10000);

% Load Vectrino Data
count=0;
for k=cind
%     
tchk=datenum(t(k));
% if tchk<=te & tchk>=to
     count=count+1;
     for j=1:9
     sb(j).t(count)=tchk;
     end
     
     %If Nan
     nchk=strcmp('"NAN"',A{3}{k});
     if nchk==1
         for j=1:9
         sb(j).v(count)=nan;
         
         end
     end
      if nchk==0
         for j=1:9
         sb(j).v(count)=str2num(A{2+j}{k});
         
         end
      end
      count
% end
end
disp('Pressure Done')


%% Save
% save(fullfile(odir,'Datasets',fname,'INSITU',[fname '_vectRAW.mat']),'vect')

f1=figure
hold on
for k=1:9
    plot(sb(k).t,(sb(k).v))
end
datetick
title('voltage')



%% Conversion From Volts TO pressre
Vrange=30;
for k=1:9
sb(k).p=(sb(k).v-.1).*Vrange./4.8
end


f1=figure
hold on
for k=1:9
    plot(sb(k).t,(sb(k).p))
end
datetick
title('pressure-- psia')


%% Conversion From Pressure to depth
for k=1:9
sb(k).pg=sb(k).p-14.7
end

f1=figure
hold on
for k=1:9
    plot(sb(k).t,(sb(k).pg))
end
datetick
title('pressure-- psi')

for k=1:9
sb(k).din=sb(k).pg./(0.0361111111);
end

f1=figure
hold on
for k=1:9
    plot(sb(k).t,(sb(k).din))
end
datetick
title('depth in')