function [intensity,PathLength,Distance] = GetMetadataByTracesId(traces,TracesId)
%GETMETADATABYTRACESID 此处显示有关此函数的摘要
%   此处显示详细说明 
    metadata = traces.Metadata(TracesId);
    intensityLow1 = string(metadata.Intensity(1));
    intensityLow2 = string(metadata.Intensity(3));
    intensityHigh1 = string(metadata.Intensity(2));
    intensityHigh2 = string(metadata.Intensity(4));
    IntensityDwell = string(metadata.IntensityDwell(1));
    IntensityDwel2 = string(metadata.IntensityDwell(2));
    
    intensity = [intensityLow1;intensityHigh1;intensityLow2;intensityHigh2;IntensityDwell;IntensityDwel2];
    
    PathLengthHigh1 = string(metadata.PathLength(2));
    PathLengthHigh2 = string(metadata.PathLength(4));
    PathLengthLow1 = string(metadata.PathLength(1));
    PathLengthLow2 = string(metadata.PathLength(3));
    PathLengthSlope1 = string(metadata.PathLengthSlope(1));
    PathLengthSlope2 = string(metadata.PathLengthSlope(2));
    PathLength = [PathLengthLow1;PathLengthHigh1;PathLengthLow2;PathLengthHigh2;PathLengthSlope1;PathLengthSlope2];
    
    DistanceHigh1 = string(metadata.Distance(2));
    DistanceHigh2 = string(metadata.Distance(4));
    DistanceLow1 = string(metadata.Distance(1));
    DistanceLow2 = string(metadata.Distance(3));
    DistanceSlope1 = string(metadata.DistanceSlope(1));
    DistanceSlope2 = string(metadata.DistanceSlope(2));
    Distance= [DistanceLow1;DistanceHigh1;DistanceLow2;DistanceHigh2;DistanceSlope1;DistanceSlope2];
end

