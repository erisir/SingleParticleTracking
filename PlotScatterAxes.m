function [] = PlotScatterAxes(handles,datalength,relativePositionX,relativePositionY,smoothRelativePosX,smoothRelativePosY,cd)
%PLOTSCATTERAXES �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
pltXYscatter = plot(handles.XYScatterAxes,smoothRelativePosX,smoothRelativePosY,'LineWidth',1.2);  %smoothed xy scatter plot 
hold(handles.XYScatterAxes, 'on');
plot(handles.XYScatterAxes,relativePositionX(1),relativePositionY(1),'*b','Markersize',10);%mark it as the beginning
plot(handles.XYScatterAxes,relativePositionX(datalength),relativePositionY(datalength),'*r','Markersize',10);%mark it as the end
p42 = plot(handles.XYScatterAxes,relativePositionX,relativePositionY,'k');  %raw xy scatter plot in transparent
p42.Color(4) = 0.2;
hold(handles.XYScatterAxes, 'off');
grid(handles.XYScatterAxes, 'on');
drawnow
set(pltXYscatter.Edge, 'ColorBinding','interpolated', 'ColorData',cd);
title(handles.XYScatterAxes,'Drift-correctedXY,from Blue to Red')
xlabel(handles.XYScatterAxes,'x (nm)') 
ylabel(handles.XYScatterAxes,'y (nm)') 
end
