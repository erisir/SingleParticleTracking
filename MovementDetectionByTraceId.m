function [isMove] = MovementDetectionByTraceId(traces,traceId)
%MOVEMENTDETECTION Summary of this function goes here
%   Detailed explanation goes here
isMove = true;
 
results = traces.molecules(traceId).Results;
traces.Config.MaximumMoveDistance = 100;
fiducialFrameIndicator =  traces.fiducialFrameIndicator;
frameIndicator = results(:,1);    %time = results(:,2); fps is 1 so time is equal to frame
absXposition = results(:,3);
absYposition = results(:,4);   
 
driftCorrectIndex = FindDriftCorrentIndex(fiducialFrameIndicator,frameIndicator);
relativePositionX = absXposition  - traces.smoothDriftx(driftCorrectIndex); 
relativePositionY = absYposition  - traces.smoothDrifty(driftCorrectIndex); 

relativePositionX = relativePositionX-relativePositionX(1);
relativePositionY = relativePositionY-relativePositionY(1);

displacement = CalculateDisplacement(relativePositionX,relativePositionY);
smDisplacement = smooth(displacement,5);

maxv = max(smDisplacement);
minv = min(smDisplacement);

if maxv - minv <traces.Config.MinimumMoveDistance
    isMove = false;
    return;
end
if maxv - minv > traces.Config.MaximumMoveDistance
    isMove = false;
    return;
end
isMove = true;

end

