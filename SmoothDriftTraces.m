function [driftx,drifty,smoothDriftx,smoothDrifty] = SmoothDriftTraces(Traces,fiducialIndex) 
    dx  =Traces.molecules(fiducialIndex(1)).Results(:,3);
    dy  =Traces.molecules(fiducialIndex(1)).Results(:,4);
    fiducialNums = size(fiducialIndex,2);
    if fiducialNums>1
        for i = 2:fiducialNums
            tempx =Traces.molecules(fiducialIndex(i)).Results(:,3);
            tempy =Traces.molecules(fiducialIndex(i)).Results(:,4);
            dx = dx  +tempx;
            dy = dy  +tempy;
        end
        dx = dx - dx(1);
        dy = dy - dy(1);
    end
    driftx = dx/fiducialNums;
    drifty = dy/fiducialNums;
    smoothDriftx = smooth(driftx);
    smoothDrifty = smooth(drifty);
    
    plotFlag =0;
    if plotFlag ==1
        figure;
        plot(smoothDriftx,smoothDrifty);
    end
end

