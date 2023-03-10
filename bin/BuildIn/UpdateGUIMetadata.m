function [] = UpdateGUIMetadata(handles,setCatalog,DataQuality,intensityMd,pathLengthMd,distanceMd)
%UPDATEMETADATAINGUI  
%     
 
    global gTraces;
    
    set(handles.Distance_Section_List,'String',distanceMd);
    
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

