function [intensity] = GetTracesIntensity(traces)
%GETTRACESINTENSITY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
intensity = [];
for i = 1:traces.moleculenum
    results = traces.molecules(i).Results;
    Amplitude =  results(:,8);
    intensity(i) = mean(Amplitude);
end
end

