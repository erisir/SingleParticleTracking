function [slopes] = PlotToIllustrator(handles,displacement,frameIndicator,D,traces,TracesId,cd,fitError)
%PLOTDISTANCEANDFIT  
%    

frameIndicator = frameIndicator*1.037;
frameIndicator = frameIndicator - min(frameIndicator);

smDisplacement = smooth(displacement,3);
pltDisplacement = plot(handles.DistanceAxes,frameIndicator,smDisplacement,'LineWidth',2);  %plot the smooth distance

hold(handles.DistanceAxes, 'on');
pltDisplacement2 = plot(handles.DistanceAxes,frameIndicator,displacement,'-k*','Markersize',1.5); %plot raw smooth in backgroud in a transparent way      
pltDisplacement2.Color(4) = 0.2;


hold(handles.DistanceAxes, 'off');
drawnow
set(pltDisplacement.Edge, 'ColorBinding','interpolated', 'ColorData',cd);

ha=gca; % current axis
title(handles.DistanceAxes,'Static');%Jump,Static Processive
xticks(0:20:100)
yticks(0:20:80)
ha.XAxis.MinorTick = 'on'; % Must turn on minor ticks if they are off
ha.YAxis.MinorTick = 'on'; % Must turn on minor ticks if they are off
ha.XAxis.MinorTickValues = 0:10:100; % Minor ticks which don't line up with majors
ha.YAxis.MinorTickValues = 0:10:80; % Minor ticks which don't line up with majors
%xticklabels({'x = 0','x = 5','x = 10'})
xlim([0 100]);
ylim([0 80]);
xlabel(handles.DistanceAxes,'Time (s)') 
ylabel(handles.DistanceAxes,'Distance (nm)') 


set(ha,'FontSize',30,'LineWidth',1.5,'XScale','linear','YScale','linear'); %,'YScale','log'

slopes=[1 2];
end

