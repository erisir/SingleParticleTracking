function [res] = isTimePointInTrustBands(trustBands,trackId)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if isempty(trustBands)
    res = true;
    return;
end

trustBands = split(trustBands,';');
bands = zeros(size(trustBands,1),2);
for i = 1:size(trustBands,1)
    temp = split(trustBands(i),',');
    bands(i,1) = str2num(temp{1});
    bands(i,2) = str2num(temp{2});
end

global gTraces;
results = gTraces.molecules(trackId).Results;

time = results(:,2); 
timeStart = time(1);
timeEnd = time(end);

for i = 1:size(bands,1)
    if ( timeStart >bands(i,1) ) && (timeEnd < bands(i,2) )
        res = true;
        return;
    end
end
res = false;
end

