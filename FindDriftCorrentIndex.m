function [index] = FindDriftCorrentIndex(fiducialFrameIndicator,frameIndicator)
%dicide which frame to substrate from
%   
index = [];
for i = 1:size(frameIndicator,1)
    temp = find(fiducialFrameIndicator==frameIndicator(i));
    if(isempty(temp))
        disp("error in finding the index for sub");
        return;
    end
    index = [index;temp];
end

