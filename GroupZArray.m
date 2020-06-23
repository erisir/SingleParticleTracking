function [returnArray] = GroupZArray(inputArray,groupSize,method)
%GROUPZARRAY GroupZArray of a 1D array
%   defaut method is sum 
%   inputArray = [1,1,2,2,3,3,4,4],
%   GroupZArray(inputArray,2) returns [2,4,6,8]
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

