function [intensity] = GetTracesIntensity(traces)
%GETTRACESINTENSITY 此处显示有关此函数的摘要
%   此处显示详细说明
intensity = [];
for i = 1:traces.moleculenum
    results = traces.molecules(i).Results;
    Amplitude =  results(:,8);
    intensity(i) = mean(Amplitude);
end
end

