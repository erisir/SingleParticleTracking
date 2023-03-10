function  SaveMetadata(handles)
%SAVEMETADATA  
%    
    global gTraces;
    global Workspace;

    if isempty(gTraces.TracesPath)
        [file,path] = uiputfile('*.mat','load',Workspace);
    else
        [file,path] = uiputfile('*.mat','load',gTraces.TracesPath);
    end
    if path ==0
        return
    end
    
    gTraces.Config.ExpusureTimems = str2num(get(handles.Frame_Expusure_Timems,'String'));
    gTraces.Config.FrameTrasferTimems = str2num(get(handles.Frame_Transfer_Timems,'String'));

    gTraces.Config.TrustBands = get(handles.TrustBands,'String');
    
    formatedData.metadata = gTraces.Metadata;
    formatedData.Config = gTraces.Config; 

    save([path,file],'formatedData'); 
    LogMsg(handles,'Finish saving Metadata');
end

