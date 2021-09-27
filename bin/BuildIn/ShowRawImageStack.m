function ShowRawImageStack(handles)
%ADJUSTTHREADHOLD  
%    
    global gImages;
    intensity_high = floor(get(handles.Slider_Threadhold_High,'Value'));
    intensity_low = floor(get(handles.Slider_Threadhold_Low,'Value'));

    if intensity_low>=intensity_high
        set(handles.Slider_Threadhold_Low,'Value',intensity_high-1);
        intensity_low = intensity_high-1;
    end

    current_stack_Id = floor(get(handles.Slider_Stack_Index,'Value'));
    stackSize = floor(get(handles.Slider_Stack_Index,'Max'));
    try
        if isfield( gImages, 'IRMImage' ) && isfield( gImages, 'rawImagesStack' )
            switch current_stack_Id
                case 1
                    if  isfield( gImages, 'IRMImage' ) && ~isempty(gImages.IRMImage)
                        imshow(gImages.IRMImage,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);
                    else
                        imshow(gImages.rawImagesStack(:,:,1),[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);  
                    end
                case stackSize
                    imshow(gImages.ZprojectMean,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);
                otherwise
                    imshow(gImages.rawImagesStack(:,:,current_stack_Id),[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);       
            end
        end
        if isfield( gImages, 'IRMImage' ) && ~isfield( gImages, 'rawImagesStack' )
            imshow(gImages.IRMImage,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);
        end
    catch
        LogMsg(handles,'Show Raw Images Stack Error');
    end
end

