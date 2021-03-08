% plot the trace we want to show [when click on the Pre/Next button on the UI,etc.]
function [slopes] = PlotTrace(handles,index,updateAxes)

    global gTraces;
    global gImages;
    if ~isfield( gTraces, 'molecules' )
        return
    end
    
    if index<1
        index = 1;
    end
    if index >gTraces.CurrentShowNums
        index = gTraces.CurrentShowNums;
    end
    
    set(handles.Current_Trace_Id,'String',int2str(index));
    TracesId = gTraces.CurrentShowIndex(index);

    LogMsg(handles,['plot trace[id][',int2str(TracesId),']']);
    
    smoothWindowSize =  gTraces.Config.smoothWindowSize;
    pixelSize = gTraces.Config.pixelSize;
    
    time_per_framems = str2num(get(handles.Frame_Expusure_Timems,'String'))+str2num(get(handles.Frame_Transfer_Timems,'String')); %#ok<ST2NM>
    time_per_frames = time_per_framems/1000;
    slopes = [0,0,0,0];
    [intensityMd,pathLengthMd,distanceMd] = GetMetadataByTracesId(TracesId); %gets the start and end frames of each trace from metadata
    setCatalog = gTraces.Metadata(TracesId).SetCatalog;
    
    if  isfield( gTraces.Metadata(TracesId), 'DataQuality' )
        DataQuality = gTraces.Metadata(TracesId).DataQuality;
    else
        DataQuality = 'All';
    end
    %contents = cellstr(get(handles.Traces_ShowType_List,'String'));
    %category = contents{get(handles.Traces_ShowType_List,'Value')};
    UpdateGUIMetadata(handles,setCatalog,DataQuality,intensityMd,pathLengthMd,distanceMd);%sets the start and end frames in gui
        
    % get detail info by id,prepare necessary data for processing
    series = GetTimeSeriesByTraceId(TracesId);
    
    frameIndicator = series.frameIndicator;
    time =series.time; %fps is 1 so time is equal to frame
    absXposition = series.absXposition;
    absYposition =series.absYposition;
    Amplitude =  series.Amplitude;
    fitError = series.fitError;
    relativePositionX = series.relativePositionX;
    relativePositionY = series.relativePositionY;   
    pathlenght= series.pathlenght;    
    displacement = series.displacement;    
    
    datalength = numel(time);  
    smoothRelativePosX = smooth(relativePositionX,smoothWindowSize);
    smoothRelativePosY = smooth(relativePositionY,smoothWindowSize); 
    %assignin('base','displacement',displacement);
    
    % colorCode use to plot the rainbow plot, define the color dictionary
       
    colorCode = [uint8(jet(datalength)*255) uint8(ones(datalength,1))].';%rainbow plot

    switch updateAxes
                 
        case 1% set segment slide move on intensity axis, update the image
            if  isfield(gImages,'rawImagesStack')
                PlotZoomInImages(handles,frameIndicator,absXposition,absYposition,pixelSize,Amplitude);  
            end    
            SetSlideIndex(handles,intensityMd(1),false);%go to the beginning of the trace when first call
            PlotIntensityAxes(handles,frameIndicator,Amplitude,intensityMd);   
        case 2% set segment slide move on pathlength axis, update pathlength axes
            sl = PlotPathLengthAndFit(handles,pathlenght,frameIndicator,pathLengthMd,TracesId,colorCode);
            slopes(1) = sl(1); 
            slopes(2) = sl(2);
        case 3% set segment slide move on distance axis, update distance axes
            s2 = PlotDistanceAndFit(handles,displacement,frameIndicator,distanceMd,TracesId,colorCode,fitError);
            slopes(3) = s2(1);
            slopes(4) = s2(2);

        otherwise
            if updateAxes ==0
                SetSlideIndex(handles,str2num(intensityMd(1)),false);%go to the beginning of the trace when first call
                if isfield(gImages,'rawImagesStack')
                    PlotZoomInImages(handles,frameIndicator,absXposition,absYposition,pixelSize,Amplitude);  
                end           
            end                       
            PlotIntensityAxes(handles,frameIndicator,Amplitude,intensityMd);   
            sl = PlotPathLengthAndFit(handles,pathlenght,frameIndicator,pathLengthMd,TracesId,colorCode);
            s2 = PlotDistanceAndFit(handles,displacement,frameIndicator,distanceMd,TracesId,colorCode,fitError);
            PlotScatterAxes(handles,datalength,relativePositionX,relativePositionY,smoothRelativePosX,smoothRelativePosY,colorCode);

            slopes(1) =  sl(1);
            slopes(2) =  sl(2);          
            slopes(2) =  s2(1);
            slopes(4) =  s2(2); 
    end
    slopes = slopes/time_per_frames;
end

 

