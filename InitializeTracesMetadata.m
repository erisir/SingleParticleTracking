function [] = InitializeTracesMetadata()
%INITIALIZETRACESMETADATA 此处显示有关此函数的摘要
%   此处显示详细说明
global gTraces;

gTraces.smoothWindowSize = 10;
gTraces.pixelSize = 65.98;
    
nums = size(gTraces.Catalogs,1);
gTraces.CatalogsContainor = cell(1,nums);

gTraces.showCatalog = 1:size(gTraces.molecules,2);
gTraces.moleculenum = max(gTraces.showCatalog);
gTraces.fiducialMarkerIndex = [];

%initial metadata
metadata.Intensity = [0,0,0,0];
metadata.IntensityDwell = [0,0];
metadata.PathLength = [0,0,0,0];
metadata.PathLengthSlope = [0,0];
metadata.Distance = [0,0,0,0];
metadata.DistanceSlope = [0,0];
metadata.SetCatalog = 'All';


for i = 1:gTraces.moleculenum
    results = gTraces.molecules(i).Results;
    framecloumn = results(:,1);
    startFrame = min(framecloumn);
    endFrame = max(framecloumn);
    temp = [startFrame,endFrame,startFrame,endFrame];
    metadata.Intensity = temp;
    metadata.PathLength = temp;
    metadata.Distance = temp;
    metadata.IntensityDwell = [endFrame-startFrame,endFrame-startFrame];
    gTraces.Metadata(i) = metadata;    
end
 
gTraces.CurrentShowTpye = 'All';
gTraces.CurrentShowNums = gTraces.moleculenum ;
gTraces.CurrentShowIndex = 1:gTraces.moleculenum;


end

