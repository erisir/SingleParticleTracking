function [] = PlotZoomInImages(handles,frameIndicator,absXposition,absYposition,pixelSize,Amplitude)
%PLOTTHEZOOMIMAGEBYPOSITIONANDFRAME  
%   
%the result is used to show the corresponding spot so we can compare
%the traces and the raw images

    global gImages;
    stackSize = floor(get(handles.Slider_Stack_Index,'Max'));
    intensity_low = get(handles.Slider_Threadhold_Low,'Value');
    intensity_high = get(handles.Slider_Threadhold_High,'Value');
    
    currentDisplayFrame = floor(get(handles.Slider_Stack_Index,'Value'));
    
    indexInFramecloumn = find(frameIndicator ==currentDisplayFrame);% to avoid the skiped frame that due to blinking in fiesta
    if  indexInFramecloumn~=0
        meanx = floor(absXposition(indexInFramecloumn)/pixelSize);
        meany = floor(absYposition(indexInFramecloumn)/pixelSize); 
    else
        meanx = floor(mean(absXposition)/pixelSize);
        meany = floor(mean(absYposition)/pixelSize); 
    end
    
    set(handles.CurrentPointXpos,'String',num2str(meanx));
    set(handles.CurrentPointYpos,'String',num2str(meany));
    
    %try to use a 80*80 pixels to show the raw images[ROI base on the
    %meanx,meany],if something goes wrong,i.e. when the spot is on the edge
    %of the image,this will cause a out of array size error.(then we can reduce the ROI size to 10*10)
    %the images is composed of ROI from the Qdot images and the IRM images
    %we load in to workspace previously.
    width  =40;        
    if ~isempty(gImages)
        try   
            width  =40;          
            cropedIRM = gImages.IRMImage(meany-width:meany+width,meanx-width:meanx+width);
            cropedRawImages=gImages.rawImagesStack(meany-width:meany+width,meanx-width:meanx+width,currentDisplayFrame); 
            imshow(cropedIRM,[],'Parent',handles.IRMZoomAxes);
            imshow(cropedRawImages,[intensity_low,intensity_high],'Parent',handles.RawImageZoomAxes);   
        catch
            try
                width  =5;          
                cropedIRM = gImages.IRMImage(meany-width:meany+width,meanx-width:meanx+width);
                cropedRawImages=gImages.rawImagesStack(meany-width:meany+width,meanx-width:meanx+width,currentDisplayFrame); 
                imshow(cropedIRM,[],'Parent',handles.IRMZoomAxes);
                imshow(cropedRawImages,[],'Parent',handles.RawImageZoomAxes);   
            catch ME
                %disp('no images load or out of range');
                imshow([0,0;0,0],[],'Parent',handles.RawImageZoomAxes);  
                imshow([0,0;0,0],[],'Parent',handles.IRMZoomAxes);
                rethrow(ME)
            end
        end
    else
         imshow([0,0;0,0],[],'Parent',handles.RawImageZoomAxes);  
         imshow([0,0;0,0],[],'Parent',handles.IRMZoomAxes);
    end
   
    hold(handles.IRMZoomAxes, 'on');         
    hold(handles.RawImageZoomAxes, 'on');     
    plot(handles.IRMZoomAxes,width,width,'ro','markersize',10);%show a red circle around the current shown spot
    plot(handles.RawImageZoomAxes,width+3,width,'ro','markersize',20);
    hold(handles.IRMZoomAxes, 'off');
    hold(handles.RawImageZoomAxes, 'off');
    
    if ~isempty(gImages)% not importance 
        if currentDisplayFrame ==stackSize
            imshow(gImages.IRMImage,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);
        else
            imshow(gImages.rawImagesStack(:,:,currentDisplayFrame),[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes); 
        end
            
    else
        imshow([0,0;0,0],[],'Parent',handles.ImageWindowAxes); 
    end
    hold(handles.ImageWindowAxes,'on');
    plot(handles.ImageWindowAxes,meanx,meany,'ro','MarkerSize',10);
    hold(handles.ImageWindowAxes,'off');
end

