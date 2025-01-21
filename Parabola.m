function [s, gLoad] = Parabola(s_0, v_0, res, length, g)
    s = zeros(2, res);
    v = zeros(2, res);
    gLoad = zeros(1, res);
    
    %% TODO: Add s_0, change v to using height
    s(1,:) = linspace(0,length, res);
    s(2,:) = v_0(2).*s(1,:)./v_0(1) - g.*s(1,:).^2./(2*v_0(1));

    v(1,:) = v_0(1);
    v(2,:) = v_0(2)./v_0(1) - g.*s(1,:)./v_0(1).^2;

    rho = (1 + (v_0(2)/v_0(1)-g*s(1,:)./v_0(1).^2).^2).^1.5./(-g/v_0(1).^2);
    r = 1./rho;

    gLoad(1,:) = (v(1,:).^2+v(2,:).^2)./(g.*r)-1;
end