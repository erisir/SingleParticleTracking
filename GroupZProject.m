function [outputImageStack] = GroupZProject(imageStack,groupSize)
%GROUPZPROJECT 此处显示有关此函数的摘要
%   此处显示详细说明
[height,width,stackSize]= size(imageStack);
if mod(stackSize,groupSize) ~= 0 || stackSize<groupSize
    outputImageStack = [];
    return
end
newStackSize = floor(stackSize/groupSize);
if CheckGpuSupported()
    outputImageStack = zeros(height,width,newStackSize,'uint16','gpuArray');
else
    outputImageStack = zeros(height,width,newStackSize,'uint16');
end

for i = 1:newStackSize
    startIndex = (i-1)*groupSize+1;
    endIndex = i*groupSize;
    outputImageStack(:,:,i) = uint16(mean(imageStack(:,:,startIndex:endIndex),3));
end

