function [] = UpdateMetadataInGUI(handles,setCatalog,DataQuality,plotFalg,I,P,D)
%UPDATEMETADATAINGUI �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵�� 
    global gTraces;
    set(handles.Intensity_Section_List,'String',I);
    set(handles.PathLength_Section_List,'String',P);
    set(handles.Distance_Section_List,'String',D);
    index = find(gTraces.Config.Catalogs==setCatalog);
    set(handles.Traces_SetType_List,'Value',index);
    switch DataQuality
        case "All"
        set(handles.Data_Quality_All,'Value',1);
        case "Perfect"
        set(handles.Data_Quality_Perfect,'Value',1);
        case "Good"
        set(handles.Data_Quality_Good,'Value',1);
        case "Bad"
        set(handles.Data_Quality_Bad,'Value',1);
    end
 
end

