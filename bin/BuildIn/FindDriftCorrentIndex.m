function [index] = FindDriftCorrentIndex(fiducialFrameIndicator,frameIndicator)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
index = [];
for i = 1:size(frameIndicator,1)
    temp = find(fiducialFrameIndicator==frameIndicator(i));
    if(isempty(temp))
        disp("error in finding the index for sub");
        return;
    end
    index = [index;temp];
end
