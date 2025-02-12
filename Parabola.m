function [s, gLoad, distanceTraveled, dz_dx, t_impact] = Parabola(s_0, tf, v_0, res, g, h0)
    s = zeros(3,res);
    distanceTraveled = zeros(1,res);
    t = linspace(0, tf, res);
    
    % Create parabola given initial velocity
    s(1,:) = s_0(1) + v_0(1)*t;
    s(2,:) = s_0(2);
    s(3,:) = s_0(3) + v_0(3)*t-0.5*g*t.^2;

    % for i = 1:res
    %     if s(3,i) < 0
    %         t_impact = t(i);
    %         break
    %     end
    % end

    dz_dx = v_0(3)/v_0(1)+g*s_0(1)/(v_0(1).^2)-g*s(1,:)/(v_0(1).^2);
    d2z_dx2 = -g/(v_0(1).^2);

    radius = (1+dz_dx.^2).^(3/2)./abs(d2z_dx2);
    theta = 90 - atan2d(dz_dx,1);

    gLoad = -2*(h0-s(3,:))./radius + sind(theta);
    
    for i = 2:res
        distanceTraveled(i) = distanceTraveled(i-1) ...
            + sqrt((s(1,i)-s(1,i-1)).^2+(s(3,i)-s(3,i-1)).^2);
    end
end