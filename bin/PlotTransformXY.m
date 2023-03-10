function PlotTransformXY(frameIndicator,time_per_frames,relativePositionX,relativePositionY,thetaRad)
    figure;
    start = 1;
    endInd = size(relativePositionX,1);
    smoothsize = 10;
    frame = frameIndicator;%1:endInd;
    t = frame*time_per_frames;
    x = relativePositionX(start:endInd);
    y = relativePositionY(start:endInd);



    xyVector = [x,y];
    transformxy = xyVector;
    theta = thetaRad*pi/180;
    trans = [cos(theta),-sin(theta);sin(theta),cos(theta)];
    for i = 1:size(xyVector,1)
    transformxy(i,:) = xyVector(i,:)*trans;
    end
    x_t = transformxy(:,1);
    y_t = transformxy(:,2);
    datalength = size(x_t,1);
    x = 1:datalength;
    x = -1*max(x_t)*x/datalength;
    y = median(y_t)*ones(1,datalength);
    
    h1 = subplot(2,1,1);
    hold off;
    plot(0,0);
    plot(h1,smooth(x_t,smoothsize),smooth(y_t,smoothsize),'linewidth',3);
    hold on;
    plot(x_t,y_t,'.k','Markersize',6);
    xlabel('x (nm)');
    ylabel('y (nm)');

    subplot(2,1,2);
    plot(t,x_t,'.r','markersize',6);
    hold on;
    plot(t,smooth(x_t,smoothsize),'-r','linewidth',3);
    plot(t,y_t,'.g','markersize',6);
    plot(t,smooth(y_t,smoothsize),'-g','linewidth',3);
    xlabel('Time (s)');
    ylabel('Position (nm)');
    yt = ylim;
    grid on;
    yticks(floor(yt(1)):8:floor(yt(2)));
    title('X Pos (red)  Y Pos (green)');
end

