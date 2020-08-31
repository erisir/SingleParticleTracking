function [] = TracesAutoClassification ()
%AUTOCLASSIFCATION Summary of this function goes here
%   Detailed explanation goes here
    global gTraces;
    for TracesId = 1:size(gTraces.Metadata,2)   
        % get detail info by id,prepare necessary data for processing
        fiducialFrameIndicator =  gTraces.fiducialFrameIndicator;
        results = gTraces.molecules(TracesId).Results;
        frameIndicator = results(:,1);    %time = results(:,2); fps is 1 so time is equal to frame
        absXposition = results(:,3);
        absYposition = results(:,4);
        fitError = results(:,9);

        driftCorrectIndex = FindDriftCorrentIndex(fiducialFrameIndicator,frameIndicator);
        relativePositionX = absXposition  - gTraces.smoothDriftx(driftCorrectIndex); 
        relativePositionY = absYposition  - gTraces.smoothDrifty(driftCorrectIndex); 

        relativePositionX = relativePositionX-relativePositionX(1);
        relativePositionY = relativePositionY-relativePositionY(1);

        displacement = CalculateDisplacement(relativePositionX,relativePositionY);       

        if ~MovementDetection(displacement,fitError)
            gTraces.Metadata(TracesId).SetCatalog = "All";
            gTraces.Metadata(TracesId).DataQuality = "Bad";       
        end

    end
end

