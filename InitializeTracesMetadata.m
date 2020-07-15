function [] = InitializeTracesMetadata()
%INITIALIZETRACESMETADATA �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global gTraces;

gTraces.smoothWindowSize = 10;
gTraces.pixelSize = 65.98;
    
    
gTraces.Stuck_Go = [];
gTraces.Go_Stuck = [];
gTraces.Stuck_Go_Stuck = [];
gTraces.Go_Stuck_Go = [];
gTraces.NonLinear = [];
gTraces.Stepping = [];
gTraces.Perfect = [];
gTraces.Temp = [];

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

