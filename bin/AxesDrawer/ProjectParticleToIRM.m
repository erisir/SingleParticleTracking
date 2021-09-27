function ProjectParticleToIRM(handles)
%PROJECTPARTICLETOIRM 此处显示有关此函数的摘要
%   此处显示详细说明
    global gImages;
    global gTraces;
    if  ~isfield( gImages, 'IRMImage' ) 
        return;
    end
    
    intensity_low = get(handles.Slider_Threadhold_Low,'Value');
    intensity_high = get(handles.Slider_Threadhold_High,'Value');
    hold (handles.ImageWindowAxes,'off');
    imshow(gImages.IRMImage,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);

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
        if ~strcmp(type,'All') && ~strcmp(type,'Stepping') && ~strcmp(type,'Diffusion') && ~strcmp(type,'Temp') % processive 
            processiveParticleId = [processiveParticleId,traceId];
        end
        if strcmp(type,'Stuck_Go') || strcmp(type,'Stuck_Go_Stuck')  % stuck-move
            stuckAndMoveParticleId = [stuckAndMoveParticleId,traceId];
        end
        if strcmp(type,'Go_Stuck') || strcmp(type,'Go_Stuck_Go')     % move-stuck
            moveAndStuckParticleId = [moveAndStuckParticleId,traceId];
        end
    end
    target = processiveParticleId;
    pixelSize = gTraces.Config.pixelSize;
    for index = 1:numel(target)
        timecourse = GetTimeSeriesByTraceId(target(index));
        meanx = floor(mean(timecourse.absXposition)/pixelSize);
        meany = floor(mean(timecourse.absYposition)/pixelSize);
        hold (handles.ImageWindowAxes,'on');
        plot(handles.ImageWindowAxes,meanx,meany,'r*','MarkerSize',3);
    end         
end

