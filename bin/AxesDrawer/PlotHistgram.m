function [] = PlotHistgram(handles)
%PLOTHISTGRAM  prepare data to plot the histgram
%   
    global gTraces;
    
    %contents = cellstr(get(handles.Traces_ShowType_List,'String'));
    %selectedType = contents{get(handles.Traces_ShowType_List,'Value')};

    time_per_framems = str2double(get(handles.Frame_Expusure_Timems,'String'))+str2double(get(handles.Frame_Transfer_Timems,'String'));
    time_per_frames = time_per_framems/1000;

    SetupCatalogByMetadata(handles);
    
    staticParticleId = [];
    processiveParticleId = [];
    stuckAndMoveParticleId = [];
    moveAndStuckParticleId = [];
    
    selectEnd = gTraces.moleculenum;
   % selectEnd = 2000;
    for traceId = 1:selectEnd
        metadata=gTraces.Metadata(traceId) ; % Indexs(i) is the real index
        type = metadata.SetCatalog;        
        DataQuality = metadata.DataQuality;
        
        if DataQuality == "Error"
            continue
        end       
        if ~isTimePointInTrustBands(get(handles.TrustBands,'String'),traceId)
            continue
        end
        
        if  strcmp(type,'Temp') && strcmp(DataQuality,'All') %static
            staticParticleId = [staticParticleId,traceId];
        end        
        if ~strcmp(type,'All') && ~strcmp(type,'Stepping') && ~strcmp(type,'Diffusion') && ~strcmp(type,'Temp') % processive 
         
        %if strcmp(type,'Stuck_Go') || strcmp(type,'Stuck_Go_Stuck') || strcmp(type,'Go_Stuck') || strcmp(type,'Go_Stuck_Go')
          processiveParticleId = [processiveParticleId,traceId];
        end
        if strcmp(type,'Stuck_Go') || strcmp(type,'Stuck_Go_Stuck')  % stuck-move
            stuckAndMoveParticleId = [stuckAndMoveParticleId,traceId];
        end
        if strcmp(type,'Go_Stuck') || strcmp(type,'Go_Stuck_Go')     % move-stuck
            moveAndStuckParticleId = [moveAndStuckParticleId,traceId];
        end
    end

    staticParticleDescribe = GetTracesDescribe(staticParticleId,time_per_frames); 
    processiveParticleDescribe = GetTracesDescribe(processiveParticleId,time_per_frames);
    stuckAndMoveParticleDescribe = GetTracesDescribe(stuckAndMoveParticleId,time_per_frames);
    moveAndStuckParticleDescribe = GetTracesDescribe(moveAndStuckParticleId,time_per_frames);
    
    %MyStructHere = evalin('base','MyStruct');
    
    saveToWorkspace = 0;
    catFromWorkspace = 0;
    str = 'lastOpen';
    
    if  catFromWorkspace == 1
        staticParticleDescribe = DescribeCatFromWorkspace(staticParticleDescribe,['staticParticleDescribe',str]);
        processiveParticleDescribe = DescribeCatFromWorkspace(processiveParticleDescribe,['processiveParticleDescribe',str]);
        stuckAndMoveParticleDescribe = DescribeCatFromWorkspace(stuckAndMoveParticleDescribe,['stuckAndMoveParticleDescribe',str]);
        moveAndStuckParticleDescribe = DescribeCatFromWorkspace(moveAndStuckParticleDescribe,['moveAndStuckParticleDescribe',str]);
    end
    
    if saveToWorkspace == 1
        assignin('base',['staticParticleDescribe',str],staticParticleDescribe);
        assignin('base',['processiveParticleDescribe',str],processiveParticleDescribe);
        assignin('base',['stuckAndMoveParticleDescribe',str],stuckAndMoveParticleDescribe);
        assignin('base',['moveAndStuckParticleDescribe',str],moveAndStuckParticleDescribe);  
    end
    gTraces.TargetParameters={'Velocity(nm/s)';'Runlength(nm)';'Processive Moving Duration(s)';'Processive Total BindDuration(s)'...
        ;'Static Total BindDuration(s)';'Processive Stuck Before Move Duration(s)';'Processive Stuck After Move Duration(s)';' Fit Error(nm)'};
    figure('name',gTraces.fileName);
    [checkCount,checkboxStatus] = FindPlotHistCheckbox(handles);
    if checkCount>4
        col = 4;
        row = 2;
    else
        col = checkCount;
        row = 1;
    end
    fitdata = cell(1,8);
    fitdata{1} = processiveParticleDescribe.movingVelocity1;
    fitdata{2} = processiveParticleDescribe.runLength1;
    fitdata{3} = processiveParticleDescribe.movingDuration1;
    fitdata{4} = processiveParticleDescribe.totalBindDuration;
    fitdata{5} = staticParticleDescribe.totalBindDuration;
    fitdata{6} = stuckAndMoveParticleDescribe.dwellTimeBeforeMovement;
    fitdata{7} = moveAndStuckParticleDescribe.dwellTimeAfterMovement;
    fitdata{8} = staticParticleDescribe.meanfitError;
    assignin('base','TimeB9',staticParticleDescribe.totalBindDuration);
    fitOption  = gTraces.histgramFitOption;%{'poisson';'gauss1';'exp1';'exp1';'exp1';'exp1';'exp1';'gauss1'};
    fitStartAndBinSize = {[0,0.5]  ;[0,3]    ;[5,4]    ;[10,10];...
                          [0,0.2]  ;[10,5]   ;[10,10]  ;[1,0.5]};
                      
    checkedFitdata =  fitdata(find(checkboxStatus==1));   
    checkedFitOption =  fitOption(find(checkboxStatus==1));   
    checkedFitStartAndBinSize =  fitStartAndBinSize(find(checkboxStatus==1));   
    checkedTargetParameters = gTraces.TargetParameters(find(checkboxStatus==1));   
    for i = 1:checkCount
        subplot(row,col,i);
        fitdataTemp =  checkedFitdata{i};
        HistAndFit(fitdataTemp,checkedFitOption{i},[checkedFitStartAndBinSize{i},220],checkedTargetParameters{i});
    end
    
end

