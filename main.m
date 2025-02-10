clc;
clear;
close all;

%% Constants
startingHeight = 125; %m
forwardGLimit = 5;
backGLimit = 4;
upGLimit = 6;
downGLimit = 1;
lateralGLimit = 3;
totalLength = 1250; % m
h0 = 125; % m

g = 9.81; % m/s^2
trackRes = 10000; % Resolution

%% Track Definition
s = zeros(3, trackRes);
gLoad = zeros(1, trackRes);

distTraveled = linspace(0, totalLength, trackRes);

%% Parabola
pStart = [0, 0, h0-1]; % x-y-z location (m) coming in horizontally
pT = 5; % Time elapsed during parabola
pRes = 200;
pStartDist = 5; % m

[~, ~, pDistTraveled] = Parabola(pStart, pT, [sqrt(2*g*(h0-(h0-1))), 0, 0], pRes, g, h0);
pLength = pDistTraveled(end);
pRes = round(pLength/totalLength*trackRes);

[ps, pGLoad, ~] = Parabola(pStart, pT, [sqrt(2*g*(h0-(h0-1))), 0, 0], pRes, g, h0);

pStartIndex = round(pStartDist/totalLength*trackRes);
pEndIndex = pStartIndex + pRes - 1;

s(1,pStartIndex:pEndIndex) = ps(1,:);
s(2,pStartIndex:pEndIndex) = ps(2,:);
s(3,pStartIndex:pEndIndex) = ps(3,:);

gLoad(pStartIndex:pEndIndex) = pGLoad;

%% Loop
% More rigerous proof required for start height
lStart = s(:, 969)';
lRes = 200;

[~, ~, lLength] = Loop(lStart, h0, upGLimit, lRes, g);
lRes = round(lLength/totalLength*trackRes);

[ls, lGLoad, ~] = Loop(lStart, h0, upGLimit, lRes, g);

lStartIndex = round(distTraveled(969)/totalLength*trackRes);
lEndIndex = lStartIndex + lRes - 1;

s(1,lStartIndex:lEndIndex) = ls(:,1)';
s(2,lStartIndex:lEndIndex) = ls(:,2)';
s(3,lStartIndex:lEndIndex) = ls(:,3)';

gLoad(lStartIndex:lEndIndex) = lGLoad;

%% Banked Turn
tStart = s(:, 969)';
tStart(1) = tStart(1) + 50;
tRes = 200;

[~, ~, tLength] = BankedTurn(tStart, h0, upGLimit, tRes, g);
tRes = round(lLength/totalLength*trackRes);

[ts, tGLoad, ~] = BankedTurn(tStart, h0, upGLimit, tRes, g);

tStartIndex = round((distTraveled(969)+lLength)/totalLength*trackRes);
tEndIndex = tStartIndex + tRes - 1;

s(1,tStartIndex:tEndIndex) = ts(1,:);
s(2,tStartIndex:tEndIndex) = ts(2,:);
s(3,tStartIndex:tEndIndex) = ts(3,:);

gLoad(tStartIndex:tEndIndex) = tGLoad;


figure
hold on
grid on
title("Track Path")
xlabel("x")
ylabel("y")
zlabel("z")
plot3(s(1,:), s(2,:), s(3,:))
view(50, 30)

figure
hold on
grid on
title("G Loading")
xlabel("Distance Traveled (m)")
ylabel("G Force")
plot(distTraveled, gLoad)