clc;
clear;
close all;

%% Constants
forwardGLimit = 5;
backGLimit = 4;
upGLimit = 6;
downGLimit = 1;
lateralGLimit = 3;
totalLength = 1250; % m

g = 9.81; % m/s^2
res = 10000; % Resolution

%% Track Definition
s = zeros(3, res);
v = zeros(3, res);
a = zeros(3, res);

distanceTraveled = linspace(0, totalLength, res);
gLoad = zeros(3, res);

% Parabola
pStart = 10; % In distance traveled (m)
pLength = 100; % m

pRes = res/pLength;
pStartIndex = round(pStart./distanceTraveled); 
pEndIndex = pStartIndex + pRes;

[ps, pGLoad] = Parabola([0,0], [100, 100], pRes, pLength, g);

figure
hold on
grid on
plot(ps(1,:), ps(2,:))
