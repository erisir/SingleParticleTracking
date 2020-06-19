function [] = PlotTrace(images,traces,TracesId,handles)
    fiducialStartOffset = 35;
    smoothWindowSize = 10;
    pixelSize = 65.98;
    results = traces.molecules(TracesId).Results;
    datalength = size(results,1);
    framecloumn = results(:,1);
    %timecloumn = results(:,2);
    absxpositioncloumn = results(:,3);
    absypositioncloumn = results(:,4);
    Amplitude =  results(:,8);
    fitError = results(:,9);
    
    cd = [uint8(jet(datalength)*255) uint8(ones(datalength,1))].';%rainbow plot
   
    relativePositionX = absxpositioncloumn - traces.smoothDriftx(framecloumn-fiducialStartOffset); 
    relativePositionY = absypositioncloumn - traces.smoothDrifty(framecloumn-fiducialStartOffset); 
    relativePositionX = relativePositionX-relativePositionX(1);
    relativePositionY = relativePositionY-relativePositionY(1);
    
    smRPosX = smooth(relativePositionX,smoothWindowSize);
    smRPosY = smooth(relativePositionY,smoothWindowSize);
    
    smRPosXPlus1 =smRPosX(2:datalength);
    smRPosYPlus1 = smRPosY(2:datalength);

    deltaX = smRPosXPlus1 -smRPosX(1:(datalength-1));%N = n-1
    deltaY = smRPosYPlus1 - smRPosY(1:(datalength-1));
    deltaDistance = sqrt(deltaX.*deltaX+deltaY.*deltaY);
    
    pathlenght = zeros(1,datalength);
    accErr = zeros(1,datalength);
    for j = 1:(datalength-1)
        pathlenght(j+1) = sum(deltaDistance(1:j));
        accErr(j+1) = sum(fitError(1:j));
    end
    deltaX=relativePositionX;
    deltaY=relativePositionY;
    displacement = sqrt(deltaX.*deltaX+deltaY.*deltaY);
    %distance = [0;distance];%add 0 to keep same size

    meanx = floor(mean(absxpositioncloumn)/pixelSize);
    meany = floor(mean(absypositioncloumn)/pixelSize);   
    try
        width  =40;
        %newCombImg = [images.ZprojectMean(meany-width:meany+width,meanx-width:meanx+width);images.ZprojectMax(meany-width:meany+width,meanx-width:meanx+width)];
        newCombImg = [images.IRMImage(meany-width:meany+width,meanx-width:meanx+width);images.ZprojectMax(meany-width:meany+width,meanx-width:meanx+width)];
    catch
        width  =5;
        %newCombImg = [images.ZprojectMean(meany-width:meany+width,meanx-width:meanx+width);images.ZprojectMax(meany-width:meany+width,meanx-width:meanx+width)];
        newCombImg = [images.IRMImage(meany-width:meany+width,meanx-width:meanx+width);images.ZprojectMax(meany-width:meany+width,meanx-width:meanx+width)];
    end
    low = get(handles.Threadhold,'Min');
    threadhold = get(handles.Threadhold,'Value');
    imshow(newCombImg,[low,threadhold],'Parent',handles.ZoomAxes);
    hold(handles.ZoomAxes, 'on');     
    plot(handles.ZoomAxes,width+1,width+1,'ro','markersize',10);
    plot(handles.ZoomAxes,width+1,width*3+1,'ro','markersize',10);
    %plot(ax1,driftx,drifty,'k-');
    %scatter(ax1,smx(framecloumn-35),smy(framecloumn-35),5,smx(framecloumn-35));
    hold(handles.ZoomAxes, 'off');
    
    plot(handles.IntensityAxes,GetZprojectIntensityByXY(images.rawImagesStack,meanx,meany)); 
    hold(handles.IntensityAxes,'on');
    plot(handles.IntensityAxes,framecloumn,Amplitude,'g');
    hold(handles.IntensityAxes,'off');

    pltPathLength = plot(handles.PathLengthAxes,framecloumn,smooth(pathlenght),'LineWidth',1);  
    hold(handles.PathLengthAxes, 'on');
    pltPathLength2 = plot(handles.PathLengthAxes,framecloumn,pathlenght,'k');         
    pltPathLength2.Color(4) = 0.2;
    hold(handles.PathLengthAxes, 'off');
    grid(handles.PathLengthAxes, 'on');
    
    pltDisplacement = plot(handles.DistanceAxes,framecloumn,smooth(displacement),'LineWidth',1); 
    hold(handles.DistanceAxes, 'on');
    pltDisplacement2 = plot(handles.DistanceAxes,framecloumn,displacement,'k'); 
    pltDisplacement2.Color(4) = 0.2;
    plot(handles.DistanceAxes,framecloumn,fitError,'r');
    hold(handles.DistanceAxes, 'off');
    grid(handles.DistanceAxes, 'on');
     
    pltXYscatter = plot(handles.XYScatterAxes,smRPosX,smooth(relativePositionY),'LineWidth',1.2);   
    hold(handles.XYScatterAxes, 'on');
    plot(handles.XYScatterAxes,relativePositionX(1),relativePositionY(1),'*b','Markersize',10);
    plot(handles.XYScatterAxes,relativePositionX(datalength),relativePositionY(datalength),'*r','Markersize',10);
    p42 = plot(handles.XYScatterAxes,relativePositionX,relativePositionY,'k');  
    p42.Color(4) = 0.2;
    hold(handles.XYScatterAxes, 'off');
    grid(handles.XYScatterAxes, 'on');
    drawnow
    set(pltDisplacement.Edge, 'ColorBinding','interpolated', 'ColorData',cd);
    set(pltPathLength.Edge, 'ColorBinding','interpolated', 'ColorData',cd);
    set(pltXYscatter.Edge, 'ColorBinding','interpolated', 'ColorData',cd);


    imageId = floor(get(handles.StackProgress,'Value'));
    stackSize = floor(get(handles.StackProgress,'Max'));
    try
        if imageId ==stackSize
            imshow(images.IRMImage,[low,threadhold] ,'Parent',handles.ImageWindowAxes);
        else
            imshow(images.rawImagesStack(:,:,imageId),[low,threadhold] ,'Parent',handles.ImageWindowAxes);
        end
        hold(handles.ImageWindowAxes,'on');
    catch
        msg =('no image stack loaded!')
    end    

    plot(handles.ImageWindowAxes,meanx,meany,'ro','MarkerSize',10);
    hold(handles.ImageWindowAxes,'off');
    
    title(handles.IntensityAxes,'Intensity of the spot [mean(x),mean(y)]')
    xlabel(handles.IntensityAxes,'time (sec)') 
    ylabel(handles.IntensityAxes,'intensity (a.u.)') 
    
    title(handles.PathLengthAxes,'path length  = sum(¡÷d)')
    xlabel(handles.PathLengthAxes,'time (sec)') 
    ylabel(handles.PathLengthAxes,'path length (nm) or nm/sec') 
        
    title(handles.DistanceAxes,'displacement  = sqrt[(X(i)-X(0))^2+(Y(i)-Y(0))^2]')
    xlabel(handles.DistanceAxes,'time (sec)') 
    ylabel(handles.DistanceAxes,'distance (nm) or nm/sec') 
    
    title(handles.XYScatterAxes,'Drift-correctedXY,from Blue to Red')
    xlabel(handles.XYScatterAxes,'x (nm)') 
    ylabel(handles.XYScatterAxes,'y (nm)') 
end

