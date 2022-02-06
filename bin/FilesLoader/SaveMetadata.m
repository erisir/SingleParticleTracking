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

    gTraces.Config.DistanceAxesBinSize = str2num(get(handles.DistanceAxes_BinSize,'String'));
    gTraces.Config.DistanceAxesBinEnd = str2num(get(handles.DistanceAxes_BinEnd,'String'));

    gTraces.Config.PathLengthAxesBinSize = str2num(get(handles.PathLengthAxes_BinSize,'String'));
    gTraces.Config.PathLengthAxesBinEnd = str2num(get(handles.PathLengthAxes_BinEnd,'String'));

    gTraces.Config.IntensityAxesBinSize = str2num(get(handles.IntensityAxes_BinSize,'String'));
    gTraces.Config.IntensityAxesBinEnd = str2num(get(handles.IntensityAxes_BinEnd,'String'));
    gTraces.Config.TrustBands = get(handles.TrustBands,'String');
    
    formatedData.metadata = gTraces.Metadata;
    formatedData.Config = gTraces.Config; 

    save([path,file],'formatedData'); 
    LogMsg(handles,'Finish saving Metadata');
end

