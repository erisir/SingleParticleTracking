function [driftx,drifty,smoothDriftx,smoothDrifty] = SmoothDriftTraces(Traces,fiducialIndex) 
    dx  =Traces.molecules(fiducialIndex(1)).Results(:,3);
    dy  =Traces.molecules(fiducialIndex(1)).Results(:,4);
    for i = 2:2
        tempx =Traces.molecules(fiducialIndex(i)).Results(:,3);
        tempy =Traces.molecules(fiducialIndex(i)).Results(:,4);
        dx = dx  +tempx;
        dy = dy  +tempy;
    end
    dx = dx - dx(1);
    dy = dy - dy(1);
    driftx = dx/2;
    drifty = dy/2;
    smoothDriftx = smooth(driftx);
    smoothDrifty = smooth(drifty);
end

