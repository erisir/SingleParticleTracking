%figure;
MinThreshold  =800;
findchangepts(displacement,'Statistic','mean','MinThreshold',MinThreshold);
pos = findchangepts(displacement,'Statistic','mean','MinThreshold',MinThreshold);
%stepSizeMain = [];
%stepSize = [];
duration = [];
durationMain = [];
%meanValue = [];
for i = 1:(size(pos)-1)
    if i==1
        duration(i) = pos(i);
    else
        duration(i) = pos(i+1)-pos(i);
    end
end
%durationMain  = [durationMain ,duration];    