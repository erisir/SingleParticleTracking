function [index] = FindDriftCorrentIndex(fiducialFrameIndicator,frameIndicator)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
index = [];
for i = 1:size(frameIndicator,1)
    temp = find(fiducialFrameIndicator==frameIndicator(i));
    if(isempty(temp))
        disp("error in finding the index for sub");
        return;
    end
    index = [index;temp];
end
