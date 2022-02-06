function [] = GcaMouseDownFcnFindFiducial(object, eventdata,handle,index)
%mouse down function, to select trace and show it on main window
%    
global gTraces;
fiducialIndex = gTraces.Config.fiducialMarkerIndex;
button = eventdata.Button;
 
if button == 1 
    id = find(fiducialIndex==index); %add index to fiducial list
    if isempty(id)
        fiducialIndex = [fiducialIndex,index];%if not there ,add one
        legend(object,'X');
    end
end

if button ==3%remove index from fiducial list
    id = find(fiducialIndex==index);
    if ~isempty(id)
        if(size(fiducialIndex,2)>1)
            fiducialIndex(id) = [];%if it is there ,remove
            legend(object,'O');
        end
    end
end

gTraces.Config.fiducialMarkerIndex = fiducialIndex;

[gTraces.driftx,gTraces.drifty,gTraces.smoothDriftx,gTraces.smoothDrifty] = SmoothDriftTraces(gTraces,fiducialIndex);
framecolumn = gTraces.molecules(gTraces.Config.fiducialMarkerIndex(1)).Results(:,1);
gTraces.fiducialFrameIndicator = framecolumn;%save the start frame of the ficucial for substration

 

plot(handle,0,0,'o');%clean up
hold(handle, 'off');
str = [];
for i = 1:size(fiducialIndex,2)
    x = gTraces.molecules(fiducialIndex(i)).Results(:,3);
    y = gTraces.molecules(fiducialIndex(i)).Results(:,4);
    str = [str,string(fiducialIndex(i))];
    plot(handle,x-x(1),y-y(1));%
    hold(handle,'on');  
end
str = [str,"smooth"];
sx = gTraces.smoothDriftx; 
sy = gTraces.smoothDrifty;

plot(handle,sx,sy,'k*','markersize',10);
plot(handle,sx,sy,'k','markersize',10);
legend(handle,str);
    
end

