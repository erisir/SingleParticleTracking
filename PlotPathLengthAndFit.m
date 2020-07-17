function [slopes] = PlotPathLengthAndFit(handles,pathlenght,frameIndicator,P,traces,TracesId,cd)
%PLOTPATHLENGTHANDFIT 此处显示有关此函数的摘要
%   此处显示详细说明
smPathLength = smooth(pathlenght,3);
pltPathLength = plot(handles.PathLengthAxes,frameIndicator,smPathLength,'-','LineWidth',1);  %plot the smooth pathlength
hold(handles.PathLengthAxes, 'on');
pltPathLength2 = plot(handles.PathLengthAxes,frameIndicator,pathlenght,'-k*','Markersize',1);%plot raw pathlength in backgroud in a transparent way      
pltPathLength2.Color(4) = 0.2;
res= ylim(handles.PathLengthAxes);
yMax = floor(res(2));
x = ones(1,yMax);
y = 1:yMax;
plot(handles.PathLengthAxes,str2num(P(1))*x,y,'b');
plot(handles.PathLengthAxes,str2num(P(2))*x,y,'r');
plot(handles.PathLengthAxes,str2num(P(3))*x,y,'b','LineWidth',1.1);
plot(handles.PathLengthAxes,str2num(P(4))*x,y,'r','LineWidth',1.1);

currentDisplayFrame = floor(get(handles.Slider_Stack_Index,'Value'));
plot(handles.PathLengthAxes,currentDisplayFrame*x,y,'k');

metadata = traces.Metadata(TracesId).PathLength;
fitStart = find(frameIndicator==metadata(1));
fitEnd = find(frameIndicator==metadata(2));
fitStart2 = find(frameIndicator==metadata(3));
fitEnd2 = find(frameIndicator==metadata(4));

try
    P1 = polyfit(frameIndicator(fitStart:fitEnd),smPathLength(fitStart:fitEnd),1);
    P2 = polyfit(frameIndicator(fitStart2:fitEnd2),smPathLength(fitStart2:fitEnd2),1);
    pltP1 = plot(handles.PathLengthAxes,frameIndicator(fitStart:fitEnd),P1(1)*frameIndicator(fitStart:fitEnd)+P1(2),'r','LineWidth',2);
    pltP2 = plot(handles.PathLengthAxes,frameIndicator(fitStart2:fitEnd2),P2(1)*frameIndicator(fitStart2:fitEnd2)+P2(2),'r','LineWidth',2);
    slopes(1) = P1(1);
    slopes(2) = P2(1);
    pltP1.Color(4) = 0.5;
    pltP2.Color(4) = 0.5;
catch ME
    LogMsg(handles,ME.identifier);
end
hold(handles.PathLengthAxes, 'off');
grid(handles.PathLengthAxes, 'on');
drawnow
set(pltPathLength.Edge, 'ColorBinding','interpolated', 'ColorData',cd);
title(handles.PathLengthAxes,'path length  = sum(△d)')
xlabel(handles.PathLengthAxes,'frame') 
ylabel(handles.PathLengthAxes,'path length (nm) or nm/sec') 
end

