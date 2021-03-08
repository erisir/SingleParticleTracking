function SetTraceQuality(handles,dataQuality)
%SETTRACEQUALITY  
%    
    global gTraces;
    CurrentDisplayIndex= str2num(get(handles.Current_Trace_Id,'String'));
    traceId = gTraces.CurrentShowIndex(CurrentDisplayIndex);
    gTraces.Metadata(traceId).DataQuality = dataQuality;
end

