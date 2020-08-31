function [] = UpdateMetadataInGUI(handles,setCatalog,DataQuality,plotFalg,I,P,D)
%UPDATEMETADATAINGUI 此处显示有关此函数的摘要
%   此处显示详细说明 
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

