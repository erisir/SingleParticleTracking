function [fitErrorTotalNums] = SetupCatalogByMetadata(handles)
%SETUPCATALOGBYMETADATA  
%    
global gTraces;

nums = size(gTraces.Config.Catalogs,1);
gTraces.CatalogsContainor = cell(1,nums);
dataQuality = handles.Data_Quality_Show_Group.SelectedObject.String;

GetPerfectAndGoodDataOnly = false;

fitErrorTotalNums = 0;
for i = 1:size(gTraces.Metadata,2)
    if gTraces.Metadata(i).DataQuality == "Error"
        fitErrorTotalNums = fitErrorTotalNums+1;
        continue
    end
    setType = gTraces.Metadata(i).SetCatalog;
    res = find(gTraces.Config.Catalogs==setType);
    if strcmp(dataQuality,"All")==1
        if GetPerfectAndGoodDataOnly
            if strcmp("Perfect",gTraces.Metadata(i).DataQuality)==1 ||   strcmp("Good",gTraces.Metadata(i).DataQuality)==1      
                gTraces.CatalogsContainor{res} = [gTraces.CatalogsContainor{res},i];
            end 
        else
        	gTraces.CatalogsContainor{res} = [gTraces.CatalogsContainor{res},i];
        end
    else
        if strcmp(dataQuality,gTraces.Metadata(i).DataQuality)==1             
            gTraces.CatalogsContainor{res} = [gTraces.CatalogsContainor{res},i];
        end 
    end
end
%assignin('base', 'CatalogsContainor',  gTraces.CatalogsContainor);

end

