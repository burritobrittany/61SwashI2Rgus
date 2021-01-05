close all
clear all


load RBR_1608217202014
load 202012171500_grid10cm_1Hz_partial
load VECT_1608217202014

%% Get Right Coordinates
for k=1:3
[ALat, ALon, spN, spE, RBR(k).y, RBR(k).x] = frfCoord(RBR(k).e, RBR(k).n);

[m xi(k)]=min(abs(X(1,:)-RBR(k).x));
[m yi(k)]=min(abs(Y(:,1)-RBR(k).y));

zs(k,:)=Z(yi(k),xi(k),1:316);

% [i(k)]=knnsearch([X(:) Y(:)],[RBR(k).x RBR(k).y])
end


%% Plot
k=1
f1=figure
hold on
bind=find(zs>10);
zs(bind)=nan;
plot(t,zs(k,:))
plot(vect(k).t,vect(k).x)
plot(RBR(k).t,RBR(k).d+RBR(k).z)

return

f1=figure
hold on
bind=find(zs>10);
zs(bind)=nan;
plot(t,zs(2,:))
plot(RBR(2).t,RBR(2).d+RBR(2).z)

f1=figure
hold on
bind=find(zs>10);
zs(bind)=nan;
plot(t,zs(3,:))
plot(RBR(3).t,RBR(3).d+RBR(3).z)