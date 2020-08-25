function [] = GcaMouseDownFcnFindFiducial(object, eventdata,handle,index)
%GCAWINDOWMOUSEDOWNFCN 此处显示有关此函数的摘要
%   此处显示详细说明
global gTraces;
fiducialIndex = gTraces.fiducialMarkerIndex;
button = eventdata.Button;
 
if button == 1%add if not exist
    id = find(fiducialIndex==index);
    
    if isempty(id)
        fiducialIndex = [fiducialIndex,index];%if not there ,add one
        legend(object,'X');
        title(object,['\color{red}' num2str(index)]);
    end
end

if button ==3%remove if exist
    id = find(fiducialIndex==index);
    if ~isempty(id)
        if(size(fiducialIndex,2)>1)
            fiducialIndex(id) = [];%if it is there ,remove
            legend(object,'o');
            title(object,['\color{black}' num2str(index)]);
        end
    end
end

gTraces.fiducialMarkerIndex = fiducialIndex;

[gTraces.driftx,gTraces.drifty,gTraces.smoothDriftx,gTraces.smoothDrifty] = SmoothDriftTraces(gTraces,fiducialIndex);
framecolumn = gTraces.molecules(gTraces.fiducialMarkerIndex(1)).Results(:,1);
gTraces.fiducialFrameIndicator = framecolumn;%save the start frame of the ficucial for substrate

colNums = ceil(size(fiducialIndex,2)/2);
hold(handle, 'off');
plot(handle,0,0,'o');
hold(handle, 'on');
str = ["o"];
for i = 1:size(fiducialIndex,2)
    x = gTraces.molecules(fiducialIndex(i)).Results(:,3);
    y = gTraces.molecules(fiducialIndex(i)).Results(:,4);
    str = [str,string(fiducialIndex(i))];
    plot(handle,x-x(1),y-y(1));
end
str = [str,"smooth"];
plot(handle,gTraces.smoothDriftx,gTraces.smoothDrifty,'k*','markersize',10);
plot(handle,gTraces.smoothDriftx,gTraces.smoothDrifty,'k','markersize',10);
legend(handle,str);
    
end

