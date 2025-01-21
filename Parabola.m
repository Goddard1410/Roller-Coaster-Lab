function [s, distanceTraveled] = Parabola(s_0, s_f, v_0, res, g)
    s = zeros(2, res);
    v = zeros(2, res);
    distanceTraveled = zeros(1, res);
    
    %% TODO: Add s_0, change v to using height
    s(1,:) = linspace(0, s_f(1)-s_0(1), res);
    s(2,:) = v_0(2).*s(1,:)./v_0(1) - g.*s(1,:).^2./(2*v_0(1));

    v(1,:) = v_0(1);
    v(2,:) = v_0(2)./v_0(1) - g.*s(1,:)./v_0(1).^2;


    rho = (1 + (v_0(2)/v_0(1)-g*s(1,:)./v_0(1).^2).^2).^(3/2)./(-g/v_0(1).^2);
    r = 1./rho;
    
    for i = 2:res
        distanceTraveled(i) = distanceTraveled(i-1) + sqrt((s(1,i) - s(1,i-1)).^2 + (s(2,i) - s(2,i-1)).^2);
    end
end