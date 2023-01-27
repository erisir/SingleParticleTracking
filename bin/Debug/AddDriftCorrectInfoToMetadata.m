function AddDriftCorrectInfoToMetadata()
%ADDDRIFTCORRECTINFOTOMETADATA Summary of this function goes here
%   Detailed explanation goes here
global gTraces;
%gTraces.Config.fiducialMarkerIndex = [8527,8528,8529,8536];
gTraces.Config.fiducialMarkerIndex = [1];
driftx = [];
drifty = [];
markerNums = numel(gTraces.Config.fiducialMarkerIndex);
for i = 1:markerNums
      results = gTraces.molecules(gTraces.Config.fiducialMarkerIndex(i)).Results;
      driftx = [driftx,results(:,3)];
      drifty = [drifty,results(:,4)]; 
      fiducialFrameIndicator = results(:,1);
end
gTraces.Config.DriftX = smooth(mean(driftx,2),10);
gTraces.Config.DriftY = smooth(mean(drifty,2),10);
gTraces.Config.fiducialFrameIndicator = fiducialFrameIndicator;
end

