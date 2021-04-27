function  LoadTraces(handles)
%LOADTRACES
    global gTraces;
    global Workspace;

    LogMsg(handles,"Start to Load Traces Data");

    [file,path] = uigetfile('*.mat','load',Workspace);
    filefullpath = [path,file];

    if path ==0
        LogMsg(handles,"Load Traces false,user cancel");
        return
    end

    [molecule,config] = LoadFiestaMatData(filefullpath);
    gTraces = [];
    gTraces.TracesPath = path;
    gTraces.molecules = molecule;
    gTraces.moleculenum =  size(gTraces.molecules,2);% show in the total tag
    gTraces.Config = config;
    gTraces.Config.Version =  "21.3.8";
    
    LogMsg(handles,["Finish Loading Traces Data  ",file]);
    set(handles.figure1,'Name',['FIESTA Data Processing-----------------       ', file]);
end

