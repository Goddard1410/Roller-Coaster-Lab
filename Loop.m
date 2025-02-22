function [r,gLoad,s, dz_dx] = Loop(s_0, startingHeight, upGLimit,res,g)
%% Calculates minimum allowable radius with given initial position (s_0), 
%% Calculates position vector throughout loop and g-loading throughout loop
%r_0 = [0,0,100]; 

% Initial Velocity Squared Calucaltion based of energy
v_squared_initial = 2 * g * (startingHeight - s_0(3)); % m^2 / s^2 
radius = v_squared_initial / (g *(upGLimit-1)); % minimum allowable radius 
total_length = 2 * pi * radius;

% s = 0:pi/12:total_length;
s = linspace(0, total_length, res);
gLoading = @(s) (2 * (startingHeight - s_0(3) - radius - radius*sin((s-(radius*pi/2))/radius)) / radius ) - sin((s-(radius*pi/2))/radius);
gLoad = gLoading(s)';
% plot(s,gLoading(s));
% hold on
% title('G Loading vs S');
% ylabel("G's");
% xlabel('S (m)');
% hold off

r(:,1) = s_0(1) + radius*cos((s-(radius*pi/2))/radius);
r(:,2) = s_0(2);
r(:,3) = s_0(3) + radius + radius*sin((s-(radius*pi/2))/radius);

dz_dx = diff(r(:,3))./diff(r(:,1));

% figure
% hold on
% colormap(jet)
% scatter3(r(:,1),r(:,2),r(:,3),20,gLoad,"filled");
% view(3);
% xlabel("x (m)")
% ylabel("y (m)")
% zlabel("z (m)")
% c = colorbar;
% c.Label.String = "G Loading";