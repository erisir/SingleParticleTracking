function [metadataListOut] = DataConversion(metadataList)
% adding metadata to traces to save the dwelltime, velocity ,etc,.
%   

for traceId = 1:size(metadataList,2)
    metadata = metadataList(traceId);
    type = metadata.SetCatalog;
    %["All";"Stuck_Go";"Go_Stuck";"Stuck_Go_Stuck";"Go_Stuck_Go";"NonLinear";"Stepping";"BackForward";"Diffusion";"Temp"];

    if strcmp(type,'Stuck_Go') || strcmp(type,'Stuck_Go_Stuck') || strcmp(type,'Go_Stuck') || strcmp(type,'Go_Stuck_Go') || strcmp(type,'NonLinear') || strcmp(type,'BackForward')   % stuck-move
        if (metadata.IntensityStartEndTimePoint(1) ~= metadata.DistanceStartEndTimePoint(1)) || (metadata.IntensityStartEndTimePoint(2) ~= metadata.DistanceStartEndTimePoint(2))
            refit = 1;
            discribe = GetTracesDescribe(traceId,1,refit); 
            metadataList(traceId) = discribe.metadata;
            
        end
    end
end
metadataListOut = metadataList;


