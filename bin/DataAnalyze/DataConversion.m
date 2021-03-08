function [] = DataConversion(handles,matData)
% adding metadata to traces to save the dwelltime, velocity ,etc,.
%   
global gTraces;
matData = matData.formatedSaveDataFormat;
gTraces.Config.smoothWindowSize = 10;%frame
gTraces.Config.pixelSize = 65.98;%nm/pixel
gTraces.Config.maxFitError = 7;%nm
gTraces.Config.MinimumMoveDistance = 10;%nm

try
gTraces.Config.ExpusureTimems = matData.ExpusureTimems;
gTraces.Config.FrameTrasferTimems =matData.FrameTrasferTimems;
gTraces.Config.fiducialMarkerIndex = matData.fiducialMarkerIndex;

gTraces.Config.DistanceAxesBinSize = matData.DistanceAxesBinSize ;
gTraces.Config.DistanceAxesBinEnd =  matData.DistanceAxesBinEnd;
gTraces.Config.PathLengthAxesBinSize = matData.PathLengthAxesBinSize ;
gTraces.Config.PathLengthAxesBinEnd =  matData.PathLengthAxesBinEnd;
gTraces.Config.IntensityAxesBinSize =  matData.IntensityAxesBinSize;
gTraces.Config.IntensityAxesBinEnd =  matData.IntensityAxesBinEnd;

catch
    
end
gTraces.Config.Version =  "08.30.1";
gTraces.Config.Catalogs = ["All";"Stuck_Go";"Go_Stuck";"Stuck_Go_Stuck";"Go_Stuck_Go";"NonLinear";"Stepping";"BackForward";"Diffusion";"Temp"];


catalognums = size(gTraces.Config.Catalogs,1);

%run time parametter, no need to save to Config
gTraces.CatalogsContainor = cell(1,catalognums);% to save different type of trace here, only the index will save
gTraces.showCatalog = 1:size(gTraces.molecules,2);%current show catalog(when use click the showtype list)
gTraces.moleculenum = max(gTraces.showCatalog);% show in the total tag


 

 


for i = 1:size(matData.metadata,2)
    
    results = gTraces.molecules(i).Results;
    fitError = results(:,9);

    gTraces.Metadata(i).IntensityStartEndTimePoint = matData.metadata(i).Intensity;
    gTraces.Metadata(i).IntensityDwell = matData.metadata(i).IntensityDwell;
    gTraces.Metadata(i).PathLengthStartEndTimePoint = matData.metadata(i).PathLength;
    gTraces.Metadata(i).PathLengthSlope = matData.metadata(i).PathLengthSlope;
    gTraces.Metadata(i).DistanceStartEndTimePoint = matData.metadata(i).Distance;
    gTraces.Metadata(i).DistanceSlope = matData.metadata(i).DistanceSlope;
 
    if mean(fitError)>gTraces.Config.maxFitError 
        gTraces.Metadata(i).DataQuality= 'Error';
        gTraces.Metadata(i).SetCatalog = 'All';
    else
        if matData.metadata(i).SetCatalog == "All" 
            gTraces.Metadata(i).DataQuality= 'All';
            if MovementDetectionByTraceId(gTraces,i)
               gTraces.Metadata(i).SetCatalog= 'Temp';
            else
               gTraces.Metadata(i).SetCatalog= 'All';
            end
        else
            gTraces.Metadata(i).SetCatalog = matData.metadata(i).SetCatalog;
            try
                gTraces.Metadata(i).DataQuality = matData.metadata(i).DataQuality;
            catch
                gTraces.Metadata(i).DataQuality = 'All';
            end
            
        end
    end
   
end


end

