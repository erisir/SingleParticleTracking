function [] = SetupCatalogByMetadata()
%SETUPCATALOGBYMETADATA  
%    
global gTraces;

nums = size(gTraces.Catalogs,1);
gTraces.CatalogsContainor = cell(1,nums);
for i = 1:size(gTraces.Metadata,2)
    setType = gTraces.Metadata(i).SetCatalog;
    res = find(gTraces.Catalogs==setType);
    gTraces.CatalogsContainor{res} = [gTraces.CatalogsContainor{res},i];
end
end

