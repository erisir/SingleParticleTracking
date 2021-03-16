function [slopes] = PlotDistanceAndFit(handles,displacement,frameIndicator,distanceMd,TracesId,colorCode,fitError)
%PLOTDISTANCEANDFIT  
%    
    global gTraces;
    smDisplacement = smooth(displacement,3);
    pltDisplacement = plot(handles.DistanceAxes,frameIndicator,smDisplacement,'LineWidth',1);  %plot the smooth distance
    %xlim(handles.DistanceAxes,[0,300]);
    %ylim(handles.DistanceAxes,[0,100]);
    hold(handles.DistanceAxes, 'on');
    pltDisplacement2 = plot(handles.DistanceAxes,frameIndicator,displacement,'-k*','Markersize',1); %plot raw smooth in backgroud in a transparent way      
    pltDisplacement2.Color(4) = 0.2;
    plot(handles.DistanceAxes,frameIndicator,fitError,'r');

    res= ylim(handles.DistanceAxes);
    yMax = floor(res(2));
    x = ones(1,yMax);
    y = 1:yMax;
    plot(handles.DistanceAxes,str2num(distanceMd(1))*x,y,'b');
    plot(handles.DistanceAxes,str2num(distanceMd(2))*x,y,'r');
    plot(handles.DistanceAxes,str2num(distanceMd(3))*x,y,'b','LineWidth',1.1);
    plot(handles.DistanceAxes,str2num(distanceMd(4))*x,y,'r','LineWidth',1.1);
    currentDisplayFrame = floor(get(handles.Slider_Stack_Index,'Value'));
    if currentDisplayFrame ~= 0
        plot(handles.DistanceAxes,currentDisplayFrame*x,y,'k');
    end
    metadata = gTraces.Metadata(TracesId).DistanceStartEndTimePoint;% [1,2,3,4]
    fitStart = find(frameIndicator==metadata(1));
    fitEnd = find(frameIndicator==metadata(2));
    fitStart2 = find(frameIndicator==metadata(3));
    fitEnd2 = find(frameIndicator==metadata(4));

    try

        P1 = polyfit(frameIndicator(fitStart:fitEnd),smDisplacement(fitStart:fitEnd),1);
        P2 = polyfit(frameIndicator(fitStart2:fitEnd2),smDisplacement(fitStart2:fitEnd2),1);

        pltP1 = plot(handles.DistanceAxes,frameIndicator(fitStart:fitEnd),P1(1)*frameIndicator(fitStart:fitEnd)+P1(2),'r','LineWidth',2);
        if get(handles.DistanceAxes_Show_Both_Slope,'value')
            pltP2 = plot(handles.DistanceAxes,frameIndicator(fitStart2:fitEnd2),P2(1)*frameIndicator(fitStart2:fitEnd2)+P2(2),'r','LineWidth',2);
        end
        slopes(1) = P1(1);
        slopes(2) = P2(1);
        pltP1.Color(4) = 0.4;
        pltP2.Color(4) = 0.4;
    catch ME
         LogMsg(handles,ME.identifier);
    end


    hold(handles.DistanceAxes, 'off');

    grid(handles.DistanceAxes, 'on');
    drawnow
    set(pltDisplacement.Edge, 'ColorBinding','interpolated', 'ColorData',colorCode);
    set(handles.DistanceAxes,'ButtonDownFcn', {@DistanceAxes_ButtonDownFcn,handles});  
    title(handles.DistanceAxes,['displacement  = sqrt[(X(i)-X(0))^2+(Y(i)-Y(0))^2]  STD=',num2str(std(displacement)),'Err=',num2str(mean(fitError))]);
    time_per_framems = str2num(get(handles.Frame_Expusure_Timems,'String'))+str2num(get(handles.Frame_Transfer_Timems,'String'));
    fps = 1000/time_per_framems;
    xlabel(handles.DistanceAxes,['frame ( fps=',num2str(fps,4),', ',num2str(1000/fps,4),'ms/frame)']); 
    ylabel(handles.DistanceAxes,'distance (nm)') ;
  
end

