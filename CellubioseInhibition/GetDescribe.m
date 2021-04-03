function describe= GetDescribe(molecules,Metadatas,traceIds,time_per_frames)
% Use in plot histgram
%   
    describe = [];
    width = zeros(1,size(traceIds,2));
    intensity = zeros(1,size(traceIds,2));
    totalBindDuration = zeros(1,size(traceIds,2));
    dwellTimeBeforeMovement = zeros(1,size(traceIds,2));
    dwellTimeAfterMovement = zeros(1,size(traceIds,2));
    movingDuration1 = zeros(1,size(traceIds,2));
    movingDuration2 = zeros(1,size(traceIds,2));
    movingVelocity1 = zeros(1,size(traceIds,2));
    movingVelocity2 = zeros(1,size(traceIds,2));
    runLength1 = zeros(1,size(traceIds,2));
    runLength2 = zeros(1,size(traceIds,2));
    meanfitError = zeros(1,size(traceIds,2));
 
    for id = 1:size(traceIds,2)
        traceId = traceIds(id);
        results = molecules(traceId).Results;  
        metadata= Metadatas(traceId);
        width(id) =  mean(results(:,7));
        intensity(id) =  mean(results(:,8));
        fitError = mean(results(:,9));

        DataQuality = metadata.DataQuality;
        totalBindDuration(id) =       ( metadata.IntensityStartEndTimePoint(2) - metadata.IntensityStartEndTimePoint(1))*time_per_frames;
        dwellTimeBeforeMovement(id) = ( metadata.DistanceStartEndTimePoint(1) - metadata.IntensityStartEndTimePoint(1))*time_per_frames;
        dwellTimeAfterMovement(id) =  ( metadata.IntensityStartEndTimePoint(2)-metadata.DistanceStartEndTimePoint(2) )*time_per_frames;
        movingDuration1(id) =          ( metadata.DistanceStartEndTimePoint(2)-metadata.DistanceStartEndTimePoint(1) )*time_per_frames;
        movingDuration2(id) =          ( metadata.DistanceStartEndTimePoint(4)-metadata.DistanceStartEndTimePoint(3) )*time_per_frames;      
        
        if strcmp("Perfect",DataQuality)==1 || strcmp("Good",DataQuality)==1
            movingVelocity1(id) = metadata.DistanceSlope(1)/time_per_frames;  
            movingVelocity2(id) = metadata.DistanceSlope(2)/time_per_frames;   
            runLength1(id) = metadata.DistanceSlope(1)*(metadata.DistanceStartEndTimePoint(2)-metadata.DistanceStartEndTimePoint(1));
            runLength2(id) = metadata.DistanceSlope(2)*(metadata.DistanceStartEndTimePoint(4)-metadata.DistanceStartEndTimePoint(3));
           
        end
         meanfitError(id) = fitError;
    end
    movingVelocity1(find(movingVelocity1==0)) =[];
    movingVelocity2(find(movingVelocity2==0)) =[];
    runLength1(find(runLength1==0)) =[];
    runLength2(find(runLength2==0)) =[];
    meanfitError(find(meanfitError==0)) =[];
    
    describe.width = width;
    describe.intensity =  intensity;
    describe.totalBindDuration =totalBindDuration ;
    describe.dwellTimeBeforeMovement =dwellTimeBeforeMovement ;
    describe.dwellTimeAfterMovement = dwellTimeAfterMovement ;
    describe.movingDuration1 = movingDuration1;
    describe.movingDuration2 = movingDuration2;
    describe.movingVelocity1 = movingVelocity1;
    describe.movingVelocity2 = movingVelocity2;
    describe.runLength1 = runLength1;
    describe.runLength2 = runLength2;     
    describe.meanfitError = meanfitError;
end

