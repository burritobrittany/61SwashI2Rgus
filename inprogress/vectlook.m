close all
clear all



% hold on


%% Open File
F=fopen('Vectrino.dat');
B=textscan(F,'%s%s%s%s%s%s%s%s%s%s%s%s%s','headerlines',4,'delimiter',',');

i1=100000;
for k=i1:(i1+7950)
    if strcmp('"NAN"',B{3}{k})==0
    c(k-i1+1)=str2num(B{2}{k});
    x1(k-i1+1)=str2num(B{3}{k});
    t(k-i1+1)=datenum(B{1}{k});
    y1(k-i1+1)=str2num(B{4}{k});
    z1(k-i1+1)=str2num(B{5}{k});
    else
    c(k-i1+1)=str2num(B{2}{k});
    x1(k-i1+1)=nan;
    t(k-i1+1)=nan;
    y1(k-i1+1)=nan;
    z1(k-i1+1)=nan;
    end
end

f1=figure
% plot(A.data(:,1),A.data(:,2))
hold on
plot(t+4/24,x1)
datetick
plot(t+4/24,y1)
plot(t+4/24,z1)

load VECT_1608217202014c

f2=figure;
plot(t+4/24,x1)
hold on
plot(vect(1).t,vect(1).xraw)
