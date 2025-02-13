function [s_change,s_end] = Braking_Section(back_G_Limit,g,startingHeight,s_0)
V_0 = sqrt(2 * g * startingHeight);
t_end = V_0 / (4*g);
s_change = V_0*t_end + 0.5*4*g*(t_end^2);
s = linspace(s_0(2),s_change,150);
s_end = [s_0(1) - s_change,s_0(2),s_0(3)];

figure
subplot(3,1,1)
plot(s,ones(length(s)),'g');
hold on
title('Upward/Downard G Loading vs S');
%yline(upGLimit,"--g");
%yline(-1,"--r")
ylabel("G's (+ UP)");
xlabel('S (m)');
hold 

subplot(3,1,2)
plot(s,-1*back_G_Limit*ones(length(s)));
hold on
title('Front/Back G Loading vs S');
%yline(upGLimit,"--g");
%yline(-1,"--r")
ylabel("G's (+ Front)");
xlabel('S (m)');
hold off

subplot(3,1,3)
plot(s,zeros(length(s)),"r");
hold on
title('Lateral G Loading vs S');
%yline(upGLimit,"--g");
%yline(-1,"--r")
ylabel("G's (+ Right)");
xlabel('S (m)');
hold off
end

