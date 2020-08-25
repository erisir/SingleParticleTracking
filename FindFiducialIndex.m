function [Index] = FindFiducialIndex(traces,plotFlag)
%FINDFIDUCIALINDEX 此处显示有关此函数的摘要
%   此处显示详细说明

dwellTime = [];
for i = 1:traces.moleculenum
    dwellTime(i) = size(traces.molecules(i).Results(:,1),1);%get the size of framecolumn
end
Index = find(dwellTime ==max(dwellTime) );
bigFitErrorIndex = [];
for i =1:size(Index,2)
    moleculeIndex = Index(i);
    results = traces.molecules(moleculeIndex).Results;
    fitError = results(:,9);
    if mean(fitError)>5
        bigFitErrorIndex = [bigFitErrorIndex,i];
    end
end
Index(bigFitErrorIndex) = [];
if(size(Index,2)> 20)
    Index = Index(1:20);
end
%Index = [73,92,116,125,359,208,406,582];
%Index = [73,89,132,156,140,138,146,163,174,168,184,187,191,195,200,210,225,233,238];
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
%Index = Index(1:10); 
if plotFlag ==1
    global gTraces;
    gTraces.fiducialMarkerIndex = Index;
    figure;
    handle = subplot(1,1,1);
    plot(handle,0,0,'o');
    [driftx,drifty,smoothDriftx,smoothDrifty] = SmoothDriftTraces(traces,Index);
  
    hold(handle,'on');
    str = ["o"];
    for i = 1:size(Index,2)
        x = traces.molecules(Index(i)).Results(:,3);
        y = traces.molecules(Index(i)).Results(:,4);
        str = [str,string(Index(i))];
        plot(handle,x-x(1),y-y(1));
    end
    str = [str,"smooth"];
    plot(handle,smoothDriftx,smoothDrifty,'k*','markersize',10);
    plot(handle,smoothDriftx,smoothDrifty,'k','markersize',10);
    legend(handle,str);
    
    figure;
    colNums = ceil(size(Index,2)/2);
    for i = 1:size(Index,2)
        x = traces.molecules(Index(i)).Results(:,3);
        y = traces.molecules(Index(i)).Results(:,4);
        subplot(2,colNums,i);
        p=plot(x,y);
        legend('X');
        set(p,'ButtonDownFcn', {@GcaMouseDownFcnFindFiducial,handle,Index(i)});
        title(['\color{red}' int2str(Index(i))]);
    end
end

end

