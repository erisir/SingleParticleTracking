function [returnArray] = GroupZArray(inputArray,groupSize,method)
%GROUPZARRAY 此处显示有关此函数的摘要
%   此处显示详细说明
arraySize = max(size(inputArray));
newSize = floor(arraySize/groupSize);
if newSize <0
    returnArray = [-1];
    return
end
returnArray = ones(1,newSize)
for i=1:newSize
    sumStartIndex = (i-1)*groupSize + 1;
    sumEndIndex = i*groupSize;
    subArray = inputArray(sumStartIndex:sumEndIndex)
    returnArray(i) = sum(subArray);
end
end

