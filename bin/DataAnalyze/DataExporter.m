function  DataExporter(handles,exportType)
%DATAEXPORTER Summary of this function goes here
%   Detailed explanation goes here
    global gTraces; 
    global Workspace;

    if isempty(gTraces.TracesPath)
        [file,path] = uiputfile('*.csv','load',Workspace);
    else
        [file,path] = uiputfile('*.csv','load',gTraces.TracesPath);
    end
    if path ==0
        return
    end

    
   selectEnd = gTraces.moleculenum;
   saveDataAll  = [];
   switch (exportType)
       case 'Metadata'
            for traceId = 1:selectEnd
                saveData = [];
                metadata=gTraces.Metadata(traceId) ; % Indexs(i) is the real index
                saveData.FrameId = traceId;

                duration = metadata.IntensityStartEndTimePoint;
                saveData.FrameOn = duration(1);
                saveData.FrameOff = duration(2);
                saveData.Duration = duration(2) - duration(1);

                processiveDuration = metadata.DistanceStartEndTimePoint;%only count the first segement
                saveData.ProcessiveStart = processiveDuration(1);
                saveData.ProcessiveEnd = processiveDuration(2);
                saveData.ProcessiveDuration = processiveDuration(2)-processiveDuration(1);

                processiveVelocity = metadata.DistanceSlope;%only count the first segement
                saveData.Velocity = processiveVelocity(1);
                saveData.RunLength = saveData.Velocity*saveData.ProcessiveDuration;

                saveData.SetCatalog =  metadata.SetCatalog; 
                saveData.DataQuality = metadata.DataQuality;     
                saveDataAll = [saveDataAll,saveData];
            end
       case 'CurrentTrace'
           smoothWindowSize = gTraces.Config.smoothWindowSize;
           index = str2double(get(handles.Current_Trace_Id,'String'));
           TracesId = gTraces.CurrentShowIndex(index);
           saveDataAll = GetTimeSeriesByTraceId(TracesId,~handles.ApplyDriftCorrection.Value);
           smoothRelativePosX = smooth(saveDataAll.relativePositionX,smoothWindowSize);
           smoothRelativePosY = smooth(saveDataAll.relativePositionY,smoothWindowSize); 
           saveDataAll.smoothRelativePosX = smoothRelativePosX;
           saveDataAll.smoothRelativePosY = smoothRelativePosY;
    end
           
    
    writetable(struct2table(saveDataAll), [path,file])
    LogMsg(handles,'Finish saving Data');
    beep;
end

