function [] = ReFitTraces()
    global gTraces;   
    
    fiducialFrameIndicator =  gTraces.fiducialFrameIndicator;
    
    for TracesId = 1:size(gTraces.Metadata,2)
        results = gTraces.molecules(TracesId).Results;
        frameIndicator = results(:,1);    %time = results(:,2); fps is 1 so time is equal to frame
        absXposition = results(:,3);
        absYposition = results(:,4);       
        TracesId               
        driftCorrectIndex = FindDriftCorrentIndex(fiducialFrameIndicator,frameIndicator);
        relativePositionX = absXposition  - gTraces.smoothDriftx(driftCorrectIndex); 
        relativePositionY = absYposition  - gTraces.smoothDrifty(driftCorrectIndex); 
        relativePositionX = relativePositionX-relativePositionX(1);
        relativePositionY = relativePositionY-relativePositionY(1);   
        displacement = CalculateDisplacement(relativePositionX,relativePositionY);

        smDisplacement = smooth(displacement,3);
       
        metadata = gTraces.Metadata(TracesId).Distance;
        fitStart = find(frameIndicator==metadata(1));
        fitEnd = find(frameIndicator==metadata(2));
        try
            P1 = polyfit(frameIndicator(fitStart:fitEnd),smDisplacement(fitStart:fitEnd),1);
            gTraces.Metadata(TracesId).DistanceSlope(1)  = P1(1)/1.0375;
        catch
        end
        
    end    
end

