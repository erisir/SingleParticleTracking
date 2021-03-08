function  SetTraceCategory(handles,category)
%SETTRACECATEGORY  
%    
    global gTraces;
    CurrentDisplayIndex= str2num(get(handles.Current_Trace_Id,'String'));
    traceId = gTraces.CurrentShowIndex(CurrentDisplayIndex);
    gTraces.Metadata(traceId).SetCatalog = category;

    %default action,select the start/end time point
    gTraces.LastSelectedList = 'Distance_Section_List';
    contents = cellstr(get(handles.Distance_Section_List,'String'));
 
    
    %default select time point to start
    res = find(["Go_Stuck","Go_Stuck_Go","Diffusion","BackForward"]==category);
    if ~isempty(res)
        set(handles.Distance_Section_List,'Value',2);
    else
        set(handles.Distance_Section_List,'Value',1);
    end
    
    value = str2num(contents{get(handles.Distance_Section_List,'Value')});
    
    res= xlim(handles.DistanceAxes);
    set(handles.Slider_Section_Select,'min',res(1));
    set(handles.Slider_Section_Select,'max',res(2));
    set(handles.Slider_Section_Select,'Value',value);
    set(handles.Slider_Section_Select,'SliderStep',[1/(res(2)-res(1)),10/(res(2)-res(1))]);
end

