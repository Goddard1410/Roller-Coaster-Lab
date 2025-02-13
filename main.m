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
totalLength = 838.1290; % m
h0 = 125; % m

g = 9.81; % m/s^2
trackRes = 20000; % Resolution

%% Track Definition
s = zeros(3, 17984);
dz_dx = zeros(1, 17984);
gLoadV = zeros(1, 17984);
gLoadF = zeros(1, 17984);

distTraveled = linspace(0, totalLength, 17984);

%% Transition Start-Parabola
l1StartIndex = round(10/totalLength*trackRes);
l1Start = [0,0,h0-20];
l1Start(1) = l1Start(1) + 8;
l1Res = 1000;

s(1,1:l1StartIndex) = 0;
s(2,1:l1StartIndex) = 0;
for i = 1:l1StartIndex
    s(3,i) = h0-(12)/(l1StartIndex-1)*(i-1);
end

gLoadV(1:l1StartIndex) = 0;

[~, ~, l1DistTraveled, ~] = Loop(l1Start, h0, upGLimit, l1Res, g);
l1Length = l1DistTraveled(end);
l1Res = round(l1Length/totalLength*trackRes);

[l1s, l1gLoadV, l1DistTraveled, l1dz_dx] = Loop(l1Start, h0, upGLimit, l1Res, g);

for i = 1:length(l1dz_dx)
    if (abs(l1dz_dx(i)) > 10000) && (i > length(l1dz_dx)/2)
        transIndexSP1 = i;
        break
    end
end

transSP1S(:,1) = l1s(transIndexSP1:end,1);
transSP1S(:,2) = l1s(transIndexSP1:end,2);
transSP1S(:,3) = l1s(transIndexSP1:end,3);

transSP1gLoadV = l1gLoadV(transIndexSP1:end);
transSP1Res = length(l1gLoadV) - transIndexSP1;
transSP1Length = l1DistTraveled(end) - l1DistTraveled(transIndexSP1);
transSP1EndIndex = l1StartIndex + transSP1Res;

s(1,l1StartIndex:transSP1EndIndex) = transSP1S(:,1)';
s(2,l1StartIndex:transSP1EndIndex) = transSP1S(:,2)';
s(3,l1StartIndex:transSP1EndIndex) = transSP1S(:,3)';

gLoadV(l1StartIndex:transSP1EndIndex) = transSP1gLoadV;

%% Transition Flat-Parabola
l2StartIndex = transSP1EndIndex + 1;
l2Start = l1Start;
l2Res = 1000;

[~, ~, l2DistTraveled, ~] = Loop(l2Start, h0, upGLimit, l2Res, g);
l2Length = l2DistTraveled(end);
l2Res = round(l2Length/totalLength*trackRes);

[l2s, l2gLoadV, l2DistTraveled, l2dz_dx] = Loop(l2Start, h0, upGLimit, l2Res, g);

for i = 1:length(l2dz_dx)
    if (abs(l2dz_dx(i)-1) < 0.2) && (l2dz_dx(i) > 0)
        transIndexSP = i;
        break
    end
end
transSPS(:,1) = l2s(1:transIndexSP,1);
transSPS(:,2) = l2s(1:transIndexSP,2);
transSPS(:,3) = l2s(1:transIndexSP,3);

transSPgLoadV = l2gLoadV(1:transIndexSP);
transSPRes = transIndexSP;
transSPLength = l2DistTraveled(transIndexSP);
transSPEndIndex = l2StartIndex + transSPRes - 1;

s(1,l2StartIndex:transSPEndIndex) = transSPS(:,1)';
s(2,l2StartIndex:transSPEndIndex) = transSPS(:,2)';
s(3,l2StartIndex:transSPEndIndex) = transSPS(:,3)';

gLoadV(l2StartIndex:transSPEndIndex) = transSPgLoadV;

%% Parabola
pStart = s(:, transSPEndIndex); % x-y-z location (m) coming in horizontally
pT = 5.4; % Time elapsed during parabola 
pRes = 1000;

[~, ~, pDistTraveled, ~] = Parabola(pStart, pT, [sqrt(g*(h0-s(3,transSPEndIndex))), 0, sqrt(g*(h0-s(3,transSPEndIndex)))], pRes, g, h0);
pLength = pDistTraveled(end);
pRes = round(pLength/totalLength*trackRes);

[ps, pgLoadV, ~, pdz_dx] = Parabola(pStart, pT, [sqrt(g*(h0-s(3,transSPEndIndex))), 0, sqrt(g*(h0-s(3,transSPEndIndex)))], pRes, g, h0);

pStartIndex = transSPEndIndex + 1;
pEndIndex = pStartIndex + pRes - 1;

s(1,pStartIndex:pEndIndex) = ps(1,:);
s(2,pStartIndex:pEndIndex) = ps(2,:);
s(3,pStartIndex:pEndIndex) = ps(3,:);

dz_dx(pStartIndex:pEndIndex) = pdz_dx;
gLoadV(pStartIndex:pEndIndex) = pgLoadV;

%% Loop
lStartIndex = pEndIndex;
lStart = s(:, lStartIndex)';
lStart(1) = lStart(1) + 48;
lStart(3) = lStart(3) - 35.97;
lRes = 1000;

[~, ~, lDistTraveled, ~] = Loop(lStart, h0, upGLimit, lRes, g);
lLength = lDistTraveled(end);
lRes = round(lLength/totalLength*trackRes);

[ls, lgLoadV, lDistTraveled, ldz_dx] = Loop(lStart, h0, upGLimit, lRes, g);

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

transLPgLoadV = lgLoadV(transIndexLP:end);
transLPRes = length(lgLoadV) - transIndexLP;
transLPLength = lDistTraveled(end) - lDistTraveled(transIndexLP);
transLPEndIndex = lStartIndex + transLPRes;

s(1,lStartIndex:transLPEndIndex) = transS(:,1)';
s(2,lStartIndex:transLPEndIndex) = transS(:,2)';
s(3,lStartIndex:transLPEndIndex) = transS(:,3)';

gLoadV(lStartIndex:transLPEndIndex) = transLPgLoadV;

lStartIndex = transLPEndIndex + 1;
lEndIndex = lStartIndex + lRes - 1;

s(1,lStartIndex:lEndIndex) = ls(:,1)';
s(2,lStartIndex:lEndIndex) = ls(:,2)';
s(3,lStartIndex:lEndIndex) = ls(:,3)';

gLoadV(lStartIndex:lEndIndex) = lgLoadV;

%% Banked Turn
tStart = s(:, lEndIndex)';
tRes = 200;

[~, ~, tLength] = BankedTurn(tStart, h0, upGLimit, tRes, g);
tRes = round(tLength/totalLength*trackRes);

[ts, tgLoadV, ~] = BankedTurn(tStart, h0, upGLimit, tRes, g);

tStartIndex = lEndIndex + 1;
tEndIndex = tStartIndex + tRes - 1;

s(1,tStartIndex:tEndIndex) = ts(1,:);
s(2,tStartIndex:tEndIndex) = ts(2,:);
s(3,tStartIndex:tEndIndex) = ts(3,:);

gLoadV(tStartIndex:tEndIndex) = tgLoadV;

[bLength, bEnd] = Braking_Section(backGLimit, g, h0, s(:, tEndIndex));
bRes = round(bLength/totalLength*trackRes);
bStartIndex = tEndIndex + 1;
bEndIndex = bStartIndex + bRes - 1;

v = sqrt(2*g*(h0-s(3, :)));

for i = 1:bRes
    v(bStartIndex+i-1) = v(tEndIndex) - (v(tEndIndex)/bRes*i);
    s(1,bStartIndex+i-1) = s(1, tEndIndex) + (bEnd(1)-s(1, tEndIndex))/bRes*i;
    s(2,bStartIndex+i-1) = s(2, tEndIndex);
    s(3,bStartIndex+i-1) = s(3, tEndIndex);
end

gLoadV(bStartIndex:bEndIndex) = ones(1, bRes);
gLoadF(bStartIndex:bEndIndex) = ones(1, bRes) * -4;

trackLength = l1Length + l2Length + pDistTraveled(end) + transLPLength + lLength + tLength + bLength + 12;
distTraveled = linspace(0, trackLength, 17984);

%% Total Track Plotting
figure
colormap(jet)
hold on
grid on
title("Track Path (Velocity Gradient)")
xlabel("x")
ylabel("y")
zlabel("z")
scatter3(s(1,:), s(2,:), s(3,:), 20, v, "filled")
view(50, 30)
c = colorbar;
c.Label.String = "Velocity (m/s)";
print('Plots/Track Path (Velocity)','-dpng','-r300')

figure
colormap(jet)
hold on
grid on
title("Track Path (G Loading Gradient)")
xlabel("x")
ylabel("y")
zlabel("z")
scatter3(s(1,:), s(2,:), s(3,:), 20, gLoadV, "filled")
view(50, 30)
c = colorbar;
c.Label.String = "G Load";
print('Plots/Track Path (GLoad)','-dpng','-r300')

% animatePlot(s, v, "Plots/Animation.mp4")

figure
subplot(3,1,1)
hold on
grid on
title("Total Vertical G Loading")
xlabel("Distance Traveled (m)")
ylabel("G Force")
plot(distTraveled, gLoadV)
yline(upGLimit, "r--")
yline(-downGLimit, "r--")
ylim([-6 6])

subplot(3,1,2)
hold on
grid on
title("Total Laterial G Loading")
xlabel("Distance Traveled(m)")
ylabel("G Force")
plot(distTraveled, zeros(1, length(distTraveled)))
yline(lateralGLimit, "r--")
ylim([-6 6])

subplot(3,1,3)
hold on
grid on
title("Total Forward/Back G Loading")
xlabel("Distance Traveled(m)")
ylabel("G Force")
plot(distTraveled, gLoadF)
yline(forwardGLimit, "r--")
yline(-backGLimit, "r--")
ylim([-6 6])
print('Plots/Total G Loading','-dpng','-r300')

%% Parabola Plotting
figure
subplot(3,1,1)
hold on
grid on
title("Parabola Vertical G Loading")
xlabel("Distance Traveled (m)")
ylabel("G Force")
plot(distTraveled(pStartIndex:pEndIndex-2), gLoadV(pStartIndex:pEndIndex-2))
yline(upGLimit, "r--")
yline(-downGLimit, "r--")
ylim([-6 6])

subplot(3,1,2)
hold on
grid on
title("Parabola Laterial G Loading")
xlabel("Distance Traveled(m)")
ylabel("G Force")
plot(distTraveled(pStartIndex:pEndIndex), zeros(1, length(distTraveled(pStartIndex:pEndIndex))))
yline(lateralGLimit, "r--")
ylim([-6 6])

subplot(3,1,3)
hold on
grid on
title("Parabola Forward/Back G Loading")
xlabel("Distance Traveled(m)")
ylabel("G Force")
plot(distTraveled(pStartIndex:pEndIndex), gLoadF(pStartIndex:pEndIndex))
yline(forwardGLimit, "r--")
yline(-backGLimit, "r--")
ylim([-6 6])
print('Plots/Parabola G Loading','-dpng','-r300')

%% Loop Plotting
figure
subplot(3,1,1)
hold on
grid on
title("Loop Vertical G Loading")
xlabel("Distance Traveled (m)")
ylabel("G Force")
plot(distTraveled(lStartIndex:lEndIndex), gLoadV(lStartIndex:lEndIndex))
yline(upGLimit, "r--")
yline(-downGLimit, "r--")
ylim([-6 6])

subplot(3,1,2)
hold on
grid on
title("Loop Laterial G Loading")
xlabel("Distance Traveled(m)")
ylabel("G Force")
plot(distTraveled(lStartIndex:lEndIndex), zeros(1, length(distTraveled(lStartIndex:lEndIndex))))
yline(lateralGLimit, "r--")
ylim([-6 6])

subplot(3,1,3)
hold on
grid on
title("Loop Forward/Back G Loading")
xlabel("Distance Traveled(m)")
ylabel("G Force")
plot(distTraveled(lStartIndex:lEndIndex), gLoadF(lStartIndex:lEndIndex))
yline(forwardGLimit, "r--")
yline(-backGLimit, "r--")
ylim([-6 6])
print('Plots/Loop G Loading','-dpng','-r300')

%% Loop Plotting
figure
subplot(3,1,1)
hold on
grid on
title("Banked Turn Vertical G Loading")
xlabel("Distance Traveled (m)")
ylabel("G Force")
plot(distTraveled(tStartIndex:tEndIndex), gLoadV(tStartIndex:tEndIndex))
yline(upGLimit, "r--")
yline(-downGLimit, "r--")
ylim([-6 6])

subplot(3,1,2)
hold on
grid on
title("Banked Turn Laterial G Loading")
xlabel("Distance Traveled(m)")
ylabel("G Force")
plot(distTraveled(tStartIndex:tEndIndex), zeros(1, length(distTraveled(tStartIndex:tEndIndex))))
yline(lateralGLimit, "r--")
ylim([-6 6])

subplot(3,1,3)
hold on
grid on
title("Banked Turn Forward/Back G Loading")
xlabel("Distance Traveled(m)")
ylabel("G Force")
plot(distTraveled(tStartIndex:tEndIndex), gLoadF(tStartIndex:tEndIndex))
yline(forwardGLimit, "r--")
yline(-backGLimit, "r--")
ylim([-6 6])
print('Plots/Banked Turn G Loading','-dpng','-r300')