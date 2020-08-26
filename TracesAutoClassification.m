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
      
        %data processing drift correction and smoothing 
        %drift correct , substraced by the smooth result of mean drifft 
        %*****************************************************************
        %this is key part of the drift-correction 
        %  absXposition  -the raw x,y data from fiesta
        %  traces.smoothDriftx  -the smooth(and mean)results of drift data
        %they are in different array size, in order to 
        %do a valid substraction,we need to introduce the frameIndicator
        %   frameIndicator is a column that specifies the real frame num to
        %current data(because the skip frame of fiesta due to photo-blinking)
        %the frame is not necessary to be continue for each spot,however,
        %the frame is continue in cases of fiducial marker, directly substraction
        %will cause mismatch
        %*****************************************************************
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

