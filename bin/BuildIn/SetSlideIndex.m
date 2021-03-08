function SetSlideIndex(handles,frameId,updateAxes)
%SETSLIDEINDEX  
%   
    global gImages;
    set(handles.Current_Frame_Id,'String',num2str(frameId));
    set(handles.Slider_Stack_Index,'Value',frameId);
    
    if isfield(gImages,'rawImagesStack')
        ShowRawImageStack(handles);
    end
    index = str2double(get(handles.Current_Trace_Id,'String'));
    if updateAxes
        updateAxes = 5;
        PlotTrace(handles,index,updateAxes);
    end

end

