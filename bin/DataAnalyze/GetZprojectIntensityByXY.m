function [intensity] = GetZprojectIntensityByXY(TifRawData,frameIndicator,absXposition,absYposition)
% NOT USE GETINTENSITY  return the average 3*3 pixels intensity profile in time
% meanx,meany is the center of the point(Qdot) that we want to trace its intensity 
    global gTraces;
    driftx = gTraces.driftx;
    drifty = gTraces.drifty;
    driftx = driftx - driftx(1);
    drifty = drifty - drifty(1);
    intensity = zeros(1,gTraces.Config.StackSize);
 
    totalFrame = frameIndicator(1):frameIndicator(end);
    
    totalAbsXposition = interp1(frameIndicator,absXposition,totalFrame);
    totalAbsYposition = interp1(frameIndicator,absYposition,totalFrame);
    driftx = driftx - driftx(frameIndicator(1));
    drifty = drifty - drifty(frameIndicator(1));
    beforeX=[];
    beforeY = [];
    afterX = [];
    afterY = [];
    if frameIndicator(1)>1
        beforeX = driftx(1:frameIndicator(1))+totalAbsXposition(1);
        beforeY = drifty(1:frameIndicator(1))+totalAbsYposition(1);
    end
    if frameIndicator(end)<gTraces.Config.StackSize
        afterX = driftx(frameIndicator(end):(gTraces.Config.StackSize))+totalAbsXposition(end);
        afterY = drifty(frameIndicator(end):(gTraces.Config.StackSize))+totalAbsYposition(end);
    end
    totalAbsXposition = [beforeX',totalAbsXposition,afterX'];
    totalAbsYposition = [beforeY',totalAbsYposition,afterY'];
    totalAbsXposition = round(totalAbsXposition/gTraces.Config.pixelSize);
    totalAbsYposition = round(totalAbsYposition/gTraces.Config.pixelSize);
    try
        for i = 1:gTraces.Config.StackSize
            row1 = TifRawData(totalAbsYposition(i)-1,totalAbsXposition(i)-1,i)+TifRawData(totalAbsYposition(i)-1,totalAbsXposition(i),i)+TifRawData(totalAbsYposition(i)-1,totalAbsXposition(i)+1,i);
            row2 = TifRawData(totalAbsYposition(i),totalAbsXposition(i)-1,i)+TifRawData(totalAbsYposition(i),totalAbsXposition(i),i)+TifRawData(totalAbsYposition(i),totalAbsXposition(i)+1,i);
            row3 = TifRawData(totalAbsYposition(i)+1,totalAbsXposition(i)-1,i)+TifRawData(totalAbsYposition(i)+1,totalAbsXposition(i),i)+TifRawData(totalAbsYposition(i)+1,totalAbsXposition(i)+1,i);
            intensity(i) = row1+row2+row3/9;
        end
    catch
    end
end

