function [intensity] = GetZprojectIntensityByXY(TifRawData,meanx,meany)
%GETINTENSITY 此处显示有关此函数的摘要
%   此处显示详细说明
row1 = TifRawData(meany-1,meanx-1,:)+TifRawData(meany-1,meanx,:)+TifRawData(meany-1,meanx+1,:);
row2 = TifRawData(meany,meanx-1,:)+TifRawData(meany,meanx,:)+TifRawData(meany,meanx+1,:);
row3 = TifRawData(meany+1,meanx-1,:)+TifRawData(meany+1,meanx,:)+TifRawData(meany+1,meanx+1,:);
intensity = row1+row2+row3;
intensity = reshape(intensity/9,1,1000);
end

