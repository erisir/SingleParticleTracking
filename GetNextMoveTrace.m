% plot the trace we want to show [when click on the Pre/Next button on the UI, it changes the TracesId that pass here]
function [frameIndicator,displacement,LastTracesId] = GetNextMoveTrace(traces,TracesId)
        
    % get detail info by id,prepare necessary data for processing
    results = traces.molecules(TracesId).Results;
    fiducialFrameIndicator =  traces.fiducialFrameIndicator;
    frameIndicator = results(:,1);    %time = results(:,2); fps is 1 so time is equal to frame
    absXposition = results(:,3);
    absYposition = results(:,4);   
    fitError = results(:,9);
    driftCorrectIndex = FindDriftCorrentIndex(fiducialFrameIndicator,frameIndicator);
    relativePositionX = absXposition  - traces.smoothDriftx(driftCorrectIndex); 
    relativePositionY = absYposition  - traces.smoothDrifty(driftCorrectIndex); 
 
    relativePositionX = relativePositionX-relativePositionX(1);
    relativePositionY = relativePositionY-relativePositionY(1);
   
    displacement = CalculateDisplacement(relativePositionX,relativePositionY);
    isMove = MovementDetection(displacement,fitError);
    LastTracesId = TracesId;
    if ~isMove
        [frameIndicator,displacement,LastTracesId] = GetNextMoveTrace(traces,TracesId+1);
    end
end

