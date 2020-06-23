function [] = SetupCatalogByMetadata()
%SETUPCATALOGBYMETADATA �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global gTraces;
gTraces.Stuck_Go = [];
gTraces.Go_Stuck = [];
gTraces.Stuck_Go_Stuck = [];
gTraces.Go_Stuck_Go = [];
gTraces.NonLinear = [];
gTraces.Perfect = [];
for i = 1:gTraces.moleculenum
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
 
        case 'Perfect'      
             gTraces.Perfect = [gTraces.Perfect,i];
 
    end
end
end

