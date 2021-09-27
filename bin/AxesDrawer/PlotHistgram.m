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
    
 
    for traceId = 1:gTraces.moleculenum
        metadata=gTraces.Metadata(traceId) ; % Indexs(i) is the real index
        type = metadata.SetCatalog;        
        if  strcmp(type,'Temp')  %static
            staticParticleId = [staticParticleId,traceId];
        end        
        %if ~strcmp(type,'All') && ~strcmp(type,'Stepping') && ~strcmp(type,'Diffusion') && ~strcmp(type,'Temp') % processive 
        if strcmp(type,'Stuck_Go') || strcmp(type,'Stuck_Go_Stuck') || strcmp(type,'Go_Stuck') || strcmp(type,'Go_Stuck_Go')
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

    figure;
    subplot(2,4,1);
    HistAndFit(processiveParticleDescribe.movingVelocity1,'gauss1',[0,1,40],'Velocity(nm/s)');
    subplot(2,4,2);
    HistAndFit(processiveParticleDescribe.runLength1,'gauss1',[0,3,200],'Runlength(nm)');
    subplot(2,4,3);
    HistAndFit(processiveParticleDescribe.movingDuration1,'exp1',[5,4,100],'Processive Moving Duration(s)');

    subplot(2,4,4);
    HistAndFit(processiveParticleDescribe.totalBindDuration,'exp1',[10,10,500],'Processive Total BindDuration(s)');
    subplot(2,4,5);
    HistAndFit(staticParticleDescribe.totalBindDuration,'exp2',[10,10,500],'Static Total BindDuration(s)');
    subplot(2,4,6);
    HistAndFit(stuckAndMoveParticleDescribe.dwellTimeBeforeMovement,'exp1',[10,10,500],'Processive Stuck Before Move Duration(s)');
    %HistAndFit(staticParticleDescribe.standardDeviation,'gauss1',[0,1,25],'Static standard deviation(nm)');
    subplot(2,4,7);
    %HistAndFit(moveAndStuckParticleDescribe.dwellTimeAfterMovement,'exp1',[10,10,500],'Static Intensity(a.u.)');
    HistAndFit(moveAndStuckParticleDescribe.dwellTimeAfterMovement,'exp1',[10,10,500],'Processive Stuck After Move Duration(s)');
    subplot(2,4,8);
    HistAndFit(staticParticleDescribe.meanfitError,'gauss1',[1,0.5,15],' Fit Error(nm)');
end

