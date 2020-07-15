function [] = UpdateMetadataInGUI(handles,setCatalog,plotFalg,I,P,D)
%UPDATEMETADATAINGUI 此处显示有关此函数的摘要
%   此处显示详细说明 
    if plotFalg == 0
        set(handles.Slider_Stack_Index,'Value',str2num(I(1)));%go to the beginning of the trace when first call
        set(handles.Current_Frame_Id,'String',I(1));%go to the beginning of the trace when first call
    end
    
    set(handles.Intensity_Section_List,'String',I);
    set(handles.PathLength_Section_List,'String',P);
    set(handles.Distance_Section_List,'String',D);
    switch setCatalog
        case 'All'
            set(handles.Traces_SetType_List,'Value',1);
        case 'Stuck_Go'
             set(handles.Traces_SetType_List,'Value',2);
        case 'Go_Stuck'
             set(handles.Traces_SetType_List,'Value',3);
        case 'Stuck_Go_Stuck'
             set(handles.Traces_SetType_List,'Value',4);
        case 'Go_Stuck_Go'
            set(handles.Traces_SetType_List,'Value',5);
        case 'NonLinear'      
            set(handles.Traces_SetType_List,'Value',6);
        case 'Stepping'      
            set(handles.Traces_SetType_List,'Value',7);
        case 'Perfect'      
            set(handles.Traces_SetType_List,'Value',8);
        case 'Temp'      
            set(handles.Traces_SetType_List,'Value',9);
    end
end

