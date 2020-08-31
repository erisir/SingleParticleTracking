function [Index] = FindFiducialIndex(traces)
% find out which spot is the tetraspack
% base on the longest lifetime and good fit error

dwellTime = [];
for i = 1:traces.moleculenum
    dwellTime(i) = size(traces.molecules(i).Results(:,1),1);%get the size of framecolumn
end
Index = find(dwellTime ==max(dwellTime) );% the longest lifetime,assuming as tetraspeck

bigFitErrorIndex = [];
for i =1:size(Index,2)
    moleculeIndex = Index(i);
    results = traces.molecules(moleculeIndex).Results;
    fitError = results(:,9);
    if mean(fitError)>5
        bigFitErrorIndex = [bigFitErrorIndex,i];
    end
end

Index(bigFitErrorIndex) = [];% if the fitting error > 5, remove it from the candidate list

if(size(Index,2)> 20) % reduce it to 20 if there is too much,we don't need them all
    Index = Index(1:20);
end

%draw/show in new figure to remove someof them by right click/ add left
%click

global gTraces;
gTraces.Config.fiducialMarkerIndex = Index;
figure;
handle = subplot(1,1,1);
plot(handle,0,0,'o');
[driftx,drifty,smoothDriftx,smoothDrifty] = SmoothDriftTraces(traces,Index);

hold(handle,'on');
str = ["o"];
for i = 1:size(Index,2)
    x = traces.molecules(Index(i)).Results(:,3);
    y = traces.molecules(Index(i)).Results(:,4);
    str = [str,string(Index(i))];
    plot(handle,x-x(1),y-y(1));
end
str = [str,"smooth"];
plot(handle,smoothDriftx,smoothDrifty,'k*','markersize',10);
plot(handle,smoothDriftx,smoothDrifty,'k','markersize',10);
legend(handle,str);

figure;
colNums = ceil(size(Index,2)/2);
for i = 1:size(Index,2)
    x = traces.molecules(Index(i)).Results(:,3);
    y = traces.molecules(Index(i)).Results(:,4);
    ax = subplot(2,colNums,i);
    p=plot(x,y);
    legend('X');
    set(p,'ButtonDownFcn', {@GcaMouseDownFcnFindFiducial,handle,Index(i)});
    set(ax,'ButtonDownFcn', {@GcaMouseDownFcnFindFiducial,handle,Index(i)});
    title(['\color{red}' int2str(Index(i))]);
end
    
end



