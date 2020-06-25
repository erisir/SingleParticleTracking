function [outputArg1,outputArg2] = PlotTheIntensityTrace(handles,images,frameIndicator,Amplitude,I)
%PLOTTHEINTENSITYTRACE  
%    
if get(handles.ShowRawIntensity ,'Value')
    try
        meanx = str2num(get(handles.CurrentPointXpos,'String'));
        meany = str2num(get(handles.CurrentPointYpos,'String'));
        
        plot(handles.IntensityAxes,GetZprojectIntensityByXY(images.rawImagesStack,meanx,meany)); %plot the intensity trace we calculate by ourself
        hold(handles.IntensityAxes,'on');
    catch
    end
end
currentDisplayFrame = floor(get(handles.StackProgress,'Value'));
plot(handles.IntensityAxes,frameIndicator,Amplitude,'g');%plot the amplitude generated from fiesta, which should be same with what we calculate.
hold(handles.IntensityAxes,'on');
res= ylim(handles.IntensityAxes);
yMax = floor(res(2));
x = ones(1,yMax);
y = 1:yMax;

plot(handles.IntensityAxes,str2num(I(1))*x,y,'b');
plot(handles.IntensityAxes,str2num(I(2))*x,y,'r');
plot(handles.IntensityAxes,str2num(I(3))*x,y,'.b','LineWidth',1.1);
plot(handles.IntensityAxes,str2num(I(4))*x,y,'.r','LineWidth',1.1);

axesRange = ylim(handles.IntensityAxes);
ymax = floor(axesRange(2));
x = currentDisplayFrame*ones(1,ymax);
y = 1:ymax;
plot(handles.IntensityAxes,x,y,'-k');
       
        
hold(handles.IntensityAxes,'off');
grid(handles.IntensityAxes,'on');

title(handles.IntensityAxes,'Intensity of the spot [mean(x),mean(y)]')
xlabel(handles.IntensityAxes,'time (sec)') 
ylabel(handles.IntensityAxes,'intensity (a.u.)') 
    
end

