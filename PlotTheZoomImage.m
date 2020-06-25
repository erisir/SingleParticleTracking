function [] = PlotTheZoomImage(handles,images,frameIndicator,absXposition,absYposition,pixelSize,Amplitude)
%PLOTTHEZOOMIMAGEBYPOSITIONANDFRAME 此处显示有关此函数的摘要
%   此处显示详细说明
 %the result is used to show the corresponding spot so we can compare
    %the traces and the raw images
 
    stackSize = floor(get(handles.StackProgress,'Max'));
    low = get(handles.Threadhold,'Min');
    threadhold = get(handles.Threadhold,'Value');
    currentDisplayFrame = floor(get(handles.StackProgress,'Value'));
    
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

    try   
        width  =40;          
        cropedIRM = images.IRMImage(meany-width:meany+width,meanx-width:meanx+width);
        cropedRawImages=images.rawImagesStack(meany-width:meany+width,meanx-width:meanx+width,currentDisplayFrame); 
        imshow(cropedIRM,[],'Parent',handles.IRMZoomAxes);
        imshow(cropedRawImages,[min(Amplitude),max(Amplitude)],'Parent',handles.RawImageZoomAxes);   
    catch
        try
            width  =5;          
            cropedIRM = images.IRMImage(meany-width:meany+width,meanx-width:meanx+width);
            cropedRawImages=images.rawImagesStack(meany-width:meany+width,meanx-width:meanx+width,currentDisplayFrame); 
            imshow(cropedIRM,[],'Parent',handles.IRMZoomAxes);
            imshow(cropedRawImages,[],'Parent',handles.RawImageZoomAxes);   
        catch
            %disp('no images load or out of range');
        end
    end
   
    hold(handles.IRMZoomAxes, 'on');         
    hold(handles.RawImageZoomAxes, 'on');     
    plot(handles.IRMZoomAxes,width+1,width+1,'ro','markersize',10);%show a red circle around the current shown spot
    plot(handles.RawImageZoomAxes,width+1,width+3,'ro','markersize',20);
    hold(handles.IRMZoomAxes, 'off');
    hold(handles.RawImageZoomAxes, 'off');
    
    try% not importance 
        if currentDisplayFrame ==stackSize
            imshow(images.IRMImage,[low,threadhold] ,'Parent',handles.ImageWindowAxes);
        else
            imshow(images.rawImagesStack(:,:,currentDisplayFrame),[low,threadhold] ,'Parent',handles.ImageWindowAxes);
        end
            
    catch
    end
    hold(handles.ImageWindowAxes,'on');
    plot(handles.ImageWindowAxes,meanx,meany,'ro','MarkerSize',10);
    hold(handles.ImageWindowAxes,'off');
end

