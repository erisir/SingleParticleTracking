function [returnArray] = GroupZArray(inputArray,groupSize,method)
%GROUPZARRAY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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

