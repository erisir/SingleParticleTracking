function [] = GcaMouseDownFcnSelectTraces(object, eventdata,handles,index)
%GCAWINDOWMOUSEDOWNFCN �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global gTraces;

button = eventdata.Button;
if button == 1 
    global gTraces;
    global gImages;

    if index<1
        index = 1;
    end
    if index >gTraces.CurrentShowNums
        index = gTraces.CurrentShowNums;
    end
    set(handles.Current_Trace_Id,'String',int2str(index));
    PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles,0);
end

if button ==3
    traceId = gTraces.CurrentShowIndex(index);
    gTraces.Metadata(traceId).SetCatalog = "Temp";
end
 
end

