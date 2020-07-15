function [] = GcaMouseDownFcn(object, eventdata,handle,index)
%GCAWINDOWMOUSEDOWNFCN 此处显示有关此函数的摘要
%   此处显示详细说明
global gTraces;
fiducialIndex = gTraces.fiducialMarkerIndex;
button = eventdata.Button;
 
if button == 1%add if not exist
    id = find(fiducialIndex==index);
    if isempty(id)
        fiducialIndex = [fiducialIndex,index];%if not there ,add one
        legend(object,'√');
    end
end

if button ==3%remove if exist
    id = find(fiducialIndex==index);
    if ~isempty(id)
        if(size(fiducialIndex,2)>1)
            fiducialIndex(id) = [];%if it is there ,remove
            legend(object,'×');
        end
    end
end

gTraces.fiducialMarkerIndex = fiducialIndex;

[gTraces.driftx,gTraces.drifty,gTraces.smoothDriftx,gTraces.smoothDrifty] = SmoothDriftTraces(gTraces,fiducialIndex);
framecolumn = gTraces.molecules(gTraces.fiducialMarkerIndex(1)).Results(:,1);
gTraces.fiducialFrameIndicator = framecolumn;%save the start frame of the ficucial for substrate

colNums = ceil(size(fiducialIndex,2)/2);
hold(handle, 'off');
plot(handle,gTraces.smoothDriftx,gTraces.smoothDrifty,'r');
hold(handle, 'on');
str = ["smooth"];
for i = 1:size(fiducialIndex,2)
    x = gTraces.molecules(fiducialIndex(i)).Results(:,3);
    y = gTraces.molecules(fiducialIndex(i)).Results(:,4);
    str = [str,string(fiducialIndex(i))];
    plot(handle,x-x(1),y-y(1));
end
legend(handle,str);
    
end

