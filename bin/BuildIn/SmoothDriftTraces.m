function [driftx,drifty,smoothDriftx,smoothDrifty] = SmoothDriftTraces(Traces,fiducialIndex) 
    
    frames = Traces.Config.FirstFrame:Traces.Config.LastFrame;
    frames = frames';
    driftx = zeros(Traces.Config.StackSize,1);
    drifty = zeros(Traces.Config.StackSize,1);     
    
    fiducialNums = numel(fiducialIndex);
    for i = 1:fiducialNums
        frameIndicator = Traces.molecules(fiducialIndex(i)).Results(:,1);
        xPos   = Traces.molecules(fiducialIndex(i)).Results(:,3);
        yPos   = Traces.molecules(fiducialIndex(i)).Results(:,4);  
        xPos = interp1(frameIndicator,xPos,frames);
        yPos = interp1(frameIndicator,yPos,frames);
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

