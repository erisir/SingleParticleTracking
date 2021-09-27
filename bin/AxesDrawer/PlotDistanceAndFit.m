function [slopes] = PlotDistanceAndFit(handles,displacement,frameIndicator,distanceMd,TracesId,colorCode,fitError,Amplitude)
%PLOTDISTANCEANDFIT  
%         
    global gTraces;
    smDisplacement = smooth(displacement,3);
    
    yyaxis(handles.DistanceAxes,'left');
    hold(handles.DistanceAxes, 'off');
    pltDisplacement = plot(handles.DistanceAxes,frameIndicator,smDisplacement,'LineWidth',1.2);  %plot the smooth distance
    %xlim(handles.DistanceAxes,[0,300]);
    %ylim(handles.DistanceAxes,[0,100]);
    hold(handles.DistanceAxes, 'on');
    pltDisplacement2 = plot(handles.DistanceAxes,frameIndicator,displacement,'ko','Markersize',1); %plot raw smooth in backgroud in a transparent way      
    pltDisplacement2.Color(4) = 0.2;
    pltError = plot(handles.DistanceAxes,frameIndicator,fitError,'r');
    pltError.Color(4) = 0.8;
    
    res= ylim(handles.DistanceAxes);
    yMax = floor(res(2));
    x = ones(1,yMax);
    y = 1:yMax;
    plot(handles.DistanceAxes,str2num(distanceMd(1))*x,y,'b-');
    plot(handles.DistanceAxes,str2num(distanceMd(2))*x,y,'r-');
    
   
    
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

        pltP1 = plot(handles.DistanceAxes,frameIndicator(fitStart:fitEnd),P1(1)*frameIndicator(fitStart:fitEnd)+P1(2),'--r','LineWidth',2);
        if get(handles.DistanceAxes_Show_Both_Slope,'value')
            plot(handles.DistanceAxes,str2num(distanceMd(3))*x,y,'b-','LineWidth',1.1);
            plot(handles.DistanceAxes,str2num(distanceMd(4))*x,y,'r-','LineWidth',1.1);
            pltP2 = plot(handles.DistanceAxes,frameIndicator(fitStart2:fitEnd2),P2(1)*frameIndicator(fitStart2:fitEnd2)+P2(2),'--r','LineWidth',2);
        end
        slopes(1) = P1(1);
        slopes(2) = P2(1);
        pltP1.Color(4) = 0.6;
        pltP2.Color(4) = 0.6;
    catch ME
         LogMsg(handles,ME.identifier);
    end

    if nargin == 8
        yyaxis(handles.DistanceAxes,'right');
        hold(handles.DistanceAxes, 'off');
        pltAmp = plot(handles.DistanceAxes,frameIndicator,Amplitude,'-.g');  %plot the smooth distance
        pltAmp.Color(4) = 0.7;
        yStickMax = max(Amplitude);
        yStickMax =yStickMax*1.2;
        if yStickMax<800
            yStickMax = 800;
        end
        ylim(handles.DistanceAxes,[0,yStickMax]);
    end
    


    grid(handles.DistanceAxes, 'on');
    drawnow
    set(pltDisplacement.Edge, 'ColorBinding','interpolated', 'ColorData',colorCode);
    set(handles.DistanceAxes,'ButtonDownFcn', {@DistanceAxes_ButtonDownFcn,handles});  
    title(handles.DistanceAxes,['Distance from landing site:  TraceId= ',num2str(TracesId),'  STD = ',num2str(std(displacement),2),'  FitErr = ',num2str(mean(fitError),2),   '  Inteisity = ',num2str(mean(Amplitude),4)]);
    time_per_framems = str2num(get(handles.Frame_Expusure_Timems,'String'))+str2num(get(handles.Frame_Transfer_Timems,'String'));
    fps = 1000/time_per_framems;
    xlabel(handles.DistanceAxes,['frame ( fps=',num2str(fps,4),', ',num2str(1000/fps,4),'ms/frame)']); 
    ylabel(handles.DistanceAxes,'distance (nm)') ;
  
end

