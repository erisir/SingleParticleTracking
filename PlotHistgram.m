function [] = PlotHistgram(handles,gTraces)
%PLOTHISTGRAM  prepare data to plot the histgram
%   
global gTraces;
%ReFitTraces();
 
contents = cellstr(get(handles.Traces_ShowType_List,'String'));
selectedType = contents{get(handles.Traces_ShowType_List,'Value')};

time_per_framems = str2double(get(handles.Frame_Expusure_Timems,'String'))+str2double(get(handles.Frame_Transfer_Timems,'String'));
time_per_frames = time_per_framems/1000;
    
SetupCatalogByMetadata(handles);%get the real index of each catalog and save it to
%gTraces.Stuck_Go/Go_Stuck  etc.
currentShowTypeIndex = find(gTraces.Config.Catalogs==selectedType);
TracesUseInHistgram =[];

if currentShowTypeIndex ==1%all
    catalogsNums = size(gTraces.Config.Catalogs,1);
    for i =1:catalogsNums%skip the first, all,step,diffusion,temp
        %if i==1 || i == 10  %stuck cel7a
        if i~=1 && i ~=7 && i ~=9&& i ~=10 % moving cel7a 
        %if i==2 || i ==4  % stuck-move
        %if i==3 || i ==5  % move-stuck
            TracesUseInHistgram  = [TracesUseInHistgram,gTraces.CatalogsContainor{i}];
        end
    end
else
    TracesUseInHistgram = gTraces.CatalogsContainor{currentShowTypeIndex};
end
%TracesUseInHistgram = 1:gTraces.moleculenum;
%TracesUseInHistgram = gTraces.CatalogsContainor{1};%plot the stuck qdot
%TracesUseInHistgram = 1:size(gTraces.Metadata,2);%plot all the qdots

moleculeNums = size(TracesUseInHistgram,2);
% prepare the hist data
intensity_dwell = [];
distance_base_slope = [];
distance_base_runLength = [];
distance_base_slope2 = [];
distance_base_runLength2 = [];
 
for i = 1:moleculeNums
    traceId = TracesUseInHistgram(i);
    metadata=gTraces.Metadata(traceId) ; % Indexs(i) is the real index
    %dwell time of overall binding

    intensity_dwell(i) = metadata.IntensityDwell(1)*time_per_frames;
    
    %dwell time of stuck before movement
    %intensity_dwell(i) = ( metadata.DistanceStartEndTimePoint(1) - metadata.IntensityStartEndTimePoint(1))*time_per_frames;
    
    %dwell time of stuck after movement
    %intensity_dwell(i) = ( metadata.IntensityStartEndTimePoint(2)-metadata.DistanceStartEndTimePoint(2) )*time_per_frames;
    
    %dwell time at the movement     
    %intensity_dwell(i) = ( metadata.DistanceStartEndTimePoint(2)-metadata.DistanceStartEndTimePoint(1) )*time_per_frames;
    
    %dwell time of stuck after movment
    %intensity_dwell(i) = ( metadata.IntensityStartEndTimePoint(2)-metadata.DistanceStartEndTimePoint(2) )*time_per_frames;
  
    if metadata.DistanceSlope(1) ~=0
        distance_base_slope(i) =  metadata.DistanceSlope(1);   
        distance_base_slope2(i) =  metadata.DistanceSlope(2);   
        distance_base_runLength(i) = metadata.DistanceSlope(1)*(metadata.DistanceStartEndTimePoint(2)-metadata.DistanceStartEndTimePoint(1));
        distance_base_runLength2(i) = metadata.DistanceSlope(2)*(metadata.DistanceStartEndTimePoint(4)-metadata.DistanceStartEndTimePoint(3));
    end
end
 
%trim zero
distance_base_runLength(find(distance_base_runLength ==0)) = [];
distance_base_slope(find(distance_base_slope ==0)) = [];
distance_base_runLength2(find(distance_base_runLength2 ==0)) = [];
distance_base_slope2(find(distance_base_slope2 ==0)) = [];
intensity_dwell(find(intensity_dwell==0)) = [];



%MyStructHere = evalin('base','MyStruct');

%assignin('base','bindDurationAll1_2edHalf',intensity_dwell);
%assignin('base','bindDurationOfStuck1_2edHalf',intensity_dwell);
%assignin('base','bindDurationOfMoving_All1_2edHalf',intensity_dwell);
%assignin('base','bindDurationOfMoving_Moving1_2edHalf',intensity_dwell);
%assignin('base','bindDurationOfStuckBeforeMove1_2edHalf',intensity_dwell);
%assignin('base','bindDurationOfStuckBeforeUnbound1',intensity_dwell);
assignin('base','bindDurationOfMovingBeforeStuck1_2edHalf',intensity_dwell);
%assignin('base','bindDurationOfMovingBeforeUnbound1',intensity_dwell);




%how many data N
totalNum_distance_base_runLength = size(distance_base_runLength,2);
totalNum_distance_base_slope = size(distance_base_slope,2);
totalNum_intensity_dwell = size(intensity_dwell,2);

%hist1
fitOption = handles.Histgram_Fit_Option.SelectedObject.String;
binsize = str2double(get(handles.DistanceAxes_BinSize,'String'));
xAxesEnd = str2double(get(handles.DistanceAxes_BinEnd,'String'));
PlotHistgramAndFitGaussian(handles.DistanceAxes,distance_base_slope,binsize,xAxesEnd,fitOption,totalNum_distance_base_slope,'Velocity (nm/s)');

binsize = str2double(get(handles.PathLengthAxes_BinSize,'String'));
xAxesEnd = str2double(get(handles.PathLengthAxes_BinEnd,'String'));
PlotHistgramAndFitGaussian(handles.PathLengthAxes,distance_base_runLength,binsize,xAxesEnd,fitOption,totalNum_distance_base_runLength,'Run Length (nm)');

selected = handles.Intensity_Axes_Plot_Option.SelectedObject.String;
if selected =="DwellTime"
    binsize = str2double(get(handles.IntensityAxes_BinSize,'String'));
    xAxesEnd = str2double(get(handles.IntensityAxes_BinEnd,'String'));
    PlotHistgramAndFitGaussian(handles.IntensityAxes,intensity_dwell,binsize,xAxesEnd,fitOption,totalNum_intensity_dwell,'Binding duration (s)');
else
    binsize = str2double(get(handles.IntensityAxes_BinSize,'String'));
    xAxesEnd = str2double(get(handles.IntensityAxes_BinEnd,'String'));
    intensity = GetTracesMeanIntensity(gTraces);
    PlotHistgramAndFitGaussian(handles.IntensityAxes,intensity,binsize,xAxesEnd,fitOption,gTraces.moleculenum,'Intensity (a.u.)');
end
end

