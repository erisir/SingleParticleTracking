function  LoadImageStack(handles)
%LOADIMAGESTACK  
    warning off; 
    global gImages;
    global Workspace;
    LogMsg(handles,"Start to Load Stack");
    [file,path] = uigetfile('*.tif;*.tiff','open',Workspace);
    gImages.filefullpath = [path,file];
    if path ==0
       return
    end
    gImages.rawImagesStack = FastReadTirf(gImages.filefullpath);
 
    [gImages.imgHeight,gImages.imgWidth,gImages.stackSize]= size(gImages.rawImagesStack);
    gImages.ZprojectMean = mean(gImages.rawImagesStack,3);
    gImages.ZprojectMax = max(gImages.rawImagesStack,[],3);

    intensity_low = floor(mean(mean(gImages.ZprojectMean)));
    intensity_high = floor(max(max(gImages.ZprojectMean)));

    set(handles.Slider_Threadhold_Low,'min',intensity_low/2);
    set(handles.Slider_Threadhold_Low,'max',intensity_high/2);
    set(handles.Slider_Threadhold_Low,'value',intensity_low/2);

    set(handles.Slider_Threadhold_High,'min',intensity_low/2);
    set(handles.Slider_Threadhold_High,'max',intensity_high/2);
    set(handles.Slider_Threadhold_High,'value',intensity_high/2);
    set(handles.Slider_Stack_Index,'Min',1);
    set(handles.Slider_Stack_Index,'Max',gImages.stackSize);
    set(handles.Slider_Stack_Index,'value',1);

    imshow(gImages.ZprojectMean,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);

    set(handles.Slider_Stack_Index,'SliderStep',[1/gImages.stackSize,0.01]);
    set(handles.Slider_Threadhold_Low,'SliderStep',[2/intensity_high,0.01]);
    set(handles.Slider_Threadhold_High,'SliderStep',[2/intensity_high,0.01]);

    LogMsg(handles,["Finish Loading Stack   ",file]);
end

