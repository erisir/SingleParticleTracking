function [Index] = FindFiducialIndex(traces)
%FINDFIDUCIALINDEX �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

dwellTime = [];
for i = 1:traces.moleculenum
    dwellTime(i) = size(traces.molecules(i).Results(:,1),1);%get the size of framecolumn
end
Index = find(dwellTime ==max(dwellTime) );

plotFlag = 1;
if plotFlag ==1
    figure;
    for i = 1:size(Index,2);
        x = traces.molecules(Index(i)).Results(:,3);
        y = traces.molecules(Index(i)).Results(:,4);
        subplot(2,2,i);
        plot(x,y);
        title(int2str(Index(i)));
    end
end

end

