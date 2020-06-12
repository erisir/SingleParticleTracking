function [pos] = FindPoints(img,threadhold)
%FINDPOINTS 此处显示有关此函数的摘要
%   此处显示详细说明
[height,width] = size(img);
img(find(img<threadhold)) = 0;
locs = imregionalmax(img);
index = find(locs);
pointNum = length(index);
if CheckGpuSupported()
    pos = zeros(pointNum,2,'gpuArray');
else
    pos = zeros(pointNum,2);
end
for i = 1:pointNum
    y = mod(index(i),height);
    if y==0
        y=height;
    end
    x = ceil(index(i)/height);
    pos(i,1) =  x;
    pos(i,2) =  y;
end
end

