function [] = GcaMouseDownFcnFindFiducial(object, eventdata,p,handle,index)
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
        p.Color = [0,1,0];
    end
end

if button ==3%remove index from fiducial list
    id = find(fiducialIndex==index);
    if ~isempty(id)
        if(size(fiducialIndex,2)>1)
            fiducialIndex(id) = [];%if it is there ,remove
            legend(object,'O');
            p.Color = [1,0,0];
        end
    end
end

gTraces.Config.fiducialMarkerIndex = fiducialIndex;

[gTraces.driftx,gTraces.drifty,gTraces.smoothDriftx,gTraces.smoothDrifty] = SmoothDriftTraces(gTraces,fiducialIndex);
gTraces.fiducialFrameIndicator = gTraces.Config.FirstFrame:gTraces.Config.LastFrame;%save the start frame of the ficucial for substration

 

plot(handle,0,0,'o');%clean up
hold(handle, 'off');
str = [];
for i = 1:size(fiducialIndex,2)
    x = gTraces.molecules(fiducialIndex(i)).Results(:,3);
    y = gTraces.molecules(fiducialIndex(i)).Results(:,4);
    str = [str,string(fiducialIndex(i))];
    plot(handle,abs(x-x(end)),abs(y-y(end)));%
    hold(handle,'on');  
end
str = [str,"smooth"];
sx = gTraces.smoothDriftx; 
sy = gTraces.smoothDrifty;

plot(handle,abs(sx-sx(end)),abs(sy-sy(end)),'k*','markersize',10);
plot(handle,abs(sx-sx(end)),abs(sy-sy(end)),'k','markersize',10);
 
legend(handle,str);
    
end

