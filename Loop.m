function [s,radius,gLoad] = Loop(s_0, startingHeight, upGLimit,g)
%% Calculates minimum allowable radius with given initial position (s_0), 
%% calculates position vector throughout loop and g-loading throughout loop
%startingHeight = 125; % m
%r_0 = [0,0,100]; 
%upGLimit = 6;
%g = 9.81; % m/s^2


% Initial Velocity Squared Calucaltion based of energy
v_squared_initial = 2 * g * (startingHeight - s_0(3)); % m^2 / s^2 
radius = v_squared_initial / (g *(upGLimit-1)); % minimum allowable radius 
total_length = 2 * pi * radius;

s = 0:pi/12:total_length;
gLoading = @(s) (2 * (startingHeight - r_0(3) - radius - radius*sin((s-(radius*pi/2))/radius)) / radius ) - sin((s-(radius*pi/2))/radius);
gLoad = gLoading(s)';
plot(s,gLoading(s));
hold on
title('G Loading vs S');
ylabel("G's");
xlabel('S (m)');
hold off

s(:,1) = s_0(1) + radius*cos((s-(radius*pi/2))/radius);
s(:,2) = s_0(2);
s(:,3) = s_0(3) + radius + radius*sin((s-(radius*pi/2))/radius);

figure
hold on
colormap(jet)
scatter3(r(:,1),r(:,2),r(:,3),20,gLoad,"filled");
view(3);
xlabel("x (m)")
ylabel("y (m)")
zlabel("z (m)")
c = colorbar;
c.Label.String = "G Loading";