function [pos, gloadvect, totalLength] = BankedTurn(s_0, h_0, upG, res, g)
    v = sqrt(2* g * (h_0-s_0(3)));
    r = (v^2/g)* (1/(tand(acosd(1/upG))));
    s = pi * r;
    Gloading = 1/(cosd(atand(v^2/(s*g))));
    % Radius of the circle

    theta = linspace(-pi/2, pi/2, res); % Angle range for upper half circle
    
    pos(1,:) = s_0(1) + r * cos(theta);
    pos(2,:) = s_0(2) + r + r * sin(theta);
    pos(3,:) = s_0(3);

    gloadvect = ones(1, res) * Gloading;
    totalLength = pi*r;
 
    % figure(1)
    % plot3(x,y,z)
    % zlim([0,100]);
    % xlabel('X position(meters)')
    % ylabel('Y position(meters)')
    % zlabel('Z position(meters)')
    % title('Banked Turn Model')
    % 
    % figure(2)
    % hold on;
    % s = linspace(0,100,100);
    % plot(s,gloadvect)
    % desiredValue = 5;
    % xlabel('Position(meters)')
    % ylabel('Gloading')
    % title('Gloading of Banked Turn')
end
 
    



