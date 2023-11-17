function [pathlenght] = CalculatePathLengh(smoothRelativePosX,smoothRelativePosY)
%CALCULATEPATHLENGH accumulation of overall movement,including fitting
%noise
    % here is the trick, if a = [1,2,3,4,5,6,7,8],
    % than b =  a(2:datalength)=[2,3,4,5,6,7,8], 
    % so c = b -a(1:(datalength-1)) = [1,1,1,1,1,1], 
    % where c(i) = a(i+1)-a(i)£¬ define our deltaX/Y as follows
    length = numel(smoothRelativePosY);
    smRPosXPlus1 =smoothRelativePosX(2:length);
    smRPosYPlus1 = smoothRelativePosY(2:length);
    %deltaX£¨i£© =  smoothRelativePosX(i+1)-smoothRelativePosX(i)
    deltaX = smRPosXPlus1 -smoothRelativePosX(1:(length-1));%N = n-1
    deltaY = smRPosYPlus1 - smoothRelativePosY(1:(length-1));
    %distance between each frame
    deltaDistance = sqrt(deltaX.*deltaX+deltaY.*deltaY);
    
    pathlenght = zeros(length,1);
    accErr = zeros(1,length);
    for j = 1:(length-1)
        pathlenght(j+1) = sum(deltaDistance(1:j));
    end    
end

