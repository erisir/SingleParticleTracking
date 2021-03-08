function [] = TracesAutoClassification ()
%AUTOCLASSIFCATION Summary of this function goes here
%   Detailed explanation goes here
    global gTraces;
    for traceId = 1:size(gTraces.Metadata,2)   
        % get detail info by id,prepare necessary data for processing
        series = GetTimeSeriesByTraceId(traceId);        

    end
end

