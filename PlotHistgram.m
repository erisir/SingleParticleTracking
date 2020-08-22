function [] = PlotHistgram(handles,gTraces)
%PLOTHISTGRAM 此处显示有关此函数的摘要
%   此处显示详细说明
global gTraces;
 
intensity_dwell = [];
pathlength_base_slopediffer = [];
pathlength_base_slope_noise = [];
pathlength_base_slope_move = [];
distance_base_slope = [];
distance_base_runLength = [];
plot_both = 0;
 
contents = cellstr(get(handles.Traces_ShowType_List,'String'));
selectedType = contents{get(handles.Traces_ShowType_List,'Value')};
time_per_framems = str2num(get(handles.Frame_Expusure_Timems,'String'))+str2num(get(handles.Frame_Transfer_Timems,'String'));
time_per_frames = time_per_framems/1000;
    
SetupCatalogByMetadata();%get the real index of each catalog and save it to
%gTraces.Stuck_Go/Go_Stuck  etc.
index = find(gTraces.Catalogs==selectedType);
Indexs =[];

if index ==1%all
    nums = size(gTraces.Catalogs,1);
    for i =1:nums%skip the first, all,step,temp
        if i~=1% && i ~=7 && i ~=10
            Indexs  = [Indexs,gTraces.CatalogsContainor{i}];
        end
    end
else
    Indexs = gTraces.CatalogsContainor{index};
end
max(Indexs)
%Indexs = gTraces.CatalogsContainor{1};%plot the stuck qdot
Indexs = 1:size(gTraces.Metadata,2);%plot all the qdots
moleculeNums = size(Indexs,2);
% prepare the hist data
for i = 1:moleculeNums
    traceId = Indexs(i);
    metadata=gTraces.Metadata(traceId) ; % Indexs(i) is the real index
    intensity_dwell(i) = metadata.IntensityDwell(1)*time_per_frames;
    if metadata.PathLengthSlope(2) ~=0
        pathlength_base_slopediffer(i) = metadata.PathLengthSlope(2)-metadata.PathLengthSlope(1);
        pathlength_base_slope_noise(i) = metadata.PathLengthSlope(1);
        pathlength_base_slope_move(i)= metadata.PathLengthSlope(2);
    end
    if metadata.DistanceSlope(1) ~=0
        distance_base_slope(i) = metadata.DistanceSlope(1);   
        distance_base_runLength(i) = metadata.DistanceSlope(1)*(metadata.Distance(2)-metadata.Distance(1));
        distance_base_slope(i) = distance_base_slope(i);   
    end
end
%trim zero
distance_base_runLength(find(distance_base_runLength ==0)) = [];
distance_base_slope(find(distance_base_slope ==0)) = [];
intensity_dwell(find(intensity_dwell==0)) = [];
pathlength_base_slopediffer(find(pathlength_base_slopediffer ==0)) = [];
pathlength_base_slope_noise(find(pathlength_base_slope_noise ==0)) = [];
pathlength_base_slope_move(find(pathlength_base_slope_move ==0)) = [];
pathlength_base_slope_both = [pathlength_base_slope_noise,pathlength_base_slope_move];

%how many data N
totalNum_distance_base_runLength = size(distance_base_runLength,2);
totalNum_distance_base_slope = size(distance_base_slope,2);
totalNum_intensity_dwell = size(intensity_dwell,2);
totalNum_pathlength_base_slopediffer = size(pathlength_base_slopediffer,2);
 
%hist1
fitOption = handles.Histgram_Fit_Option.SelectedObject.String;
binsize = str2double(get(handles.DistanceAxes_BinSize,'String'));
xAxesEnd = str2double(get(handles.DistanceAxes_BinEnd,'String'));
PlotHistgramAndFitGaussian(handles.DistanceAxes,distance_base_slope,binsize,xAxesEnd,fitOption,totalNum_distance_base_slope,'Velocity (nm/s)');

binsize = str2double(get(handles.PathLengthAxes_BinSize,'String'));
xAxesEnd = str2double(get(handles.PathLengthAxes_BinEnd,'String'));
PlotHistgramAndFitGaussian(handles.PathLengthAxes,distance_base_runLength,binsize,xAxesEnd,fitOption,totalNum_distance_base_runLength,'Run Length (nm)');

selected = handles.Intensity_Axes_Plot_Option.SelectedObject.String;
if selected =='DwellTime'
    binsize = str2double(get(handles.IntensityAxes_BinSize,'String'));
    xAxesEnd = str2double(get(handles.IntensityAxes_BinEnd,'String'));
    PlotHistgramAndFitGaussian(handles.IntensityAxes,intensity_dwell,binsize,xAxesEnd,fitOption,totalNum_intensity_dwell,'Binding duration (s)');
else
    binsize = str2double(get(handles.IntensityAxes_BinSize,'String'));
    xAxesEnd = str2double(get(handles.IntensityAxes_BinEnd,'String'));
    intensity = GetTracesIntensity(gTraces);
    PlotHistgramAndFitGaussian(handles.IntensityAxes,intensity,binsize,xAxesEnd,fitOption,gTraces.moleculenum,'Intensity (a.u.)');
end
end

