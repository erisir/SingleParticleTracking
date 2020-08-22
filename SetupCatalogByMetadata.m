function [] = SetupCatalogByMetadata(handles)
%SETUPCATALOGBYMETADATA  
%    
global gTraces;

nums = size(gTraces.Catalogs,1);
gTraces.CatalogsContainor = cell(1,nums);
dataQuality = handles.Data_Quality_Show_Group.SelectedObject.String;
for i = 1:size(gTraces.Metadata,2)
    setType = gTraces.Metadata(i).SetCatalog;
    res = find(gTraces.Catalogs==setType);
    if strcmp(dataQuality,"All")==1
        gTraces.CatalogsContainor{res} = [gTraces.CatalogsContainor{res},i];
    else
        if strcmp(dataQuality,gTraces.Metadata(i).DataQuality)==1             
            gTraces.CatalogsContainor{res} = [gTraces.CatalogsContainor{res},i];
        end 
    end
end
end

