function [isMove] = MovementDetectionByDisplacement(displacement,smoothWindow)
%MOVEMENTDETECTION Summary of this function goes here
%   Detailed explanation goes here
    global gTraces;
    
    smDisplacement = smooth(displacement,smoothWindow);
    
    maxv = max(smDisplacement);
    minv = min(smDisplacement);
    if maxv - minv <gTraces.Config.MinimumMoveDistance
        isMove = false;
        return;
    end
    if maxv - minv > gTraces.Config.MaximumMoveDistance
        isMove = false;
        return;
    end
    
    isMove = true;
end

