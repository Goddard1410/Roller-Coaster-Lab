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
radius = zeros(1, trackRes);
theta = zeros(1, trackRes);
theta = theta - 90;

distanceTraveled = linspace(0, totalLength, trackRes);


% Parabola
pStart = [0, 2, 0]; % x-y-z location (m)
pStartDistance = 100; % in distance traveled (m)
pLength = 10; % in distance traveled (m) 
pRes = round(pLength/totalLength*trackRes);

[ps, pRadius, pTheta] = Parabola(pStart, pLength, [0, 5, 5], pRes, g);

pStartIndex = round(pStartDistance/totalLength*trackRes); 
pEndIndex = pStartIndex + pRes - 1;

s(1,pStartIndex:pEndIndex) = ps(1,:);
s(2,pStartIndex:pEndIndex) = ps(2,:);
s(3,pStartIndex:pEndIndex) = ps(3,:);

radius(pStartIndex:pEndIndex) = pRadius;
theta(pStartIndex:pEndIndex) = pTheta;

gLoad = GLoad(s, radius, theta, g, h0);

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
plot(s(2,:), gLoad)


figure
hold on
grid on
title("Curvature")
plot(s(2,:), radius)

figure
hold on
grid on
title("Theta")
plot(distanceTraveled, theta)