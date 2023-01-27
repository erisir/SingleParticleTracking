function LoadIRMImage(handles)
%LOADIRMIMAGE  
%    
    global gImages;
    global Workspace;
    warning off;
    [file,path] = uigetfile('*.tif;*.tiff','open',Workspace);
    filefullpath = [path,file];
    if path ==0
        return
    end
    LogMsg(handles,"Start to Load IRM image");

    gImages.IRMImage = mean(FastReadTirf(filefullpath),3);
    intensity_low = floor(mean(mean(gImages.IRMImage)));
    intensity_high = floor(max(max(gImages.IRMImage)));

    set(handles.Slider_Threadhold_Low,'min',intensity_low/2);
    set(handles.Slider_Threadhold_Low,'max',intensity_high/2);
    set(handles.Slider_Threadhold_Low,'value',intensity_low/2);

    set(handles.Slider_Threadhold_High,'min',intensity_low/2);
    set(handles.Slider_Threadhold_High,'max',intensity_high/2);
    set(handles.Slider_Threadhold_High,'value',intensity_high/2);
    imshow(gImages.IRMImage,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);
    LogMsg(handles,["Finish Loading IRM image  ",file]);
     beep;
end

