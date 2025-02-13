function animatePlot(s, v, filename)
    % Incraments over time slices (X axis)
    fps = 60;
    totalFrames = 17984;

    % Initialize the figure
    fig = figure;
    hold on
    grid on
    title("3D Roller Coaster")
    xlabel("x (m)")
    ylabel("y (m)")
    zlabel("z (m)")
    
    % Animation loop
    videoWriter = VideoWriter(filename, "MPEG-4");
    videoWriter.FrameRate = fps;
    open(videoWriter)

    for i = 1:50:totalFrames
        % Plot the x-z slice
        cla; % Clear previous frame
        hold on
        grid on
        colormap(jet)
        scatter3(s(1,:), s(2,:), s(3,:), 20, v, "filled")
        scatter3(s(1,i), s(2,i), s(3,i), 60, "filled", "g")
        view(50, 30)
        c = colorbar;
        c.Label.String = "Velocity (m/s)";

        drawnow; % Update the figure window
        writeVideo(videoWriter, getframe(fig))
    end    

    close(videoWriter)
end