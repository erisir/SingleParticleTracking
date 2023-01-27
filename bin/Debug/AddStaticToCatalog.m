function AddStaticToCatalog(handles)
%ADDSTATICTOCATALOG Summary of this function goes here
%   Detailed explanation goes here
global gTraces;
gTraces.Config.Catalogs = ["All";"Stuck_Go";"Go_Stuck";"Stuck_Go_Stuck";"Go_Stuck_Go";"NonLinear";"Stepping";"BackForward";"Diffusion";"Static";"Temp"];
set(handles.Traces_ShowType_List,'String',gTraces.Config.Catalogs);
set(handles.Traces_SetType_List,'String',gTraces.Config.Catalogs); 

for traceId = 1:gTraces.moleculenum
       
        series = GetTimeSeriesByTraceId(traceId);        
       
        metadata = gTraces.Metadata(traceId); 
        

        if mean(series.fitError) <= gTraces.Config.maxFitError 
            smoothwindow = 5;
            if ~MovementDetectionByDisplacement(series.displacement,smoothwindow)  
               metadata.DataQuality= 'All';
               metadata.SetCatalog= 'Static';
            end
        end
        gTraces.Metadata(traceId) = metadata;    
end
    
end

