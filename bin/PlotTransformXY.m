function PlotTransformXY(frameIndicator,relativePositionX,relativePositionY,thetaRad)
    figure;
    start = 1;
    endInd = size(relativePositionX,1);
    smoothsize = 10;
    frame = frameIndicator;%1:endInd;
    t = frame*0.001;
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
    plot(h1,x_t,y_t);
    hold on;
    plot(x_t,y_t,'.b','Markersize',3);
    xlabel('x (nm)');
    ylabel('y (nm)');

    subplot(2,1,2);
    plot(t,x_t,'.g','markersize',6);
    hold on;
    plot(t,smooth(x_t,smoothsize),'-g','linewidth',3);
    plot(t,y_t,'.r','markersize',6);
    plot(t,smooth(y_t,smoothsize),'-r','linewidth',3);
    xlabel('time (s)');
    ylabel('x(red)-y(green) (nm)');
    yt = ylim;
    grid on;
    yticks(floor(yt(1)):8:floor(yt(2)));
end

