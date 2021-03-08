function PrepareDataForNN()
%PREPAREDATAFORNN �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    global gTraces;
    type = cell(1,gTraces.moleculenum);
    distance = cell(1,gTraces.moleculenum);
    for traceId = 1:gTraces.moleculenum
        ts = GetTimeSeriesByTraceId(traceId);
        distance{traceId} = ts.displacement;
        metadata=gTraces.Metadata(traceId) ; % Indexs(i) is the real index
        type{traceId} = metadata.SetCatalog;
    end
       %MyStructHere = evalin('base','MyStruct');
    assignin('base','distance',distance);
    assignin('base','type',type);
    finish = 1
end

