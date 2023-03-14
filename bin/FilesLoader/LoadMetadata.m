function   LoadMetadata(handles)
%LOADMETADATA  
%    
    global gTraces;
    global Workspace;

    if isempty(gTraces.TracesPath)
        [file,path] = uigetfile('*.mat','load',Workspace);
    else
        [file,path] = uigetfile('*.mat','load',gTraces.TracesPath);
    end
    if file ==0
        return;
    end
    filefullpath = [path,file];
    matData = load(filefullpath);
    LogMsg(handles,'start to Load Metadata');

    temp = matData.formatedData;
    if ~isfield(temp,'Config')
        temp.Config.smoothWindowSize = 10;%frame
        temp.Config.maxFitError = 7;%nm
        temp.Config.MinimumMoveDistance = 10;%nm
        temp.Config.MaximumMoveDistance = 1000;%nm
        temp.Config.FrameTrasferTimems = 37.5 ;
        temp.Config.DistanceAxesBinSize = 0.3 ;
        temp.Config.DistanceAxesBinEnd =  25;
        temp.Config.PathLengthAxesBinSize = 1 ;
        temp.Config.PathLengthAxesBinEnd =  100;
        temp.Config.IntensityAxesBinSize =  1;
        temp.Config.IntensityAxesBinEnd =  500;
        temp.Config.Version =  "21.3.8";
        temp.Config.Catalogs = ["All";"Stuck_Go";"Go_Stuck";"Stuck_Go_Stuck";"Go_Stuck_Go";"NonLinear";"Stepping";"BackForward";"Diffusion";"Temp"];
    else
        Config = temp.Config;
         if ~isfield(Config,'FirstFrame')
            temp.Config.FirstFrame = gTraces.Config.FirstFrame;%frame
        end
        if ~isfield(Config,'LastFrame')
            temp.Config.LastFrame = gTraces.Config.LastFrame;%nm
        end
        if ~isfield(Config,'smoothWindowSize')
            temp.Config.smoothWindowSize = 10;%frame
        end
        if ~isfield(Config,'maxFitError')
            temp.Config.maxFitError = 7;%nm
        end
        if ~isfield(Config,'MinimumMoveDistance')
             temp.Config.MinimumMoveDistance = 10;%nm
        end
        if ~isfield(Config,'MaximumMoveDistance')
            temp.Config.MaximumMoveDistance = 1000;%nm
        end
        if ~isfield(Config,'FrameTrasferTimems')
             temp.Config.FrameTrasferTimems = 37.5 ;
        end
        if ~isfield(Config,'TrustBands')
            temp.Config.TrustBands =  "";
        end
        if isfield(Config,'fiducialMarkerIndex')%%data don't have drift correct, correct it manually
          [gTraces.driftx,gTraces.drifty,gTraces.smoothDriftx,gTraces.smoothDrifty] = SmoothDriftTraces(gTraces,Config.fiducialMarkerIndex);
           gTraces.fiducialFrameIndicator = gTraces.Config.FirstFrame:gTraces.Config.LastFrame;%save the start frame of the ficucial for substration
           gTraces.manualDriftCorrection = 1;
        end
        
    end
    versionMatch = strcmp(temp.Config.Version,gTraces.Config.Version);
    tempVersionStr = gTraces.Config.Version;
    temp.Config.StackSize = gTraces.Config.StackSize;
    gTraces.Config = temp.Config;
    gTraces.Config.Version = tempVersionStr;
    gTraces.Metadata = temp.metadata;
    versionCoverStr = "";
    if ~versionMatch
        warning off;
        gTraces.Metadata = DataConversion(temp.metadata);
        warning on;
        versionCoverStr = "cover data to ["+gTraces.Config.Version+"]";
    end
    
    

    set(handles.Traces_ShowType_List,'String',gTraces.Config.Catalogs);
    set(handles.Traces_SetType_List,'String',gTraces.Config.Catalogs); 
    set(handles.Frame_Expusure_Timems,'String',num2str(gTraces.Config.ExpusureTimems));
    set(handles.Frame_Transfer_Timems,'String',num2str(gTraces.Config.FrameTrasferTimems));

    set(handles.TrustBands,'String',gTraces.Config.TrustBands);

    catalognums = size(gTraces.Config.Catalogs,1);

    %run time parametter, no need to save to Config
    gTraces.CatalogsContainor = cell(1,catalognums);% to save different type of trace here, only the index will save
    gTraces.showCatalog = 1:size(gTraces.molecules,2);%current show catalog(when use click the showtype list)
    gTraces.moleculenum = max(gTraces.showCatalog);% show in the total tag

    SetupCatalogByMetadata(handles);
    
    gTraces.CurrentShowTpye = "Temp";
   
    
    index = find(gTraces.Config.Catalogs==gTraces.CurrentShowTpye);
    set(handles.Traces_ShowType_List,'Value',index);
    
    gTraces.CurrentShowIndex = gTraces.CatalogsContainor{index};
    gTraces.CurrentShowNums = size(gTraces.CatalogsContainor{index},2);
    
    set(handles.TotalParticleNum,'String',int2str(gTraces.CurrentShowNums));

    set(handles.Current_Trace_Id,'String',num2str(1));
    set(handles.TotalParticleNum,'String',int2str(gTraces.CurrentShowNums));

    PlotTrace(handles,1,0);%plot all

    LogMsg(handles,"Finish Loading Metatata "+file+" "+versionCoverStr);
    beep;
end

