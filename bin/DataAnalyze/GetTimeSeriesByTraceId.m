% plot the trace we want to show [when click on the Pre/Next button on the UI, it changes the TracesId that pass here]
function series = GetTimeSeriesByTraceId(TracesId,noDriftCorrection)
        
    % get detail info by id,prepare necessary data for processing
    global gTraces;
    if nargin < 2
        noDriftCorrection =1;
        if isfield(gTraces,'fiducialFrameIndicator')
            noDriftCorrection =0;
        end
    end

    
    results = gTraces.molecules(TracesId).Results;
    drift = gTraces.molecules(TracesId).Drift;
    %drift = 0;
    frameIndicator = results(:,1);    %time = results(:,2); fps is 1 so time is equal to frame
    
    time = results(:,2); %fps is 1 so time is equal to frame
    absXposition = results(:,3);
    absYposition = results(:,4);   
    Amplitude =  results(:,8);
    fitError = results(:,9);
    if (drift == 1) || noDriftCorrection ==1
        relativePositionX = absXposition  - absXposition(1); 
        relativePositionY = absYposition  - absYposition(1); 
    else
        correctIndex = FindDriftCorrentIndex( gTraces.fiducialFrameIndicator,frameIndicator);
        relativePositionX = absXposition  - gTraces.driftx(correctIndex);
        relativePositionY = absYposition  - gTraces.drifty(correctIndex); 
    end
  
    relativePositionX = relativePositionX-relativePositionX(1);
    relativePositionY = relativePositionY-relativePositionY(1);
    
    smoothRelativePosX = smooth(relativePositionX, gTraces.Config.smoothWindowSize);
    smoothRelativePosY = smooth(relativePositionY, gTraces.Config.smoothWindowSize); 
    
    displacement = CalculateDisplacement(relativePositionX,relativePositionY);
    pathlenght = CalculatePathLengh(smoothRelativePosX,smoothRelativePosY);
    
    series.frameIndicator = frameIndicator;
    series.time = time;
    series.absXposition = absXposition;
    series.absYposition = absYposition;
    series.Amplitude = Amplitude;
    series.fitError = fitError;
    
    series.relativePositionX = relativePositionX;
    series.relativePositionY = relativePositionY;
    series.displacement = displacement;
    series.pathlenght = pathlenght;

end

