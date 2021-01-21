function [pausingDuration,stepSize,meanValue] = FindDwellTimeAndStepSize(displacement,MinThreshold,startWithPausing)
%FINDDWELLTIMEANDSTEPSIZE Summary of this function goes here
%   Detailed explanation goes here
%startWithPausing:true pausing, false, moving
pos = findchangepts(displacement,'Statistic','mean','MinThreshold',MinThreshold);
pausingDuration = [];
for i = 1:(size(pos,2)-1)
    if startWithPausing % duration
        pausingDuration(i) = pos(i+1) - pos(i);
    else
        if i+2< size(pos,2)
            pausingDuration(i) = pos(i+2) - pos(i+1);
        end
    end
    meanValue(i) = mean(pos(i:(i+1)));
    
    if ~startWithPausing   %stepSize
        if i ==1
            stepSize(i) = meanValue(i)
        else
            
        end
    else
        
    end
        
end


end

