function  LoadTraces(handles)
%LOADTRACES
    global gTraces;
    global gImages;
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
    gImages = [];
    gTraces.TracesPath = path;
    gTraces.molecules = molecule;
    gTraces.Config = config;

    LogMsg(handles,["Finish Loading Traces Data  ",file]);
    set(handles.figure1,'Name',['FIESTA Data Processing-----------------       ', file]);
end

