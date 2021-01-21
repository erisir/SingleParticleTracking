function [] = SysConfigAndInitializeTracesMetadata(handles)
% adding metadata to traces to save the dwelltime, velocity ,etc,.
%   
global gTraces;
global gImages;
gTraces.Config.smoothWindowSize = 10;%frame
gTraces.Config.maxFitError = 7;%nm
gTraces.Config.MinimumMoveDistance = 10;%nm
gTraces.Config.MaximumMoveDistance = 400;%nm
gTraces.Config.FrameTrasferTimems = 37.5 ;
gTraces.Config.DistanceAxesBinSize = 0.3 ;
gTraces.Config.DistanceAxesBinEnd =  25;
gTraces.Config.PathLengthAxesBinSize = 1 ;
gTraces.Config.PathLengthAxesBinEnd =  100;
gTraces.Config.IntensityAxesBinSize =  1;
gTraces.Config.IntensityAxesBinEnd =  500;
gTraces.Config.Version =  "08.30.1";
 
gTraces.Config.Catalogs = ["All";"Stuck_Go";"Go_Stuck";"Stuck_Go_Stuck";"Go_Stuck_Go";"NonLinear";"Stepping";"BackForward";"Diffusion";"Temp"];

set(handles.Traces_ShowType_List,'String',gTraces.Config.Catalogs);
set(handles.Traces_SetType_List,'String',gTraces.Config.Catalogs);
catalognums = size(gTraces.Config.Catalogs,1);

%run time parametter, no need to save to Config
gTraces.CatalogsContainor = cell(1,catalognums);% to save different type of trace here, only the index will save
gTraces.showCatalog = 1:size(gTraces.molecules,2);%current show catalog(when use click the showtype list)
gTraces.moleculenum = max(gTraces.showCatalog);% show in the total tag


gTraces.Config.fiducialMarkerIndex =FindFiducialIndex(gTraces);%auto find fiducial,dont plot it

[gTraces.driftx,gTraces.drifty,gTraces.smoothDriftx,gTraces.smoothDrifty]=SmoothDriftTraces(gTraces,gTraces.Config.fiducialMarkerIndex);%save the result to Traces struct

gTraces.fiducialFrameIndicator = gTraces.Config.FirstFrame:gTraces.Config.LastFrame;%save the start frame of the ficucial for substrate


%initial metadata
metadata.IntensityStartEndTimePoint = [0,0,0,0];
metadata.IntensityDwell = [0,0];
metadata.PathLengthStartEndTimePoint = [0,0,0,0];%
metadata.PathLengthSlope = [0,0];
metadata.DistanceStartEndTimePoint = [0,0,0,0];
metadata.DistanceSlope = [0,0];

metadata.SetCatalog = 'All';
metadata.DataQuality= 'All';

for i = 1:gTraces.moleculenum
    
    results = gTraces.molecules(i).Results;
    framecloumn = results(:,1);
    fitError = results(:,9);
 
    
    startFrame = min(framecloumn);
    endFrame = max(framecloumn);
    temp = [startFrame,endFrame,startFrame,endFrame];
    metadata.IntensityStartEndTimePoint = temp;
    metadata.PathLengthStartEndTimePoint = temp;
    metadata.DistanceStartEndTimePoint = temp;
    metadata.IntensityDwell = [endFrame-startFrame,endFrame-startFrame];
    
    if mean(fitError)>gTraces.Config.maxFitError 
        metadata.DataQuality= 'Error';
    else
        metadata.DataQuality= 'All';
        if MovementDetectionByTraceId(gTraces,i)
          
           metadata.SetCatalog= 'Temp';
        end
    end
    gTraces.Metadata(i) = metadata;    
end

gTraces.CurrentShowTpye = 'All';
gTraces.CurrentShowNums = gTraces.moleculenum ;
gTraces.CurrentShowIndex = 1:gTraces.moleculenum;

PlotTrace(gImages,gTraces,1,handles,0);%plot all

set(handles.Current_Trace_Id,'String',int2str(1));
set(handles.TotalParticleNum,'String',int2str(gTraces.moleculenum));

 
set(handles.Frame_Expusure_Timems,'String',num2str(gTraces.Config.ExpusureTimems));
set(handles.Frame_Transfer_Timems,'String',num2str(gTraces.Config.FrameTrasferTimems));
set(handles.DistanceAxes_BinSize,'String',num2str(gTraces.Config.DistanceAxesBinSize));
set(handles.DistanceAxes_BinEnd,'String',num2str(gTraces.Config.DistanceAxesBinEnd));
set(handles.PathLengthAxes_BinSize,'String',num2str(gTraces.Config.PathLengthAxesBinSize));
set(handles.PathLengthAxes_BinEnd,'String',num2str(gTraces.Config.PathLengthAxesBinEnd));
set(handles.IntensityAxes_BinSize,'String',num2str(gTraces.Config.IntensityAxesBinSize));
set(handles.IntensityAxes_BinEnd,'String',num2str(gTraces.Config.IntensityAxesBinEnd));

end

