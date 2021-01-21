% plot the trace we want to show [when click on the Pre/Next button on the UI, it changes the TracesId that pass here]
function [slopes] = PlotTrace(images,traces,TracesId,handles,plotFalg)
    selected =1;
    warning off;
    LogMsg(handles,['plot trace[id][',int2str(TracesId),']']);
    smoothWindowSize =  traces.Config.smoothWindowSize;
    pixelSize = traces.Config.pixelSize;
    time_per_framems = str2num(get(handles.Frame_Expusure_Timems,'String'))+str2num(get(handles.Frame_Transfer_Timems,'String'));
    time_per_frames = time_per_framems/1000;
    slopes = [0,0,0,0];
    [I,P,D] = GetMetadataByTracesId(traces,TracesId); %gets the start and end frames of each trace from metadata
    setCatalog = traces.Metadata(TracesId).SetCatalog;
    try%old version control
    DataQuality = traces.Metadata(TracesId). DataQuality;
    catch
        DataQuality = "All";
    end
    UpdateMetadataInGUI(handles,setCatalog,DataQuality,plotFalg,I,P,D);%sets the start and end frames in gui
    if plotFalg == 0
        if ~isempty(images)
            set(handles.Slider_Stack_Index,'Value',str2num(I(1)));%go to the beginning of the trace when first call
        end
        set(handles.Current_Frame_Id,'String',I(1));%go to the beginning of the trace when first call
     end
        
    % get detail info by id,prepare necessary data for processing
    results = traces.molecules(TracesId).Results;
    datalength = size(results,1);
    frameIndicator = results(:,1);    %time = results(:,2); fps is 1 so time is equal to frame
    absXposition = results(:,3);
    absYposition = results(:,4);
    Amplitude =  results(:,8);
    fitError = results(:,9);
      
    %data processing drift correction and smoothing 
    %drift correct , substraced by the smooth result of mean drifft 
    %*****************************************************************
    %this is key part of the drift-correction 
    %  absXposition  -the raw x,y data from fiesta
    %  traces.smoothDriftx  -the smooth(and mean)results of drift data
    %they are in different array size, in order to 
    %do a valid substraction,we need to introduce the frameIndicator
    %   frameIndicator is a column that specifies the real frame num to
    %current data(because the skip frame of fiesta due to photo-blinking)
    %the frame is not necessary to be continue for each spot,however,
    %the frame is continue in cases of fiducial marker, directly substraction
    %will cause mismatch
    %*****************************************************************
   
    relativePositionX = absXposition    - absXposition(1);% 
    relativePositionY = absYposition    - absYposition(1); %
    %substarced by the first[oringal position] so every traces go from
    %(0,0)
    relativePositionX = relativePositionX-relativePositionX(1);
    relativePositionY = relativePositionY-relativePositionY(1);
    % smooth it 
    smoothRelativePosX = smooth(relativePositionX,smoothWindowSize);
    smoothRelativePosY = smooth(relativePositionY,smoothWindowSize);   
    % accumulation of overall movement,including fitting noise           
    % pathlenght sum up all the previous 'deltaDistance 
    % NOTE: this step induces the fitting noise and give us a base slope
    % which represents the amount of tracking uncertainties. BUT also gives
    % us a consistent velocity when enzyme move in nonlinear way 
    pathlenght = CalculatePathLengh(smoothRelativePosX,smoothRelativePosY,datalength);
    %the displacement is a vector point from the original position to the
    %current position.regardless of where the spot has been.     
    displacement = CalculateDisplacement(relativePositionX,relativePositionY);
    assignin('base','displacement',displacement);
    
    % cd use to plot the rainbow plot, define the color dictionary
    cd = [uint8(jet(datalength)*255) uint8(ones(datalength,1))].';%rainbow plot
    contents = cellstr(get(handles.Traces_ShowType_List,'String'));
    selectedType = contents{get(handles.Traces_ShowType_List,'Value')};
    if selectedType=="All" && false==MovementDetectionByTraceId(traces,TracesId) && get(handles.System_Debug,'value')%sikp the high error
       set(handles.Current_Trace_Id,'String',num2str(TracesId+1));
       PlotTrace(images,traces,TracesId+1,handles,plotFalg);
    else
        switch plotFalg
            case 0 % next or previou button hit
                if ~get(handles.System_Debug,'value')
                    PlotTheZoomImage(handles,images,frameIndicator,absXposition,absYposition,pixelSize,Amplitude);  

                    PlotTheIntensityTrace(handles,images,frameIndicator,Amplitude,I);   

                    sl = PlotPathLengthAndFit(handles,pathlenght,frameIndicator,P,traces,TracesId,cd);

                    s2 = PlotDistanceAndFit(handles,displacement,frameIndicator,D,traces,TracesId,cd,fitError);

                    PlotScatterAxes(handles,datalength,relativePositionX,relativePositionY,smoothRelativePosX,smoothRelativePosY,cd);

                    slopes(1) =  sl(1);
                    slopes(2) =  sl(2);          
                    slopes(2) =  s2(1);
                    slopes(4) =  s2(2);  
                else
                    PlotDistance(handles,displacement,frameIndicator,D,traces,TracesId,cd,fitError);
                    %PlotToIllustrator(handles,displacement,frameIndicator,D,traces,TracesId,cd,fitError);
                    PlotScatterAxes(handles,datalength,relativePositionX,relativePositionY,smoothRelativePosX,smoothRelativePosY,cd);
                    slopes = [1,1,1,1];
                end
            case 1
                PlotTheZoomImage(handles,images,frameIndicator,absXposition,absYposition,pixelSize,Amplitude);  
                PlotTheIntensityTrace(handles,images,frameIndicator,Amplitude,I);           
            case 2
                sl = PlotPathLengthAndFit(handles,pathlenght,frameIndicator,P,traces,TracesId,cd);
                slopes(1) = sl(1); 
                slopes(2) = sl(2);
            case 3
                sl = PlotDistanceAndFit(handles,displacement,frameIndicator,D,traces,TracesId,cd,fitError);
                slopes(3) = sl(1);
                slopes(4) = sl(2);
            case 4
                 PlotScatterAxes(handles,datalength,relativePositionX,relativePositionY,smoothRelativePosX,smoothRelativePosY,cd);
           case 5 % next or previou button hit
                PlotTheZoomImage(handles,images,frameIndicator,absXposition,absYposition,pixelSize,Amplitude);  
                PlotTheIntensityTrace(handles,images,frameIndicator,Amplitude,I);        
                sl = PlotPathLengthAndFit(handles,pathlenght,frameIndicator,P,traces,TracesId,cd);
                s2 = PlotDistanceAndFit(handles,displacement,frameIndicator,D,traces,TracesId,cd,fitError);
                PlotScatterAxes(handles,datalength,relativePositionX,relativePositionY,smoothRelativePosX,smoothRelativePosY,cd);
                slopes(1) = sl(1);
                slopes(2) = sl(2);          
                slopes(2) = s2(1);
                slopes(4) = s2(2);
           otherwise
                disp('err');

        end
        slopes = slopes/time_per_frames;
    end

end

