function [] = GcaMouseDownFcnSelectTraces(object, eventdata,handles,index)
%GCAWINDOWMOUSEDOWNFCN 此处显示有关此函数的摘要
%   此处显示详细说明
global gTraces;
global gImages;
button = eventdata.Button;
traceId = gTraces.CurrentShowIndex(index);
if button == 1 
    set(handles.Current_Trace_Id,'String',int2str(index));
    PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles,0);
end

if button ==3    
    %gTraces.Metadata(traceId).SetCatalog = "Diffusion";
    if gTraces.Metadata(traceId).DataQuality == "All"
        gTraces.Metadata(traceId).DataQuality = "Good";
    end
    set(handles.Current_Trace_Id,'String',int2str(index));
    PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles,0);
end
 
end

