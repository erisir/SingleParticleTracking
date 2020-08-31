function [intensity] = GetTracesMeanIntensity(traces)
% Use in plot histgram
%   
intensity = [];
for i = 1:traces.moleculenum
    results = traces.molecules(i).Results;
    Amplitude =  results(:,8);
    intensity(i) = mean(Amplitude);
end
end

