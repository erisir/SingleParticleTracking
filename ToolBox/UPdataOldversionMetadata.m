updateDataByRealTime =0;
if updateDataByRealTime ==1
    realTime = 1.0375;
    for i = 1:moleculeNums
        traceId = Indexs(i);
        metadata=gTraces.Metadata(traceId) ; 
        gTraces.Metadata(traceId).PathLengthSlope(1) = metadata.PathLengthSlope(1)/realTime;
        gTraces.Metadata(traceId).PathLengthSlope(2) = metadata.PathLengthSlope(2)/realTime;
        gTraces.Metadata(traceId).DistanceSlope(1) = metadata.DistanceSlope(1)/realTime;
        gTraces.Metadata(traceId).DistanceSlope(2) = metadata.DistanceSlope(2)/realTime;
        gTraces.Metadata(traceId).IntensityDwell(1) = metadata.IntensityDwell(1)*realTime;
    end
end