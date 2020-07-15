function [] = SetupCatalogByMetadata()
%SETUPCATALOGBYMETADATA  
%    
global gTraces;
gTraces.Stuck_Go = [];
gTraces.Go_Stuck = [];
gTraces.Stuck_Go_Stuck = [];
gTraces.Go_Stuck_Go = [];
gTraces.NonLinear = [];
gTraces.Stepping = [];
gTraces.Perfect = [];
gTraces.Temp = [];

for i = 1:size(gTraces.Metadata,2)
    setType = gTraces.Metadata(i).SetCatalog;
    switch setType
        case 'Stuck_Go'
             gTraces.Stuck_Go = [gTraces.Stuck_Go,i];          
        case 'Go_Stuck'
             gTraces.Go_Stuck = [gTraces.Go_Stuck,i];
 
        case 'Stuck_Go_Stuck'
             gTraces.Stuck_Go_Stuck = [gTraces.Stuck_Go_Stuck,i];
 
        case 'Go_Stuck_Go'
             gTraces.Go_Stuck_Go = [gTraces.Go_Stuck_Go,i];
 
        case 'NonLinear'      
             gTraces.NonLinear = [gTraces.NonLinear,i];
        case 'Stepping'
            gTraces.Stepping = [gTraces.Stepping,i];
        case 'Perfect'      
             gTraces.Perfect = [gTraces.Perfect,i];
        case 'Temp'
             gTraces.Temp = [gTraces.Temp,i];
    end
end
end

