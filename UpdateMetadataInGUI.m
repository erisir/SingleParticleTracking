function [] = UpdateMetadataInGUI(handles,setCatalog,plotFalg,I,P,D)
%UPDATEMETADATAINGUI 此处显示有关此函数的摘要
%   此处显示详细说明 
    if plotFalg == 0
        set(handles.StackProgress,'Value',str2num(I(1)));%go to the beginning of the trace when first call
        set(handles.FrameId,'String',I(1));%go to the beginning of the trace when first call
    end
    
    set(handles.IntensityList,'String',I);
    set(handles.PathLengthList,'String',P);
    set(handles.DistanceList,'String',D);
    switch setCatalog
        case 'All'
            set(handles.SetTypeList,'Value',1);
        case 'Stuck_Go'
             set(handles.SetTypeList,'Value',2);
        case 'Go_Stuck'
             set(handles.SetTypeList,'Value',3);
        case 'Stuck_Go_Stuck'
             set(handles.SetTypeList,'Value',4);
        case 'Go_Stuck_Go'
            set(handles.SetTypeList,'Value',5);
        case 'NonLinear'      
            set(handles.SetTypeList,'Value',6);
        case 'Perfect'      
            set(handles.SetTypeList,'Value',7);
    end
end

