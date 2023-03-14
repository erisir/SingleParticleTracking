function  SetFittingsegment(handles,time)
%SETFITTINGSEGMENT  
%    
    global gTraces;
   

    index = str2num(get(handles.Current_Trace_Id,'String'));
    TraceId = gTraces.CurrentShowIndex(index);

    switch gTraces.LastSelectedList
        case 'Intensity_Section_List1'   
            selected  =floor(get(handles.Intensity_Section_List,'Value'));
            gTraces.Metadata(TraceId).IntensityStartEndTimePoint(selected) = time;
            
            slopes =PlotTrace(handles,index,1);
            
            intensity = gTraces.Metadata(TraceId).IntensityStartEndTimePoint;
            gTraces.Metadata(TraceId).IntensityDwell(1) = intensity(2)-intensity(1);
            gTraces.Metadata(TraceId).IntensityDwell(2) = intensity(4)-intensity(3);


        case 'PathLength_Section_List'  
            selected  =floor(get(handles.PathLength_Section_List,'Value'));
            gTraces.Metadata(TraceId).PathLengthStartEndTimePoint(selected) = time;

            slopes =PlotTrace(handles,index,2);

            gTraces.Metadata(TraceId).PathLengthSlope(1) = slopes(1);
            gTraces.Metadata(TraceId).PathLengthSlope(2) = slopes(2);

        case 'Distance_Section_List'        
            selected  =floor(get(handles.Distance_Section_List,'Value'));
            gTraces.Metadata(TraceId).DistanceStartEndTimePoint(selected) = time;%4 elemene[]

            slopes =PlotTrace(handles,index,3);

            gTraces.Metadata(TraceId).DistanceSlope(1) = slopes(3);
            gTraces.Metadata(TraceId).DistanceSlope(2) = slopes(4);

    end%switch

    [intensityMd,pathlengthMd,distanceMd] = GetMetadataByTracesId(TraceId);

    set(handles.Intensity_Section_List,'String',intensityMd);
    set(handles.PathLength_Section_List,'String',pathlengthMd);
    set(handles.Distance_Section_List,'String',distanceMd);
end

