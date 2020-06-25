function [intensity] = GetZprojectIntensityByXY(TifRawData,meanx,meany)
%GETINTENSITY  return the average 3*3 pixels intensity profile in time
% meanx,meany is the center of the point(Qdot) that we want to trace its intensity  
row1 = TifRawData(meany-1,meanx-1,:)+TifRawData(meany-1,meanx,:)+TifRawData(meany-1,meanx+1,:);
row2 = TifRawData(meany,meanx-1,:)+TifRawData(meany,meanx,:)+TifRawData(meany,meanx+1,:);
row3 = TifRawData(meany+1,meanx-1,:)+TifRawData(meany+1,meanx,:)+TifRawData(meany+1,meanx+1,:);
intensity = row1+row2+row3;
intensity = reshape(intensity/9,1,max(size(intensity)));
end

