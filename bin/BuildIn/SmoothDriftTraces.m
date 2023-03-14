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
        xPos = interp1(frameIndicator,xPos,frames(frameIndicator(1):frameIndicator(end)));
        yPos = interp1(frameIndicator,yPos,frames(frameIndicator(1):frameIndicator(end)));
        xPosBefore = [];
        yPosBefore = [];
        xPosAfter = [];
        yPosAfter = [];
        if frameIndicator(1)>1
            xPosBefore = xPos(1)*ones(frameIndicator(1)-1,1);
            yPosBefore = yPos(1)*ones(frameIndicator(1)-1,1);
        end
        if frameIndicator(end)<Traces.Config.StackSize
            xPosAfter = xPos(end)*ones(Traces.Config.StackSize-frameIndicator(end),1);
            yPosAfter = yPos(end)*ones(Traces.Config.StackSize-frameIndicator(end),1);
        end
        xPos = [xPosBefore;xPos;xPosAfter];
        yPos = [yPosBefore;yPos;yPosAfter];
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

