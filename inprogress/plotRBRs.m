close all
clear all


load RBR_1608217202014local
load 202012171500_grid10cm_1Hz_partial


%% Get Right Coordinates
for k=1:3
[ALat, ALon, spN, spE, RBR(k).y, RBR(k).x] = frfCoord(RBR(k).e, RBR(k).n);

[m xi(k)]=min(abs(X(1,:)-RBR(k).x));
[m yi(k)]=min(abs(Y(:,1)+1-RBR(k).y));

zs(k,:)=Z(yi(k),xi(k),1:316);

% [i(k)]=knnsearch([X(:) Y(:)],[RBR(k).x RBR(k).y])
end


%% Plot
f1=figure
hold on
bind=find(zs>10);
zs(bind)=nan;
plot(t,zs(1,:))
plot(RBR(1).t,RBR(1).d+RBR(1).z)


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