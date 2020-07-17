function [Index] = FindFiducialIndex(traces,plotFlag)
%FINDFIDUCIALINDEX 此处显示有关此函数的摘要
%   此处显示详细说明

dwellTime = [];
for i = 1:traces.moleculenum
    dwellTime(i) = size(traces.molecules(i).Results(:,1),1);%get the size of framecolumn
end
Index = find(dwellTime ==max(dwellTime) );
%Index = [17  38  75 ];%20200711_180521_2nMCel7aNaOH
%Index = [2,3,4,6,7,8,9,13];%10mw1000ms
%Index = [2,3,4,6,7,8,10,11,12,13,14];20mw250ms
%Index = [ 9    10    12    ]; 10mw500ms
%Index = [121,146];%6,20,27,58,59,97,182
%20200519_180044_2nMCel7a500pMQdot-Cat---[7,8]
%20200519_182711_10nMCel7a500pMQdot-Cat --[4851,4869]

%20200707_1809552nM_TIFFs--[29,30,41,69,86,101];%
%20200707_184841_500pM-1-1000 --[31,34];
%20200707_191303_100pM-1-1400--[121,146]
%
%

if plotFlag ==1
    global gTraces;
    gTraces.fiducialMarkerIndex = Index;
    figure;
    handle = subplot(1,1,1);
    [driftx,drifty,smoothDriftx,smoothDrifty] = SmoothDriftTraces(traces,Index);
    plot(handle,smoothDriftx,smoothDrifty,'r');
    hold on;
    str = ["smooth"];
    for i = 1:size(Index,2)
        x = traces.molecules(Index(i)).Results(:,3);
        y = traces.molecules(Index(i)).Results(:,4);
        str = [str,string(Index(i))];
        plot(handle,x-x(1),y-y(1));
    end
    legend(str);
    
    figure;
    colNums = ceil(size(Index,2)/2);
    for i = 1:size(Index,2)
        x = traces.molecules(Index(i)).Results(:,3);
        y = traces.molecules(Index(i)).Results(:,4);
        subplot(2,colNums,i);
        plot(x,y);
        legend('√');
        set(gca,'ButtonDownFcn', {@GcaMouseDownFcn,handle,Index(i)});
        title(int2str(Index(i)));
    end
end

end

