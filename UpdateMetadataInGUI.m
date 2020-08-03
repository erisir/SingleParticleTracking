function [] = UpdateMetadataInGUI(handles,setCatalog,plotFalg,I,P,D)
%UPDATEMETADATAINGUI 此处显示有关此函数的摘要
%   此处显示详细说明 
    global gTraces;
    set(handles.Intensity_Section_List,'String',I);
    set(handles.PathLength_Section_List,'String',P);
    set(handles.Distance_Section_List,'String',D);
    index = find(gTraces.Catalogs==setCatalog);
    set(handles.Traces_SetType_List,'Value',index);
 
end

