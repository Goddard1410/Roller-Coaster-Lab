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
trackRes = 10000; % Resolution

%% Track Definition
s = zeros(3, trackRes);
v = zeros(3, trackRes);
a = zeros(3, trackRes);

distanceTraveled = linspace(0, totalLength, trackRes);
gLoad = zeros(3, trackRes);

% Parabola
pStart = [0, 0]; % x-y location (m)
pStartDistance = 10; % in distance traveled (m) 
pEnd = [10, 0]; % x-y location (m)
pRes = 100;

[ps, pDistanceTraveled] = Parabola(pStart, pEnd, [23, 10], pRes, g);

pRes = pDistanceTraveled/totalLength;
pStartIndex = round(pStartDistance/distanceTraveled); 
pEndIndex = pStartIndex + round(pDistanceTraveled(end)/totalLength);

figure
hold on
grid on
plot(ps(1,:), ps(2,:))

% gLoad = (v(1,:).^2+v(2,:).^2)./(g.*r)-1;


