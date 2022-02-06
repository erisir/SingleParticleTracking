function [fitErrorTotalNums] = SetupCatalogByMetadata(handles)
%SETUPCATALOGBYMETADATA  
%    
    global gTraces;

    nums = size(gTraces.Config.Catalogs,1);
    gTraces.CatalogsContainor = cell(1,nums);
    dataQuality = handles.Data_Quality_Show_Group.SelectedObject.String;

    fitErrorTotalNums = 0;
    outofTrustBandsNums = 0;
    for trackId = 1:gTraces.moleculenum
        
        if gTraces.Metadata(trackId).DataQuality == "Error"
            fitErrorTotalNums = fitErrorTotalNums+1;
            continue
        end
        
        if ~isTimePointInTrustBands(get(handles.TrustBands,'String'),trackId)
            %outofTrustBandsNums = outofTrustBandsNums+1;
            fitErrorTotalNums = fitErrorTotalNums+1;
            continue
        end

        setType = gTraces.Metadata(trackId).SetCatalog;
        res = find(gTraces.Config.Catalogs==setType);

        if strcmp(dataQuality,"All")==1 %dataQuality control
            if get(handles.Get_DataQuality_Perfect_Good,'value')
                if strcmp("Perfect",gTraces.Metadata(trackId).DataQuality)==1 || strcmp("Good",gTraces.Metadata(trackId).DataQuality)==1
                    gTraces.CatalogsContainor{res} = [gTraces.CatalogsContainor{res},trackId];
                end 
            else
                gTraces.CatalogsContainor{res} = [gTraces.CatalogsContainor{res},trackId];
            end
        else
            if strcmp(dataQuality,gTraces.Metadata(trackId).DataQuality)==1             
                gTraces.CatalogsContainor{res} = [gTraces.CatalogsContainor{res},trackId];
            end 
        end
        
    end
end

