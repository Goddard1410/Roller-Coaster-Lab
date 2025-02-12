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
trackRes = 20000; % Resolution

%% Track Definition
s = zeros(3, trackRes);
dz_dx = zeros(1, trackRes);
gLoad = zeros(1, trackRes);

distTraveled = linspace(0, totalLength, trackRes);

%% Transition Start-Parabola
l1StartIndex = 10/totalLength*trackRes;
l1Start = [0,0,h0-20];
l1Start(1) = l1Start(1) + 8;
l1Res = 1000;

s(1,1:l1StartIndex) = 0;
s(2,1:l1StartIndex) = 0;
s(3,1:l1StartIndex) = h0;

gLoad(1:l1StartIndex) = 0;

[~, ~, l1DistTraveled, ~] = Loop(l1Start, h0, upGLimit, l1Res, g);
l1Length = l1DistTraveled(end);
l1Res = round(l1Length/totalLength*trackRes);

[l1s, l1GLoad, l1DistTraveled, l1dz_dx] = Loop(l1Start, h0, upGLimit, l1Res, g);

for i = 1:length(l1dz_dx)
    if (abs(l1dz_dx(i) - max(l1dz_dx)) < 500) && (i > length(l1dz_dx)/2)
        transIndexSP1 = i;
        break
    end
end

transSP1S(:,1) = l1s(transIndexSP1:end,1);
transSP1S(:,2) = l1s(transIndexSP1:end,2);
transSP1S(:,3) = l1s(transIndexSP1:end,3);

transSP1GLoad = l1GLoad(transIndexSP1:end);
transSP1Res = length(l1GLoad) - transIndexSP1;
transSP1Length = l1DistTraveled(end) - l1DistTraveled(transIndexSP1);
transSP1EndIndex = l1StartIndex + transSP1Res;

s(1,l1StartIndex:transSP1EndIndex) = transSP1S(:,1)';
s(2,l1StartIndex:transSP1EndIndex) = transSP1S(:,2)';
s(3,l1StartIndex:transSP1EndIndex) = transSP1S(:,3)';

gLoad(l1StartIndex:transSP1EndIndex) = transSP1GLoad;

%% Transition Flat-Parabola
l2StartIndex = transSP1EndIndex + 1;
l2Start = l1Start;
l2Res = 1000;

[~, ~, l2DistTraveled, ~] = Loop(l2Start, h0, upGLimit, l2Res, g);
l2Length = l2DistTraveled(end);
l2Res = round(l2Length/totalLength*trackRes);

[l2s, l2GLoad, l2DistTraveled, l2dz_dx] = Loop(l2Start, h0, upGLimit, l2Res, g);

for i = 1:length(l2dz_dx)
    if (abs(l2dz_dx(i)-1) < 0.2) && (l2dz_dx(i) > 0)
        transIndexSP = i;
        break
    end
end
transSPS(:,1) = l2s(1:transIndexSP,1);
transSPS(:,2) = l2s(1:transIndexSP,2);
transSPS(:,3) = l2s(1:transIndexSP,3);

transSPGLoad = l2GLoad(1:transIndexSP);
transSPRes = transIndexSP;
transSPLength = l2DistTraveled(transIndexSP);
transSPEndIndex = l2StartIndex + transSPRes - 1;

s(1,l2StartIndex:transSPEndIndex) = transSPS(:,1)';
s(2,l2StartIndex:transSPEndIndex) = transSPS(:,2)';
s(3,l2StartIndex:transSPEndIndex) = transSPS(:,3)';

gLoad(l2StartIndex:transSPEndIndex) = transSPGLoad;

%% Parabola
pStart = s(:, transSPEndIndex); % x-y-z location (m) coming in horizontally
pT = 5.4; % Time elapsed during parabola 
pRes = 1000;

[~, ~, pDistTraveled, ~] = Parabola(pStart, pT, [sqrt(g*(h0-s(3,transSPEndIndex))), 0, sqrt(g*(h0-s(3,transSPEndIndex)))], pRes, g, h0);
pLength = pDistTraveled(end);
pRes = round(pLength/totalLength*trackRes);

[ps, pGLoad, ~, pdz_dx] = Parabola(pStart, pT, [sqrt(g*(h0-s(3,transSPEndIndex))), 0, sqrt(g*(h0-s(3,transSPEndIndex)))], pRes, g, h0);

pStartIndex = transSPEndIndex + 1;
pEndIndex = pStartIndex + pRes - 1;

s(1,pStartIndex:pEndIndex) = ps(1,:);
s(2,pStartIndex:pEndIndex) = ps(2,:);
s(3,pStartIndex:pEndIndex) = ps(3,:);

dz_dx(pStartIndex:pEndIndex) = pdz_dx;
gLoad(pStartIndex:pEndIndex) = pGLoad;

%% Loop
lStartIndex = pEndIndex;
lStart = s(:, lStartIndex)';
lStart(1) = lStart(1) + 48;
lStart(3) = lStart(3) - 35.97;
lRes = 1000;

[~, ~, lDistTraveled, ~] = Loop(lStart, h0, upGLimit, lRes, g);
lLength = lDistTraveled(end);
lRes = round(lLength/totalLength*trackRes);

[ls, lGLoad, lDistTraveled, ldz_dx] = Loop(lStart, h0, upGLimit, lRes, g);

%% Transition
for i = 1:length(ldz_dx)
    if (abs(ldz_dx(i)-dz_dx(lStartIndex)) < 0.2) && (i > length(ldz_dx)/2)
        transIndexLP = i;
        break
    end
end
transS(:,1) = ls(transIndexLP:end,1);
transS(:,2) = ls(transIndexLP:end,2);
transS(:,3) = ls(transIndexLP:end,3);

transLPGLoad = lGLoad(transIndexLP:end);
transLPRes = length(lGLoad) - transIndexLP;
transLPLength = lDistTraveled(end) - lDistTraveled(transIndexLP);
transLPEndIndex = lStartIndex + transLPRes;

s(1,lStartIndex:transLPEndIndex) = transS(:,1)';
s(2,lStartIndex:transLPEndIndex) = transS(:,2)';
s(3,lStartIndex:transLPEndIndex) = transS(:,3)';

gLoad(lStartIndex:transLPEndIndex) = transLPGLoad;

lStartIndex = round((distTraveled(lStartIndex)+transLPLength)/totalLength*trackRes);
lEndIndex = lStartIndex + lRes - 1;

s(1,lStartIndex:lEndIndex) = ls(:,1)';
s(2,lStartIndex:lEndIndex) = ls(:,2)';
s(3,lStartIndex:lEndIndex) = ls(:,3)';

gLoad(lStartIndex:lEndIndex) = lGLoad;

%% Banked Turn
tStart = s(:, lEndIndex)';
tRes = 200;

[~, ~, tLength] = BankedTurn(tStart, h0, upGLimit, tRes, g);
tRes = round(lLength/totalLength*trackRes);

[ts, tGLoad, ~] = BankedTurn(tStart, h0, upGLimit, tRes, g);

tStartIndex = lEndIndex + 1;
tEndIndex = tStartIndex + tRes - 1;

s(1,tStartIndex:tEndIndex) = ts(1,:);
s(2,tStartIndex:tEndIndex) = ts(2,:);
s(3,tStartIndex:tEndIndex) = ts(3,:);

gLoad(tStartIndex:tEndIndex) = tGLoad;

trackLength = l2Length + pDistTraveled(end) + transLPLength + lLength + tLength

figure
hold on
grid on
title("Track Path")
xlabel("x")
ylabel("y")
zlabel("z")
plot3(s(1,:), s(2,:), s(3,:))
view(50, 30)

% figure
% hold on
% grid on
% title("Vertical G Loading")
% xlabel("Distance Traveled (m)")
% ylabel("G Force")
% plot(distTraveled, gLoad)

% figure
% hold on
% grid on
% title("Laterial G Loading")
% xlabel("Distance Traveled(m)")
% ylabel("G Force")
% plot(distanceTraveled, )