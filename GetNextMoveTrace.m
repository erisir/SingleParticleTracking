% plot the trace we want to show [when click on the Pre/Next button on the UI, it changes the TracesId that pass here]
function [frameIndicator,displacement,LastDispId] = GetNextMoveTrace(traces,index)
        
    % get detail info by id,prepare necessary data for processing
    TracesId = traces.CurrentShowIndex(index);
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
    isMove = MovementDetectionByTraceId(traces,TracesId);
    LastDispId = index;
    if ~isMove  
        [frameIndicator,displacement,LastDispId] = GetNextMoveTrace(traces,index+1);
    end 
end

