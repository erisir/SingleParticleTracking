function ShowTraceCategory(handles,category)
%SHOWTRACECATEGORY  
%    
    global gTraces;
    fitErrorNums = SetupCatalogByMetadata(handles);
    gTraces.CurrentShowTpye = category;
    index = find(gTraces.Config.Catalogs==category);
    if index ==1%all
        gTraces.CurrentShowNums = gTraces.moleculenum ;
        gTraces.CurrentShowIndex = 1:gTraces.moleculenum;
        set(handles.TotalParticleNum,'String',[int2str(gTraces.moleculenum-fitErrorNums),'+',int2str(fitErrorNums),'Err']);
    else
        gTraces.CurrentShowIndex = gTraces.CatalogsContainor{index};
        gTraces.CurrentShowNums = size(gTraces.CatalogsContainor{index},2);    
        set(handles.TotalParticleNum,'String',int2str(gTraces.CurrentShowNums));
    end
    set(handles.Current_Trace_Id,'String',num2str(1)); %go to the first 
end

