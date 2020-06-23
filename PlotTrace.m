% plot the trace we want to show [when click on the Pre/Next button on the UI, it changes the TracesId that pass here]
function [slopes] = PlotTrace(images,traces,TracesId,handles,plotIndex)
    fiducialStartOffset = 35;
    smoothWindowSize = 10;
    pixelSize = 65.98;
    slopes = [0,0,0,0];
    results = traces.molecules(TracesId).Results;%get the spot by  id
    % get detail info
    datalength = size(results,1);
    framecloumn = results(:,1);
    %timecloumn = results(:,2);
    absxpositioncloumn = results(:,3);
    absypositioncloumn = results(:,4);
    Amplitude =  results(:,8);
    fitError = results(:,9);
    [I,P,D] = GetMetadataByTracesId(traces,TracesId); 
 
    set(handles.IntensityList,'String',I);
    set(handles.PathLengthList,'String',P);
    set(handles.DistanceList,'String',D);
    setCatalog = traces.Metadata(TracesId).SetCatalog;
    switch setCatalog
        case 'All'
            set(handles.SetTypeList,'Value',1);
        case 'Stuck_Go'
             set(handles.SetTypeList,'Value',2);
        case 'Go_Stuck'
             set(handles.SetTypeList,'Value',3);
        case 'Stuck_Go_Stuck'
             set(handles.SetTypeList,'Value',4);
        case 'Go_Stuck_Go'
            set(handles.SetTypeList,'Value',5);
        case 'NonLinear'      
            set(handles.SetTypeList,'Value',6);
        case 'Perfect'      
            set(handles.SetTypeList,'Value',7);
    end
    % cd use to plot the rainbow plot, define the color dictionary
    cd = [uint8(jet(datalength)*255) uint8(ones(datalength,1))].';%rainbow plot
    
    %drift correct , substraced by the soooth result of mean drifft 
    relativePositionX = absxpositioncloumn - traces.smoothDriftx(framecloumn-fiducialStartOffset); 
    relativePositionY = absypositioncloumn - traces.smoothDrifty(framecloumn-fiducialStartOffset); 
    %substarced by the first[oringal position] so every traces go from
    %(0,0)
    relativePositionX = relativePositionX-relativePositionX(1);
    relativePositionY = relativePositionY-relativePositionY(1);
    % smooth it 
    smRPosX = smooth(relativePositionX,smoothWindowSize);
    smRPosY = smooth(relativePositionY,smoothWindowSize);
    % here is the trick, if a = [1,2,3,4,5,6,7,8],
    % than b =  a(2:datalength)=[2,3,4,5,6,7,8], 
    % so c = b -a(1:(datalength-1)) = [1,1,1,1,1,1], 
    % where c(i) = a(i+1)-a(i)�� define our deltaX/Y as follows
    smRPosXPlus1 =smRPosX(2:datalength);
    smRPosYPlus1 = smRPosY(2:datalength);

    deltaX = smRPosXPlus1 -smRPosX(1:(datalength-1));%N = n-1
    deltaY = smRPosYPlus1 - smRPosY(1:(datalength-1));
    %distance between each frame
    deltaDistance = sqrt(deltaX.*deltaX+deltaY.*deltaY);
    
    pathlenght = zeros(1,datalength);
    accErr = zeros(1,datalength);
    for j = 1:(datalength-1)
        pathlenght(j+1) = sum(deltaDistance(1:j));
        accErr(j+1) = sum(fitError(1:j));
    end
    % pathlenght sum up all the previous 'deltaDistance's
    % NOTE: this step induces the fitting noise and give us a base slope
    % which represents the amount of tracking uncertainties. 
    
    deltaX=relativePositionX;
    deltaY=relativePositionY;
    %the displacement is a vector point from the original position to the
    %current position.regardless of where the spot has been.
    displacement = sqrt(deltaX.*deltaX+deltaY.*deltaY);
    %distance = [0;distance];%add 0 to keep same size
    %use the raw position data to get the mean position[like groupzproject]
    
    %the result is used to show the corresponding spot so we can compare
    %the traces and the raw images
    
    meanx = floor(mean(absxpositioncloumn)/pixelSize);
    meany = floor(mean(absypositioncloumn)/pixelSize);   
    %try to use a 80*80 pixels to show the raw images[ROI base on the
    %meanx,meany],if something goes wrong,i.e. when the spot is on the edge
    %of the image,this will cause a out of array size error.(then we can reduce the ROI size to 10*10)
    %the images is composed of ROI from the Qdot images and the IRM images
    %we load in to workspace previously.
    if plotIndex == 0 || plotIndex ==5
        try
            width  =40;
            %newCombImg = [images.ZprojectMean(meany-width:meany+width,meanx-width:meanx+width);images.ZprojectMax(meany-width:meany+width,meanx-width:meanx+width)];
            newCombImg = [images.IRMImage(meany-width:meany+width,meanx-width:meanx+width);images.ZprojectMax(meany-width:meany+width,meanx-width:meanx+width)];
            low = get(handles.Threadhold,'Min');
            threadhold = get(handles.Threadhold,'Value');
            %show the croped images
            imshow(newCombImg,[low,threadhold],'Parent',handles.ZoomAxes);
        catch
            %width  =5;
            %newCombImg = [images.ZprojectMean(meany-width:meany+width,meanx-width:meanx+width);images.ZprojectMax(meany-width:meany+width,meanx-width:meanx+width)];
            %newCombImg = [images.IRMImage(meany-width:meany+width,meanx-width:meanx+width);images.ZprojectMax(meany-width:meany+width,meanx-width:meanx+width)];
        end
        

        hold(handles.ZoomAxes, 'on');     
        plot(handles.ZoomAxes,width+1,width+1,'ro','markersize',10);%show a red circle around the current shown spot
        plot(handles.ZoomAxes,width+1,width*3+1,'ro','markersize',10);
        %plot(ax1,driftx,drifty,'k-');
        %scatter(ax1,smx(framecloumn-35),smy(framecloumn-35),5,smx(framecloumn-35));
        hold(handles.ZoomAxes, 'off');
    end
    
    if plotIndex == 0 || plotIndex ==1
        try
        plot(handles.IntensityAxes,GetZprojectIntensityByXY(images.rawImagesStack,meanx,meany)); %plot the intensity trace we calculate by ourself
        hold(handles.IntensityAxes,'on');
        catch
        end

        plot(handles.IntensityAxes,framecloumn,Amplitude,'g');%plot the amplitude generated from fiesta, which should be same with what we calculate.
        hold(handles.IntensityAxes,'on');
        res= ylim(handles.IntensityAxes);
        yMax = floor(res(2));
        x = ones(1,yMax);
        y = 1:yMax;
        plot(handles.IntensityAxes,str2num(I(1))*x,y,'b');
        plot(handles.IntensityAxes,str2num(I(2))*x,y,'r');
        plot(handles.IntensityAxes,str2num(I(3))*x,y,'.b','LineWidth',1.1);
        plot(handles.IntensityAxes,str2num(I(4))*x,y,'.r','LineWidth',1.1);
        hold(handles.IntensityAxes,'off');
         
    end
    if plotIndex == 0 || plotIndex ==2
        smPathLength = smooth(pathlenght);
        pltPathLength = plot(handles.PathLengthAxes,framecloumn,smPathLength,'-','LineWidth',1);  %plot the smooth pathlength
        hold(handles.PathLengthAxes, 'on');
        pltPathLength2 = plot(handles.PathLengthAxes,framecloumn,pathlenght,'-k*','Markersize',1);%plot raw pathlength in backgroud in a transparent way      
        pltPathLength2.Color(4) = 0.2;
        res= ylim(handles.PathLengthAxes);
        yMax = floor(res(2));
        x = ones(1,yMax);
        y = 1:yMax;
        plot(handles.PathLengthAxes,str2num(P(1))*x,y,'b');
        plot(handles.PathLengthAxes,str2num(P(2))*x,y,'r');
        plot(handles.PathLengthAxes,str2num(P(3))*x,y,'b','LineWidth',1.1);
        plot(handles.PathLengthAxes,str2num(P(4))*x,y,'r','LineWidth',1.1);
    
        metadata = traces.Metadata(TracesId).PathLength;
        fitStart = find(framecloumn==metadata(1));
        fitEnd = find(framecloumn==metadata(2));
        fitStart2 = find(framecloumn==metadata(3));
        fitEnd2 = find(framecloumn==metadata(4));
       
        try
            P1 = polyfit(framecloumn(fitStart:fitEnd),smPathLength(fitStart:fitEnd),1);
            P2 = polyfit(framecloumn(fitStart2:fitEnd2),smPathLength(fitStart2:fitEnd2),1);
            pltP1 = plot(handles.PathLengthAxes,framecloumn(fitStart:fitEnd),P1(1)*framecloumn(fitStart:fitEnd)+P1(2),'r','LineWidth',2);
            pltP2 = plot(handles.PathLengthAxes,framecloumn(fitStart2:fitEnd2),P2(1)*framecloumn(fitStart2:fitEnd2)+P2(2),'r','LineWidth',2);
            slopes(1) = P1(1);
            slopes(2) = P2(1);
            pltP1.Color(4) = 0.1;
            pltP2.Color(4) = 0.1;
        catch
        end
        hold(handles.PathLengthAxes, 'off');
        grid(handles.PathLengthAxes, 'on');
        drawnow
        set(pltPathLength.Edge, 'ColorBinding','interpolated', 'ColorData',cd);
    end
    if plotIndex == 0 || plotIndex ==3
        smDisplacement = smooth(displacement);
        pltDisplacement = plot(handles.DistanceAxes,framecloumn,smDisplacement,'LineWidth',1);  %plot the smooth distance
        hold(handles.DistanceAxes, 'on');
        pltDisplacement2 = plot(handles.DistanceAxes,framecloumn,displacement,'-k*','Markersize',1); %plot raw smooth in backgroud in a transparent way      
        pltDisplacement2.Color(4) = 0.2;
        plot(handles.DistanceAxes,framecloumn,fitError,'r');
        
        res= ylim(handles.DistanceAxes);
        yMax = floor(res(2));
        x = ones(1,yMax);
        y = 1:yMax;
        plot(handles.DistanceAxes,str2num(D(1))*x,y,'b');
        plot(handles.DistanceAxes,str2num(D(2))*x,y,'r');
        plot(handles.DistanceAxes,str2num(D(3))*x,y,'b','LineWidth',1.1);
        plot(handles.DistanceAxes,str2num(D(4))*x,y,'r','LineWidth',1.1);
        
        metadata = traces.Metadata(TracesId).Distance;
        fitStart = find(framecloumn==metadata(1));
        fitEnd = find(framecloumn==metadata(2));
        fitStart2 = find(framecloumn==metadata(3));
        fitEnd2 = find(framecloumn==metadata(4));
       
        try
            P1 = polyfit(framecloumn(fitStart:fitEnd),smDisplacement(fitStart:fitEnd),1);
            P2 = polyfit(framecloumn(fitStart2:fitEnd2),smDisplacement(fitStart2:fitEnd2),1);
            pltP1 = plot(handles.DistanceAxes,framecloumn(fitStart:fitEnd),P1(1)*framecloumn(fitStart:fitEnd)+P1(2),'r','LineWidth',2);
            pltP2 = plot(handles.DistanceAxes,framecloumn(fitStart2:fitEnd2),P2(1)*framecloumn(fitStart2:fitEnd2)+P2(2),'r','LineWidth',2);
            slopes(3) = P1(1);
            slopes(4) = P2(1);
            pltP1.Color(4) = 0.2;
            pltP2.Color(4) = 0.2;
        catch
        end
        
        
        hold(handles.DistanceAxes, 'off');
        grid(handles.DistanceAxes, 'on');
        drawnow
        set(pltDisplacement.Edge, 'ColorBinding','interpolated', 'ColorData',cd);
    end
    if plotIndex == 0 || plotIndex ==4   
        pltXYscatter = plot(handles.XYScatterAxes,smRPosX,smooth(relativePositionY),'LineWidth',1.2);  %smoothed xy scatter plot 
        hold(handles.XYScatterAxes, 'on');
        plot(handles.XYScatterAxes,relativePositionX(1),relativePositionY(1),'*b','Markersize',10);%mark it as the beginning
        plot(handles.XYScatterAxes,relativePositionX(datalength),relativePositionY(datalength),'*r','Markersize',10);%mark it as the end
        p42 = plot(handles.XYScatterAxes,relativePositionX,relativePositionY,'k');  %raw xy scatter plot in transparent
        p42.Color(4) = 0.2;
        hold(handles.XYScatterAxes, 'off');
        grid(handles.XYScatterAxes, 'on');
        drawnow
        set(pltXYscatter.Edge, 'ColorBinding','interpolated', 'ColorData',cd);
    end
   
   
   
   

    if plotIndex == 0 || plotIndex ==5
        imageId = floor(get(handles.StackProgress,'Value'));
        stackSize = floor(get(handles.StackProgress,'Max'));
        try% not importance 
            if imageId ==stackSize
                imshow(images.IRMImage,[low,threadhold] ,'Parent',handles.ImageWindowAxes);
            else
                imshow(images.rawImagesStack(:,:,imageId),[low,threadhold] ,'Parent',handles.ImageWindowAxes);
            end
            hold(handles.ImageWindowAxes,'on');
        catch
            %msg =('no image stack loaded!')
        end    

        plot(handles.ImageWindowAxes,meanx,meany,'ro','MarkerSize',10);
        hold(handles.ImageWindowAxes,'off');
    end
    title(handles.IntensityAxes,'Intensity of the spot [mean(x),mean(y)]')
    xlabel(handles.IntensityAxes,'time (sec)') 
    ylabel(handles.IntensityAxes,'intensity (a.u.)') 
    
    title(handles.PathLengthAxes,'path length  = sum(��d)')
    xlabel(handles.PathLengthAxes,'time (sec)') 
    ylabel(handles.PathLengthAxes,'path length (nm) or nm/sec') 
        
    title(handles.DistanceAxes,'displacement  = sqrt[(X(i)-X(0))^2+(Y(i)-Y(0))^2]')
    xlabel(handles.DistanceAxes,'time (sec)') 
    ylabel(handles.DistanceAxes,'distance (nm) or nm/sec') 
    
    title(handles.XYScatterAxes,'Drift-correctedXY,from Blue to Red')
    xlabel(handles.XYScatterAxes,'x (nm)') 
    ylabel(handles.XYScatterAxes,'y (nm)') 
     
end

