function [outputArg1,outputArg2] = PlotTheIntensityTrace(handles,images,timesec,Amplitude,I)
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
currentDisplayFrame = floor(get(handles.Slider_Stack_Index,'Value'));
plot(handles.IntensityAxes,timesec,Amplitude,'g');%plot the amplitude generated from fiesta, which should be same with what we calculate.
hold(handles.IntensityAxes,'on');
plot(handles.IntensityAxes,timesec,Amplitude,'.k','markersize',1.2);

res= ylim(handles.IntensityAxes);
yMax = floor(res(2));
x = ones(1,yMax);
y = 1:yMax;

plot(handles.IntensityAxes,str2num(I(1))*x,y,'b');
plot(handles.IntensityAxes,str2num(I(2))*x,y,'r');
plot(handles.IntensityAxes,str2num(I(3))*x,y,'.b','LineWidth',1.1);
plot(handles.IntensityAxes,str2num(I(4))*x,y,'.r','LineWidth',1.1);

 
plot(handles.IntensityAxes,currentDisplayFrame*x,y,'-k');
       
        
hold(handles.IntensityAxes,'off');
grid(handles.IntensityAxes,'on');

title(handles.IntensityAxes,'Intensity of the spot [mean(x),mean(y)]')
xlabel(handles.IntensityAxes,'frame') 
ylabel(handles.IntensityAxes,'intensity (a.u.)') 
    
end

