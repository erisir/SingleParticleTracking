function [] = GcaMouseDownFcnSelectTraces(object, eventdata,handles,index)
%GCAWINDOWMOUSEDOWNFCN �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global gTraces;
global gImages;
button = eventdata.Button;
if button == 1 

    set(handles.Current_Trace_Id,'String',int2str(index));
    PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles,0);
end

if button ==3
    traceId = gTraces.CurrentShowIndex(index);
    gTraces.Metadata(traceId).SetCatalog = "Diffusion";
    gTraces.Metadata(traceId).DataQuality = "Good";
    set(handles.Current_Trace_Id,'String',int2str(index));
    PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles,0);
end
 
end

