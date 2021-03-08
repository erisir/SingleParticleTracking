function [displacement] = CalculateDisplacement(relativePositionX,relativePositionY)
%CALCULATEDISPLACEMENT  
%    
    displacement = sqrt(relativePositionX.*relativePositionX+relativePositionY.*relativePositionY);
end

