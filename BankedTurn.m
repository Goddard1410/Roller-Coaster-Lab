clear;
clc;



    
    g = 9.81;
    h_0 = 125;
    h = 0;
    G= 5.8;

    
    v = sqrt(2* g * (h_0-h));
    r = (v^2/g)* (1/(tand(acosd(1/G))));
    s = pi * r;
    Gloading = 1/(cosd(atand(v^2/(s*g))));
    % Radius of the circle

theta = linspace(0, pi, 100); % Angle range for upper half circle

x = r * cos(theta);

y = r * sin(theta);
z = linspace(0,5,100);
 

    
 

    figure(1)
    plot3(x,y,z)
    zlim([0,100]);
    xlabel('X position(meters)')
    ylabel('Y position(meters)')
    zlabel('Z position(meters)')
    title('Banked Turn Model')

  

    figure(2)
    hold on;
    s = linspace(0,100,100);
    gloadvect = ones(1, 100) * Gloading; 
    plot(s,gloadvect)
    desiredValue = 5;
    xlabel('Position(meters)')
    ylabel('Gloading')
    title('Gloading of Banked Turn')

 
    



