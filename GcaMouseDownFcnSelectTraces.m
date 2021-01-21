function [] = GcaMouseDownFcnSelectTraces(object, eventdata,handles,index)
%GCAWINDOWMOUSEDOWNFCN 此处显示有关此函数的摘要
%   此处显示详细说明
global gTraces;
global gImages;
button = eventdata.Button;

pos = eventdata.IntersectionPoint;
traceId = gTraces.CurrentShowIndex(index);
if button == 2% first round 
    set(handles.Current_Trace_Id,'String',int2str(index));
    PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles,0);
end
if button ==1    
    if gTraces.Metadata(traceId).DataQuality == "Good"
        gTraces.Metadata(traceId).DataQuality = "bad";
        hold(object,'on');
        plot(pos(1),pos(2),'ok');
        hold(object,'off'); 
    end
    if gTraces.Metadata(traceId).DataQuality == "All"
        gTraces.Metadata(traceId).DataQuality = "Good";
        hold(object,'on');
        plot(pos(1),pos(2),'or');
        hold(object,'off'); 
    end
end
if button ==3    
    if gTraces.Metadata(traceId).DataQuality == "Good"
        gTraces.Metadata(traceId).DataQuality = "Perfect";
 
        hold(object,'on');
        plot(pos(1),pos(2),'og');
        hold(object,'off'); 
    end
end

 
end

