function [Index] = FindFiducialIndex(handles)
% find out which spot is the tetraspack
% base on the longest lifetime and good fit error
global gTraces;
Index = -1;
gTraces.manualDriftCorrection = 0;
% find those particles that bright for 80% of time
corelationThreadhold = 0.59;%???
durationThreadhold = 0.95;
dwellTime = zeros(1,gTraces.moleculenum);
frames = gTraces.Config.FirstFrame:gTraces.Config.LastFrame;
if ~isfield(gTraces,'Metadata')
     LogMsg(handles,"You need to Initialize the metadata first!");
     beep();
     return;
end
for traceId = 1:gTraces.moleculenum
    dwellTime(traceId) = gTraces.Metadata(traceId).IntensityDwell(1);   
end

Index = find(dwellTime >= durationThreadhold*gTraces.Config.StackSize);% 80% of time being bright
fiducialDistance = zeros(numel(Index),gTraces.Config.StackSize);
for i =1:numel(Index)
    series = GetTimeSeriesByTraceId(Index(i));
    distance = interp1(series.frameIndicator,series.displacement,frames);
    distance(find(isnan(distance))) = 0;
    fiducialDistance(i,:) = normalize(distance,'range', [0 1]);
end
meanDistance = mean(fiducialDistance,1);
meanDistance = normalize(meanDistance,'range', [0 1]);

corelation = zeros(1,numel(Index));

for i =1:numel(Index)
    corelation(i) = sum( meanDistance.*fiducialDistance(i,:));
end

[sortIncValue,sortIndex] = sort(corelation);
IndexFound = Index(sortIndex(find(sortIncValue >= corelationThreadhold)));
findNumber = size(IndexFound,2);
disp(['Tracking - found: ',num2str(findNumber),' fiducial markers!'])
if(size(IndexFound,2)> 20) % reduce it to 20 if there is too much,we don't need them all
    IndexFound = Index(sortIndex(end-19:end));
end

%draw/show in new figure to remove someof them by right click/ add left
%click
gTraces.Config.fiducialMarkerIndex = IndexFound; 
Index = IndexFound;
figure('name','Fiducial Marker overlaping panel');
handle = subplot(1,1,1);
plot(handle,0,0,'o');
[driftx,drifty,smoothDriftx,smoothDrifty] = SmoothDriftTraces(gTraces,Index);
hold(handle,'on');
str = ["o"];
for i = 1:size(Index,2)
    x = gTraces.molecules(Index(i)).Results(:,3);
    y = gTraces.molecules(Index(i)).Results(:,4);
    str = [str,string(Index(i))];
    plot(handle,abs(x-x(end)),abs(y-y(end)));%
end
str = [str,"smooth"];
plot(handle,abs(smoothDriftx-smoothDriftx(end)),abs(smoothDrifty-smoothDrifty(end)),'k*','markersize',10);
plot(handle,abs(smoothDriftx-smoothDriftx(end)),abs(smoothDrifty-smoothDrifty(end)),'k','markersize',10);
legend(handle,str);



figure('name','Fiducial Marker selection panel');
colNums = ceil(size(Index,2)/2);
for i = 1:size(Index,2)
    x = gTraces.molecules(Index(i)).Results(:,3);
    y = gTraces.molecules(Index(i)).Results(:,4);
    ax = subplot(2,colNums,i);
    p=plot(x,y);
    legend('X');
    %set(p,'ButtonDownFcn', {@GcaMouseDownFcnFindFiducial,handle,Index(i)});
    set(ax,'ButtonDownFcn', {@GcaMouseDownFcnFindFiducial,p,handle,Index(i)});
    title(['\color{red}' int2str(Index(i))]);
end
    
end



