close all
clear all


%% Load ncfile
t=ncread('FRF-ocean_waves_waverider-26m_202012.nc','time');
Hs=ncread('FRF-ocean_waves_waverider-26m_202012.nc','waveHs');
Tm=ncread('FRF-ocean_waves_waverider-26m_202012.nc','waveTm');
Tp=ncread('FRF-ocean_waves_waverider-26m_202012.nc','waveTp');
Dm=ncread('FRF-ocean_waves_waverider-26m_202012.nc','waveMeanDirection');


t=datenum(1970,1,1)+t/24/3600;
gind=find(t<=datenum(2020,12,28) & t>datenum(2020,12,10));
t=t(gind);
Hs=Hs(gind);
Tm=Tm(gind);
Tp=Tp(gind);
Dm=Dm(gind);



%% Plot
f1=figure;
subplot(3,1,1)
hold on
title('Hs-26m Waverider')
ylabel('[m]')
plot(t,Hs)
datetick
xlim([datenum(2020,12,10) datenum(2020,12,28)])



subplot(3,1,2)
hold on
title('Tm/Tp-26m Waverider')
ylabel('[s]')
plot(t,Tm)
plot(t,Tp)
datetick
xlim([datenum(2020,12,10) datenum(2020,12,28)])
legend('Tm','Tp')



subplot(3,1,3)
hold on
title('Mean Direction-26m Waverider')
ylabel('[s]')
plot(t,Dm)
datetick
xlim([datenum(2020,12,10) datenum(2020,12,28)])


%% Plot Date
td=1608217202014/1000/3600/24+datenum(1970,1,1);
for k=1:3
subplot(3,1,k)
hold on
plot([td td],get(gca,'ylim'))
end

[m i]=min(abs(t-td));
Dm(i)
Hs(i)
Tm(i)
Tp(i)
