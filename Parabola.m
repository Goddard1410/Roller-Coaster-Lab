function [s, radius, theta] = Parabola(s_0, length, v_0, res, g)
    s = zeros(3,res);
    theta = zeros(1,res);
    
    %% TODO: Add s_0, change v to using height
    s(1,:) = 0;
    s(2,:) = linspace(0, length-s_0(2), res);
    s(3,:) = v_0(3).*s(2,:)./v_0(2) - g.*s(2,:).^2./(2*v_0(2).^2);

    radius = ((1+(v_0(3)/v_0(2)-g*s(2,:)./v_0(2).^2).^2).^(3/2))./(g/v_0(2).^2);
    theta = theta-90;
end