function [isMove] = MovementDetection(displacement,fitError)
%MOVEMENTDETECTION Summary of this function goes here
%   Detailed explanation goes here
if mean(fitError)>7
    isMove = false;
    return;
end
meanv = mean(displacement);
maxv = max(displacement);
minv = min(displacement);
stdv = std(displacement);
if maxv - minv <15
    isMove = false;
    return;
end


isMove = true;
end

