function [driftx,drifty,smoothDriftx,smoothDrifty] = SmoothDriftTraces(Traces,fiducialIndex) 
    
    Traces.Config.LastFrame=700;
    Traces.Config.FirstFrame=11;
    driftx = zeros(Traces.Config.LastFrame-Traces.Config.FirstFrame+1,1);
    drifty = driftx;     
    
    fiducialNums = size(fiducialIndex,2);
    for i = 1:fiducialNums
        xPos =Traces.molecules(fiducialIndex(i)).Results(:,3);
        yPos =Traces.molecules(fiducialIndex(i)).Results(:,4);       
        driftx = driftx+xPos;
        drifty = drifty+yPos;       
    end
 
    driftx = driftx/fiducialNums;
    drifty = drifty/fiducialNums;
    driftx = driftx -driftx(1);
    drifty = drifty -drifty(1);
    
    smoothDriftx = smooth(driftx);
    smoothDrifty = smooth(drifty);
    
end

