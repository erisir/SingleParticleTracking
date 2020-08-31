function [intensity,PathLength,Distance] = GetMetadataByTracesId(traces,TracesId)
%GETMETADATABYTRACESID  
%   
    metadata = traces.Metadata(TracesId);
    intensityLow1 = string(metadata.IntensityStartEndTimePoint(1));
    intensityLow2 = string(metadata.IntensityStartEndTimePoint(3));
    intensityHigh1 = string(metadata.IntensityStartEndTimePoint(2));
    intensityHigh2 = string(metadata.IntensityStartEndTimePoint(4));
    IntensityDwell = string(metadata.IntensityDwell(1));
    IntensityDwel2 = string(metadata.IntensityDwell(2));
    
    intensity = [intensityLow1;intensityHigh1;intensityLow2;intensityHigh2;IntensityDwell;IntensityDwel2];
    
    PathLengthHigh1 = string(metadata.PathLengthStartEndTimePoint(2));
    PathLengthHigh2 = string(metadata.PathLengthStartEndTimePoint(4));
    PathLengthLow1 = string(metadata.PathLengthStartEndTimePoint(1));
    PathLengthLow2 = string(metadata.PathLengthStartEndTimePoint(3));
    PathLengthSlope1 = string(metadata.PathLengthSlope(1));
    PathLengthSlope2 = string(metadata.PathLengthSlope(2));
    PathLength = [PathLengthLow1;PathLengthHigh1;PathLengthLow2;PathLengthHigh2;PathLengthSlope1;PathLengthSlope2];
    
    DistanceHigh1 = string(metadata.DistanceStartEndTimePoint(2));
    DistanceHigh2 = string(metadata.DistanceStartEndTimePoint(4));
    DistanceLow1 = string(metadata.DistanceStartEndTimePoint(1));
    DistanceLow2 = string(metadata.DistanceStartEndTimePoint(3));
    DistanceSlope1 = string(metadata.DistanceSlope(1));
    DistanceSlope2 = string(metadata.DistanceSlope(2));
    Distance= [DistanceLow1;DistanceHigh1;DistanceLow2;DistanceHigh2;DistanceSlope1;DistanceSlope2];
end

