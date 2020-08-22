function [slopes] = PlotDistanceAndFit(handles,displacement,frameIndicator,D,traces,TracesId,cd,fitError)
%PLOTDISTANCEANDFIT  
%    
 
smDisplacement = smooth(displacement,3);
pltDisplacement = plot(handles.DistanceAxes,frameIndicator,smDisplacement,'LineWidth',1);  %plot the smooth distance

hold(handles.DistanceAxes, 'on');
pltDisplacement2 = plot(handles.DistanceAxes,frameIndicator,displacement,'-k*','Markersize',1); %plot raw smooth in backgroud in a transparent way      
pltDisplacement2.Color(4) = 0.2;
plot(handles.DistanceAxes,frameIndicator,fitError,'r');

slopes=[1 2];

hold(handles.DistanceAxes, 'off');

grid(handles.DistanceAxes, 'on');
drawnow
set(pltDisplacement.Edge, 'ColorBinding','interpolated', 'ColorData',cd);

title(handles.DistanceAxes,['displacement  = sqrt[(X(i)-X(0))^2+(Y(i)-Y(0))^2]  STD=',num2str(std(displacement)),'Err=',num2str(mean(fitError))]);
xlabel(handles.DistanceAxes,'frame') 
ylabel(handles.DistanceAxes,'distance (nm) or nm/sec') 
 
end

