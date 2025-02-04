function [gLoad] = GLoad(s, radius, theta, g, h0)
    height = s(3,:);
    gLoad = 2*(h0-height)./radius + sind(theta);
end