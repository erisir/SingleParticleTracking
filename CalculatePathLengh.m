function [pathlenght] = CalculatePathLengh(smoothRelativePosX,smoothRelativePosY,datalength)
%CALCULATEPATHLENGH accumulation of overall movement,including fitting
%noise
% here is the trick, if a = [1,2,3,4,5,6,7,8],
% than b =  a(2:datalength)=[2,3,4,5,6,7,8], 
% so c = b -a(1:(datalength-1)) = [1,1,1,1,1,1], 
% where c(i) = a(i+1)-a(i)£¬ define our deltaX/Y as follows
smRPosXPlus1 =smoothRelativePosX(2:datalength);
smRPosYPlus1 = smoothRelativePosY(2:datalength);
%deltaX£¨i£© =  smoothRelativePosX(i+1)-smoothRelativePosX(i)
deltaX = smRPosXPlus1 -smoothRelativePosX(1:(datalength-1));%N = n-1
deltaY = smRPosYPlus1 - smoothRelativePosY(1:(datalength-1));
%distance between each frame
deltaDistance = sqrt(deltaX.*deltaX+deltaY.*deltaY);
pathlenght = zeros(1,datalength);
accErr = zeros(1,datalength);
for j = 1:(datalength-1)
    pathlenght(j+1) = sum(deltaDistance(1:j));
end    
end

