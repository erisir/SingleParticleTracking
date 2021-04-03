function  PlotOnRate()
%PLOTONRATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global gTraces;
gTraces.Config.maxFitError = 7;%nm
frameIndicator = [];
for traceId = 1:gTraces.moleculenum
    results = gTraces.molecules(traceId).Results;
    fitError = results(:,9);
    if mean(fitError)<gTraces.Config.maxFitError 
        frameIndicator = [frameIndicator;results(:,1)];  
    end
end

h1 = histogram(frameIndicator,1:2:700);
y = h1.Values;
plot(y);

end

