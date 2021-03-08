function [] = GcaKeyDownFcnSelectTraces(src, event,handles,number)
%GCAWINDOWMOUSEDOWNFCN  
%    
    keyValue = event.Key;
    index = str2double(get(handles.Current_Trace_Id,'String'));  
    switch keyValue 
        case "rightarrow"
            PlotMultipleTraces(handles,index,number);
        case "leftarrow"
            PlotMultipleTraces(handles,index-2*number,number);
        otherwise
    end
end

